class Item {

  String nome;

  String tipo;

  int quantidade;

  bool comprado;

  Item({required this.nome,required this.tipo,required this.quantidade,required this.comprado});

  Map<String, dynamic> toJson() {//converter para JSON
    return {
      'nome': nome,
      'tipo': tipo,
      'quantidade': quantidade,
      'comprado': comprado,
    };
  }

  factory Item.fromJson(Map<dynamic, dynamic> json) {//converter de JSON
    return Item(
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      quantidade: json['quantidade'] as int,
      comprado: json['comprado'] as bool,
    );
  }

  Item copy() {//gerar uma "deep copy"
    return Item(
      nome: nome,
      tipo: tipo,
      quantidade: quantidade,
      comprado: comprado,
    );
  }

  @override
  String toString() {
    return 'Item{nome: $nome, tipo: $tipo, quantidade: $quantidade, comprado: $comprado}';
  }

}