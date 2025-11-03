import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/data/model/character.dart';
import 'package:rick_and_morty_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final favBloc = context.read<FavoritesBloc>();
    final isFavorite =
        favBloc.state.favorites.any((c) => c.id == character.id);

    return ListTile(
      leading: Hero(
        tag: 'character_${character.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: character.image,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline),
          ),
        ),
      ),
      title: Text(character.name),
      subtitle: Text('${character.status} • ${character.species}'),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? Colors.amber : null,
        ),
        onPressed: () {
          
          if (isFavorite) {
            favBloc.add(RemoveFavorite(character.id));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from favorites')),
            );
          } else {
            favBloc.add(AddFavorite(character));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to favorites')),
            );
          }
        },
      ),
      onTap: () {

        context.push('/detail', extra: character);
      },
    );
  }
}
