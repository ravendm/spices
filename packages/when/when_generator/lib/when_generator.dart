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
  late ClassElement _element;
  late List<ClassElement> _children;
  late ConstantReader _annotation;
  late List<String> _genericList;
  late List<ChildDeclaration> _childDeclarations;

  String get _typeName => _element.name;

  String get _generic => _genericList.isNotEmpty ? '<${_genericList.join(', ')}>' : '';

  List<GeneratorEntity> get _entities =>
      _childDeclarations.map((e) => GeneratorClassEntity(argName: e.argumentName, typeName: e.typeName)).toList();

  Logger get logger => Logger('WhenGenerator');

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) throw '$element is not a ClassElement';

    _element = element;
    _annotation = annotation;
    _genericList = _element.typeParameters.map((e) => e.name).toList();

    logger.info('WhenGenerator build');
    logger.info('> type name [${_element.displayName}]${_generic.isNotEmpty ? ' generics: $_generic' : ''}');

    final extensionName = '${_element.name}WhenExtension';

    // _children = _annotation.read('children').listValue.map((e) => e.toTypeValue()!.element! as ClassElement).toList();

    final inputLibrary = await buildStep.inputLibrary;
    final classes = inputLibrary.units.expand((cu) => cu.classes);

    _children = [];

    for (final klass in classes) {
      if (klass.allSupertypes.map((e) => e.element).contains(_element)) {
        _children.add(klass);
      }
    }

    logger.info('> children: ' + _children.map((e) => e.displayName).toList().join(', '));

    _buildDeclarations();

    final result = '''
    extension $extensionName$_generic on $_typeName$_generic {
       ${_map()}
       ${_maybeMap()}
       ${_when()}
       ${_maybeWhen()}
       ${_whenFuture()}
       ${_maybeWhenFuture()}
       
       ${_is()}
       
       ${_as()}
    }
    ''';

    return result;
  }

  String _map() {
    return WhenUtils.generateMap(entities: _entities, errorMessage: WhenUtils.typeErrorMessage);
  }

  String _maybeMap() {
    return WhenUtils.generateMaybeMap(
        entities: _entities, errorMessage: WhenUtils.typeErrorMessage, orElseArgument: _element.name);
  }

  String _when() {
    return WhenUtils.generateWhen(entities: _entities, errorMessage: WhenUtils.typeErrorMessage);
  }

  String _maybeWhen() {
    return WhenUtils.generateMaybeWhen(
        entities: _entities, errorMessage: WhenUtils.typeErrorMessage, orElseArgument: _element.name);
  }

  String _whenFuture() {
    return WhenUtils.generateWhenFuture(entities: _entities, errorMessage: WhenUtils.typeErrorMessage);
  }

  String _maybeWhenFuture() {
    return WhenUtils.generateMaybeWhenFuture(
        entities: _entities, errorMessage: WhenUtils.typeErrorMessage, orElseArgument: _element.name);
  }

  String _is() {
    return WhenUtils.generateIs(entities: _entities);
  }

  String _as() {
    return WhenUtils.generateAs(entities: _entities);
  }

  void _buildDeclarations() {
    _childDeclarations = [];

    var removePrefix = true;
    for (final child in _children) {
      if (!child.name.startsWith(_element.name)) {
        removePrefix = false;
        break;
      }
    }

    for (final child in _children) {
      /// argument name
      final typeName = child.name;
      final underTrimmedTypeName = RegExp(r'^_*(.*)$').firstMatch(typeName)!.group(1)!;
      var argName = underTrimmedTypeName.substring(0, 1).toLowerCase() + underTrimmedTypeName.substring(1);

      if (removePrefix) {
        argName = argName.substring(_element.name.length);
        argName = argName.substring(0, 1).toLowerCase() + argName.substring(1);
      }

      final childToSuperGenericIndexes = <int, int>{};
      final childGenericList = <String>[];
      final gList = <String>[];

      if (_element.typeParameters.isNotEmpty) {
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

        if (_genericList.isNotEmpty && childGenericList.isNotEmpty && childToSuperGenericIndexes.isNotEmpty) {
          for (var i = 0; i < childGenericList.length; ++i) {
            if (!childToSuperGenericIndexes.containsKey(i)) {
              gList.add('dynamic');
            } else {
              final pi = childToSuperGenericIndexes[i]!;
              gList.add(_genericList[pi]);
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
  }
}
