import 'package:flutter/material.dart';

void fadePush(BuildContext context, Widget page,
    {Duration duration = const Duration(milliseconds: 150)}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
