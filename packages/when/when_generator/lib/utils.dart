import 'package:when_generator/generator_struct.dart';

abstract class GeneratorEntity {
  const GeneratorEntity({required this.argName, required this.typeName});

  final String argName;

  final String typeName;

  String get argument;

  String get condition;

  String get expression;
}

class GeneratorClassEntity extends GeneratorEntity {
  const GeneratorClassEntity({
    required String argName,
    required String typeName,
  }) : super(argName: argName, typeName: typeName);

  @override
  String get argument => typeName;

  @override
  String get condition => 'this is $typeName';

  @override
  String get expression => '$argName(this as $typeName)';
}

class GeneratorEnumEntity extends GeneratorEntity {
  const GeneratorEnumEntity({
    required String argName,
    required String typeName,
    required this.constantName,
  }) : super(argName: argName, typeName: typeName);

  final String constantName;

  @override
  String get argument => '';

  @override
  String get condition => 'this == $typeName.$constantName';

  @override
  String get expression => '$argName()';
}

class WhenUtils {
  WhenUtils._();

  static const valueErrorMessage = r'Invalid self value $this';
  static const typeErrorMessage = r'Invalid self type $this';

  static String toUpper(String source, int count) => source.substring(0, count).toUpperCase() + source.substring(count);

  static String toLower(String source, int count) => source.substring(0, count).toLowerCase() + source.substring(count);

  static String generateMap({
    required List<GeneratorEntity> entities,
    required String errorMessage,
    String returnType = '_T',
  }) {
    final struct = GeneratorStruct();
    for (final entity in entities) {
      struct.push(
        argument: 'required $returnType Function(${entity.argument}) ${entity.argName}',
        condition: entity.condition,
        expression: 'return ${entity.expression}',
      );
    }
    final blockList = struct.blockList;
    return '''
      $returnType map<$returnType>({
        ${struct.argumentList.join(', ')},
      }) {
        ${blockList.join(' else ')}
        throw '$errorMessage';
      }
    ''';
  }

  static String generateMaybeMap({
    required List<GeneratorEntity> entities,
    required String errorMessage,
    required String orElseArgument,
    String returnType = '_T',
  }) {
    final struct = GeneratorStruct();
    for (final entity in entities) {
      struct.push(
        argument: '$returnType Function(${entity.argument})? ${entity.argName}',
        condition: '${entity.condition} && ${entity.argName} != null',
        expression: 'return ${entity.expression}',
      );
    }
    final blockList = struct.blockList;
    return '''
      $returnType maybeMap<$returnType>({
        ${struct.argumentList.join(', ')},
        required $returnType Function($orElseArgument) orElse,
      }) {
        ${blockList.join(' else ')}
        else {
          return orElse(${orElseArgument.isNotEmpty ? 'this' : ''});
        }
      }
    ''';
  }

  static String generateWhen({
    required List<GeneratorEntity> entities,
    required String errorMessage,
  }) {
    final struct = GeneratorStruct();
    for (final entity in entities) {
      struct.push(
        argument: 'required void Function(${entity.argument}) ${entity.argName}',
        condition: '${entity.condition}',
        expression: 'return ${entity.expression}',
      );
    }
    final blockList = struct.blockList;
    return '''
      void when({
        ${struct.argumentList.join(', ')},
      }) {
        ${blockList.join(' else ')}
        throw '$errorMessage';
      }
    ''';
  }

  static String generateMaybeWhen({
    required List<GeneratorEntity> entities,
    required String errorMessage,
    required String orElseArgument,
  }) {
    final struct = GeneratorStruct();
    for (final entity in entities) {
      struct.push(
        argument: 'void Function(${entity.argument})? ${entity.argName}',
        condition: '${entity.condition} && ${entity.argName} != null',
        expression: 'return ${entity.expression}',
      );
    }
    final blockList = struct.blockList;
    return '''
      void maybeWhen({
        ${struct.argumentList.join(', ')},
        void Function($orElseArgument)? orElse,
      }) {
        ${blockList.join(' else ')}
        else if (orElse != null) {
          return orElse(${orElseArgument.isNotEmpty ? 'this' : ''});
        }
      }
    ''';
  }

  static String generateWhenFuture({
    required List<GeneratorEntity> entities,
    required String errorMessage,
  }) {
    final struct = GeneratorStruct();
    for (final entity in entities) {
      struct.push(
        argument: 'required Future<void> Function(${entity.argument}) ${entity.argName}',
        condition: '${entity.condition}',
        expression: 'return ${entity.expression}',
      );
    }
    final blockList = struct.blockList;
    return '''
      Future<void> whenFuture({
        ${struct.argumentList.join(', ')},
      }) {
        ${blockList.join(' else ')}
        throw '$errorMessage';
      }
    ''';
  }

  static String generateMaybeWhenFuture({
    required List<GeneratorEntity> entities,
    required String errorMessage,
    required String orElseArgument,
  }) {
    final struct = GeneratorStruct();
    for (final entity in entities) {
      struct.push(
        argument: 'Future<void> Function(${entity.argument})? ${entity.argName}',
        condition: '${entity.condition} && ${entity.argName} != null',
        expression: 'return ${entity.expression}',
      );
    }
    final blockList = struct.blockList;
    return '''
      Future<void> maybeWhenFuture({
        ${struct.argumentList.join(', ')},
        Future<void> Function($orElseArgument)? orElse,
      }) {
        ${blockList.join(' else ')}
        else if (orElse != null) {
          return orElse(${orElseArgument.isNotEmpty ? 'this' : ''});
        }
        return Future.value();
      }
    ''';
  }

  static String generateIs({required List<GeneratorEntity> entities}) {
    return entities.map((e) => 'bool get is${WhenUtils.toUpper(e.argName, 1)} => ${e.condition};').join('\n\n');
  }

  static String generateAs({required List<GeneratorEntity> entities}) {
    return entities
        .map((e) => '${e.typeName}? get as${WhenUtils.toUpper(e.argName, 1)} => this is ${e.typeName} ? this as ${e
        .typeName}? : null;')
        .join('\n\n');
  }
}
