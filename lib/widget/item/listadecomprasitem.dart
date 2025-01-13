import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/globais/functionsglobal.dart';
import 'package:shopping_list/globais/objectglobal.dart';
import 'package:shopping_list/models/item.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/screens/viewlist.dart';
import 'package:shopping_list/service/database.dart';

import '../../globais/colorsglobal.dart';
import '../../riverpod/selectedlistprovider.dart';
import '../../screens/editlist.dart';

class ListadDeComprasItem extends ConsumerStatefulWidget {
  final ListaDeCompras lista;
  final PageController pageController;
  const ListadDeComprasItem({super.key, required this.lista, required this.pageController});

  @override
  ConsumerState<ListadDeComprasItem> createState() => _ListadecomprasitemState();
}

class _ListadecomprasitemState extends ConsumerState<ListadDeComprasItem> {

  @override
  Widget build(BuildContext context) {
    final selectedList = ref.watch(selectedListaNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          ref.read(selectedListaNotifierProvider.notifier).selectLista(widget.lista);
          widget.pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Card(
          color: Colors.white,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.lista.nome),
                Text('${widget.lista.itensPorComprar} Itens por comprar',
                  style: TextStyle(
                    color: widget.lista.itensPorComprar == 0 ? Colors.green : Colors.red
                  ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(widget.lista.createdDate)),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditLista(
                              listaDeCompras: ListaDeCompras(
                                id: widget.lista.id,
                                nome: widget.lista.nome,
                                createdDate: widget.lista.createdDate,
                                listItems: widget.lista.listItems
                              )
                            )
                          ),
                        );
                      },
                      icon: Icon(Icons.edit)
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('Itens'),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.lista.listItems.length,
                      itemBuilder: (context,itemIndex){
                        return Row(
                          children: [
                            SizedBox(
                                width: 30,
                                child: Text(
                                  widget.lista.listItems[itemIndex].quantidade.toString()
                                  ,textAlign: TextAlign.left,
                                )
                            ),
                            Expanded(child: SizedBox()),
                            SizedBox(
                                width: 100,
                                child: Text(
                                  widget.lista.listItems[itemIndex].tipo
                                  ,textAlign: TextAlign.left,
                                )
                            ),
                            SizedBox(
                                width: 100,
                                child: Text(
                                  widget.lista.listItems[itemIndex].nome
                                  ,textAlign: TextAlign.left,
                                )
                            ),
                            Expanded(child: SizedBox()),
                            Checkbox(
                              checkColor: textoPrincipal,
                              activeColor: principal,
                              value: widget.lista.listItems[itemIndex].comprado,
                              onChanged: (bool? value) async{
                                value! ? widget.lista.itensPorComprar-- : widget.lista.itensPorComprar++;
                                setState(() {
                                  widget.lista.listItems[itemIndex].comprado = value;
                                });
                                await Database.addLista(widget.lista);
                              },
                            )
                          ],
                        );
                      }
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
