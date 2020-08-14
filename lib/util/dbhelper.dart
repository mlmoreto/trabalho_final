import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:trabalho_final/model/pacoteViagem.dart';

class DbHelper {

  // Atributos: o nome da tabela e os nomes das colunas:
  String tblPacoteViagem = "pacoteViagem";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPrice = "price";
  String colDate = "date";
  String colUrlImage = 'urlImage';

  DbHelper._internal();

  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper(){
    return _dbHelper;
  }


  Future<Database> initializeDb() async {

    Directory dir = await getApplicationDocumentsDirectory();

    String path = dir.path + "pacotesViagens.db";

    var dbPacotesViagens = await openDatabase(path, version: 1, onCreate: _createDb);

    return dbPacotesViagens;
  }


  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblPacoteViagem($colId INTEGER PRIMARY KEY, $colTitle TEXT, " +
            "$colDescription TEXT, $colPrice TEXT, $colDate TEXT, $colUrlImage TEXT)");
  }


  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<int> insertPacote(PacoteViagem pacoteViagem) async {

    Database db = await this.db;

    var result = await db.insert(tblPacoteViagem, pacoteViagem.toMap());
    return result;
  }

  Future<List> getPacotes() async {
    Database db = await this.db;
    var result = await db.rawQuery('SELECT * FROM $tblPacoteViagem order by $colTitle ASC');
    return result;
  }

  Future<int> updatePacote(PacoteViagem pacoteViagem) async {
    var db = await this.db;
    var result = await db.update(tblPacoteViagem,
        pacoteViagem.toMap(),
        where: "$colId = ?",
        whereArgs: [pacoteViagem.id]);
    return result;
  }

  Future<int> deletePacote(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblPacoteViagem WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    // Usa o método Sqflite.firstIntValue,
    // que retorna apenas o 1o valor inteiro da resposta.
    // No caso desta query, só vai ter um valor mesmo (count).
    var result = Sqflite.firstIntValue(
        await db.rawQuery('select count (*) from $tblPacoteViagem')
    );
    return result;
  }

}