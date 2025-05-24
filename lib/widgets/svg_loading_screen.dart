import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SvgLoadingScreen extends StatelessWidget {
  const SvgLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: const Color(0xFF317873),
        size: 80,
      ),
    );
  }
}
