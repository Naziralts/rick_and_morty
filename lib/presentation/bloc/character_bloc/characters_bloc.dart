import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/data/models/character.dart';
import 'package:rick_and_morty_app/data/repository/character_repository.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final CharacterRepository repository;

  CharactersBloc({required this.repository}) : super(const CharactersState()) {
    on<CharactersFetched>(_onCharactersFetched);
    on<CharactersRefreshed>(_onCharactersRefreshed);
  }

  Future<void> _onCharactersFetched(
      CharactersFetched event, Emitter<CharactersState> emit) async {
    if (state.hasReachedMax) return;

    try {
      
      if (state.status == CharactersStatus.initial) {
        final characters = await repository.fetchCharacters(1);
        emit(state.copyWith(
          status: CharactersStatus.success,
          characters: characters,
          page: 1,
          hasReachedMax: false,
        ));
        return;
      }

     
      final nextPage = state.page + 1;
      final characters = await repository.fetchCharacters(nextPage);

      if (characters.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          status: CharactersStatus.success,
          characters: List.of(state.characters)..addAll(characters),
          page: nextPage,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: CharactersStatus.failure));
    }
  }

  Future<void> _onCharactersRefreshed(
      CharactersRefreshed event, Emitter<CharactersState> emit) async {
    try {
      emit(state.copyWith(status: CharactersStatus.loading));
      final characters = await repository.fetchCharacters(1);
      emit(state.copyWith(
        status: CharactersStatus.success,
        characters: characters,
        page: 1,
        hasReachedMax: false,
      ));
    } catch (_) {
      emit(state.copyWith(status: CharactersStatus.failure));
    }
  }
}
