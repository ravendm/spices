import 'package:copy_with/copy_with.dart';

part 'copy_with.g.dart';

@CopyWith(constructor: GenericObject.poof)
class GenericObject<T> {
  const GenericObject({
    required this.id,
    required this.data,
    this.nullableId,
    required this.i,
  });

  const GenericObject.poof({
    required this.id,
    required this.data,
    required this.nullableId,
    required this.i,
  });

  final int id;
  final T data;
  final int? nullableId;
  final int i;
}

@CopyWith()
class SimpleObject<A, B> {
  const SimpleObject({required this.a, required this.b});

  final A a;
  final B b;
}

@CopyWith()
class EmptyObject {}
