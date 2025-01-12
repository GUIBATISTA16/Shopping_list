import 'package:firebase_database/firebase_database.dart';
import 'package:shopping_list/globais/objectglobal.dart';
import 'package:shopping_list/models/listadecompras.dart';

import '../models/item.dart';

class Database {

  static Future<void> addLista(ListaDeCompras lista) async {
    final dbRef = FirebaseDatabase.instance.ref('listas').child(loggedUser!.uid).child(lista.id);
    try{
      await dbRef.set(lista.toJson());
    } catch(e){
      print(e);
    }
  }

  static Future<void> removeLista(String listid) async{
    final dbRef = FirebaseDatabase.instance.ref('listas').child(loggedUser!.uid).child(listid);
    try{
      await dbRef.remove();
    } catch(e){
      print(e);
    }
  }

  static Stream<List<ListaDeCompras>> getListasStream() {
    final dbRef = FirebaseDatabase.instance.ref('listas').child(loggedUser!.uid);

    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries.map(ListaDeCompras.fromJson).toList();
      } else {
        return [];
      }
    });
  }

}