import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/globais/colorsglobal.dart';
import 'package:shopping_list/globais/functionsglobal.dart';
import 'package:shopping_list/globais/objectglobal.dart';
import 'package:shopping_list/globais/widgetglobal.dart';
import 'package:shopping_list/models/item.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/screens/homepage.dart';
import 'package:shopping_list/service/database.dart';

class EditLista extends StatefulWidget {
  final ListaDeCompras listaDeCompras;
  const EditLista({super.key, required this.listaDeCompras});

  @override
  State<EditLista> createState() => _EditListaState();
}

class _EditListaState extends State<EditLista> {


  List<TextEditingController> _quantityControllers = [];
  List<TextEditingController> _nameControllers = [];
  final List<String> _units = ["kg", "g", "L", "mL", "Pacotes", "Meia Duzia", "Duzia"];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (Item item in widget.listaDeCompras.listItems) {
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
    _scrollController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      Item item = Item(nome: "", tipo: "kg", quantidade: 0, comprado: false);
      widget.listaDeCompras.listItems.add(item);
      print(item);
      _quantityControllers.add(TextEditingController(text: "0"));
      _nameControllers.add(TextEditingController(text: ""));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.listaDeCompras.listItems.removeAt(index);
      _quantityControllers[index].dispose();
      _nameControllers[index].dispose();
      _quantityControllers.removeAt(index);
      _nameControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(widget.listaDeCompras.createdDate);
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
              await Database.removeLista(widget.listaDeCompras.id);
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.delete_forever, color: Colors.red, size: 35,)
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextoPrincipal(text: widget.listaDeCompras.nome,fontSize: 24,),
            TextoPrincipal(text: formattedDate, fontSize: 19,)
          ],
        ),
        backgroundColor: principal,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qtd.'),
                Text('Tipo'),
                Text('Item'),
                Text('Comprado')
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.listaDeCompras.listItems.length,
                    itemBuilder: (context, index) {
                      bool checkBox = widget.listaDeCompras.listItems[index].comprado;
                      return Dismissible(//deslizar para remover item da lista
                        key: Key(widget.listaDeCompras.listItems[index].hashCode.toString()),
                        background: Container(color: Colors.red,child: Align(child: Icon(Icons.delete_forever),alignment: Alignment.centerLeft,),),
                        secondaryBackground: Container(color: Colors.red,child: Align(child: Icon(Icons.delete_forever),alignment: Alignment.centerRight,),),
                        onDismissed: (_){
                          showCustomSnackBar(context, 'Item ${widget.listaDeCompras.listItems[index].nome} removido');
                          setState(() {
                            _removeItem(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    widget.listaDeCompras.listItems[index].quantidade = int.parse(val) ;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 120,
                                child: DropdownButtonFormField<String>(
                                  value: widget.listaDeCompras.listItems[index].tipo,
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
                                  onChanged: (value) {
                                    setState(() {
                                      widget.listaDeCompras.listItems[index].tipo = value!;
                                    });
                                  },
                                  items: _units.map((unit) {
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
                                    widget.listaDeCompras.listItems[index].nome = val;
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
                                    widget.listaDeCompras.listItems[index].comprado = value!;
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
                        _addItem();
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
                ListaDeCompras lista = widget.listaDeCompras;
                lista.listItems.removeWhere((item) => (item.quantidade <= 0));
                lista.listItems.removeWhere((item) => (item.nome.trim() == ""));
                if(lista.listItems.isEmpty){
                  showCustomSnackBar(context, 'Lista Sem Itens');
                  await Database.removeLista(widget.listaDeCompras.id);
                  Navigator.pop(context);
                  return;
                }
                print(lista);
                await Database.addLista(lista);
                showCustomSnackBar(context, 'Lista Guardada');
                Navigator.pop(context);
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
    );
  }
}
