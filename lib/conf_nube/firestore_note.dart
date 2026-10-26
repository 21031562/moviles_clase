import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNote {
  final FirebaseFirestore conexion = FirebaseFirestore.instance;
  late final CollectionReference notesCollection;

  FirestoreNote() {
    notesCollection = conexion.collection("notes");
  }

  /// CREATE
  Future<bool> insertNote(Map<String, dynamic> note) async {
    try {
      await notesCollection.add(note);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// READ (en tiempo real)
  Stream<QuerySnapshot> selectNote() {
    return notesCollection.snapshots();
  }

  /// UPDATE
  Future<bool> updateNote(String idNote, Map<String, dynamic> note) async {
    try {
      await notesCollection.doc(idNote).update(note);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// DELETE
  Future<bool> deleteNote(String idNote) async {
    try {
      await notesCollection.doc(idNote).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
