class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double? latitude;
  final double? longitude;

  const Pharmacy({
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

  factory Pharmacy.fromJson(Map<String, dynamic> j) => Pharmacy(
    id: (j['id'] ?? '') as String,
    name: (j['name'] ?? '') as String,
    address: (j['address'] ?? '') as String,
    phone: j['phone'] as String?,
    latitude: j['latitude'] as double?,
    longitude: j['longitude'] as double?,
  );
}

