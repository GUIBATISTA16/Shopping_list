import 'package:shopping_list/models/item.dart';

class ListaDeCompras {

  String id;

  String nome;

  final DateTime createdDate;

  List<Item> listItems;

  int itensPorComprar;

  ListaDeCompras({required this.id ,required this.nome,required this.createdDate,required this.listItems}) : itensPorComprar = calculateItensPorComprar(listItems);

  static int calculateItensPorComprar(List<Item> listItems){
    int itensPorComprar = 0;
    for(Item item in listItems){
      if(!item.comprado){
        itensPorComprar++;
      }
    }
    return itensPorComprar;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'createdDate': createdDate.toIso8601String(),
      'listItems': listItems.map((item) => item.toJson()).toList(),
    };
  }

  factory ListaDeCompras.fromJson(MapEntry<dynamic, dynamic> entry) {
    final listaData = entry.value as Map<dynamic, dynamic>;
    final listItems = (listaData['listItems'] as List<dynamic>)
        .map((itemData) => Item.fromJson(itemData))
        .toList();
    return ListaDeCompras(
      id: entry.key as String,
      nome: listaData['nome'] as String,
      createdDate: DateTime.parse(listaData['createdDate'] as String),
      listItems: listItems,
    );
  }

  @override
  String toString() {
    return 'ListaDeCompras{id: $id, nome: $nome, createdDate: $createdDate, listItems: $listItems}';
  }

}