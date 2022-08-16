import 'package:when/when.dart';

part 'when_generator_example.g.dart';

@When()
abstract class UserState {}

class UserStateInitial extends UserState {}

class UserStateGuest extends UserState {}

@When()
abstract class Mobile<T1, T2> {
  const Mobile({required this.pos, required this.data});

  final int pos;
  final T1 data;

  factory Mobile.monster(T1 data) => _Monster(health: 0, pos: 0, data: data);
}

class _Player extends Mobile<int, String> {
  const _Player({required this.level, required int pos}) : super(pos: pos, data: 777);

  final int level;
}

class _Monster<A, B, C> extends Mobile<A, C> {
  const _Monster({required this.health, required int pos, required A data}) : super(pos: pos, data: data);

  final int health;
}

class _EmptyNPC extends Mobile {
  const _EmptyNPC({required int pos}) : super(pos: pos, data: null);
}

@When()
class A {}

@When()
class B extends A {}

class C extends B {}

@WhenEnum()
enum Enum1 {
  success,
  error,
  loading,
}

extension E1 on Enum1 {
  bool get isA => true;
}
