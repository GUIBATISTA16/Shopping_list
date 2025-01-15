import 'package:flutter/material.dart';

class ContainerBordasFinas extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  const ContainerBordasFinas({super.key, required this.child, this.borderRadius = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 0.5,
            color: Colors.black
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}