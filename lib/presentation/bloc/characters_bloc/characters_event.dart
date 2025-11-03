part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузка следующей страницы персонажей
class CharactersFetched extends CharactersEvent {
  const CharactersFetched();
}

/// Полное обновление списка
class CharactersRefreshed extends CharactersEvent {
  const CharactersRefreshed();
}
