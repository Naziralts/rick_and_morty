part of 'characters_bloc.dart';

enum CharactersStatus { initial, loading, success, failure }

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<Character> characters;
  final int page;
  final bool hasReachedMax;

  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const <Character>[],
    this.page = 1,
    this.hasReachedMax = false,
  });

  CharactersState copyWith({
    CharactersStatus? status,
    List<Character>? characters,
    int? page,
    bool? hasReachedMax,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, characters, page, hasReachedMax];
}
