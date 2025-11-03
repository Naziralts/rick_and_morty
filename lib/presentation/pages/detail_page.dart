import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/data/model/character.dart';


import 'package:rick_and_morty_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';


class DetailPage extends StatelessWidget {
  final Character character;

  const DetailPage({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = context.read<FavoritesBloc>();
    final isFavorite =
        favoritesBloc.state.favorites.any((c) => c.id == character.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesBloc.add(RemoveFavorite(character.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from favorites')),
                );
              } else {
                favoritesBloc.add(AddFavorite(character));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'character_${character.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: character.image,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              character.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Status', character.status),
            _buildInfoRow('Species', character.species),
            _buildInfoRow('Location', character.locationName),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Unknown',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
