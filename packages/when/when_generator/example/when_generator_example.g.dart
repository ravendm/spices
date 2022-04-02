// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'when_generator_example.dart';

// **************************************************************************
// WhenGenerator
// **************************************************************************

extension MobileWhenExtension<T1, T2> on Mobile<T1, T2> {
  _T when<_T>({
    required _T Function(_Player) player,
    required _T Function(_Monster<T1, dynamic, T2>) monster,
    required _T Function(_EmptyNPC) emptyNPC,
  }) {
    if (this is _Player) {
      return player(this as _Player);
    } else if (this is _Monster<T1, dynamic, T2>) {
      return monster(this as _Monster<T1, dynamic, T2>);
    } else if (this is _EmptyNPC) {
      return emptyNPC(this as _EmptyNPC);
    }

    throw 'Invalid self type $runtimeType';
  }

  _T maybeWhen<_T>({
    _T Function(_Player)? player,
    _T Function(_Monster<T1, dynamic, T2>)? monster,
    _T Function(_EmptyNPC)? emptyNPC,
    required _T Function(Mobile<T1, T2>) orElse,
  }) {
    if (this is _Player && player != null) {
      return player(this as _Player);
    } else if (this is _Monster<T1, dynamic, T2> && monster != null) {
      return monster(this as _Monster<T1, dynamic, T2>);
    } else if (this is _EmptyNPC && emptyNPC != null) {
      return emptyNPC(this as _EmptyNPC);
    }

    return orElse(this);
  }
}

extension AWhenExtension on A {
  _T when<_T>({
    required _T Function(B) b,
    required _T Function(C) c,
  }) {
    if (this is B) {
      return b(this as B);
    } else if (this is C) {
      return c(this as C);
    }

    throw 'Invalid self type $runtimeType';
  }

  _T maybeWhen<_T>({
    _T Function(B)? b,
    _T Function(C)? c,
    required _T Function(A) orElse,
  }) {
    if (this is B && b != null) {
      return b(this as B);
    } else if (this is C && c != null) {
      return c(this as C);
    }

    return orElse(this);
  }
}

extension BWhenExtension on B {
  _T when<_T>({
    required _T Function(C) c,
  }) {
    if (this is C) {
      return c(this as C);
    }

    throw 'Invalid self type $runtimeType';
  }

  _T maybeWhen<_T>({
    _T Function(C)? c,
    required _T Function(B) orElse,
  }) {
    if (this is C && c != null) {
      return c(this as C);
    }

    return orElse(this);
  }
}
