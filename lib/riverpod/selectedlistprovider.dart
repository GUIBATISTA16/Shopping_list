import 'package:riverpod/riverpod.dart';
import 'package:shopping_list/models/listadecompras.dart';
import 'package:shopping_list/riverpod/streamprovider.dart';

class SelectedListNotifier extends Notifier<ListaDeCompras?> {

  late final Stream<List<ListaDeCompras>> listasStream;

  @override
  ListaDeCompras? build() {

    ref.listen<AsyncValue<List<ListaDeCompras>>>(
      listasStreamProvider,
          (previous, next) {
        if (next is AsyncData<List<ListaDeCompras>>) {
          final listas = next.value;

          if (state != null) {
            final listaAtualizada = listas.firstWhere((lista) => lista.id == state!.id);
            state = listaAtualizada;
          }
        }
      },
    );

    return null;
  }

  void selectLista(ListaDeCompras? lista) {
    state = lista;
  }

}

final selectedListaNotifierProvider = NotifierProvider<SelectedListNotifier, ListaDeCompras?>(() {
  return SelectedListNotifier();
});