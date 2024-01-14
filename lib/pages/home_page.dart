import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crudfb/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //FireStore
  final FirestoreService firestoreService = FirestoreService();

  //Text Controller
  TextEditingController noteController = TextEditingController();

  // Membuka dialog vox dari penambahan note
  void openNoteBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: noteController,
              ),
              actions: [
                // Tombol Menyimpan Note
                ElevatedButton(
                  onPressed: () {
                    // Menambahkan Note
                    firestoreService.addNote(noteController.text);

                    // Clear text controller
                    noteController.clear();

                    // Tutup dialog box
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Add",
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // Jika mempunyai data, maka tampilkan semua data
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            // Tampilkan pada daftar
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                // Mendapatkan 1 dokumen
                DocumentSnapshot document = noteList[index];
                String docID = document.id;

                // Mendapatkan note dari setiap dokumen
                Map<String, dynamic> note =
                    document.data() as Map<String, dynamic>;
                String noteText = note['note'];

                // Menampilkan dalam bentuk list
                return ListTile(
                  title: Text(noteText),
                );
              },
            );
          }

          // Jika tidak mempunyai data, maka tidak menampilkan apa-apa
          else {
            return const Text("No Notes...");
          }
        },
      ),
    );
  }
}
