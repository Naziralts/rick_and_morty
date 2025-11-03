part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}


class FavoritesLoaded extends FavoritesEvent {
  const FavoritesLoaded();
}

class AddFavorite extends FavoritesEvent {
  final Character character;
  const AddFavorite(this.character);

  @override
  List<Object?> get props => [character];
}

class RemoveFavorite extends FavoritesEvent {
  final int id;
  const RemoveFavorite(this.id);

  @override
  List<Object?> get props => [id];
}
