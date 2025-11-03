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
    final screenWidth = MediaQuery.of(context).size.width;

    
    final isFavorite = context.select<FavoritesBloc, bool>(
      (bloc) => bloc.state.favorites.any((c) => c.id == character.id),
    );

    final favBloc = context.read<FavoritesBloc>();

    double imageSize;
    if (screenWidth < 600) {
      imageSize = 64; 
    } else if (screenWidth < 900) {
      imageSize = 120; 
    } else {
      imageSize = 180; 
    }

    if (screenWidth < 600) {
      return ListTile(
        leading: Hero(
          tag: 'character_${character.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: character.image,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error_outline),
            ),
          ),
        ),
        title: Text(character.name,
            style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text('${character.status} • ${character.species}'),
        trailing: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              key: ValueKey(isFavorite),
              color: isFavorite ? Colors.amber : null,
            ),
          ),
          onPressed: () {
            isFavorite
                ? favBloc.add(RemoveFavorite(character.id))
                : favBloc.add(AddFavorite(character));
          },
        ),
        onTap: () => context.push('/detail', extra: character),
      );
    }


    return InkWell(
      onTap: () => context.push('/detail', extra: character),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
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
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline, size: 48),
                ),
              ),
            ),
   
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            key: ValueKey(isFavorite),
                            color: isFavorite ? Colors.amber : null,
                          ),
                        ),
                        onPressed: () {
                          isFavorite
                              ? favBloc.add(RemoveFavorite(character.id))
                              : favBloc.add(AddFavorite(character));
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
