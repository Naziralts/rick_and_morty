import 'dart:convert';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String locationName;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.locationName,
  });

  /// Создание Character из JSON Map
  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Unknown',
      status: map['status'] ?? 'Unknown',
      species: map['species'] ?? 'Unknown',
      image: map['image'] ?? '',
      locationName: map['location']?['name'] ?? 'Unknown',
    );
  }

  /// Преобразование Character в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'location': {'name': locationName},
    };
  }

  /// Для хранения/чтения в Hive (строковый формат)
  String toJson() => json.encode(toMap());

  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Копия с изменениями
  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? image,
    String? locationName,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      image: image ?? this.image,
      locationName: locationName ?? this.locationName,
    );
  }

  @override
  String toString() =>
      'Character(id: $id, name: $name, status: $status, species: $species)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Character && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
