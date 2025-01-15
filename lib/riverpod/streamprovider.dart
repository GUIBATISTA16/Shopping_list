import 'package:riverpod/riverpod.dart';
import 'package:shopping_list/models/listadecompras.dart';
import '../service/database.dart';
import 'loggeduserprovider.dart';

final listasStreamProvider = StreamProvider<List<ListaDeCompras>>((ref) {
  final uid = ref.watch(userUidProvider);
  if (uid == null) return Stream.value([]);
  return Database.getListasStream(uid);
});

