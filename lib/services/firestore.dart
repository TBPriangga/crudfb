import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Mendapatkan List Note
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  // Create : Menambahkan Note
  Future<void> addNote(String note) {
    return notes
        .add({
          'note': note,
          'timestamp': Timestamp.now(),
        })
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  // Read : Mendapatkan Note
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // Update : Edit Note

  // Delete : Hapus Note
}
