import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
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

  final _childDeclarations = <ChildDeclaration>[];

  String get _typeName => _element.name;

  String get _generic => _genericList.isNotEmpty ? '<${_genericList.join(', ')}>' : '';

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

    final extensionName = '${_element.name}WhenExtension';

    _children = _annotation.read('children').listValue.map((e) => e.toTypeValue()!.element! as ClassElement).toList();
    _buildDeclarations();

    final result = '''
    extension $extensionName$_generic on $_typeName$_generic {
       ${_when()}
    }
    ''';

    return result;
  }

  String _when() {
    final argumentWhenList = <String>[];
    final argumentMaybeWhenList = <String>[];
    final conditionWhenList = <String>[];
    final conditionMaybeWhenList = <String>[];
    final returnList = <String>[];
    for (final childDeclaration in _childDeclarations) {
      final argName = childDeclaration.argumentName;
      final typeName = childDeclaration.typeName;
      final generics = childDeclaration.genericsMapped.isEmpty ? '' : '<${childDeclaration.genericsMapped.join(', ')}>';

      argumentWhenList.add('required _T Function($typeName$generics) $argName');
      argumentMaybeWhenList.add('_T Function($typeName$generics)? $argName');
      conditionWhenList.add('this is $typeName$generics');
      conditionMaybeWhenList.add('this is $typeName$generics && $argName != null');
      returnList.add('$argName(this as $typeName$generics)');
    }

    argumentMaybeWhenList.add('required _T Function($_typeName$_generic) orElse');

    final blockWhenList = <String>[];
    final blockMaybeWhenList = <String>[];
    for (var i = 0; i < conditionWhenList.length; ++i) {
      blockWhenList.add('''if (${conditionWhenList[i]}) { 
        return ${returnList[i]};
      }''');
      blockMaybeWhenList.add('''if (${conditionMaybeWhenList[i]}) { 
        return ${returnList[i]};
      }''');
    }

    final blocksWhen = blockWhenList.join(' else ');
    final blocksMaybeWhen = blockMaybeWhenList.join(' else ');

    return '''
       _T when<_T>({
          ${argumentWhenList.join(',\n')},
       }) {
          ${blocksWhen}
          
          throw 'Invalid self type \$runtimeType';
       }
       
       _T maybeWhen<_T>({
          ${argumentMaybeWhenList.join(',\n')},
       }) {
          ${blocksMaybeWhen}
          
          return orElse(this);
       }
    ''';
  }

  void _buildDeclarations() {
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
}
