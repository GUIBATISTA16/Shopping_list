import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/globais/colorsglobal.dart';
import 'package:shopping_list/globais/functionsglobal.dart';
import 'package:shopping_list/globais/validator.dart';
import 'package:shopping_list/models/item.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/screens/homepage.dart';
import 'package:shopping_list/service/database.dart';

import '../riverpod/loggeduserprovider.dart';
import '../riverpod/selectedlistprovider.dart';
import '../widget/standalonewidgets/backbutton.dart';
import '../widget/standalonewidgets/textoprincipal.dart';

class EditLista extends ConsumerStatefulWidget {
  final ListaDeCompras listaDeCompras;
  const EditLista({super.key, required this.listaDeCompras});

  @override
  ConsumerState<EditLista> createState() => _EditListaState();
}

class _EditListaState extends ConsumerState<EditLista> {

  final _nomeListaController = TextEditingController();
  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _nameControllers = [];
  final List<String> tipo = ["kg", "g", "L", "mL", "Pacotes", "Meia Duzia", "Duzia", "Latas", "Garrafas"];
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  
  late ListaDeCompras listaAAlterar;

  @override
  void initState() {
    super.initState();
    listaAAlterar = widget.listaDeCompras.copy();
    _nomeListaController.text = listaAAlterar.nome;
    for (Item item in widget.listaDeCompras.listItems) {//gera os controlladores para cada item
      _quantityControllers.add(TextEditingController(text: item.quantidade.toString()));
      _nameControllers.add(TextEditingController(text: item.nome));
    }
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    _nomeListaController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addItem(ListaDeCompras lista) {//adiciona um item á lista e os seus controladores
    setState(() {
      Item item = Item(nome: "", tipo: "kg", quantidade: 0, comprado: false);
      lista.listItems.add(item);
      print(item);
      _quantityControllers.add(TextEditingController(text: "0"));
      _nameControllers.add(TextEditingController(text: ""));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {//caso o botão fique escondido ao adicionar um item volta a mostrar o botão
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeItem(int index, ListaDeCompras lista) {//remove um item da lista e os seus controladores
    setState(() {
      lista.listItems.removeAt(index);
      _quantityControllers[index].dispose();
      _nameControllers[index].dispose();
      _quantityControllers.removeAt(index);
      _nameControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(listaAAlterar.createdDate);
    final selectedList = ref.watch(selectedListaNotifierProvider);
    final uid = ref.watch(userUidProvider);
    return Scaffold(
      appBar: AppBar(
        leading: BackButao(color: textoPrincipal),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: Duration(seconds: 2),
                message: 'Deslizar para remover um Item',
                child: Icon(Icons.info_outline,color: textoPrincipal,)
            ),
          ),
          IconButton(
            onPressed: () async {
              await Database.removeLista(listaAAlterar.id,uid!);//remove da BD
              if(selectedList?.id == listaAAlterar.id){//caso a lista selecionada seja eliminada
                ref.read(selectedListaNotifierProvider.notifier).selectLista(null);//tira a lista selecionada
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete_forever, color: Colors.red, size: 35,)
          ),
        ],
        title: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              if(value!.isEmpty){
                return '';
              }
              return null;
            },
            textCapitalization: TextCapitalization.sentences,
            controller: _nomeListaController,
            style: TextStyle(color: textoPrincipal),
            decoration: InputDecoration(
              hintText: "Nome da lista",
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: textoPrincipal
                )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: textoPrincipal
                  )
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: textoPrincipal
                  )
              ),
              hintStyle: TextStyle(color: textoPrincipal),
              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            ),
            onChanged: (val){
              listaAAlterar.nome = val;
            },
          ),
        ),
        backgroundColor: principal,
      ),
      backgroundColor: fundoMenus,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qtd.'),
                Text('Tipo'),
                Text('Item'),
                Text('Comprado')
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaAAlterar.listItems.length,
                      itemBuilder: (context, index) {
                        bool checkBox = listaAAlterar.listItems[index].comprado;
                        return Dismissible(//deslizar para remover item da lista
                          key: Key(listaAAlterar.listItems[index].hashCode.toString()),
                          background: Container(color: Colors.red,child: Align(child: Icon(Icons.delete_forever),alignment: Alignment.centerLeft,),),
                          secondaryBackground: Container(color: Colors.red,child: Align(child: Icon(Icons.delete_forever),alignment: Alignment.centerRight,),),
                          onDismissed: (_){
                            showCustomSnackBar(context, 'Item ${listaAAlterar.listItems[index].nome} removido');
                            setState(() {
                              _removeItem(index,listaAAlterar);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    controller: _quantityControllers[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                    ),
                                    onChanged: (val){
                                      listaAAlterar.listItems[index].quantidade = int.parse(val) ;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 120,
                                  child: DropdownButtonFormField<String>(
                                    value: listaAAlterar.listItems[index].tipo,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                                    ),
                                    dropdownColor: fundoMenus,
                                    onChanged: (value) {
                                      setState(() {
                                        listaAAlterar.listItems[index].tipo = value!;
                                      });
                                    },
                                    items: tipo.map((unit) {
                                      return DropdownMenuItem<String>(
                                        value: unit,
                                        child: Text(unit),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    controller: _nameControllers[index],
                                    decoration: InputDecoration(
                                      hintText: "Item",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    ),
                                    onChanged: (val){
                                      listaAAlterar.listItems[index].nome = val;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Checkbox(
                                  checkColor: textoPrincipal,
                                  activeColor: principal,
                                  value: checkBox,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      listaAAlterar.listItems[index].comprado = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                        onPressed: (){
                          _addItem(listaAAlterar);
                        },
                        icon: Icon(Icons.add_circle_outline, color:  principal,size: 35,)
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    ListaDeCompras lista = listaAAlterar;
                    lista.listItems.removeWhere((item) => (item.quantidade <= 0));//remove itens incompletos
                    lista.listItems.removeWhere((item) => (item.nome.trim() == ""));//remove itens incompletos
                    if(lista.listItems.isEmpty){//elimina automaticamente a lista caso não tenha itens
                      showCustomSnackBar(context, 'Lista Sem Itens');
                      await Database.removeLista(listaAAlterar.id,uid!);
                      Navigator.pop(context);
                      return;
                    }
                    print(lista);
                    await Database.addLista(lista,uid!);//guarda na BD
                    showCustomSnackBar(context, 'Lista Guardada');
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: principal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: textoPrincipal,),
                    const TextoPrincipal(
                      text: 'Salvar Lista',
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
