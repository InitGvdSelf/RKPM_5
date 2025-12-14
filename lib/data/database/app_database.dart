import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'schema.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Notes, Categories, Tags, NoteTags],
  daos: [NotesDao, CategoriesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        await _seedInitialData();
      }
    },
  );

  Future<void> _seedInitialData() async {
    await into(categories).insert(
      CategoriesCompanion.insert(
        name: 'Личное',
        color: const Value('#FF6B6B'),
      ),
    );

    await into(categories).insert(
      CategoriesCompanion.insert(
        name: 'Работа',
        color: const Value('#4ECDC4'),
      ),
    );

    await into(categories).insert(
      CategoriesCompanion.insert(
        name: 'Идеи',
        color: const Value('#FFD166'),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Notes, Categories, Tags, NoteTags])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  Future<int> createNote(NotesCompanion companion) {
    return into(notes).insert(companion);
  }

  Future<List<NoteWithCategory>> getAllNotes() {
    final query = select(notes).join([
      leftOuterJoin(categories, categories.id.equalsExp(notes.categoryId)),
    ]);

    return query.map((row) {
      return NoteWithCategory(
        note: row.readTable(notes),
        category: row.readTableOrNull(categories),
      );
    }).get();
  }

  Future<NoteWithDetails?> getNoteWithDetails(int noteId) async {
    final note = await (select(notes)..where((t) => t.id.equals(noteId)))
        .getSingleOrNull();
    if (note == null) return null;

    Category? category;
    if (note.categoryId != null) {
      category = await (select(categories)
        ..where((t) => t.id.equals(note.categoryId!)))
          .getSingleOrNull();
    }

    final tagsQuery = select(tags).join([
      innerJoin(noteTags, noteTags.tagId.equalsExp(tags.id)),
    ])
      ..where(noteTags.noteId.equals(noteId));

    final tagRows = await tagsQuery.get();
    final tagsList = tagRows.map((r) => r.readTable(tags)).toList();

    return NoteWithDetails(note: note, category: category, tags: tagsList);
  }

  Future<bool> updateNote(NotesCompanion companion) {
    return update(notes).replace(companion);
  }

  Future<void> archiveNote(int noteId) async {
    await (update(notes)..where((t) => t.id.equals(noteId)))
        .write(const NotesCompanion(isArchived: Value(true)));
  }

  Future<int> deleteNote(int noteId) async {
    await (delete(noteTags)..where((t) => t.noteId.equals(noteId))).go();
    return (delete(notes)..where((t) => t.id.equals(noteId))).go();
  }

  Future<List<Note>> searchNotes(String q) {
    final term = '%$q%';
    return (select(notes)
      ..where((t) => t.title.like(term) | t.content.like(term))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<NotesStatistics> getStatistics() async {
    final total = await select(notes).get();
    final archived = await (select(notes)..where((t) => t.isArchived.equals(true))).get();

    final recentNotes = await (select(notes)
      ..where((t) => t.createdAt.isBiggerThanValue(
          DateTime.now().subtract(const Duration(days: 7))))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(5))
        .get();

    return NotesStatistics(
      total: total.length,
      archived: archived.length,
      recent: recentNotes.length,
      recentNotes: recentNotes,
    );
  }
}

@DriftAccessor(tables: [Categories, Notes]) // <- ВАЖНО: добавили Notes
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Future<List<CategoryWithCount>> getAllCategoriesWithCount() async {
    final cats = await select(categories).get();
    final result = <CategoryWithCount>[];

    for (final c in cats) {
      final notesInCat = await (select(notes)
        ..where((t) => t.categoryId.equals(c.id)))
          .get();

      result.add(CategoryWithCount(category: c, noteCount: notesInCat.length));
    }
    return result;
  }
}

class NoteWithCategory {
  final Note note;
  final Category? category;
  NoteWithCategory({required this.note, this.category});
}

class NoteWithDetails {
  final Note note;
  final Category? category;
  final List<Tag> tags;
  NoteWithDetails({required this.note, this.category, required this.tags});
}

class CategoryWithCount {
  final Category category;
  final int noteCount;
  CategoryWithCount({required this.category, required this.noteCount});
}

class NotesStatistics {
  final int total;
  final int archived;
  final int recent;
  final List<Note> recentNotes;
  NotesStatistics({
    required this.total,
    required this.archived,
    required this.recent,
    required this.recentNotes,
  });
}