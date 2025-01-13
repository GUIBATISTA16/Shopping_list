import 'package:riverpod/riverpod.dart';
import 'package:shopping_list/models/listadecompras.dart';
import '../service/database.dart';

final listasStreamProvider = StreamProvider<List<ListaDeCompras>>((ref) {
  return Database.getListasStream();
});
