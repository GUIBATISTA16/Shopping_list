import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/globais/functionsglobal.dart';
import 'package:shopping_list/screens/homepage.dart';
import 'package:shopping_list/service/database.dart';
import 'package:shopping_list/widget/keepalive.dart';

import '../../globais/colorsglobal.dart';
import '../../riverpod/loggeduserprovider.dart';
import '../../riverpod/selectedlistprovider.dart';
import '../../screens/viewlist.dart';
import '../standalonewidgets/textoprincipal.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {

  late final PageController _pageController;

  @override
  void initState()  {
    super.initState();
    final uid = ref.read(userUidProvider);
    Database.removeListasCompletas(uid!);//remove as listas completas de 7 dias ao iniciar a página
    _pageController = PageController(initialPage: pageIndex);
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final selectedList = ref.watch(selectedListaNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const TextoPrincipal(text: 'Bem-vindo á sua Shopping List'),
        backgroundColor: principal,
      ),
      backgroundColor: fundoMenusSecondary,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          KeepAlivePage(child: HomePage(pageController: _pageController,)),//manter a página "viva" para não acabar com a stream
          // ao mudar para a outra página
          if(selectedList != null)//caso tenha selecionado uma lista
            KeepAlivePage(child: ViewListaDeCompras(pageController: _pageController,))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: principal,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Listas de Compras ',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Lista Selecionada ',
          ),
        ],
        currentIndex: pageIndex,
        onTap: (index) {
          if((index == 1 && selectedList != null) || index == 0){//caso selecione a página da lista selecionada verifica mesmo se tem lista selecionada
            setState(() {
              pageIndex = index;
            });
            _pageController.animateToPage(
              pageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          else{
            showCustomSnackBar(context, 'Não tem uma lista selecionada');
          }
        },
      ),
    );
  }
}
