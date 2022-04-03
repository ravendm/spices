// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'when_generator_example.dart';

// **************************************************************************
// WhenGenerator
// **************************************************************************

extension MobileWhenExtension<T1, T2> on Mobile<T1, T2> {
  _T map<_T>({
    required _T Function(_Player) player,
    required _T Function(_Monster<T1, dynamic, T2>) monster,
    required _T Function(_EmptyNPC) emptyNPC,
  }) {
    if (this is _Player) {
      return player(this as _Player);
    }
    if (this is _Monster<T1, dynamic, T2>) {
      return monster(this as _Monster<T1, dynamic, T2>);
    }
    if (this is _EmptyNPC) {
      return emptyNPC(this as _EmptyNPC);
    }
    throw 'Invalid self type $runtimeType';
  }

  Future<_T> mapFuture<_T>({
    required Future<_T> Function(_Player) player,
    required Future<_T> Function(_Monster<T1, dynamic, T2>) monster,
    required Future<_T> Function(_EmptyNPC) emptyNPC,
  }) {
    if (this is _Player) {
      return player(this as _Player);
    }
    if (this is _Monster<T1, dynamic, T2>) {
      return monster(this as _Monster<T1, dynamic, T2>);
    }
    if (this is _EmptyNPC) {
      return emptyNPC(this as _EmptyNPC);
    }
    throw 'Invalid self type $runtimeType';
  }

  _T maybeMap<_T>({
    _T Function(_Player)? player,
    _T Function(_Monster<T1, dynamic, T2>)? monster,
    _T Function(_EmptyNPC)? emptyNPC,
    required _T Function(Mobile<T1, T2>) orElse,
  }) {
    if (this is _Player && player != null) {
      return player(this as _Player);
    }
    if (this is _Monster<T1, dynamic, T2> && monster != null) {
      return monster(this as _Monster<T1, dynamic, T2>);
    }
    if (this is _EmptyNPC && emptyNPC != null) {
      return emptyNPC(this as _EmptyNPC);
    }
    return orElse(this);
  }

  Future<_T> maybeMapFuture<_T>({
    Future<_T> Function(_Player)? player,
    Future<_T> Function(_Monster<T1, dynamic, T2>)? monster,
    Future<_T> Function(_EmptyNPC)? emptyNPC,
    required Future<_T> Function(Mobile<T1, T2>) orElse,
  }) {
    if (this is _Player && player != null) {
      return player(this as _Player);
    }
    if (this is _Monster<T1, dynamic, T2> && monster != null) {
      return monster(this as _Monster<T1, dynamic, T2>);
    }
    if (this is _EmptyNPC && emptyNPC != null) {
      return emptyNPC(this as _EmptyNPC);
    }
    return orElse(this);
  }

  bool when({
    Function(_Player)? player,
    Function(_Monster<T1, dynamic, T2>)? monster,
    Function(_EmptyNPC)? emptyNPC,
  }) {
    if (this is _Player && player != null) {
      player(this as _Player);
      return true;
    }
    if (this is _Monster<T1, dynamic, T2> && monster != null) {
      monster(this as _Monster<T1, dynamic, T2>);
      return true;
    }
    if (this is _EmptyNPC && emptyNPC != null) {
      emptyNPC(this as _EmptyNPC);
      return true;
    }
    return false;
  }

  Future<bool> whenFuture({
    Future<void> Function(_Player)? player,
    Future<void> Function(_Monster<T1, dynamic, T2>)? monster,
    Future<void> Function(_EmptyNPC)? emptyNPC,
  }) async {
    if (this is _Player && player != null) {
      await player(this as _Player);
      return true;
    }
    if (this is _Monster<T1, dynamic, T2> && monster != null) {
      await monster(this as _Monster<T1, dynamic, T2>);
      return true;
    }
    if (this is _EmptyNPC && emptyNPC != null) {
      await emptyNPC(this as _EmptyNPC);
      return true;
    }
    return false;
  }
}

extension AWhenExtension on A {
  _T map<_T>({
    required _T Function(B) b,
    required _T Function(C) c,
  }) {
    if (this is B) {
      return b(this as B);
    }
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $runtimeType';
  }

  Future<_T> mapFuture<_T>({
    required Future<_T> Function(B) b,
    required Future<_T> Function(C) c,
  }) {
    if (this is B) {
      return b(this as B);
    }
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $runtimeType';
  }

  _T maybeMap<_T>({
    _T Function(B)? b,
    _T Function(C)? c,
    required _T Function(A) orElse,
  }) {
    if (this is B && b != null) {
      return b(this as B);
    }
    if (this is C && c != null) {
      return c(this as C);
    }
    return orElse(this);
  }

  Future<_T> maybeMapFuture<_T>({
    Future<_T> Function(B)? b,
    Future<_T> Function(C)? c,
    required Future<_T> Function(A) orElse,
  }) {
    if (this is B && b != null) {
      return b(this as B);
    }
    if (this is C && c != null) {
      return c(this as C);
    }
    return orElse(this);
  }

  bool when({
    Function(B)? b,
    Function(C)? c,
  }) {
    if (this is B && b != null) {
      b(this as B);
      return true;
    }
    if (this is C && c != null) {
      c(this as C);
      return true;
    }
    return false;
  }

  Future<bool> whenFuture({
    Future<void> Function(B)? b,
    Future<void> Function(C)? c,
  }) async {
    if (this is B && b != null) {
      await b(this as B);
      return true;
    }
    if (this is C && c != null) {
      await c(this as C);
      return true;
    }
    return false;
  }
}

extension BWhenExtension on B {
  _T map<_T>({
    required _T Function(C) c,
  }) {
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $runtimeType';
  }

  Future<_T> mapFuture<_T>({
    required Future<_T> Function(C) c,
  }) {
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $runtimeType';
  }

  _T maybeMap<_T>({
    _T Function(C)? c,
    required _T Function(B) orElse,
  }) {
    if (this is C && c != null) {
      return c(this as C);
    }
    return orElse(this);
  }

  Future<_T> maybeMapFuture<_T>({
    Future<_T> Function(C)? c,
    required Future<_T> Function(B) orElse,
  }) {
    if (this is C && c != null) {
      return c(this as C);
    }
    return orElse(this);
  }

  bool when({
    Function(C)? c,
  }) {
    if (this is C && c != null) {
      c(this as C);
      return true;
    }
    return false;
  }

  Future<bool> whenFuture({
    Future<void> Function(C)? c,
  }) async {
    if (this is C && c != null) {
      await c(this as C);
      return true;
    }
    return false;
  }
}
