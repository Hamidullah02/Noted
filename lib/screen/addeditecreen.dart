import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noted/model/note.dart';

class addEditScreen extends StatefulWidget {
  final dynamic note;

  const addEditScreen({super.key, this.note});

  @override
  State<addEditScreen> createState() => _addEditScreenState();
}

class _addEditScreenState extends State<addEditScreen> {


  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _collection = FirebaseFirestore.instance.collection("notes");


  @override
  void initState() {
    super.initState();
    late dynamic Note = widget.note;

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descController.text = widget.note!.description;
    }
  }


  Future<void> _saveNote() async {
    final title = _titleController.text;
    final desc = _descController.text;

    if (title.isEmpty || desc.isEmpty) return;

    if (widget.note == null) {
      await _collection.add({"title": title, "description": desc});
    } else {
      await _collection.doc(widget.note!.id).update({
        "title": title,
        "description": desc,
      });
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();

    _titleController.clear();
    _descController.clear();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
