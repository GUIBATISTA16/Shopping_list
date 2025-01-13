import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/widget/item/listadecomprasitem.dart';

import '../../globais/colorsglobal.dart';

class ListaDeComprasLista extends StatefulWidget {
  final List<ListaDeCompras> list;
  final PageController pageController;
  const ListaDeComprasLista({super.key, required this.list, required this.pageController});

  @override
  State<ListaDeComprasLista> createState() => _ListaDeComprasListaState();
}

class _ListaDeComprasListaState extends State<ListaDeComprasLista> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        return ListadDeComprasItem(lista: widget.list[index], pageController: widget.pageController,);
      },
    );
  }
}
