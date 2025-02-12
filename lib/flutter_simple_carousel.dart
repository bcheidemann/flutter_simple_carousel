import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_carousel/helpers/build_context.dart';
import 'package:flutter_simple_carousel/helpers/size.dart';

/// A page for use in the [Carousel] widget.
class CarouselPage {
  /// Return the desired size of the page, given the layout constraints.
  final Size Function(BoxConstraints constraints) layout;

  /// The child widget to render in the carousel page.
  final Widget child;

  /// Creates a [CarouselPage].
  CarouselPage({required this.layout, required this.child});

  /// Creates a [CarouselPage] which has an exact size.
  factory CarouselPage.sized({
    required Size size,
    required Widget child,
  }) =>
      CarouselPage(
        layout: (constraints) => size,
        child: child,
      );

  /// Creates a [CarouselPage] which expands to fill the available width and
  /// height.
  factory CarouselPage.expanded({
    required Widget child,
  }) =>
      CarouselPage(
        layout: (constraints) =>
            Size(constraints.maxWidth, constraints.maxHeight),
        child: child,
      );
}

class _SizedPage {
  final Size size;
  final Widget child;

  _SizedPage({required this.size, required this.child});
}

/// A carousel widget.
class Carousel extends StatelessWidget {
  /// The axis along which the carousel scrolls.
  final Axis direction;

  /// The padding applied to the carousel. This does not impact the spacing
  /// between pages in the carousel.
  final EdgeInsets padding;

  /// The spacing between pages in the carousel.
  final double spacing;

  /// The pages in the carousel.
  final List<CarouselPage> pages;

  /// Creates a [Carousel].
  const Carousel({
    super.key,
    this.direction = Axis.horizontal,
    this.padding = EdgeInsets.zero,
    this.spacing = 0,
    required this.pages,
  });

  EdgeInsets _getPadding(BuildContext context, int index) {
    final double startPadding = index > 0 ? spacing : 0;

    return direction == Axis.horizontal
        ? EdgeInsets.only(
            left: context.isLtr ? startPadding : 0,
            right: context.isRtl ? startPadding : 0,
          )
        : EdgeInsets.only(
            top: startPadding,
          );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveConstraints = constraints.copyWith(
          maxWidth: constraints.maxWidth - padding.left - padding.right,
          maxHeight: constraints.maxHeight - padding.top - padding.bottom,
        );

        final sizedPages = pages.indexed.map(
          (page) => _SizedPage(
            size: page.$2.layout(effectiveConstraints),
            child: page.$2.child,
          ),
        );

        final maxCrossAxisSize =
            sizedPages.map((page) => page.size.crossAxisSize(direction)).max;

        return ConstrainedBox(
          constraints: direction == Axis.horizontal
              ? BoxConstraints.tightFor(
                  height: maxCrossAxisSize,
                )
              : BoxConstraints.tightFor(
                  width: maxCrossAxisSize,
                ),
          child: ListView(
            padding: padding,
            scrollDirection: direction,
            physics: _CarouselScrollPhysics(
              direction: direction,
              spacing: spacing,
              pages: sizedPages.toList(),
            ),
            children: [
              ...sizedPages.indexed.map(
                (page) => Padding(
                  padding: _getPadding(context, page.$1),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(page.$2.size),
                    child: page.$2.child,
                  ),
                ),
              ),
              SizedBox(
                width: direction == Axis.horizontal
                    ? constraints.maxWidth
                    : constraints.maxHeight,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CarouselScrollPhysics extends ScrollPhysics {
  final Axis direction;
  final double spacing;
  final List<_SizedPage> pages;

  /// Creates physics for a [Carousel].
  const _CarouselScrollPhysics({
    super.parent,
    required this.direction,
    required this.spacing,
    required this.pages,
  });

  @override
  _CarouselScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CarouselScrollPhysics(
      parent: buildParent(ancestor),
      direction: direction,
      spacing: spacing,
      pages: pages,
    );
  }

  double _getPage(ScrollMetrics position) {
    double currentPagePositionPixels = 0;

    for (final page in pages.indexed) {
      var currentPageIndex = page.$1;
      var currentPage = page.$2;
      var currentPageSize = currentPage.size.mainAxisSize(direction);

      if (currentPagePositionPixels + currentPageSize > position.pixels) {
        final pixelsTravelledOnPage =
            position.pixels - currentPagePositionPixels;
        final fractionTravelledOnPage = pixelsTravelledOnPage / currentPageSize;

        return currentPageIndex + fractionTravelledOnPage;
      }

      currentPagePositionPixels +=
          page.$2.size.mainAxisSize(direction) + spacing;
    }

    return 0;
  }

  double _getPixels(ScrollMetrics position, int pageIndex) {
    return pages
        .slice(0, min(pages.length, pageIndex))
        .map((page) => page.size.mainAxisSize(direction) + spacing)
        .sum;
  }

  double _getTargetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    int effectivePage = min(page.round(), pages.length - 1);
    return _getPixels(position, effectivePage);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
