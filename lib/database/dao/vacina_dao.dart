

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vetpet/model/vacina.dart';

import '../database.dart';

class Vacina_Dao extends ChangeNotifier{

  static const String _id = 'id';
  static const String _id_pet = 'id_pet';
  static const String _nome_vacina = 'nome_vacina';
  static const String _dataaplicacao = 'dataaplicacao';
  static const String _dataretorno = 'dataretorno';
  static const String _veterinario = 'veterinario';

  static final String tableSql = 'CREATE TABLE IF NOT EXISTS vacinas ('
      '$_id INTEGER PRIMARY KEY, '
      '$_id_pet INT, '
      '$_nome_vacina TEXT,'
      '$_dataaplicacao TEXT,'
      '$_dataretorno TEXT, '
      '$_veterinario TEXT)';

  static final String tablename = "vacinas";

  Future<List<Vacina>> findAllVacinas(int idpetsel ) async {
    final Database db = await getDatabase();
    if(idpetsel > 0){
      return findAllVacinasPet(idpetsel);
    }
    else{
      final List<Map<String, dynamic>> result = await db.query(tablename);
      List<Vacina> vacinas = _toList(result);
      notifyListeners();
      return vacinas;
    }
  }
  Future<Vacina> findVacina(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_id = $id");
    Vacina vacina = _toVacina(result);
    return vacina;
  }

  Future<int> save(Vacina vacina) async {
    final Database db = await getDatabase();
    Map<String, dynamic> petMap = _toMap(vacina);
    return db.insert(tablename, petMap);
  }
  Future<int> updatePet(Vacina vacina, int idvacina) async {
    final Database db = await getDatabase();
    Map<String, dynamic> petMap = _toMap(vacina);
    notifyListeners();
    return db.update(
        tablename,
        petMap,
        where: '$_id = ?',
        whereArgs: [idvacina]);
  }
  Future<int> deletePet( int idpet) async {
    final Database db = await getDatabase();
    return db.delete(
        tablename,
        where: '$_id = ?',
        whereArgs: [idpet]);
  }

  List<Vacina> _toList(List<Map<String, dynamic>> result) {
    final List<Vacina> vacinas = [];
    for (Map<String, dynamic> row in result) {
      final Vacina vacina = Vacina(row[_id], row[_id_pet], row[_nome_vacina],
          row[_dataaplicacao], row[_dataretorno], row[_veterinario]);
      vacinas.add(vacina);
    }
    return vacinas;
  }
  Vacina _toVacina(List<Map<String, dynamic>> result) {
    final List<Vacina> vacinas = [];
    for (Map<String, dynamic> row in result) {

      final Vacina vacina = Vacina(row[_id], row[_id_pet], row[_nome_vacina],
          row[_dataaplicacao], row[_dataretorno], row[_veterinario]);
      vacinas.add(vacina);
    }

    return vacinas.first;
  }
  Map<String, dynamic> _toMap(Vacina vacina) {
    final Map<String, dynamic> vacinaMap = Map();

    // pettMap[_id] = pet.id;
    vacinaMap[_id_pet] = vacina.id_pet;
    vacinaMap[_nome_vacina] = vacina.nome_vacina;
    vacinaMap[_dataaplicacao]= vacina.dataaplicacao ;
    vacinaMap[_dataretorno]= vacina.dataretorno;
    vacinaMap[_veterinario]= vacina.veterinario;

    return vacinaMap;
  }

  Future<List<Vacina>> findAllVacinasPet(int idpetsel) async {

    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename,where: " $_id_pet = $idpetsel");
    List<Vacina> vacinas = _toList(result);
    notifyListeners();
    return vacinas;
  }
}