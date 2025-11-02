part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Событие: загрузить избранных
class FavoritesLoaded extends FavoritesEvent {
  const FavoritesLoaded();
}

/// Событие: добавить в избранное
class AddFavorite extends FavoritesEvent {
  final Character character;
  const AddFavorite(this.character);

  @override
  List<Object?> get props => [character];
}

/// Событие: удалить из избранного
class RemoveFavorite extends FavoritesEvent {
  final int id;
  const RemoveFavorite(this.id);

  @override
  List<Object?> get props => [id];
}
