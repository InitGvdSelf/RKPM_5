import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/datasources/local/drift_datasource.dart';
import '../../domain/usecases/notes_usecase.dart';
import '../../core/models/note.dart';

class DriftDemoScreen extends StatefulWidget {
  const DriftDemoScreen({super.key});

  @override
  State<DriftDemoScreen> createState() => _DriftDemoScreenState();
}

class _DriftDemoScreenState extends State<DriftDemoScreen> {
  final _ds = DriftDataSource();
  late final NotesUseCase _uc;

  bool _ready = false;
  String _log = '—';

  StreamSubscription<List<Note>>? _sub;
  List<Note> _recent = [];

  @override
  void initState() {
    super.initState();
    _uc = NotesUseCase(_ds);
    _init();
  }

  Future<void> _init() async {
    await _ds.init();

    _sub = _uc.watchRecentNotes().listen((notes) {
      setState(() {
        _recent = notes;
      });
    });

    setState(() {
      _ready = true;
      _log = 'Drift init OK. БД создана/открыта. Seed категорий выполнен при первом запуске.';
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ds.close();
    super.dispose();
  }

  Future<void> _createNote() async {
    final id = await _uc.createNote(
      title: 'Заметка ${DateTime.now().toIso8601String()}',
      content: 'Текст заметки (demo)',
      categoryId: 1,
      color: '#FFFFFF',
    );
    setState(() => _log = 'Создана заметка id=$id');
  }

  Future<void> _loadAllNotes() async {
    final list = await _uc.getAllNotes();
    setState(() {
      _log = 'Все заметки (${list.length}):\n' +
          list
              .map((e) =>
          'id=${e.note.id} title="${e.note.title}" cat=${e.category?.name ?? '—'} archived=${e.note.isArchived}')
              .join('\n');
    });
  }

  Future<void> _searchNotes() async {
    final res = await _uc.searchNotes('Заметка');
    setState(() {
      _log = 'Поиск "Заметка" → ${res.length} шт.\n' +
          res.map((n) => 'id=${n.id} title="${n.title}"').join('\n');
    });
  }

  Future<void> _stats() async {
    final s = await _uc.getStatistics();
    setState(() {
      _log = 'Статистика:\n'
          'total=${s.total}\n'
          'archived=${s.archived}\n'
          'recent(7d)=${s.recent}\n'
          'recentNotesTop5:\n' +
          s.recentNotes.map((n) => 'id=${n.id} title="${n.title}"').join('\n');
    });
  }

  Future<void> _archiveFirstRecent() async {
    if (_recent.isEmpty) {
      setState(() => _log = 'Нет заметок в recent, нечего архивировать');
      return;
    }
    await _uc.archiveNote(_recent.first.id);
    setState(() => _log = 'Архивирована заметка id=${_recent.first.id}');
  }

  Future<void> _deleteFirstRecent() async {
    if (_recent.isEmpty) {
      setState(() => _log = 'Нет заметок в recent, нечего удалять');
      return;
    }
    final id = _recent.first.id;
    await _uc.deleteNote(id);
    setState(() => _log = 'Удалена заметка id=$id');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('PR12 — Drift Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: !_ready
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: _createNote,
                    child: const Text('Create note'),
                  ),
                  FilledButton(
                    onPressed: _loadAllNotes,
                    child: const Text('Get all notes'),
                  ),
                  FilledButton(
                    onPressed: _searchNotes,
                    child: const Text('Search'),
                  ),
                  FilledButton(
                    onPressed: _stats,
                    child: const Text('Statistics'),
                  ),
                  OutlinedButton(
                    onPressed: _archiveFirstRecent,
                    child: const Text('Archive first recent'),
                  ),
                  OutlinedButton(
                    onPressed: _deleteFirstRecent,
                    child: const Text('Delete first recent'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Recent notes stream (${_recent.length}):',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _recent.length,
                  itemBuilder: (_, i) {
                    final n = _recent[i];
                    return ListTile(
                      title: Text(n.title),
                      subtitle: Text('id=${n.id} archived=${n.isArchived}'),
                    );
                  },
                ),
              ),
              const Divider(),
              const Text('Лог:'),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(child: Text(_log)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}