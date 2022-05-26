import 'package:flutter/cupertino.dart';
import 'package:xynote/data/models/note_model.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  void pushNewNote(Note note) {
    _notes.add(note);
  }
}