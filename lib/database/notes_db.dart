import 'dart:async';
import 'dart:io';

import 'package:flutter_application_1/database/notes_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDb {
  final nameDB = 'NOTESDB';
  final versionDB = 1; // version de la base de datos para que tenga forma de detectar cambios y actualizaciones
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: createTables);
  }

  FutureOr<void> createTables(Database db, int version) {
    String query = '''
    CREATE TABLE tblNotes(
      idNote INTEGER PRIMARY KEY,
      title VARCHAR(35),
      content TEXT,
      dateNote CHAR(10)
    )
    ''';
    db.execute(query);
  }

  Future<int> INSERT(Map<String, dynamic> note) async {
    var conexion = await database;
    return conexion!.insert("tblNotes", note);
  }

  Future<int> UPDATE(Map<String, dynamic> note) async {
    var conexion = await database;
    return conexion!.update(
      "tblNotes",
      note,
      where: "idNote = ?",
      whereArgs: [note["idNote"]],
    );
  }

  Future<int> DELETE(int idNote) async {
    var conexion = await database;
    return conexion!.delete(
      "tblNotes",
      where: "idNote = ?",
      whereArgs: [idNote],
    );
  }

  Future<List<NotesDao>> SELECT() async {
    var conexion = await database;
    final res = await conexion!.query("tblNotes");
    return res.map((note) => NotesDao.fromMap(note)).toList();
  }
}
