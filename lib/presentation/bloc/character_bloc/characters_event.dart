part of 'characters_bloc.dart';

abstract class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => [];
}

/// Событие: загрузить персонажей (следующая страница)
class CharactersFetched extends CharactersEvent {
  const CharactersFetched();
}

/// Событие: обновить список (pull-to-refresh)
class CharactersRefreshed extends CharactersEvent {
  const CharactersRefreshed();
}
