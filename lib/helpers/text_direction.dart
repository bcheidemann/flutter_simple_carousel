import 'dart:ui';

/// Helpers extension for [TextDirection].
extension TextDirectionHelpers on TextDirection {
  /// Whether the [TextDirection] is left to right.
  bool get isLtr {
    return this == TextDirection.ltr;
  }

  /// Whether the [TextDirection] is right to left.
  bool get isRtl {
    return this == TextDirection.rtl;
  }
}
