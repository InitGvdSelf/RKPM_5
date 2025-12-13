import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PharmacyAddress {
  final String name;
  final String address;
  final String? hours;

  const PharmacyAddress({
    required this.name,
    required this.address,
    this.hours,
  });
}

class PharmaciesView extends StatefulWidget {
  const PharmaciesView({super.key});

  @override
  State<PharmaciesView> createState() => _PharmaciesViewState();
}

class _PharmaciesViewState extends State<PharmaciesView> {
  final _searchCtrl = TextEditingController();

  // TODO: замени на реальные адреса (хоть 5-10 штук для отчёта)
  final List<PharmacyAddress> _items = const [
    PharmacyAddress(
      name: 'Аптека №1',
      address: 'ул. Примерная, 10',
      hours: '08:00–22:00',
    ),
    PharmacyAddress(
      name: 'Аптека “Здоровье”',
      address: 'пр-т Центральный, 25',
      hours: 'круглосуточно',
    ),
    PharmacyAddress(
      name: 'Аптека №3',
      address: 'ул. Ленина, 5',
      hours: '09:00–21:00',
    ),
    PharmacyAddress(
      name: 'Аптека “Фарм+”',
      address: 'ул. Победы, 17',
      hours: '10:00–20:00',
    ),
    PharmacyAddress(
      name: 'Аптека у дома',
      address: 'ул. Садовая, 3',
      hours: '09:00–23:00',
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchCtrl.text.trim().toLowerCase();

    final filtered = _items.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.address.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Адреса аптек')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Поиск по названию или адресу',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Ничего не найдено'))
                : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = filtered[i];
                return Card(
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(p.address),
                        if (p.hours != null) ...[
                          const SizedBox(height: 4),
                          Text('Время работы: ${p.hours}'),
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