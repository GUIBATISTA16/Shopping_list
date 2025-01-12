class Item {

  String nome;

  String tipo;

  int quantidade;

  bool comprado;

  Item({required this.nome,required this.tipo,required this.quantidade,required this.comprado});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'quantidade': quantidade,
      'comprado': comprado,
    };
  }

  @override
  String toString() {
    return 'Item{nome: $nome, tipo: $tipo, quantidade: $quantidade, comprado: $comprado}';
  }

}