import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:when/when.dart';
import 'package:when_generator/utils.dart';

class ChildDeclaration {
  const ChildDeclaration({
    required this.element,
    required this.argumentName,
    required this.typeName,
    required this.generics,
    required this.genericIndexes,
    required this.genericsMapped,
  });

  final ClassElement element;

  /// Название класса, где первый символ в нижнем регистре
  final String argumentName;
  final String typeName;

  /// child index -> super index
  final Map<int, int> genericIndexes;

  /// Список generic аргументов, определённых в классе
  final List<String> generics;

  /// Список generic аргументов, изменённых для использования в extension
  final List<String> genericsMapped;
}

class WhenGenerator extends GeneratorForAnnotation<When> {
  List<String> _genericList(ClassElement element) => element.typeParameters.map((e) => e.name).toList();

  String _typeName(ClassElement element) => element.name;

  String _generic(ClassElement element) =>
      _genericList(element).isNotEmpty ? '<${_genericList(element).join(', ')}>' : '';

  List<GeneratorEntity> _entities(List<ChildDeclaration> childDeclarations) =>
      childDeclarations.map((e) => GeneratorClassEntity(argName: e.argumentName, typeName: e.typeName)).toList();

  Logger get logger => Logger('WhenGenerator');

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) throw '$element is not a ClassElement';

    final generic = _generic(element);
    final typeName = _typeName(element);

    logger.info('WhenGenerator build');
    logger.info('> type name [${element.displayName}]${generic.isNotEmpty ? ' generics: $generic' : ''}');

    final extensionName = '${element.name}WhenExtension';

    // _children = _annotation.read('children').listValue.map((e) => e.toTypeValue()!.element! as ClassElement).toList();

    final inputLibrary = await buildStep.inputLibrary;
    final classes = inputLibrary.units.expand((cu) => cu.classes);

    final children = <ClassElement>[];

    for (final klass in classes) {
      if (klass.allSupertypes.map((e) => e.element2).contains(element)) {
        children.add(klass);
      }
    }

    print('> type name [${element.displayName}]${generic.isNotEmpty ? ' generics: $generic' : ''}');
    print('> children: ' + children.map((e) => e.displayName).toList().join(', '));

    logger.info('> children: ' + children.map((e) => e.displayName).toList().join(', '));

    final childDeclarations = _buildDeclarations(element, children);
    final entities = _entities(childDeclarations);

    final result = '''
    extension $extensionName$generic on $typeName$generic {
       ${_map(entities)}
       ${_maybeMap(element, entities)}
       ${_when(entities)}
       ${_maybeWhen(element, entities)}
       ${_whenFuture(entities)}
       ${_maybeWhenFuture(element, entities)}
       
       ${_is(entities)}
       
       ${_as(entities)}
    }
    ''';

    print(result);

    return result;
  }

  String _map(List<GeneratorEntity> _entities) {
    return WhenUtils.generateMap(entities: _entities, errorMessage: WhenUtils.typeErrorMessage);
  }

  String _maybeMap(ClassElement element, List<GeneratorEntity> _entities) {
    return WhenUtils.generateMaybeMap(
        entities: _entities, errorMessage: WhenUtils.typeErrorMessage, orElseArgument: element.name);
  }

  String _when(List<GeneratorEntity> _entities) {
    return WhenUtils.generateWhen(entities: _entities, errorMessage: WhenUtils.typeErrorMessage);
  }

  String _maybeWhen(ClassElement element, List<GeneratorEntity> _entities) {
    return WhenUtils.generateMaybeWhen(
        entities: _entities, errorMessage: WhenUtils.typeErrorMessage, orElseArgument: element.name);
  }

  String _whenFuture(List<GeneratorEntity> _entities) {
    return WhenUtils.generateWhenFuture(entities: _entities, errorMessage: WhenUtils.typeErrorMessage);
  }

  String _maybeWhenFuture(ClassElement element, List<GeneratorEntity> _entities) {
    return WhenUtils.generateMaybeWhenFuture(
        entities: _entities, errorMessage: WhenUtils.typeErrorMessage, orElseArgument: element.name);
  }

  String _is(List<GeneratorEntity> _entities) {
    return WhenUtils.generateIs(entities: _entities);
  }

  String _as(List<GeneratorEntity> _entities) {
    return WhenUtils.generateAs(entities: _entities);
  }

  List<ChildDeclaration> _buildDeclarations(ClassElement element, List<ClassElement> children) {
    final _childDeclarations = <ChildDeclaration>[];

    var removePrefix = true;
    for (final child in children) {
      if (!child.name.startsWith(element.name)) {
        removePrefix = false;
        break;
      }
    }

    for (final child in children) {
      /// argument name
      final typeName = child.name;
      final underTrimmedTypeName = RegExp(r'^_*(.*)$').firstMatch(typeName)!.group(1)!;
      var argName = underTrimmedTypeName.substring(0, 1).toLowerCase() + underTrimmedTypeName.substring(1);

      if (removePrefix) {
        argName = argName.substring(element.name.length);
        argName = argName.substring(0, 1).toLowerCase() + argName.substring(1);
      }

      final childToSuperGenericIndexes = <int, int>{};
      final childGenericList = <String>[];
      final gList = <String>[];

      if (element.typeParameters.isNotEmpty) {
        /// child raw generic list names
        childGenericList.addAll(child.typeParameters.map((e) => e.name));

        /// super raw generics list names
        final superGenerics =
            child.supertype!.typeArguments.map((e) => e.getDisplayString(withNullability: false)).toList();

        /// fill map child to super generic index
        /// if child has
        /// class Child<T1, T2> extends Parent<T2>
        /// declaration
        /// map will contains a {1: 0} values
        for (var i = 0; i < childGenericList.length; ++i) {
          final superI = superGenerics.indexOf(childGenericList[i]);
          if (superI != -1) {
            childToSuperGenericIndexes[i] = superI;
          }
        }

        if (_genericList(element).isNotEmpty && childGenericList.isNotEmpty && childToSuperGenericIndexes.isNotEmpty) {
          for (var i = 0; i < childGenericList.length; ++i) {
            if (!childToSuperGenericIndexes.containsKey(i)) {
              gList.add('dynamic');
            } else {
              final pi = childToSuperGenericIndexes[i]!;
              gList.add(_genericList(element)[pi]);
            }
          }
        }
      }

      final childDeclaration = ChildDeclaration(
        element: child,
        argumentName: argName,
        typeName: typeName,
        genericIndexes: childToSuperGenericIndexes,
        generics: childGenericList,
        genericsMapped: gList,
      );

      _childDeclarations.add(childDeclaration);
    }

    return _childDeclarations;
  }
}
