import 'package:firebase_database/firebase_database.dart';
import 'package:shopping_list/models/listadecompras.dart';

class Database {

  static Future<void> addLista(ListaDeCompras lista,String uid) async {
    final dbRef = FirebaseDatabase.instance.ref('listas').child(uid).child(lista.id);
    try{
      await dbRef.set(lista.toJson());
    } catch(e){
      print(e);
    }
  }

  static Future<void> removeLista(String listid, String uid) async{
    final dbRef = FirebaseDatabase.instance.ref('listas').child(uid).child(listid);
    try{
      await dbRef.remove();
    } catch(e){
      print(e);
    }
  }

  static void removeListasCompletas(String uid) async{
    final dbRef = FirebaseDatabase.instance.ref('listas').child(uid);

    await dbRef.once().then((val) async{
      final data = val.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final list = data.entries
            .map(ListaDeCompras.fromJson)
            .toList();
        DateTime threeDaysAgo = DateTime.now().subtract(Duration(days: 3));//3 dias atras
        for(ListaDeCompras shpl in list){//verificar que listas de compras já têm todos os itens comprados e existem há mais de 3 dias
          if(shpl.itensPorComprar == 0 && shpl.createdDate.isBefore(threeDaysAgo)){
            await removeLista(shpl.id,uid);
          }
        }
      }

    });
  }

  static Stream<List<ListaDeCompras>> getListasStream(String uid) {
    final dbRef = FirebaseDatabase.instance.ref('listas').child(uid);

    return dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final listas = data.entries.map(ListaDeCompras.fromJson).toList();
        listas.sort((a, b) => b.createdDate.compareTo(a.createdDate));
        return listas;
      } else {
        return [];
      }
    });
  }

}