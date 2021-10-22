

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

//import 'dart:developer' as developer;

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

    try{
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tablename);
      List<Notificacao> notificacao = _toList(result);
      notifyListeners();
      return notificacao;
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro findAllNotificacoes');
      List<Notificacao> notificacao  = []  ;
     return notificacao;
    }
  }
  Future<Notificacao> findNotificacao(int id) async {
    Notificacao notificacao = new Notificacao(0,0,0,0,'','','','');
    try{
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_id = $id");
      notificacao = _toNotificacao(result);
      return notificacao;
    }
    catch(e, s){
       FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro findNotificacao');
    return notificacao;
  }
  }
  Future<Notificacao> findNotificacaoVacina(int idvacina) async {
    Notificacao notificacao = new Notificacao(0,0,0,0,'','','','');
    try{
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_idvacina = $idvacina");
      notificacao = _toNotificacao(result);
      return notificacao;
    }
    catch(e, s){
     FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro findNotificacaoVacina');
     return notificacao;
    }
  }
  Future<Notificacao> findNotificacaoAviso(int idaviso) async {
    Notificacao notificacao = new Notificacao(0,0,0,0,'','','','');
    try{
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_idaviso = $idaviso");
      notificacao = _toNotificacao(result);
      return notificacao;
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro findNotificacaoVacina');
      return notificacao;
    }
  }
  Future<int> save(Notificacao notificacao) async {
    try{
      final Database db = await getDatabase();
      notificacao.calculaInicio();
      Map<String, dynamic> notificacaoMap = _toMap(notificacao);
      return db.insert(tablename, notificacaoMap);
    }
    catch(e, s){
     FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro save Notificação');
    return 0;
    }
  }
  Future<int> updateNotificacaoAviso(Notificacao notificacao, int id) async {
    try{
      final Database db = await getDatabase();
      notificacao.calculaInicio();
      Map<String, dynamic> notificacaoMap = _toMap(notificacao);
      if(notificacao.status != "A"){
        _cancelaNotificacao(id,0);
      }
      return db.update(
          tablename,
          notificacaoMap,
          where: '$_idaviso = ?',
          whereArgs: [id]);
  }
  catch(e, s){
    FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro updateNotificacaoAviso');
  return 0;
  }

}
  Future<int> updateNotificacaoVacina(Notificacao notificacao, int idvacina) async {
    try{
      final Database db = await getDatabase();
      notificacao.calculaInicio();
      Map<String, dynamic> notificacaoMap = _toMap(notificacao);
      if(notificacao.status != "A"){
        _cancelaNotificacao(0,idvacina);
      }
      return db.update(
          tablename,
          notificacaoMap,
          where: '$_idvacina = ?',
          whereArgs: [idvacina]);
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro updateNotificacaoVacina');
      return 0;
    }

  }
  Future<int> deletenotificacao( int id) async {
    try{
      final Database db = await getDatabase();
      notificationPlugin.cancelNotification(id);
      return db.delete(
          tablename,
          where: '$_id = ?',
          whereArgs: [id]);
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro deletenotificacao');
      return 0;
    }
  }
  Future<int> deletenotificacaoAviso( int idaviso) async {
    try{
      final Database db = await getDatabase();
      _cancelaNotificacao(idaviso,0);
      return db.delete(

          tablename,
          where: '$_idaviso = ?',
          whereArgs: [idaviso]);
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro deletenotificacaoAviso');
      return 0;
    }
  }
  Future<int> deletenotificacaoVacina(int id) async {
    try{
      final Database db = await getDatabase();
      _cancelaNotificacao(0,id);
      return db.delete(
          tablename,
          where: '$_idvacina = ?',
          whereArgs: [id]);
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro deletenotificacaoVacina');
      return 0;
    }
  }
  Future<int> deletenotificacaoPet(int idpet) async {
    try{
      final Database db = await getDatabase();
      return db.delete(
          tablename,
          where: '$_idpet = ?',
          whereArgs: [idpet]);
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro deletenotificacaoPet');
      return 0;
    }
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
    notificacaoMap[_idpet] = notificacao.idpet;
    notificacaoMap[_datacadastro]= notificacao.datacadastro ;
    notificacaoMap[_datainicio]= notificacao.datainicio;
    notificacaoMap[_datavencimento]= notificacao.datavencimento;
    notificacaoMap[_status]= notificacao.status;

    return notificacaoMap;
  }
  static verificaNotificacao( ) async {
    final String dtBuscaAviso = DateTime.now().year.toString() + DateTime.now().month.toString().padLeft(2,'0') +DateTime.now().day.toString().padLeft(2,'0')   ;
    final Database db = await getDatabase();
   // developer.log('verificaNotificacao $dtBuscaAviso');
    final List<Map<String, dynamic>> resultnot = await db.query(tablename , where: " substr($_datainicio,7)||substr($_datainicio,4,2)||substr($_datainicio,1,2)  <= '$dtBuscaAviso' AND $_status = 'A'");
    for (Map<String, dynamic> row in resultnot) {
    //  developer.log('verificaNotificacao $dtBuscaAviso');
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
    final List<Map<String, dynamic>> result = await db.query(tablename , where: " substr($_datavencimento,7)||substr($_datavencimento,4,2)||substr($_datavencimento,1,2) <= '$dtBuscaAviso' and $_status = 'A'");
    int count= 0 ;
    for (Map<String, dynamic> row in result) {
       count = await db.rawUpdate("UPDATE $tablename SET $_status = 'I' WHERE $_id = ?",
           [row[_id]]);
      await notificationPlugin.cancelNotification(row[_id]);
    }
    return count;

  }

  _cancelaNotificacao(int idaviso,int idvacina ) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename , where: " $_idaviso = $idaviso "
        "and $_idvacina = $idvacina");
    //int count= 0 ;
    for (Map<String, dynamic> row in result) {
      await notificationPlugin.cancelNotification(row[_id]);
    }
  }




}