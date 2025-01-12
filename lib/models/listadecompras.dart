import 'package:shopping_list/models/item.dart';

class ListaDeCompras {

  String id;

  String nome;

  final DateTime createdDate;

  List<Item> listItems;

  ListaDeCompras({required this.id ,required this.nome,required this.createdDate,required this.listItems});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'createdDate': createdDate.toIso8601String(),
      'listItems': listItems.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ListaDeCompras{id: $id, nome: $nome, createdDate: $createdDate, listItems: $listItems}';
  }

}