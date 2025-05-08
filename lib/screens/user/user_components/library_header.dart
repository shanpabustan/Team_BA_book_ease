import 'package:flutter/material.dart';

class AnimatedHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool isVisible;

  AnimatedHeader({
    required this.child,
    required this.isVisible,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }

  @override
  double get maxExtent => isVisible ? 120.0 : 0.0;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(AnimatedHeader oldDelegate) {
    return oldDelegate.isVisible != isVisible || oldDelegate.child != child;
  }
}
