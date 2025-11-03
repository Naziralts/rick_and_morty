import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../core/api/characters_api.dart';
import '../model/character.dart';

class CharacterRepository {
  final http.Client client;
  final CharactersApi _api;

  /// Hive боксы
  final Box _cacheBox = Hive.box('cache_box');
  final Box _favoritesBox = Hive.box('favorites_box');

  CharacterRepository(this.client) : _api = CharactersApi(client);

  /// Получение списка персонажей с API
  /// Если нет интернета — берёт из кеша (Hive)
  Future<List<Character>> fetchCharacters(int page) async {
    try {
      final characters = await _api.fetchCharacters(page);

      // Кэшируем данные (каждая страница отдельно)
      _cacheBox.put('page_$page', characters.map((c) => c.toMap()).toList());
      return characters;
    } catch (error) {
      // При ошибке сети — возвращаем кеш, если он есть
      final cached = _cacheBox.get('page_$page');
      if (cached != null) {
        return (cached as List)
            .map((e) => Character.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      rethrow;
    }
  }

  // -----------------------
  // ❤️ Работа с избранными
  // -----------------------

  /// Получаем список избранных персонажей
  List<Character> getFavorites() {
    final ids = _favoritesBox.get('favorites', defaultValue: <int>[]) as List;
    return ids.map((id) {
      final data = _favoritesBox.get('fav_$id');
      if (data != null) {
        return Character.fromMap(Map<String, dynamic>.from(data));
      }
      return null;
    }).whereType<Character>().toList();
  }

  /// Проверка: находится ли персонаж в избранном
  bool isFavorite(int id) {
    final ids = _favoritesBox.get('favorites', defaultValue: <int>[]) as List;
    return ids.contains(id);
  }

  /// Добавление персонажа в избранное
  void addFavorite(Character character) {
    final ids = _favoritesBox.get('favorites', defaultValue: <int>[]) as List;
    if (!ids.contains(character.id)) {
      ids.add(character.id);
      _favoritesBox.put('favorites', ids);
      _favoritesBox.put('fav_${character.id}', character.toMap());
    }
  }

  /// Удаление персонажа из избранного
  void removeFavorite(int id) {
    final ids = _favoritesBox.get('favorites', defaultValue: <int>[]) as List;
    ids.remove(id);
    _favoritesBox.put('favorites', ids);
    _favoritesBox.delete('fav_$id');
  }

  /// Очистка всех кешированных данных
  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  /// Очистка избранного (опционально)
  Future<void> clearFavorites() async {
    await _favoritesBox.clear();
  }
}
