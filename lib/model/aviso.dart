
class Aviso {
  final int id;
  final int idpet;
  final String nomeaviso;
  final String datacadastro;
  final String datavencimento;
  final String descricao;
  final String nomepet;

  Aviso(this.id, this.idpet, this.nomeaviso, this.datacadastro,
      this.datavencimento, this.descricao,[this.nomepet = '' ]);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idpet': idpet,
      'nomeaviso': nomeaviso,
      'datacadastro': datacadastro,
      'datavencimento': datavencimento,
      'descricao':descricao,
    };
  }
  @override
  String toString() {
    return 'Pet{id: $id,id_pet: $idpet nomeaviso: $nomeaviso, datacadastro: $datacadastro,datavencimento:$datavencimento,  descricao: $descricao}';
  }

}