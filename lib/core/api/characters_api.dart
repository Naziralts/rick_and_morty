import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/models/character.dart';


class CharactersApi {
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';
  final http.Client client;

  CharactersApi(this.client);

  /// Получает список персонажей с Rick and Morty API.
  /// [page] — номер страницы для пагинации.
  Future<List<Character>> fetchCharacters(int page) async {
    final uri = Uri.parse('$_baseUrl?page=$page');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];

      return results
          .map((json) => Character.fromMap(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Ошибка при получении персонажей (код: ${response.statusCode})');
    }
  }

  /// Поиск персонажей по имени
  Future<List<Character>> searchCharacters(String query) async {
    final uri = Uri.parse('$_baseUrl/?name=$query');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];

      return results
          .map((json) => Character.fromMap(json as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 404) {
     
      return [];
    } else {
      throw Exception(
          'Ошибка при поиске персонажей (код: ${response.statusCode})');
    }
  }
}
