import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/notes_dao.dart';
import 'package:flutter_application_1/database/notes_db.dart';

class NotesScreens extends StatefulWidget {
  const NotesScreens({super.key});

  @override
  State<NotesScreens> createState() => _NotesScreensState();
}

class _NotesScreensState extends State<NotesScreens> {
  late final NotesDb? notesDb;
  late Future<List<NotesDao>> notesFuture;

  @override
  void initState() {
    super.initState();
    notesDb = NotesDb();
    notesFuture = notesDb!.SELECT();
  }

  void _recargar() {
    setState(() {
      notesFuture = notesDb!.SELECT();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Notas')),
      body: FutureBuilder(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ItemNote(snapshot.data![index]);
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
          Navigator.pushNamed(context, '/add').then((value) => _recargar());
        },
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }

  Widget ItemNote(NotesDao note) {
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
                  note.title!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(note.content!, style: TextStyle(fontSize: 14)),
              ],
            ),
            IconButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildAlertDialog(note.idNote!);
                  },
                );
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/add",
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

  Widget _buildAlertDialog(int idNote) {
    return AlertDialog(
      title: Text('Alerta del sistema'),
      content: Text("¿Desea eliminar el registró :) ?"),
      actions: [
        TextButton(
          child: Text("Aceptar"),
          onPressed: () {
            notesDb!.DELETE(idNote).then((value) {
              if (value > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nota eliminada correctamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
                _recargar();
              }
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
}
