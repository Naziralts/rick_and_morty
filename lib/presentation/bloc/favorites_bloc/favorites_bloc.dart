import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/data/models/character.dart';
import 'package:rick_and_morty_app/data/repository/character_repository.dart';


part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CharacterRepository repository;

  FavoritesBloc({required this.repository}) : super(const FavoritesState()) {
    on<FavoritesLoaded>(_onFavoritesLoaded);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  void _onFavoritesLoaded(
      FavoritesLoaded event, Emitter<FavoritesState> emit) {
    final favorites = repository.getFavorites();
    emit(state.copyWith(favorites: favorites));
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoritesState> emit) {
    repository.addFavorite(event.character);
    final updated = repository.getFavorites();
    emit(state.copyWith(favorites: updated));
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<FavoritesState> emit) {
    repository.removeFavorite(event.id);
    final updated = repository.getFavorites();
    emit(state.copyWith(favorites: updated));
  }
}
