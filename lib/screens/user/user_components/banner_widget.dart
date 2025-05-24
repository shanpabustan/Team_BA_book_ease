// banner_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';

class BannerWidget extends StatefulWidget {
  final VoidCallback onReserveTap;

  const BannerWidget({Key? key, required this.onReserveTap}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final List<Map<String, String>> originalImages = [
    {
      'image': 'assets/images/banner1.jpg',
      'title': 'Discover New Worlds',
      'subtitle': 'Explore thousands of books in our library',
    },
    {
      'image': 'assets/images/banner2.png',
      'title': 'Easy Book Reservations',
      'subtitle': 'Reserve books online with one click',
    },
    {
      'image': 'assets/images/banner3.png',
      'title': 'Your Library, Your Way',
      'subtitle': 'Access anytime, anywhere',
    },
  ];

  late List<Map<String, String>> imageData;
  late PageController controller;
  Timer? timer;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    imageData = [
      originalImages.last,
      ...originalImages,
      originalImages.first,
    ];
    controller =
        PageController(initialPage: currentPage, viewportFraction: 0.9);
    WidgetsBinding.instance.addPostFrameCallback((_) => startAutoSlide());
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
      controller.jumpToPage(originalImages.length);
    } else if (index == imageData.length - 1) {
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
        height: 200,
        child: PageView.builder(
          controller: controller,
          itemCount: imageData.length,
          onPageChanged: (index) {
            setState(() => currentPage = index);
            Future.delayed(const Duration(milliseconds: 350), () {
              handleLoopTransition(index);
            });
            stopAutoSlide();
            startAutoSlide();
          },
          itemBuilder: (context, index) {
            final item = imageData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['subtitle']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: widget.onReserveTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AdminColor.secondaryBackgroundColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Reserve Now'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
