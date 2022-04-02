import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/build.dart';
import 'package:copy_with/copy_with.dart';
import 'package:source_gen/source_gen.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  late ClassElement _element;
  late ConstantReader _annotation;

  String get _typeName => _element.name;

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) throw '$element is not a ClassElement';
    _element = element;
    _annotation = annotation;

    final genericList = element.typeParameters.map((e) => e.name).toList();
    final generic = genericList.isNotEmpty ? '<${genericList.join(', ')}>' : '';
    final extensionName = '${element.name}CopyWithExtension';
    final constructor = _findConstructor();

    final copyWithDeclaration = constructor.parameters.isNotEmpty ? _copyWith(constructor, generic) : '';
    final copyWithNullDeclaration = constructor.parameters.isNotEmpty ? _copyWithNullable(constructor, generic) : '';

    final result = '''
    extension $extensionName$generic on $_typeName$generic {
       $copyWithDeclaration
       
       $copyWithNullDeclaration
    }
    ''';

    return result;
  }

  ConstructorElement _findConstructor() {
    final constructors = _element.constructors;
    if (constructors.isEmpty) throw '${_element.name} has zero constructors';

    final ann = _annotation.read('constructor');
    if (ann.isNull) {
      final unnamedConstructor = _element.unnamedConstructor;
      if (unnamedConstructor == null) throw '${_element.name} has no default constructor';
      return unnamedConstructor;
    }

    final obj = ann.objectValue;
    final fn = obj.toFunctionValue();
    return constructors.firstWhere((e) => e.name == fn!.name);
  }

  String _copyWith(ConstructorElement constructor, String generic) {
    final argumentList = <String>[];
    final constructList = <String>[];
    for (final param in constructor.parameters) {
      final argumentType = param.type.getDisplayString(withNullability: false);
      final argumentName = param.name;
      argumentList.add('$argumentType? $argumentName');
      constructList.add('$argumentName: $argumentName ?? this.$argumentName');
    }

    var name = '';
    if(constructor != _element.unnamedConstructor) {
      name = '.${constructor.name}';
    }

    return '''
       $_typeName copyWith({
          ${argumentList.join(',\n')},
       }) {
          return $_typeName$generic$name(${constructList.join(',\n')},);
       }
    ''';
  }

  String _copyWithNullable(ConstructorElement constructor, String generic) {
    final argumentList = <String>[];
    final constructList = <String>[];
    for (final param in constructor.parameters) {
      final argumentName = param.name;
      if (param.type.nullabilitySuffix == NullabilitySuffix.question) {
        argumentList.add('bool? $argumentName');
        constructList.add('$argumentName: $argumentName == true ? null : this.$argumentName');
      } else {
        constructList.add('$argumentName: this.$argumentName');
      }
    }

    var name = '';
    if(constructor != _element.unnamedConstructor) {
      name = '.${constructor.name}';
    }
    if (argumentList.isEmpty) return '';

    return '''
       $_typeName copyWithNull({
          ${argumentList.join(',\n')},
       }) {
          return $_typeName$generic$name(${constructList.join(',\n')},);
       }
    ''';
  }
}
