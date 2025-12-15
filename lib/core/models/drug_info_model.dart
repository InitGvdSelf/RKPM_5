/// Domain model for drug information from openFDA.
class DrugInfo {
  final String title;
  final String? indications;
  final String? warnings;

  const DrugInfo({
    required this.title,
    this.indications,
    this.warnings,
  });
}

