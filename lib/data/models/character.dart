import 'dart:convert';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String origin;
  final String location;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.origin,
    required this.location,
  });

  /// Создание объекта из JSON
  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Unknown',
      status: map['status'] ?? 'Unknown',
      species: map['species'] ?? 'Unknown',
      gender: map['gender'] ?? 'Unknown',
      image: map['image'] ?? '',
      origin: map['origin']?['name'] ?? 'Unknown',
      location: map['location']?['name'] ?? 'Unknown',
    );
  }

  /// Конвертация в Map для сохранения в Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'image': image,
      'origin': origin,
      'location': location,
    };
  }

  /// JSON сериализация
  String toJson() => json.encode(toMap());

  /// JSON десериализация
  factory Character.fromJson(String source) =>
      Character.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Копия с изменениями
  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? image,
    String? origin,
    String? location,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      origin: origin ?? this.origin,
      location: location ?? this.location,
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
