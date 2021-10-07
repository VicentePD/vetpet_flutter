import 'package:dart_date/dart_date.dart';
import '../../helpers/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class Notificacao {
  final int id;
  final int idvacina;
  final int idaviso;
  final int idpet;
  final String datacadastro;
  late String datainicio;
  final String datavencimento;
  final String status;


  Notificacao(this.id, this.idvacina, this.idaviso,this.idpet, this.datacadastro,
  this.datainicio, this.datavencimento, this.status);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idvacina': idvacina,
      'idaviso': idaviso,
      'idpet': idpet,
      'datacadastro': datacadastro,
      'datainicio': datainicio,
      'datavencimento': datavencimento,
      'status':status,
    };
  }
  calculaInicio(){
    final DateTime datacalc = new DateFormat('DD/MM/yyyy').parse(datavencimento);
    datainicio =  datacalc.subDays(5).format(globals.pattern, 'pt_BR');
  }
  @override
  String toString() {
    return 'Pet{id: $id,idvacina: $idvacina idaviso: $idaviso,idpet: $idpet, datacadastro: $datacadastro,datainicio:$datainicio,datavencimento:$datavencimento,  status: $status}';
  }

}