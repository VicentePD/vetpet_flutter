import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vetpet/database/database.dart';
import 'package:vetpet/model/Pet.dart';
import 'dart:developer' as developer;

class PetDao extends ChangeNotifier{
  //Campos da tabela
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _datanascimento = 'datanascimento';
  static const String _pelagem = 'pelagem';
  static const String _sexo = 'sexo';
  static const String _tipo = 'tipo';
  static const String _raca = 'raca';
  static const String _foto = 'foto';
  static final String tableSql = 'CREATE TABLE IF NOT EXISTS pets('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT, '
      '$_datanascimento TEXT,'
      '$_pelagem TEXT,'
      '$_sexo TEXT, '
      '$_tipo TEXT, '
      '$_raca TEXT,'
      '$_foto TEXT)';
  static final String alttableSql =
      'ALTER TABLE pets ADD IF NOT EXISTS  $_foto TEXT';
  static final String tablename = "pets";

  Future<List<Pet>> findAllPets() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename);
    List<Pet> pets = _toList(result);
    notifyListeners();
    return pets;
  }
  Future<Pet> findPet(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tablename, where: " $_id = $id");
    Pet pet = _toPet(result);
    return pet;
  }

  Future<int> save(Pet pet) async {
    final Database db = await getDatabase();
    Map<String, dynamic> petMap = _toMap(pet);
    notifyListeners();
    return db.insert(tablename, petMap);
  }
  Future<int> updatePet(Pet pet, int idpet) async {
    final Database db = await getDatabase();
    Map<String, dynamic> petMap = _toMap(pet);
    notifyListeners();
    return db.update(
        tablename,
        petMap,
        where: '$_id = ?',
        whereArgs: [idpet]);
  }
  Future<int> deletePet( int idpet) async {
    final Database db = await getDatabase();
    return db.delete(
        tablename,
        where: '$_id = ?',
        whereArgs: [idpet]);
  }

  List<Pet> _toList(List<Map<String, dynamic>> result) {
    final List<Pet> pets = [];
    for (Map<String, dynamic> row in result) {
      final Pet pet = Pet(row[_id], row[_nome], row[_datanascimento],
          row[_pelagem], row[_raca], row[_sexo], row[_tipo], row[_foto]);
      pets.add(pet);
    }
    return pets;
  }
  Pet _toPet(List<Map<String, dynamic>> result) {
    final List<Pet> pets = [];
    for (Map<String, dynamic> row in result) {
      developer.log("teteeee $row[_id]");
      final Pet pet = Pet(row[_id], row[_nome], row[_datanascimento],
          row[_pelagem], row[_raca], row[_sexo], row[_tipo], row[_foto]);
      pets.add(pet);
    }

    return pets.first;
  }
  Map<String, dynamic> _toMap(Pet pet) {
    final Map<String, dynamic> pettMap = Map();
    developer.log("teteeee $pet");
   // pettMap[_id] = pet.id;
    pettMap[_nome] = pet.nome;
    pettMap[_datanascimento] = pet.datanascimento;
    pettMap[_pelagem]= pet.pelagem ;
    pettMap[_raca]= pet.raca;
    pettMap[_sexo]= pet.sexo;
    pettMap[_tipo]= pet.tipo;
    pettMap[_foto]= pet.foto;
    return pettMap;
  }
  notificarDadosAlterador(){
    notifyListeners();
  }
}
