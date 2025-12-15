import 'package:rkpm_5/core/models/pharmacy_model.dart';
import 'package:rkpm_5/data/datasources/remote/overpass/dto/overpass_response_dto.dart';

/// Mapper from Overpass element to Pharmacy domain model.
class OverpassPharmacyMapper {
  static Pharmacy toDomain(OverpassElementDto element) {
    final tags = element.tags;

    // Build address from addr tags
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

    final address = addressParts.isNotEmpty
        ? addressParts.join(', ')
        : 'Адрес не указан';

    // Get name or fallback
    final name = tags['name'] ?? 'Аптека';

    // Get phone if present
    final phone = tags['phone'];

    return Pharmacy(
      id: element.idString,
      name: name,
      address: address,
      phone: phone,
      latitude: element.lat,
      longitude: element.lon,
    );
  }

  static List<Pharmacy> toDomainList(List<OverpassElementDto> elements) {
    return elements.map(toDomain).toList();
  }
}

