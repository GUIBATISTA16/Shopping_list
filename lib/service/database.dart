import 'package:firebase_database/firebase_database.dart';
import 'package:shopping_list/globais/objectglobal.dart';
import 'package:shopping_list/models/listadecompras.dart';

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
}