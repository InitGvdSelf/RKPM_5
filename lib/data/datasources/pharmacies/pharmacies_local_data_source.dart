import 'package:rkpm_5/core/utils/id_generator.dart';
import 'package:rkpm_5/data/datasources/pharmacies/dto/pharmacy_dto.dart';

class PharmaciesLocalDataSource {
  // In-memory storage for pharmacies
  static final List<PharmacyDto> _pharmacies = [
    PharmacyDto(
      id: IdGenerator.generate(),
      name: 'Аптека №1',
      address: 'ул. Примерная, 10',
      phone: '+7 (123) 456-78-90',
    ),
    PharmacyDto(
      id: IdGenerator.generate(),
      name: 'Аптека "Здоровье"',
      address: 'пр-т Центральный, 25',
      phone: '+7 (123) 456-78-91',
    ),
    PharmacyDto(
      id: IdGenerator.generate(),
      name: 'Аптека №3',
      address: 'ул. Ленина, 5',
      phone: '+7 (123) 456-78-92',
    ),
    PharmacyDto(
      id: IdGenerator.generate(),
      name: 'Аптека "Фарм+"',
      address: 'ул. Победы, 17',
      phone: '+7 (123) 456-78-93',
    ),
    PharmacyDto(
      id: IdGenerator.generate(),
      name: 'Аптека у дома',
      address: 'ул. Садовая, 3',
      phone: '+7 (123) 456-78-94',
    ),
  ];

  Future<List<PharmacyDto>> getPharmacies() async {
    return List.from(_pharmacies);
  }

  Future<List<PharmacyDto>> searchPharmacies(String query) async {
    final lowerQuery = query.toLowerCase();
    return _pharmacies.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.address.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

