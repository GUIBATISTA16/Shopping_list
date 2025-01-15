import 'package:flutter/cupertino.dart';

import '../../globais/colorsglobal.dart';

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