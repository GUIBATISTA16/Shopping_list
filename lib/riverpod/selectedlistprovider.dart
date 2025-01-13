import 'package:riverpod/riverpod.dart';
import 'package:shopping_list/models/listadecompras.dart';

class SelectedListNotifier extends Notifier<ListaDeCompras?> {

  @override
  ListaDeCompras? build() {
    return null;
  }

  void selectLista(ListaDeCompras lista) {
    state = lista;
  }

}

final selectedListaNotifierProvider = NotifierProvider<SelectedListNotifier, ListaDeCompras?>(() {
  return SelectedListNotifier();
});