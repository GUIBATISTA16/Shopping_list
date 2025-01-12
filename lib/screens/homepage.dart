import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/screens/editlist.dart';
import 'package:shopping_list/service/database.dart';
import 'package:uuid/v8.dart';
import '../globais/colorsglobal.dart';
import '../globais/functionsglobal.dart';
import '../globais/validator.dart';
import '../globais/widgetglobal.dart';
import '../widget/loading.dart';
import '../widget/logout.dart';
import 'login.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}
class HomePageState extends State<HomePage> {

  final _nomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<ListaDeCompras> list = [];
  ListaDeCompras? selectedList;

  @override
  void initState() {
    super.initState();
  }

  void popupCriarConta(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0), // Controla o espaçamento lateral
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackButao(
                color: Colors.black,
              ),
              Text('Criar Nova Lista'),
            ],
          ),
          backgroundColor: fundoMenus,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) => Validator.validateName(name: value),
                    controller: _nomeController,
                    cursorColor: preto,
                    decoration: InputDecoration(
                      labelText: 'Nome da Lista',
                      labelStyle: TextStyle(color: preto),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      String listName = _nomeController.text;
                      _nomeController.text = '';
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => EditLista(
                                listaDeCompras: ListaDeCompras(id: UuidV8().generate(), nome: listName, createdDate: DateTime.now(), listItems: []))
                        ),
                      );
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
                      Icon(
                        Icons.add,
                        size: 20,
                        color: textoPrincipal,
                      ),
                      const SizedBox(width: 8),
                      const TextoPrincipal(
                        text: 'Criar Lista',
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextoPrincipal(text: 'Bem-vindo á sua Shopping List'),
        backgroundColor: principal,
      ),
      backgroundColor: fundoMenusSecondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Icon(Icons.add_box,color: principal, size: 35,),
                        Text('Nova Lista',
                          style: TextStyle(
                            color: principal,
                            fontSize: 24
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      popupCriarConta();
                    },
                  ),
                  Expanded(child: Container()),
                  Logout(size: 35,)
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: fundoMenus,
                child: StreamBuilder(
                  stream: Database.getListasStream(),
                  builder: (context,snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Loading());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Nenhuma Lista'));
                    } else {
                      List<ListaDeCompras> list = snapshot.data!;
                      selectedList = list[0];
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: fundoCards,
                              child: ListTile(
                                title: Text(list[index].nome),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(DateFormat('dd/MM/yyyy').format(list[index].createdDate)),
                                        IconButton(
                                          onPressed: (){

                                          },
                                          icon: Icon(Icons.edit)
                                        ),
                                      ],
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    ),
                                    ExpansionTile(
                                      title: Text('Itens'),
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: list[index].listItems.length,
                                          itemBuilder: (context,itemIndex){
                                            return Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                  child: Text(
                                                    list[index].listItems[itemIndex].quantidade.toString()
                                                    ,textAlign: TextAlign.left,
                                                  )
                                                ),
                                                Expanded(child: SizedBox()),
                                                SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      list[index].listItems[itemIndex].tipo
                                                      ,textAlign: TextAlign.left,
                                                    )
                                                ),
                                                SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      list[index].listItems[itemIndex].nome
                                                      ,textAlign: TextAlign.left,
                                                    )
                                                ),
                                                Expanded(child: SizedBox()),
                                                Checkbox(
                                                  checkColor: textoPrincipal,
                                                  activeColor: principal,
                                                  value: list[index].listItems[itemIndex].comprado,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      list[index].listItems[itemIndex].comprado = value!;
                                                    });
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
                          );
                        },
                      );
                    }
                  }
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}
