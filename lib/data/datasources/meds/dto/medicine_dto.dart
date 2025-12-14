class MedicineDto {
  final String id;
  final String name;
  final String form;
  final String dose;
  final String notes;
  final String? imageUrl;
  final Map<String, dynamic> schedule;

  MedicineDto({
    required this.id,
    required this.name,
    required this.form,
    required this.dose,
    required this.notes,
    required this.schedule,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'form': form,
    'dose': dose,
    'notes': notes,
    'imageUrl': imageUrl,
    'schedule': schedule,
  };

  factory MedicineDto.fromJson(Map<String, dynamic> json) => MedicineDto(
    id: json['id'] as String,
    name: json['name'] as String,
    form: json['form'] as String,
    dose: json['dose'] as String,
    notes: json['notes'] as String,
    imageUrl: json['imageUrl'] as String?,
    schedule: (json['schedule'] as Map?)?.cast<String, dynamic>() ?? const {},
  );
}

