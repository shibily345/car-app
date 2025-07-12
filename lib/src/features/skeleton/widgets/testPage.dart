import 'package:flutter/material.dart';

class ScrollingAnimationPage extends StatefulWidget {
  const ScrollingAnimationPage({super.key});

  @override
  _ScrollingAnimationPageState createState() => _ScrollingAnimationPageState();
}

class _ScrollingAnimationPageState extends State<ScrollingAnimationPage> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrolling Animation'),
        backgroundColor: Colors.blueAccent,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = scrollNotification.metrics.pixels;
            });
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Vertical list of containers
              for (int i = 0; i < 10; i++)
                AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    vertical: (_scrollOffset / 10).clamp(10.0, 50.0),
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.primaries[i % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Horizontal scrollable row of containers
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.accents[index % Colors.accents.length],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
