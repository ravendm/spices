import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:when/when.dart';
import 'package:when_generator/utils.dart';

class WhenEnumGenerator extends GeneratorForAnnotation<WhenEnum> {
  late EnumElement _element;
  late List<FieldElement> _constants;

  List<GeneratorEntity> get _entities => _constants
      .map((e) =>
          GeneratorEnumEntity(argName: WhenUtils.toLower(e.name, 1), constantName: e.name, typeName: _element.name))
      .toList();

  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! EnumElement) {
      throw '$element не enum, ${element.runtimeType}';
    }

    _element = element;
    _constants = element.fields.where((e) => e.isEnumConstant).toList();

    return '''
    extension ${_element.name}Extension on ${_element.name} {
      ${_map()}
      ${_maybeMap()}
      ${_when()}
      ${_maybeWhen()}
      ${_is()}
    }
    ''';
  }

  String _map() {
    return WhenUtils.generateMap(entities: _entities, errorMessage: WhenUtils.valueErrorMessage);
  }

  String _maybeMap() {
    return WhenUtils.generateMaybeMap(
        entities: _entities, errorMessage: WhenUtils.valueErrorMessage, orElseArgument: _element.name);
  }

  String _when() {
    return WhenUtils.generateWhen(entities: _entities, errorMessage: WhenUtils.valueErrorMessage);
  }

  String _maybeWhen() {
    return WhenUtils.generateMaybeWhen(
        entities: _entities, errorMessage: WhenUtils.valueErrorMessage, orElseArgument: _element.name);
  }

  String _is() {
    return WhenUtils.generateIs(entities: _entities);
  }
}
