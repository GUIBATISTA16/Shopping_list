import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackButao extends StatelessWidget {
  final Color color;
  const BackButao({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      color: color,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}