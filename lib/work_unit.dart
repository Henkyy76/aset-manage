class WorkUnit {
  final String id; // uuid
  final String name; // text NOT NULL
  final DateTime createdAt;

  WorkUnit({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WorkUnit.fromJson(Map<String, dynamic> map) {
    return WorkUnit(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  WorkUnit copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return WorkUnit(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
