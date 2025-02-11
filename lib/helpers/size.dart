import 'package:flutter/material.dart';

/// Helpers extension for [Size].
extension SizeHelpers on Size {
  /// The size in the main axis.
  double mainAxisSize(Axis axis) => axis == Axis.horizontal ? width : height;

  /// The size in the cross axis.
  double crossAxisSize(Axis axis) => axis == Axis.horizontal ? height : width;
}
