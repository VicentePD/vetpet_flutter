

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vetpet/helpers/NotificacaoPlugin.dart';
import 'package:vetpet/model/aviso.dart';
//import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:vetpet/model/notificacao.dart';
import 'package:vetpet/database/dao/notificacao_dao.dart';
import '../database.dart';

class AvisoDao extends ChangeNotifier{

  static const String _id = 'id';
  static const String _idpet = 'idpet';
  static const String _nomeaviso = 'nomeaviso';
  static const String _datacadastro = 'datacadastro';
  static const String _datavencimento = 'datavencimento';
  static const String _descricao = 'descricao';

  static final String tableSql = 'CREATE TABLE IF NOT EXISTS avisos ('
      '$_id INTEGER PRIMARY KEY, '
      '$_idpet INT, '
      '$_nomeaviso TEXT,'
      '$_datacadastro TEXT,'
      '$_datavencimento TEXT, '
      '$_descricao TEXT)';

  static final String tablename = "avisos";
  static final String tablenamePet = "pets";
  Future<List<Aviso>> findAllAvisos(int idpetsel ) async {
    final Database db = await getDatabase();
    if(idpetsel > 0){
      return findAllAvisosPet(idpetsel);
    }
    else{
      final List<Map<String, dynamic>> result = await db.rawQuery("SELECT $tablename.*, $tablenamePet.nome from $tablename,$tablenamePet where $tablename.idpet = $tablenamePet.id  ORDER BY $_datavencimento DESC");
     // final List<Map<String, dynamic>> result = await db.query(tablename, orderBy: "$_datavencimento DESC");
      List<Aviso> avisos = _toList(result);
      notifyListeners();
      return avisos;
    }
  }
  Future<List<Aviso>> findAllAvisosPet(int idpetsel) async {

    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename,where: " $_idpet = $idpetsel", orderBy: "$_datavencimento DESC");
    List<Aviso> avisos = _toList(result);
    notifyListeners();
    return avisos;
  }
  Future<Aviso> findAviso(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_id = $id");
    Aviso aviso = _toAviso(result);
    return aviso;
  }
  Future<String> findPetsComAvisosVencendo( ) async {
    final Database db = await getDatabase();
    DateTime dtb = DateTime.now().add(Duration(days: 30));
    final String dtBuscaVacina = dtb.year.toString() + dtb.month.toString().padLeft(2,'0') +dtb.day.toString().padLeft(2,'0') ;
    String msg = "";
    try{
      //final List<Map<String, dynamic>> result = await db.query(tablename,orderBy: "$_dataretorno DESC");
      final List<Map<String, dynamic>> result = await db.rawQuery("SELECT DISTINCT $tablenamePet.nome from $tablename, $tablenamePet "
          "where $tablename.idpet = $tablenamePet.id  "
          "and substr($_datavencimento,7)||substr($_datavencimento,4,2)||substr($_datavencimento,1,2)  <= '$dtBuscaVacina' "
          "and substr($_datavencimento,7)||substr($_datavencimento,4,2)||substr($_datavencimento,1,2)  >= '"
          + DateTime.now().year.toString() + DateTime.now().month.toString().padLeft(2,'0') +DateTime.now().day.toString().padLeft(2,'0') +
          "'  ORDER BY $_datavencimento DESC");

      if(result.isNotEmpty && result.length > 0){
        msg = "Os Avisos do(s) Pet(s)";
        for (Map<String, dynamic> row in result) {
          msg  += ", " + row['nome'].toString() ;
        }
        msg += " estão próximo do vencimento.";
      }
      else{
        msg = "Não existe Aviso vencendo nos próximos dias.";
      }

      return msg;
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro findPetsComAvisosVencendo');
      throw('erro');
    }
  }

  Future<int> save(Aviso aviso) async {
     try{
      final Database db = await getDatabase();
      Map<String, dynamic> avisoMap = _toMap(aviso);
      int idaviso = await db.insert(tablename, avisoMap);
      final Notificacao notificacao = new Notificacao(0,0,idaviso,aviso.idpet ,aviso.datacadastro,"",aviso.datavencimento,'A');
      notificacao.calculaInicio();
      NotificacaoDao().save(notificacao);

      return idaviso;
    }
    catch(e, s){
        FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro save Aviso');
        throw('erro');
    }
  }
  Future<int> updateAviso(Aviso aviso, int idaviso,[String statusNotificacoa= "A"]) async {
   try{
      final Database db = await getDatabase();
      Map<String, dynamic> avisoMap = _toMap(aviso);
      final Notificacao notificacao = new Notificacao(0,0,aviso.id,aviso.idpet ,aviso.datacadastro,"",aviso.datavencimento,statusNotificacoa);
      notificacao.calculaInicio();
      NotificacaoDao().updateNotificacaoAviso(notificacao,idaviso);
      return db.update(
          tablename,
          avisoMap,
          where: '$_id = ?',
          whereArgs: [idaviso]);
    }
    catch(e, s){
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro updateAviso');
      throw('erro');
    }
  }
  Future<int> deleteAviso( int idaviso) async {
    try{
      final Database db = await getDatabase();
      return db.delete(
          tablename,
          where: '$_id = ?',
          whereArgs: [idaviso]).whenComplete(() => (){
        final NotificacaoDao notificacaoDao = new NotificacaoDao();
        return notificacaoDao.deletenotificacaoAviso(idaviso);
      });
    }
    catch(e, s){
       FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro deleteAviso');
       throw('erro');
    }
  }
  Future<int> deleteAvisoPet( int idpet) async {

    try{
      final Database db = await getDatabase();
      return db.delete(
          tablename,
          where: '$_idpet = ?',
          whereArgs: [idpet]);
    }
    catch(e, s){
       FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro deleteAvisoPet');
       throw('erro');
    }
  }
  List<Aviso> _toList(List<Map<String, dynamic>> result) {
    final List<Aviso> avisos = [];
    for (Map<String, dynamic> row in result) {
      if(row.length == 7)
      {
        final Aviso aviso = Aviso(row[_id], row[_idpet], row[_nomeaviso],
            row[_datacadastro], row[_datavencimento], row[_descricao],row['nome']);
        avisos.add(aviso);
      }
      else{
        final Aviso aviso = Aviso(row[_id], row[_idpet], row[_nomeaviso],
            row[_datacadastro], row[_datavencimento], row[_descricao]);
        avisos.add(aviso);
      }

    }
    return avisos;
  }
  Aviso _toAviso(List<Map<String, dynamic>> result) {
    final List<Aviso> avisos = [];
    for (Map<String, dynamic> row in result) {

      final Aviso aviso = Aviso(row[_id], row[_idpet], row[_nomeaviso],
          row[_datacadastro], row[_datavencimento], row[_descricao]);
      avisos.add(aviso);
    }

    return avisos.first;
  }
  Map<String, dynamic> _toMap(Aviso aviso) {
    final Map<String, dynamic> avisoMap = Map();

    // pettMap[_id] = pet.id;
    avisoMap[_idpet] = aviso.idpet;
    avisoMap[_nomeaviso] = aviso.nomeaviso;
    avisoMap[_datacadastro]= aviso.datacadastro ;
    avisoMap[_datavencimento]= aviso.datavencimento;
    avisoMap[_descricao]= aviso.descricao;

    return avisoMap;
  }


  static verificaAvisoVencendo( int id, int idnotivicacao) async {

    try{
      final Database db = await getDatabase();
      //final List<Map<String, dynamic>> result = await db.query(tablename,where: " $_id = $id");
      final List<Map<String, dynamic>> result = await db.rawQuery("SELECT $tablename.*, $tablenamePet.nome "
          "from $tablename,$tablenamePet "
          "where $tablename.id =  $id and $tablename.idpet = $tablenamePet.id  ORDER BY $_datavencimento DESC");
      for (Map<String, dynamic> row in result) {
        DateTime dt =new DateFormat('dd/MM/yyyy HH:mm:ss').parse(row[_datavencimento].toString() +' ' +DateTime.now().hour.toString() + ':'+ DateTime.now().minute.toString() +':22');
        await notificationPlugin.scheduleNotification(idnotivicacao,datanotificacao: dt , titulo:"Aviso " +row[_nomeaviso].toString() ,
            msg:'O aviso cadastrado para o Pet '+  row['nome'].toString() +'. Exipira dia ' + row[_datavencimento].toString());
      }
    }
    catch(e, s){
       FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro verificaAvisoVencendo');
       throw('erro');
    }
  }
}