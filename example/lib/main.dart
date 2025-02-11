import 'package:flutter/material.dart';
import 'package:flutter_simple_carousel/flutter_simple_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Text("Expanded Pages"),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 200),
              child: Carousel(
                pages: [
                  CarouselPage.expanded(
                    child: Page(color: Colors.red),
                  ),
                  CarouselPage.expanded(
                    child: Page(color: Colors.blue),
                  ),
                  CarouselPage.expanded(
                    child: Page(color: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text("Variably Sized Pages"),
            Carousel(
              pages: [
                CarouselPage.sized(
                  size: Size(
                    200,
                    200,
                  ),
                  child: Page(color: Colors.red),
                ),
                CarouselPage.sized(
                  size: Size(
                    300,
                    200,
                  ),
                  child: Page(color: Colors.blue),
                ),
                CarouselPage.sized(
                  size: Size(
                    400,
                    200,
                  ),
                  child: Page(color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text("Spaced Pages"),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 200),
              child: Carousel(
                padding: EdgeInsets.symmetric(horizontal: 20),
                spacing: 10,
                pages: [
                  CarouselPage.expanded(
                    child: Page(color: Colors.red),
                  ),
                  CarouselPage.expanded(
                    child: Page(color: Colors.blue),
                  ),
                  CarouselPage.expanded(
                    child: Page(color: Colors.green),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text("Dynamically Sized Pages"),
            Carousel(
              pages: [
                CarouselPage(
                  layout: (constraints) => Size(
                    1 * constraints.maxWidth / 3,
                    200,
                  ),
                  child: Page(color: Colors.red, label: "1 / 3"),
                ),
                CarouselPage(
                  layout: (constraints) => Size(
                    2 * constraints.maxWidth / 3,
                    200,
                  ),
                  child: Page(color: Colors.blue, label: "2 / 3"),
                ),
                CarouselPage(
                  layout: (constraints) => Size(
                    3 * constraints.maxWidth / 3,
                    200,
                  ),
                  child: Page(color: Colors.green, label: "3 / 3"),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text("Right To Left Pages"),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 200),
                child: Carousel(
                  pages: [
                    CarouselPage.expanded(
                      child: Page(color: Colors.red),
                    ),
                    CarouselPage.expanded(
                      child: Page(color: Colors.blue),
                    ),
                    CarouselPage.expanded(
                      child: Page(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Text("Vertical Pages"),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 200),
              child: Carousel(
                direction: Axis.vertical,
                pages: [
                  CarouselPage.expanded(
                    child: Page(direction: Axis.vertical, color: Colors.red),
                  ),
                  CarouselPage.expanded(
                    child: Page(direction: Axis.vertical, color: Colors.blue),
                  ),
                  CarouselPage.expanded(
                    child: Page(direction: Axis.vertical, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final Axis direction;
  final Color color;
  final String? label;

  const Page({
    super.key,
    this.direction = Axis.horizontal,
    required this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              direction == Axis.horizontal
                  ? Icons.arrow_forward
                  : Icons.arrow_downward,
              size: 40,
            ),
            if (label != null)
              Text(label!),
          ],
        ),
      ),
    );
  }
}
