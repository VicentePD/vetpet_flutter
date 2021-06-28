class Pet {
  final int id;
  final String nome;
  final String datanascimento;
  final String pelagem;
  final String raca;
  final String sexo;
  final String tipo;

  Pet(this.id, this.nome, this.datanascimento, this.pelagem, this.raca,
      this.sexo, this.tipo);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'datanascimento': datanascimento,
      'pelagem': pelagem,
      'raca':raca,
      'sexo': sexo,
      'tipo': tipo,
    };
  }

  @override
  String toString() {
    return 'Pet{id: $id,nome: $nome datanascimento: $datanascimento, pelagem: $pelagem,raca:$raca,  sexo: $sexo, tipo: $tipo}';
  }
}
// Define a function that inserts dogs into the database
