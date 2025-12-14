class PharmacyDto {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double? latitude;
  final double? longitude;

  PharmacyDto({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory PharmacyDto.fromJson(Map<String, dynamic> json) => PharmacyDto(
    id: json['id'] as String,
    name: json['name'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String?,
    latitude: json['latitude'] as double?,
    longitude: json['longitude'] as double?,
  );
}

