import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/riverpod/selectedlistprovider.dart';

import '../../riverpod/loggeduserprovider.dart';
import '../../screens/login.dart';

class Logout extends ConsumerWidget {
  final double size;
  const Logout ({super.key, this.size = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.logout),
      color: Colors.red,
      iconSize: size,
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        ref.read(userUidProvider.notifier).state = null;
        ref.read(selectedListaNotifierProvider.notifier).selectLista(null);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
    );

  }
}