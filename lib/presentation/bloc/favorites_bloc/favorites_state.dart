part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final List<Character> favorites;

  const FavoritesState({this.favorites = const []});

  FavoritesState copyWith({List<Character>? favorites}) {
    return FavoritesState(favorites: favorites ?? this.favorites);
  }

  @override
  List<Object?> get props => [favorites];
}
