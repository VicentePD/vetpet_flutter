import 'package:flutter/cupertino.dart';

import 'Pet.dart';

class Vacina {
  final int id;
  final int id_pet;
  final String nome_vacina;
  final String dataaplicacao;
  final String dataretorno;
  final String veterinario;


  Vacina(this.id, this.id_pet, this.nome_vacina, this.dataaplicacao,
      this.dataretorno, this.veterinario);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pet': id_pet,
      'nome_vacina': nome_vacina,
      'dataaplicacao': dataaplicacao,
      'dataretorno': dataretorno,
      'veterinario':veterinario,
    };
  }
  @override
  String toString() {
    return 'Pet{id: $id,id_pet: $id_pet nome_vacina: $nome_vacina, dataaplicacao: $dataaplicacao,dataretorno:$dataretorno,  veterinario: $veterinario}';
  }

}