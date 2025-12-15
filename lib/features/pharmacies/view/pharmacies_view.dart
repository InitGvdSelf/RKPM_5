import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/data/datasources/remote/dadata/dto/dadata_suggest_dto.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/dto/overpass_response_dto.dart';

class PharmaciesView extends StatefulWidget {
  const PharmaciesView({super.key});

  @override
  State<PharmaciesView> createState() => _PharmaciesViewState();
}

class _PharmaciesViewState extends State<PharmaciesView> {
  final _searchCtrl = TextEditingController();
  List<Pharmacy> _pharmacies = [];
  bool _isLoading = true;
  List<DadataSuggestionDto> _suggestions = [];
  double? _currentLat;
  double? _currentLon;

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text;
    if (query.length >= 3) {
      _loadSuggestions(query);
    } else {
      setState(() {
        _suggestions = [];
      });
    }
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

  Future<void> _loadSuggestions(String query) async {
    try {
      final result = await DI.suggestAddressUseCase(query);
      result.fold(
        (failure) {
          // Ignore errors for suggestions
        },
        (suggestions) {
          if (mounted) {
            setState(() {
              _suggestions = suggestions;
            });
          }
        },
      );
    } catch (e) {
      // Ignore errors for suggestions
    }
  }

  Future<void> _onSuggestionTap(DadataSuggestionDto suggestion) async {
    setState(() {
      _searchCtrl.text = suggestion.value;
      _suggestions = [];
    });

    // Geocode the selected address
    await _geocodeAddress(suggestion.value);
  }

  Future<void> _geocodeAddress(String address) async {
    try {
      final result = await DI.geocodeAddressUseCase(address);
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message)),
            );
          }
        },
        (coords) {
          setState(() {
            _currentLat = coords.$1;
            _currentLon = coords.$2;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка геокодирования: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _findNearbyPharmacies() async {
    // If no coordinates yet, geocode current text first
    if (_currentLat == null || _currentLon == null) {
      final address = _searchCtrl.text.trim();
      if (address.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Введите адрес для поиска')),
          );
        }
        return;
      }
      await _geocodeAddress(address);
      if (_currentLat == null || _currentLon == null) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _suggestions = [];
    });

    final result = await DI.findNearbyPharmaciesUseCase(
      _currentLat!,
      _currentLon!,
      1500, // 1.5 km radius
    );

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (pharmacies) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _pharmacies = pharmacies;
          });
        }
      },
    );
  }

  Future<void> _showPharmacyDetails(Pharmacy pharmacy) async {
    // Parse pharmacy.id as "type:id"
    final parts = pharmacy.id.split(':');
    if (parts.length != 2) {
      return;
    }

    final osmType = parts[0];
    final osmId = parts[1];

    final result = await DI.getPharmacyDetailsUseCase(osmType, osmId);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (element) {
        if (element == null || !mounted) return;

        _showPharmacyDetailsDialog(element);
      },
    );
  }

  Future<void> _showPharmacyDetailsDialog(OverpassElementDto element) async {
    final tags = element.tags;
    final name = tags['name'] ?? 'Аптека';
    final phone = tags['phone'];
    final openingHours = tags['opening_hours'];
    
    // Try to get address from reverse geocoding if coordinates are available
    String? address;
    if (element.lat != null && element.lon != null) {
      final result = await DI.reverseGeocodeUseCase(element.lat!, element.lon!);
      result.fold(
        (_) {
          // If reverse geocoding fails, try to build address from tags
          address = _buildAddressFromTags(tags);
        },
        (geocodedAddress) {
          address = geocodedAddress;
        },
      );
    } else {
      // If no coordinates, build address from tags
      address = _buildAddressFromTags(tags);
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text('Адрес: $address'),
            if (phone != null) ...[
              const SizedBox(height: 8),
              Text('Телефон: $phone'),
            ],
            if (openingHours != null) ...[
              const SizedBox(height: 8),
              Text('Часы работы: $openingHours'),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _buildAddressFromTags(Map<String, String> tags) {
    final street = tags['addr:street'] ?? '';
    final houseNumber = tags['addr:housenumber'] ?? '';
    final city = tags['addr:city'] ?? '';
    final addressParts = <String>[];
    if (city.isNotEmpty) addressParts.add(city);
    if (street.isNotEmpty) {
      addressParts.add(street);
      if (houseNumber.isNotEmpty) {
        addressParts.add(houseNumber);
      }
    }
    return addressParts.isNotEmpty
        ? addressParts.join(', ')
        : 'Адрес не указан';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
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
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Card(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            dense: true,
                            title: Text(suggestion.value),
                            onTap: () => _onSuggestionTap(suggestion),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _findNearbyPharmacies,
                    icon: const Icon(Icons.near_me),
                    label: const Text('Аптеки рядом'),
                  ),
                ),
              ],
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
                          // Show coordinates instead of address for nearby pharmacies
                          final locationText = p.latitude != null && p.longitude != null
                              ? '${p.latitude!.toStringAsFixed(6)}, ${p.longitude!.toStringAsFixed(6)}'
                              : p.address;
                          return Card(
                            child: ListTile(
                              title: Text(p.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(locationText),
                                  if (p.phone != null) ...[
                                    const SizedBox(height: 4),
                                    Text('Телефон: ${p.phone}'),
                                  ],
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Детали',
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => _showPharmacyDetails(p),
                                  ),
                                  IconButton(
                                    tooltip: 'Скопировать координаты',
                                    icon: const Icon(Icons.copy),
                                    onPressed: () async {
                                      final textToCopy = p.latitude != null && p.longitude != null
                                          ? '${p.latitude!.toStringAsFixed(6)}, ${p.longitude!.toStringAsFixed(6)}'
                                          : p.address;
                                      await Clipboard.setData(
                                        ClipboardData(text: textToCopy),
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Координаты скопированы'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
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

