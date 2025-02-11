import 'dart:ui';

extension TextDirectionHelpers on TextDirection {
  bool get isLtr {
    return this == TextDirection.ltr;
  }

  bool get isRtl {
    return this == TextDirection.rtl;
  }
}
