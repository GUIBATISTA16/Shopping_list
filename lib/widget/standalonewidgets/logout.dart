import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/globais/objectglobal.dart';

import '../../screens/login.dart';

class Logout extends StatelessWidget {
  final double size;
  const Logout ({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      color: Colors.red,
      iconSize: size,
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        loggedUser = null;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
    );

  }
}