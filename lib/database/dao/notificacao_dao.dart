

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:developer' as developer;

import 'package:intl/intl.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
import 'package:vetpet/helpers/NotificacaoPlugin.dart';
import 'package:vetpet/model/notificacao.dart';
import '../database.dart';
import 'aviso_dao.dart';

class NotificacaoDao extends ChangeNotifier{

  static const String _id = 'id';
  static const String _idvacina = 'idvacina';
  static const String _idaviso = 'idaviso';
  static const String _idpet = 'idpet';
  static const String _datacadastro = 'datacadastro';
  static const String _datainicio = 'datainicio';
  static const String _datavencimento = 'datavencimento';
  static const String _status = 'status';

  static final String tableSql = 'CREATE TABLE IF NOT EXISTS notificacoes ('
      '$_id INTEGER PRIMARY KEY, '
      '$_idvacina INT, '
      '$_idaviso INT,'
      '$_idpet INT,'
      '$_datacadastro TEXT,'
      '$_datainicio TEXT, '
      '$_datavencimento TEXT, '
      '$_status TEXT)';

  static final String tablename = "notificacoes";

  Future<List<Notificacao>> findAllNotificacoes( ) async {
    final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tablename);
      List<Notificacao> notificacao = _toList(result);
      notifyListeners();
      return notificacao;
  }
  Future<Notificacao> findNotificacao(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_id = $id");
    Notificacao notificacao = _toNotificacao(result);
    return notificacao;
  }

  Future<int> save(Notificacao notificacao) async {
    final Database db = await getDatabase();
    notificacao.calculaInicio();
    Map<String, dynamic> notificacaoMap = _toMap(notificacao);
    return db.insert(tablename, notificacaoMap);
  }
  Future<int> updateNotificacaoAviso(Notificacao notificacao, int id) async {
    final Database db = await getDatabase();
    notificacao.calculaInicio();
    Map<String, dynamic> notificacaoMap = _toMap(notificacao);
    return db.update(
        tablename,
        notificacaoMap,
        where: '$_idaviso = ?',
        whereArgs: [id]);
  }
  Future<int> deletenotificacao( int id) async {
    final Database db = await getDatabase();
    return db.delete(
        tablename,
        where: '$_id = ?',
        whereArgs: [id]);
  }
  Future<int> deletenotificacaoAviso( int idaviso) async {
    final Database db = await getDatabase();
    return db.delete(
        tablename,
        where: '$_idaviso = ?',
        whereArgs: [idaviso]);
  }
  Future<int> deletenotificacaoVacina(int id) async {
    final Database db = await getDatabase();
    return db.delete(
        tablename,
        where: '$_idvacina = ?',
        whereArgs: [id]);
  }
  Future<int> deletenotificacaoPet(int idpet) async {
    final Database db = await getDatabase();
    return db.delete(
        tablename,
        where: '$_idpet = ?',
        whereArgs: [idpet]);
  }
  List<Notificacao> _toList(List<Map<String, dynamic>> result) {
    final List<Notificacao> notificacoes = [];
    for (Map<String, dynamic> row in result) {
      final Notificacao notificacao = Notificacao(row[_id], row[_idvacina], row[_idaviso],
          row[_idpet],row[_datacadastro], row[_datainicio], row[_datavencimento], row[_status]);
      notificacoes.add(notificacao);
    }
    return notificacoes;
  }
  Notificacao _toNotificacao(List<Map<String, dynamic>> result) {
    final List<Notificacao> notificacoes = [];
    for (Map<String, dynamic> row in result) {

      final Notificacao notificacao = Notificacao(row[_id], row[_idvacina], row[_idaviso],
          row[_idpet],  row[_datacadastro], row[_datainicio],row[_datavencimento], row[_status]);
      notificacoes.add(notificacao);
    }

    return notificacoes.first;
  }
  Map<String, dynamic> _toMap(Notificacao notificacao) {
    final Map<String, dynamic> notificacaoMap = Map();

    // pettMap[_id] = pet.id;
    notificacaoMap[_idvacina] = notificacao.idvacina;
    notificacaoMap[_idaviso] = notificacao.idaviso;
    notificacaoMap[_datacadastro]= notificacao.datacadastro ;
    notificacaoMap[_datainicio]= notificacao.datainicio;
    notificacaoMap[_datavencimento]= notificacao.datavencimento;
    notificacaoMap[_status]= notificacao.status;

    return notificacaoMap;
  }
  static verificaNotificacao( ) async {
    final String dtBuscaAviso = DateTime.now().year.toString() + DateTime.now().month.toString().padLeft(2,'0') +DateTime.now().day.toString().padLeft(2,'0')   ;
    final Database db = await getDatabase();
    developer.log('verificaNotificacao $dtBuscaAviso');
    final List<Map<String, dynamic>> result_Not = await db.query(tablename , where: " substr($_datainicio,7)||substr($_datainicio,4,2)||substr($_datainicio,1,2)  <= '$dtBuscaAviso' AND $_status = 'A'");
    for (Map<String, dynamic> row in result_Not) {
      developer.log('verificaNotificacao $dtBuscaAviso');
      if(row[_idaviso] > 0)
         AvisoDao.verificaAvisoVencendo(row[_idaviso], row[_id]);
      if(row[_idvacina] > 0)
        Vacina_Dao.verificaVacinaVencendo(row[_idvacina], row[_id]);
    }
    /*Inativar Notificações vencidas*/
    inativaNotificacao();
  }
  static inativaNotificacao( ) async {
    final DateTime dtb = DateTime.now().add(Duration(days:-5));
    final String dtBuscaAviso = dtb.year.toString()  + dtb.month.toString().padLeft(2,'0') + dtb.day.toString().padLeft(2,'0')  ;
    final Database db = await getDatabase();
    developer.log(' inativaNotificacao Data Busca $dtBuscaAviso');
    final List<Map<String, dynamic>> result = await db.query(tablename , where: " substr($_datavencimento,7)||substr($_datavencimento,4,2)||substr($_datavencimento,1,2) <= '$dtBuscaAviso' and $_status = 'A'");
    int count= 0 ;
    for (Map<String, dynamic> row in result) {
      developer.log('Inativando Data Busca ' + row[_datainicio].toString());
       count = await db.rawUpdate("UPDATE $tablename SET $_status = 'I' WHERE $_id = ?",
           [row[_id]]);
      await notificationPlugin.cancelNotification(row[_id]);
    }
    return count;

  }


}