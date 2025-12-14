import 'package:drift/drift.dart';

import '../../core/models/note.dart';
import '../../data/datasources/local/drift_datasource.dart';

class NotesUseCase {
  final DriftDataSource _drift;

  NotesUseCase(this._drift);

  Future<int> createNote({
    required String title,
    String? content,
    int? categoryId,
    String color = '#FFFFFF',
  }) {
    final now = DateTime.now();

    final companion = NotesCompanion.insert(
      title: title,
      content: Value(content),
      categoryId: Value(categoryId),
      color: Value(color),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return _drift.notesDao.createNote(companion);
  }

  Future<List<NoteWithCategory>> getAllNotes() => _drift.notesDao.getAllNotes();

  Future<List<Note>> searchNotes(String query) async {
    if (query.trim().isEmpty) return [];
    return _drift.notesDao.searchNotes(query);
  }

  Future<NotesStatistics> getStatistics() => _drift.notesDao.getStatistics();

  Future<void> archiveNote(int noteId) => _drift.notesDao.archiveNote(noteId);

  Future<void> deleteNote(int noteId) => _drift.notesDao.deleteNote(noteId);

  Future<NoteWithDetails?> getNoteDetails(int noteId) =>
      _drift.notesDao.getNoteWithDetails(noteId);

  Stream<List<Note>> watchRecentNotes() => _drift.watchRecentNotes();
}