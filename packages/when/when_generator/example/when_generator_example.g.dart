// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'when_generator_example.dart';

// **************************************************************************
// WhenGenerator
// **************************************************************************

extension MobileWhenExtension<T1, T2> on Mobile<T1, T2> {
  _T map<_T>({
    required _T Function(_Player) player,
    required _T Function(_Monster) monster,
    required _T Function(_EmptyNPC) emptyNPC,
  }) {
    if (this is _Player) {
      return player(this as _Player);
    } else if (this is _Monster) {
      return monster(this as _Monster);
    } else if (this is _EmptyNPC) {
      return emptyNPC(this as _EmptyNPC);
    }
    throw 'Invalid self type $this';
  }

  _T maybeMap<_T>({
    _T Function(_Player)? player,
    _T Function(_Monster)? monster,
    _T Function(_EmptyNPC)? emptyNPC,
    required _T orElse(Mobile),
  }) {
    if (this is _Player && player != null) {
      return player(this as _Player);
    } else if (this is _Monster && monster != null) {
      return monster(this as _Monster);
    } else if (this is _EmptyNPC && emptyNPC != null) {
      return emptyNPC(this as _EmptyNPC);
    } else {
      return orElse(this);
    }
  }

  void when({
    required void Function(_Player) player,
    required void Function(_Monster) monster,
    required void Function(_EmptyNPC) emptyNPC,
  }) {
    if (this is _Player) {
      return player(this as _Player);
    } else if (this is _Monster) {
      return monster(this as _Monster);
    } else if (this is _EmptyNPC) {
      return emptyNPC(this as _EmptyNPC);
    }
    throw 'Invalid self type $this';
  }

  void maybeWhen({
    void Function(_Player)? player,
    void Function(_Monster)? monster,
    void Function(_EmptyNPC)? emptyNPC,
    void Function(Mobile)? orElse,
  }) {
    if (this is _Player && player != null) {
      return player(this as _Player);
    } else if (this is _Monster && monster != null) {
      return monster(this as _Monster);
    } else if (this is _EmptyNPC && emptyNPC != null) {
      return emptyNPC(this as _EmptyNPC);
    } else if (orElse != null) {
      return orElse(this);
    }
  }

  Future<void> whenFuture({
    required Future<void> Function(_Player) player,
    required Future<void> Function(_Monster) monster,
    required Future<void> Function(_EmptyNPC) emptyNPC,
  }) {
    if (this is _Player) {
      return player(this as _Player);
    } else if (this is _Monster) {
      return monster(this as _Monster);
    } else if (this is _EmptyNPC) {
      return emptyNPC(this as _EmptyNPC);
    }
    throw 'Invalid self type $this';
  }

  Future<void> maybeWhenFuture({
    Future<void> Function(_Player)? player,
    Future<void> Function(_Monster)? monster,
    Future<void> Function(_EmptyNPC)? emptyNPC,
    Future<void> Function(Mobile)? orElse,
  }) {
    if (this is _Player && player != null) {
      return player(this as _Player);
    } else if (this is _Monster && monster != null) {
      return monster(this as _Monster);
    } else if (this is _EmptyNPC && emptyNPC != null) {
      return emptyNPC(this as _EmptyNPC);
    } else if (orElse != null) {
      return orElse(this);
    }
    return Future.value();
  }

  bool get isPlayer => this is _Player;

  bool get isMonster => this is _Monster;

  bool get isEmptyNPC => this is _EmptyNPC;

  _Player? get asPlayer => this as _Player?;

  _Monster? get asMonster => this as _Monster?;

  _EmptyNPC? get asEmptyNPC => this as _EmptyNPC?;
}

extension AWhenExtension on A {
  _T map<_T>({
    required _T Function(B) b,
    required _T Function(C) c,
  }) {
    if (this is B) {
      return b(this as B);
    } else if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $this';
  }

  _T maybeMap<_T>({
    _T Function(B)? b,
    _T Function(C)? c,
    required _T orElse(A),
  }) {
    if (this is B && b != null) {
      return b(this as B);
    } else if (this is C && c != null) {
      return c(this as C);
    } else {
      return orElse(this);
    }
  }

