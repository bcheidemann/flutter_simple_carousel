A simple carousel widget for Flutter.

## Features

- ✅ Page snapping
- ✅ Horizontal and vertical scrolling
- ✅ Automatic text direction handling
- ✅ Varying page sizes

## Getting started

```yaml
dependencies:
  simple_carousel: ^0.0.1
```

## Usage

```dart
import "simple_carousel/simple_carousel.dart";

ConstrainedBox(
  constraints: BoxConstraints.tightFor(height: 200),
  child: Carousel(
    pages: [
      CarouselPage.expanded(
        child: Container(color: Colors.red),
      ),
      CarouselPage.expanded(
        child: Container(color: Colors.blue),
      ),
      CarouselPage.expanded(
        child: Container(color: Colors.green),
      ),
    ],
  ),
);
```

## Additional information

Contributions are welcome!
