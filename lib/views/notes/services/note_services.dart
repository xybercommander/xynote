import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xynote/views/notes/models/note_model.dart';

class NoteServices {

  //------- UPLOAD A SINGLE NOTE TO FIRESTORE -------//
  void uploadNoteToDB(NoteModel noteModel, String docID, String noteDocID) {
    FirebaseFirestore.instance.collection("usernotes")
      .doc(docID)
      .collection("notes")
      .doc(noteDocID)
      .set({
        "id": noteModel.id,
        "content": noteModel.content,
        "createdAt": noteModel.createdAt
      });
  }

}