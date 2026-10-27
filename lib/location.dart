class Location {
  final String id; // uuid
  final String name; // text NOT NULL
  final String? address; // text
  final DateTime createdAt;

  Location({
    required this.id,
    required this.name,
    this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Location.fromJson(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Location copyWith({
    String? id,
    String? name,
    String? address,
    DateTime? createdAt,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
