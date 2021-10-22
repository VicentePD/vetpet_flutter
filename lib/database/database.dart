import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vetpet/database/dao/vacina_dao.dart';
//import 'package:vetpet/model/pet.dart';

import 'dao/aviso_dao.dart';
import 'dao/notificacao_dao.dart';
import 'dao/pet_dao.dart';

//import 'dart:developer' as developer;

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'vetpet.db');
  Future<Database> db ;
  try{
    db = openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(PetDao.tableSql);
        db.execute(Vacina_Dao.tableSql);
        db.execute(AvisoDao.tableSql);
        db.execute(NotificacaoDao.tableSql);
      },
      onUpgrade: (db, oldVersion,newVersion) async {
        db.execute(NotificacaoDao.tableSql);

      },version: 1,
    );
    return db;
  }
  catch(e, s){
    FirebaseCrashlytics.instance.recordError(e, s, reason: 'Erro getDatabase');
    throw('erro');
  }

}

