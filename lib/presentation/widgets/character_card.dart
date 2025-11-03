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
    final isFavorite = favBloc.state.favorites.any((c) => c.id == character.id);
    final screenWidth = MediaQuery.of(context).size.width;

    
    if (screenWidth < 600) {
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
                  const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error_outline),
            ),
          ),
        ),
        title: Text(
          character.name,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
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
                SnackBar(
                  content: Text('${character.name} removed from favorites'),
                  duration: const Duration(milliseconds: 1000),
                ),
              );
            } else {
              favBloc.add(AddFavorite(character));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${character.name} added to favorites'),
                  duration: const Duration(milliseconds: 1000),
                ),
              );
            }
          },
        ),
        onTap: () => context.push('/detail', extra: character),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/detail', extra: character),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
         
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'character_${character.id}',
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline),
                ),
              ),
            ),
            
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${character.status} • ${character.species}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : null,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            favBloc.add(RemoveFavorite(character.id));
                          } else {
                            favBloc.add(AddFavorite(character));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
