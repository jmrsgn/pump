class Exercise {
  String name;
  int sets;
  String repRange;
  String? notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.repRange,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'sets': sets,
    'repRange': repRange,
    'notes': notes,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    sets: json['sets'],
    repRange: json['repRange'],
    notes: json['notes'],
  );
}
