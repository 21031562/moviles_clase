import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/conf_nube/firestore_note.dart';

class AddNoteNubeScreen extends StatefulWidget {
  const AddNoteNubeScreen({super.key});

  @override
  State<AddNoteNubeScreen> createState() => _AddNoteNubeScreenState();
}

class _AddNoteNubeScreenState extends State<AddNoteNubeScreen> {
  final firestoreNote = FirestoreNote();
  final conTitle = TextEditingController();
  final conContent = TextEditingController();
  QueryDocumentSnapshot? note;
  bool _cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cargado) return;
    _cargado = true;
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      note = args as QueryDocumentSnapshot;
      conTitle.text = note!.get('title');
      conContent.text = note!.get('content');
    }
  }

  @override
  void dispose() {
    conTitle.dispose();
    conContent.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (conTitle.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título es obligatorio')),
      );
      return;
    }

    final data = {
      "title": conTitle.text.trim(),
      "content": conContent.text.trim(),
      "dateNote": DateTime.now().toString().substring(0, 10),
    };

    final bool ok = (note == null)
        ? await firestoreNote.insertNote(data)
        : await firestoreNote.updateNote(note!.id, data);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(!ok
            ? 'Ocurrió un error al guardar la nota'
            : note == null
                ? 'Nota guardada correctamente'
                : 'Nota actualizada correctamente'),
        duration: const Duration(seconds: 2),
      ),
    );
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final space = const SizedBox(height: 16.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Agregar Nota (Nube)' : 'Editar Nota (Nube)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: conTitle,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            space,
            TextFormField(
              controller: conContent,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Contenido'),
            ),
            space,
            ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
