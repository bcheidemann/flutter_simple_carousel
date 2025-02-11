import 'package:flutter/material.dart';

extension SizeHelpers on Size {
  double mainAxisSize(Axis axis) => axis == Axis.horizontal ? width : height;
  double crossAxisSize(Axis axis) => axis == Axis.horizontal ? height : width;
}
