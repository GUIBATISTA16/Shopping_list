import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/screens/editlist.dart';
import 'package:shopping_list/screens/viewlist.dart';
import 'package:shopping_list/service/database.dart';
import 'package:shopping_list/widget/home/listadecompraslist.dart';
import 'package:uuid/v8.dart';
import '../globais/colorsglobal.dart';
import '../globais/functionsglobal.dart';
import '../globais/objectglobal.dart';
import '../globais/validator.dart';
import '../globais/widgetglobal.dart';
import '../riverpod/selectedlistprovider.dart';
import '../riverpod/streamprovider.dart';
import '../widget/loading.dart';
import '../widget/logout.dart';
import 'login.dart';


class HomePage extends ConsumerStatefulWidget {
  final PageController pageController;

  const HomePage({super.key, required this.pageController});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  final _nomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void popupCriarLista() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
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
                    if (_formKey.currentState!.validate()) {
                      String listName = _nomeController.text;
                      _nomeController.text = '';
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => EditLista(
                            listaDeCompras: ListaDeCompras(
                              id: UuidV8().generate(),
                              nome: listName,
                              createdDate: DateTime.now(),
                              listItems: [],
                            ),
                          ),
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
    super.build(context); // Necessário para AutomaticKeepAliveClientMixin
    final listasAsync = ref.watch(listasStreamProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: popupCriarLista,
                child: Row(
                  children: [
                    Icon(
                      Icons.add_box,
                      color: principal,
                      size: 35,
                    ),
                    Text(
                      'Nova Lista',
                      style: TextStyle(
                        color: principal,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Logout(size: 35),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: fundoMenus,
            child: listasAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('Nenhuma Lista'));
                }
                return ListaDeComprasLista(
                  list: list,
                  pageController: widget.pageController,
                );
              },
              loading: () => const Center(child: Loading()),
              error: (err, stack) => Center(
                child: Text('Error: $err'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
