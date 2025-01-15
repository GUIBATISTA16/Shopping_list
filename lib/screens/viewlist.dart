import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/models/listadecompras.dart';

import '../globais/colorsglobal.dart';
import '../riverpod/loggeduserprovider.dart';
import '../riverpod/selectedlistprovider.dart';
import '../service/database.dart';
import '../widget/standalonewidgets/textoprincipal.dart';

class ViewListaDeCompras extends ConsumerStatefulWidget {
  final PageController pageController;
  const ViewListaDeCompras({super.key, required this.pageController});

  @override
  ViewListaDeComprasState createState() => ViewListaDeComprasState();
}

class ViewListaDeComprasState extends ConsumerState<ViewListaDeCompras> {
  @override
  Widget build(BuildContext context) {
    final selectedList = ref.watch(selectedListaNotifierProvider);//provider da lista selecionada
    final uid = ref.watch(userUidProvider);//provider do uid
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedList!.createdDate);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            widget.pageController.animateToPage(//volta para a página anterior
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          color: textoPrincipal
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextoPrincipal(text: selectedList.nome,fontSize: 24,),
            TextoPrincipal(text: formattedDate, fontSize: 19,)
          ],
        ),
        backgroundColor: principal,
      ),
      backgroundColor: fundoMenus,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(child: Text('Qtd.'),width: 30,),
                Expanded(child: SizedBox()),
                SizedBox(child: Text('Tipo'),width: 100,),
                SizedBox(child: Text('Item'),width: 100,),
                Expanded(child: SizedBox()),
                Text('Comprado')
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 2,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedList.listItems.length,
              itemBuilder: (context,itemIndex){
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 30,
                            child: Text(
                              selectedList.listItems[itemIndex].quantidade.toString()
                              ,textAlign: TextAlign.left,
                            )
                        ),
                        Expanded(child: SizedBox()),
                        SizedBox(
                            width: 100,
                            child: Text(
                              selectedList.listItems[itemIndex].tipo
                              ,textAlign: TextAlign.left,
                            )
                        ),
                        SizedBox(
                            width: 100,
                            child: Text(
                              selectedList.listItems[itemIndex].nome
                              ,textAlign: TextAlign.left,
                            )
                        ),
                        Expanded(child: SizedBox()),
                        Checkbox(
                          checkColor: textoPrincipal,
                          activeColor: principal,
                          value: selectedList.listItems[itemIndex].comprado,
                          onChanged: (bool? value) async{
                            value! ? selectedList.itensPorComprar-- : selectedList.itensPorComprar++;
                            setState(() {
                              selectedList.listItems[itemIndex].comprado = value;
                            });
                            await Database.addLista(selectedList,uid!);
                          },
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 2,
                      thickness: 1,
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
