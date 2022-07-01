import 'package:flutter/cupertino.dart';
import 'package:xynote/views/notes/models/note_model.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  void pushNewNote(NoteModel note) {
    _notes.add(note);
  }
}