import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/model/character.dart';


class CharactersApi {
  static const String _baseUrl = 'https://rickandmortyapi.com/api/character';
  final http.Client client;

  CharactersApi(this.client);


  Future<List<Character>> fetchCharacters(int page) async {
    final uri = Uri.parse('$_baseUrl?page=$page');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      return results
          .map((json) => Character.fromMap(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch characters (status: ${response.statusCode})');
    }
  }
}
