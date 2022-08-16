import 'package:flutter/widgets.dart';

int _insertBetween<T extends Widget>(List<T> items, T Function() builder) {
  var c = 0;
  for (var i = items.length - 1; i > 0; --i, c++) {
    items.insert(i, builder());
  }
  return c;
}

SizedBox _buildSizedBox(Axis direction, double? gap) {
  return SizedBox(
    width: direction == Axis.horizontal ? gap : 0,
    height: direction == Axis.vertical ? gap : 0,
  );
}

List<Widget> _buildChildren(List<Widget> children, Axis direction, double? gap) {
  final result = List.of(children);
  if (gap != null) {
    _insertBetween(result, () => _buildSizedBox(direction, gap));
  }
  return result;
}

class SpiceFlex extends Flex {
  SpiceFlex({
    super.key,
    this.gap,
    required super.direction,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    List<Widget> children = const <Widget>[],
  }) : super(children: _buildChildren(children, direction, gap));

  final double? gap;
}

class SpiceRow extends SpiceFlex {
  SpiceRow({
    super.key,
    super.gap,
    super.direction = Axis.vertical,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.children,
  });
}

class SpiceColumn extends SpiceFlex {
  SpiceColumn({
    super.key,
    super.gap,
    super.direction = Axis.vertical,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    super.clipBehavior,
    super.children,
  });
}
