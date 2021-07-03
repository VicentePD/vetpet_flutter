import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vetpet/model/Pet.dart';

import 'dao/pet_dao.dart';

//import 'dart:developer' as developer;

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'vetpet.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(PetDao.tableSql);
    },
      onUpgrade: (db, oldVersion,newVersion) async {
        db.execute(PetDao.alttableSql);
  },version: 2,
  );
}

