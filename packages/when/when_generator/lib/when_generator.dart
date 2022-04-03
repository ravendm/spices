import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';
import 'package:when/when.dart';

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

  Logger get logger => Logger('WhenGenerator');

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) throw '$element is not a ClassElement';
    _element = element;
    _annotation = annotation;
    _genericList = _element.typeParameters.map((e) => e.name).toList();

    logger.info('WhenGenerator build');
    logger.info('> type name [${_element.displayName}]${_generic.isNotEmpty ? ' generics: $_generic' : ''}');

    final extensionName = '${_element.name}WhenExtension';

    _children = _annotation.read('children').listValue.map((e) => e.toTypeValue()!.element! as ClassElement).toList();

    logger.info('> children: ' + _children.map((e) => e.displayName).toList().join(', '));

    _buildDeclarations();

    final result = '''
    extension $extensionName$_generic on $_typeName$_generic {
       ${_build()}
    }
    ''';

    return result;
  }

  String _build() {
    final argumentMapList = <String>[];
    final argumentMapFutureList = <String>[];
    final argumentMaybeMapList = <String>[];
    final argumentMaybeMapFutureList = <String>[];
    final argumentWhenList = <String>[];
    final argumentWhenFutureList = <String>[];
    final conditionMapList = <String>[];
    final conditionMaybeMapList = <String>[];
    final returnList = <String>[];
    for (final childDeclaration in _childDeclarations) {
      final argName = childDeclaration.argumentName;
      final typeName = childDeclaration.typeName;
      final generics = childDeclaration.genericsMapped.isEmpty ? '' : '<${childDeclaration.genericsMapped.join(', ')}>';

      argumentMapList.add('required _T Function($typeName$generics) $argName');
      argumentMapFutureList.add('required Future<_T> Function($typeName$generics) $argName');
      argumentMaybeMapList.add('_T Function($typeName$generics)? $argName');
      argumentMaybeMapFutureList.add('Future<_T> Function($typeName$generics)? $argName');
      argumentWhenList.add('Function($typeName$generics)? $argName');
      argumentWhenFutureList.add('Future<void> Function($typeName$generics)? $argName');
      conditionMapList.add('this is $typeName$generics');
      conditionMaybeMapList.add('this is $typeName$generics && $argName != null');
      returnList.add('$argName(this as $typeName$generics)');
    }

    argumentMaybeMapList.add('required _T Function($_typeName$_generic) orElse');
    argumentMaybeMapFutureList.add('required Future<_T> Function($_typeName$_generic) orElse');

    final blockMapList = <String>[];
    final blockMapFutureList = <String>[];
    final blockMaybeMapList = <String>[];
    final blockMaybeMapFutureList = <String>[];
    final blockWhenList = <String>[];
    final blockWhenFutureList = <String>[];
    for (var i = 0; i < conditionMapList.length; ++i) {
      blockMapList.add('''if (${conditionMapList[i]}) {
        return ${returnList[i]};
      }''');
      blockMapFutureList.add('''if (${conditionMapList[i]}) { 
        return ${returnList[i]};
      }''');
      blockMaybeMapList.add('''if (${conditionMaybeMapList[i]}) { 
        return ${returnList[i]};
      }''');
      blockMaybeMapFutureList.add('''if (${conditionMaybeMapList[i]}) { 
        return ${returnList[i]};
      }''');
      blockWhenList.add('''if (${conditionMaybeMapList[i]}) { 
        ${returnList[i]};
        return true;
      }''');
      blockWhenFutureList.add('''if (${conditionMaybeMapList[i]}) { 
        await ${returnList[i]};
        return true;
      }''');
    }

    return '''
       _T map<_T>({
          ${argumentMapList.join(',\n')},
       }) {
          ${blockMapList.join('\n')}
          throw 'Invalid self type \$runtimeType';
       }
       
       Future<_T> mapFuture<_T>({
          ${argumentMapFutureList.join(',\n')},
       }) {
          ${blockMapFutureList.join('\n')}
          throw 'Invalid self type \$runtimeType';
       }
       
       _T maybeMap<_T>({
          ${argumentMaybeMapList.join(',\n')},
       }) {
          ${blockMaybeMapList.join('\n')}
          return orElse(this);
       }
       
       Future<_T> maybeMapFuture<_T>({
          ${argumentMaybeMapFutureList.join(',\n')},
       }) {
          ${blockMaybeMapFutureList.join('\n')}
          return orElse(this);        
       }
       
       bool when({
          ${argumentWhenList.join(',\n')},
       }) {
          ${blockWhenList.join('\n')}
          return false;
       }
       
       Future<bool> whenFuture({
         ${argumentWhenFutureList.join(',\n')},
       }) async {
         ${blockWhenFutureList.join('\n')}
         return false;
       }
    ''';
  }

  void _buildDeclarations() {
    _childDeclarations = [];
    for (final child in _children) {
      /// argument name
      final typeName = child.name;
      final underTrimmedTypeName = RegExp(r'^_*(.*)$').firstMatch(typeName)!.group(1)!;
      final argName = underTrimmedTypeName.substring(0, 1).toLowerCase() + underTrimmedTypeName.substring(1);

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

  String _argName(ClassElement element) {
    final typeName = _element.name;
    final underTrimmedTypeName = RegExp(r'^_*(.*)$').firstMatch(typeName)!.group(1)!;
    return underTrimmedTypeName.substring(0, 1).toLowerCase() + underTrimmedTypeName.substring(1);
  }
}
