import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noted/screen/addeditecreen.dart';

import '../model/note.dart';

class noteScreen extends StatefulWidget {
  const noteScreen({super.key});

  @override
  State<noteScreen> createState() => _noteScreenState();
}

class _noteScreenState extends State<noteScreen> {
  final firebaseCollection = FirebaseFirestore.instance.collection("notes");

  Stream<List<note>> getNotes() {
    return firebaseCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return note.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deleteNote(String id) async {
    await firebaseCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"), centerTitle: true),
      body: StreamBuilder(
        stream: getNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<note>> snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => deleteNote(note.id),
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => addEditScreen(note: note),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const addEditScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
