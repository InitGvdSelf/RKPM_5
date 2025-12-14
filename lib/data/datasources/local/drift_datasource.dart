import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class DriftDataSource {
  late AppDatabase _database;

  Future<void> init() async {
    _database = AppDatabase();
  }

  AppDatabase get database => _database;

  NotesDao get notesDao => _database.notesDao;
  CategoriesDao get categoriesDao => _database.categoriesDao;

  Future<void> close() async {
    await _database.close();
  }

  Future<void> moveNotesToCategory(int fromCategoryId, int toCategoryId) async {
    await _database.transaction(() async {
      await (_database.update(_database.notes)
        ..where((t) => t.categoryId.equals(fromCategoryId)))
          .write(NotesCompanion(categoryId: Value(toCategoryId)));
    });
  }

  Stream<List<Note>> watchRecentNotes({int limit = 10}) {
    return (_database.select(_database.notes)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(limit))
        .watch();
  }

  Future<void> importNotes(List<Note> notesToImport) async {
    await _database.batch((batch) {
      batch.insertAll(_database.notes, notesToImport);
    });
  }
}