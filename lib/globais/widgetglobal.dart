import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../screens/login.dart';
import 'colorsglobal.dart';

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

class TextoPrincipal extends StatelessWidget {
  final double? fontSize;
  final int? maxLines;
  final String text;
  final TextAlign textAlign;
  const TextoPrincipal({
    super.key,
    required this.text,
    this.fontSize,
    this.maxLines,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontSize: fontSize,
        color: textoPrincipal
      ),
      maxLines: maxLines,
    );
  }
}

class BlackText extends StatelessWidget {
  final double? fontSize;
  final int? maxLines;
  final String text;
  final TextAlign textAlign;
  const BlackText({
    super.key,
    required this.text,
    this.fontSize,
    this.maxLines,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          fontSize: fontSize,
          color: preto
      ),
      maxLines: maxLines,
    );
  }
}

class Carde extends StatelessWidget {
  final Widget child;
  final Color color;
  const Carde({super.key, required this.child, this.color = Colors.white70});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: child,
    );
  }
}

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







