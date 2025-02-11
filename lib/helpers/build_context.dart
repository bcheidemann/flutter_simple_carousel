import 'package:flutter/material.dart';
import 'package:flutter_simple_carousel/helpers/text_direction.dart';

/// Helpers extension for [BuildContext].
extension BuildContextHelpers on BuildContext {
  /// Returns the [TextDirection] for the [BuildContext].
  TextDirection get textDirection => Directionality.of(this);

  /// Whether the text direction for the [BuildContext] is left to right.
  bool get isLtr => textDirection.isLtr;

  /// Whether the text direction for the [BuildContext] is right to left.
  bool get isRtl => textDirection.isRtl;
}