  void when({
    required void Function(B) b,
    required void Function(C) c,
  }) {
    if (this is B) {
      return b(this as B);
    } else if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $this';
  }

  void maybeWhen({
    void Function(B)? b,
    void Function(C)? c,
    void Function(A)? orElse,
  }) {
    if (this is B && b != null) {
      return b(this as B);
    } else if (this is C && c != null) {
      return c(this as C);
    } else if (orElse != null) {
      return orElse(this);
    }
  }

  Future<void> whenFuture({
    required Future<void> Function(B) b,
    required Future<void> Function(C) c,
  }) {
    if (this is B) {
      return b(this as B);
    } else if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $this';
  }

  Future<void> maybeWhenFuture({
    Future<void> Function(B)? b,
    Future<void> Function(C)? c,
    Future<void> Function(A)? orElse,
  }) {
    if (this is B && b != null) {
      return b(this as B);
    } else if (this is C && c != null) {
      return c(this as C);
    } else if (orElse != null) {
      return orElse(this);
    }
    return Future.value();
  }

  bool get isB => this is B;

  bool get isC => this is C;

  B? get asB => this as B?;

  C? get asC => this as C?;
}

extension BWhenExtension on B {
  _T map<_T>({
    required _T Function(C) c,
  }) {
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $this';
  }

  _T maybeMap<_T>({
    _T Function(C)? c,
    required _T orElse(B),
  }) {
    if (this is C && c != null) {
      return c(this as C);
    } else {
      return orElse(this);
    }
  }

  void when({
    required void Function(C) c,
  }) {
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $this';
  }

  void maybeWhen({
    void Function(C)? c,
    void Function(B)? orElse,
  }) {
    if (this is C && c != null) {
      return c(this as C);
    } else if (orElse != null) {
      return orElse(this);
    }
  }

  Future<void> whenFuture({
    required Future<void> Function(C) c,
  }) {
    if (this is C) {
      return c(this as C);
    }
    throw 'Invalid self type $this';
  }

  Future<void> maybeWhenFuture({
    Future<void> Function(C)? c,
    Future<void> Function(B)? orElse,
  }) {
    if (this is C && c != null) {
      return c(this as C);
    } else if (orElse != null) {
      return orElse(this);
    }
    return Future.value();
  }

  bool get isC => this is C;

  C? get asC => this as C?;
}

// **************************************************************************
// WhenEnumGenerator
// **************************************************************************

extension Enum1Extension on Enum1 {
  _T map<_T>({
    required _T Function() success,
    required _T Function() error,
    required _T Function() loading,
  }) {
    if (this == Enum1.success) {
      return success();
    } else if (this == Enum1.error) {
      return error();
    } else if (this == Enum1.loading) {
      return loading();
    }
    throw 'Invalid self value $this';
  }

  _T maybeMap<_T>({
    _T Function()? success,
    _T Function()? error,
    _T Function()? loading,
    required _T orElse(Enum1),
  }) {
    if (this == Enum1.success && success != null) {
      return success();
    } else if (this == Enum1.error && error != null) {
      return error();
    } else if (this == Enum1.loading && loading != null) {
      return loading();
    } else {
      return orElse(this);
    }
  }

  void when({
    required void Function() success,
    required void Function() error,
    required void Function() loading,
  }) {
    if (this == Enum1.success) {
      return success();
    } else if (this == Enum1.error) {
      return error();
    } else if (this == Enum1.loading) {
      return loading();
    }
    throw 'Invalid self value $this';
  }

  void maybeWhen({
    void Function()? success,
    void Function()? error,
    void Function()? loading,
    void Function(Enum1)? orElse,
  }) {
    if (this == Enum1.success && success != null) {
      return success();
    } else if (this == Enum1.error && error != null) {
      return error();
    } else if (this == Enum1.loading && loading != null) {
      return loading();
    } else if (orElse != null) {
      return orElse(this);
    }
  }

  bool get isSuccess => this == Enum1.success;

  bool get isError => this == Enum1.error;

  bool get isLoading => this == Enum1.loading;
}
