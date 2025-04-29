import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class ReusableDashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry outerPadding; // 👈 Add this line
  final double? width;

  const ReusableDashboardCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
    this.outerPadding = const EdgeInsets.only(
        top: 20.0, bottom: 20.0), // 👈 Default stays the same
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding, // 👈 Use this instead
      child: SizedBox(
        width: width,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: DashboardTheme.cardBackground,
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
      ),
    );
  }
}
