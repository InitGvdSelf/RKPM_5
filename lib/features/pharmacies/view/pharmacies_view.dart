import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/pharmacy_model.dart';

class PharmaciesView extends StatefulWidget {
  const PharmaciesView({super.key});

  @override
  State<PharmaciesView> createState() => _PharmaciesViewState();
}

class _PharmaciesViewState extends State<PharmaciesView> {
  final _searchCtrl = TextEditingController();
  List<Pharmacy> _pharmacies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPharmacies() async {
    setState(() => _isLoading = true);
    final result = await DI.getPharmaciesUseCase();
    result.fold(
      (_) => setState(() {
        _isLoading = false;
        _pharmacies = [];
      }),
      (pharmacies) => setState(() {
        _isLoading = false;
        _pharmacies = pharmacies;
      }),
    );
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      _loadPharmacies();
      return;
    }

    setState(() => _isLoading = true);
    final result = await DI.searchPharmaciesUseCase(query);
    result.fold(
      (_) => setState(() {
        _isLoading = false;
        _pharmacies = [];
      }),
      (pharmacies) => setState(() {
        _isLoading = false;
        _pharmacies = pharmacies;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Адреса аптек')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (value) {
                setState(() {});
                _search(value);
              },
              decoration: const InputDecoration(
                labelText: 'Поиск по названию или адресу',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pharmacies.isEmpty
                    ? const Center(child: Text('Ничего не найдено'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: _pharmacies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final p = _pharmacies[i];
                          return Card(
                            child: ListTile(
                              title: Text(p.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(p.address),
                                  if (p.phone != null) ...[
                                    const SizedBox(height: 4),
                                    Text('Телефон: ${p.phone}'),
                                  ],
                                ],
                              ),
                              trailing: IconButton(
                                tooltip: 'Скопировать адрес',
                                icon: const Icon(Icons.copy),
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: p.address),
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Адрес скопирован'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

