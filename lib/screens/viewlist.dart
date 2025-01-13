import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/models/listadecompras.dart';

import '../globais/colorsglobal.dart';
import '../globais/widgetglobal.dart';
import '../riverpod/selectedlistprovider.dart';
import '../service/database.dart';

class ViewListaDeCompras extends ConsumerStatefulWidget {
  const ViewListaDeCompras({super.key});

  @override
  ViewListaDeComprasState createState() => ViewListaDeComprasState();
}

class ViewListaDeComprasState extends ConsumerState<ViewListaDeCompras> {
  @override
  Widget build(BuildContext context) {
    final selectedList = ref.watch(selectedListaNotifierProvider);
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedList!.createdDate);
    return Scaffold(
      appBar: AppBar(
        //leading: BackButao(color: textoPrincipal),TODO
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedList.listItems.length,
            itemBuilder: (context,itemIndex){
              return Row(
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
                      await Database.addLista(selectedList);
                    },
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}
