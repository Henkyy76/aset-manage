import 'package:flutter/foundation.dart';

class Asset {
  final String id;
  final String? userId;
  final String code;
  final String name;
  final String? categoryId;
  final String? typeId;
  final String? source;
  final DateTime? receivedAt;
  final double? initialValue;
  final String? unitSuk;
  final int? lifeYears;
  final String? workUnitId;
  final String? locationId;
  final String? condition;
  final String? notes;
  final String? photoUrl;
  final int stockSistem;
  final int stockFisik;
  final DateTime createdAt;
  final DateTime updatedAt;

  Asset({
    required this.id,
    this.userId,
    required this.code,
    required this.name,
    this.categoryId,
    this.typeId,
    this.source,
    this.receivedAt,
    this.initialValue,
    this.unitSuk,
    this.lifeYears,
    this.workUnitId,
    this.locationId,
    this.condition,
    this.notes,
    this.photoUrl,
    required this.stockSistem,
    required this.stockFisik,
    required this.createdAt,
    required this.updatedAt,
  });

  // fromJson factory to create an Asset from a Supabase map
  factory Asset.fromJson(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] as String,
      userId: map['user_id'] as String?,
      code: map['code'] as String,
      name: map['name'] as String,
      categoryId: map['category_id'] as String?,
      typeId: map['type_id'] as String?,
      source: map['source'] as String?,
      receivedAt: map['received_at'] != null ? DateTime.parse(map['received_at'] as String) : null,
      initialValue: (map['initial_value'] as num?)?.toDouble(),
      unitSuk: map['unit_suk'] as String?,
      lifeYears: map['life_years'] as int?,
      workUnitId: map['work_unit_id'] as String?,
      locationId: map['location_id'] as String?,
      condition: map['condition'] as String?,
      notes: map['notes'] as String?,
      photoUrl: map['photo_url'] as String?,
      stockSistem: map['stock_sistem'] as int? ?? 0,
      stockFisik: map['stock_fisik'] as int? ?? 0,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  // toJson method to convert an Asset to a map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'name': name,
      'category_id': categoryId,
      'type_id': typeId,
      'source': source,
      'received_at': receivedAt?.toIso8601String(),
      'initial_value': initialValue,
      'unit_suk': unitSuk,
      'life_years': lifeYears,
      'work_unit_id': workUnitId,
      'location_id': locationId,
      'condition': condition,
      'notes': notes,
      'photo_url': photoUrl,
      'stock_sistem': stockSistem,
      'stock_fisik': stockFisik,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // copyWith method remains useful for updating objects
  Asset copyWith({
     String? id, String? userId, String? code, String? name, String? categoryId, String? typeId, String? source, DateTime? receivedAt, double? initialValue, String? unitSuk, int? lifeYears, String? workUnitId, String? locationId, String? condition, String? notes, String? photoUrl, int? stockSistem, int? stockFisik, DateTime? createdAt, DateTime? updatedAt,
  }) {
    return Asset(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      typeId: typeId ?? this.typeId,
      source: source ?? this.source,
      receivedAt: receivedAt ?? this.receivedAt,
      initialValue: initialValue ?? this.initialValue,
      unitSuk: unitSuk ?? this.unitSuk,
      lifeYears: lifeYears ?? this.lifeYears,
      workUnitId: workUnitId ?? this.workUnitId,
      locationId: locationId ?? this.locationId,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      stockSistem: stockSistem ?? this.stockSistem,
      stockFisik: stockFisik ?? this.stockFisik,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
