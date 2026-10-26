import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/conf_nube/firestore_note.dart';

class NotesScreensNube extends StatefulWidget {
  const NotesScreensNube({super.key});

  @override
  State<NotesScreensNube> createState() => _NotesScreensState();
}

class _NotesScreensState extends State<NotesScreensNube> {
  late final FirestoreNote firestoreNotes;
  int _reloadKey = 0;

  @override
  void initState() {
    super.initState();
    firestoreNotes = FirestoreNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Notas')),
      body: StreamBuilder(
        key: ValueKey(_reloadKey),
        stream: firestoreNotes.selectNote(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return itemNote(snapshot.data!.docs[index]);
              },
            );
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addNube').then((value) => _recargar());
        },
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }

  Widget itemNote(QueryDocumentSnapshot<Object?> note) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              child: Center(child: Text("10")),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue,
              ),
            ),
            Column(
              children: [
                Text(
                  note.get('title'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(note.get('content'), style: TextStyle(fontSize: 14)),
              ],
            ),
            IconButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildAlertDialog(note.id);
                  },
                );
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/addNube",
                  arguments: note,
                ).then((value) => _recargar());
              },
              icon: Icon(Icons.edit, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertDialog(String idNote) {
    return AlertDialog(
      title: Text('Alerta del sistema'),
      content: Text("¿Desea eliminar el registró :) ?"),
      actions: [
        TextButton(
          child: Text("Aceptar"),
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);
            firestoreNotes.deleteNote(idNote).then((value) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Nota eliminada correctamente'
                      : 'Ha ocurrido un problema con el borrado'),
                  duration: const Duration(seconds: 2),
                ),
              );
              if (value) _recargar();
            });
            Navigator.of(context).pop();
          },
        ),

        TextButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _recargar() {
    if (mounted) {
      setState(() {
        _reloadKey++;
      });
    }
  }
}
