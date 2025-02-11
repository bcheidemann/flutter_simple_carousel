import 'package:flutter/material.dart';
import 'package:flutter_simple_carousel/helpers/text_direction.dart';

extension BuildContextHelpers on BuildContext {
  TextDirection get textDirection => Directionality.of(this);
  bool get isLtr => textDirection.isLtr;
  bool get isRtl => textDirection.isRtl;
}
