import 'package:flutter/material.dart';
import 'colorsglobal.dart';

void showCustomSnackBar(BuildContext context, String text) {//notificação in-app customizavel
  final snackBar = SnackBar(
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: principal,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 16.0,
        ),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    margin: const EdgeInsets.only(
      bottom: 50,
      left: 70,
      right: 70,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
