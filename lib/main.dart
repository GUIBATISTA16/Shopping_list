import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/screens/login.dart';


import 'firebase_options.dart';
import 'globais/colorsglobal.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:  DefaultFirebaseOptions.currentPlatform
  );*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: preto,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: preto,
          //selectionColor: preto,
          selectionHandleColor: principal,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
