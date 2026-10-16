import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/notes_dao.dart';
import 'package:flutter_application_1/database/notes_db.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  NotesDb? notesDb;
  @override
  void initState() {
    super.initState();
    notesDb = NotesDb();
  }

  @override
  Widget build(BuildContext context) {
    final conTitle = TextEditingController();
    final conContent = TextEditingController();
    NotesDao? note;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      note = ModalRoute.of(context)!.settings.arguments as NotesDao;
      conTitle.text = note.title!;
      conContent.text = note.content!;
    }

    final txtTitle = TextFormField(
      controller: conTitle,
      decoration: InputDecoration(labelText: 'Título'),
    );
    final txtContent = TextFormField(
      maxLines: 5,
      controller: conContent,
      decoration: InputDecoration(labelText: 'Contenido'),
    );
    final space = SizedBox(height: 16.0);
    final btnSave = ElevatedButton(
      onPressed: () {
        if (note == null) {
          notesDb!
              .INSERT({
                "title": conTitle.text,
                "content": conContent.text,
                "dateNote": "2026-09-25",
              })
              .then((value) {
                if (value > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nota guardada correctamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                }
              });
        } else {
          notesDb!
              .UPDATE({
                "idNote": note.idNote,
                "title": conTitle.text,
                "content": conContent.text,
                "dateNote": "2026-09-25",
              })
              .then((value) {
                if (value > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nota actualizada correctamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                }
              });
        }
      },
      child: const Text('Guardar'),
    );
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Nota'), leading: Container()),
      body: Column(children: [txtTitle, space, txtContent, space, btnSave]),
    );
  }
}
