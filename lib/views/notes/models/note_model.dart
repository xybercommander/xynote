import 'package:uuid/uuid.dart';

class NoteModel {
  String? id;
  String? content;
  DateTime? createdAt;

  NoteModel({
    this.id,
    this.content,
    this.createdAt
  });


}