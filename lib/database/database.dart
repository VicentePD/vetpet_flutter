import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vetpet/dao/pet_dao.dart';
import 'package:vetpet/model/Pet.dart';

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




// A method that retrieves all the dogs from the dogs table.
Future<List<Pet>> pets() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'vetpet.db'),
  );
  // Get a reference to the database.
  final db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('pets');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return Pet(
      maps[i]['id'],
      maps[i]['nome'],
      maps[i]['datanascimento'],
      maps[i]['pelagem'],
      maps[i]['raca'],
      maps[i]['sexo'],
      maps[i]['tipo'],
    );
  });
}
