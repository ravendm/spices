// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'copy_with.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension GenericObjectCopyWithExtension<T> on GenericObject<T> {
  GenericObject copyWith({
    int? id,
    T? data,
    int? nullableId,
    int? i,
  }) {
    return GenericObject<T>.poof(
      id: id ?? this.id,
      data: data ?? this.data,
      nullableId: nullableId ?? this.nullableId,
      i: i ?? this.i,
    );
  }

  GenericObject copyWithNull({
    bool? nullableId,
  }) {
    return GenericObject<T>.poof(
      id: this.id,
      data: this.data,
      nullableId: nullableId == true ? null : this.nullableId,
      i: this.i,
    );
  }
}

extension SimpleObjectCopyWithExtension<A, B> on SimpleObject<A, B> {
  SimpleObject copyWith({
    A? a,
    B? b,
  }) {
    return SimpleObject<A, B>(
      a: a ?? this.a,
      b: b ?? this.b,
    );
  }
}

extension EmptyObjectCopyWithExtension on EmptyObject {}
