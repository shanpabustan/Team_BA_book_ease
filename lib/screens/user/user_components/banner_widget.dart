import 'dart:async';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final List<String> originalImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  late List<String> imagePaths;
  late PageController controller;
  Timer? timer;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    // Create fake first and last for smooth looping
    imagePaths = [
      originalImages.last,
      ...originalImages,
      originalImages.first,
    ];

    controller =
        PageController(initialPage: currentPage, viewportFraction: 0.9);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoSlide();
    });
  }

  void startAutoSlide() {
    stopAutoSlide();
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!controller.hasClients) return;

      controller.nextPage(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  void stopAutoSlide() {
    timer?.cancel();
  }

  void handleLoopTransition(int index) {
    if (index == 0) {
      // Jump to last real image
      controller.jumpToPage(originalImages.length);
    } else if (index == imagePaths.length - 1) {
      // Jump to first real image
      controller.jumpToPage(1);
    }
  }

  @override
  void dispose() {
    stopAutoSlide();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: stopAutoSlide,
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          controller: controller,
          itemCount: imagePaths.length,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });

            // Delay the loop fix just slightly for animation to complete
            Future.delayed(const Duration(milliseconds: 350), () {
              handleLoopTransition(index);
            });

            stopAutoSlide();
            startAutoSlide();
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
