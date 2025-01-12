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

  factory Item.fromJson(Map<dynamic, dynamic> json) {
    return Item(
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      quantidade: json['quantidade'] as int,
      comprado: json['comprado'] as bool,
    );
  }

  @override
  String toString() {
    return 'Item{nome: $nome, tipo: $tipo, quantidade: $quantidade, comprado: $comprado}';
  }

}