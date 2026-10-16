import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNote {
  FirebaseFirestore conexion = FirebaseFirestore.instance;

  CollectionReference? notesCollection;

  FirestoreNote() {
    notesCollection = conexion.collection("notes");
  }

  insertNote(Map<String, dynamic> note) async {
    notesCollection!.doc().set(note);
  }

  updateNote(String idNote, Map<String, dynamic> note) async {
    notesCollection!.doc(idNote).update(note);
  }

  deleteNote(String idNote) async {
    notesCollection!.doc(idNote).delete();
  }

  Stream<QuerySnapshot> selectNote() {
    return notesCollection!.snapshots();
  }
}
