import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/data/model/character.dart';
import 'package:rick_and_morty_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';

import '../widgets/character_card.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  String _sortOption = 'Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _sortOption = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Name', child: Text('Sort by Name')),
              PopupMenuItem(value: 'Status', child: Text('Sort by Status')),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          var favorites = List<Character>.from(state.favorites);

          if (favorites.isEmpty) {
            return const Center(
              child: Text('No favorites yet 💫'),
            );
          }

          // сортировка
          favorites.sort((a, b) {
            switch (_sortOption) {
              case 'Status':
                return a.status.compareTo(b.status);
              default:
                return a.name.compareTo(b.name);
            }
          });

          return AnimatedListExample(favorites: favorites);
        },
      ),
    );
  }
}

class AnimatedListExample extends StatefulWidget {
  final List<Character> favorites;
  const AnimatedListExample({super.key, required this.favorites});

  @override
  State<AnimatedListExample> createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  late final GlobalKey<AnimatedListState> _listKey;
  late List<Character> _items;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<AnimatedListState>();
    _items = List.from(widget.favorites);
  }

  @override
  void didUpdateWidget(covariant AnimatedListExample oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Если список изменился — плавно обновляем
    if (widget.favorites.length < _items.length) {
      // элемент удалён
      for (final old in _items) {
        if (!widget.favorites.contains(old)) {
          _removeItem(_items.indexOf(old), old);
          break;
        }
      }
    } else {
      _items = List.from(widget.favorites);
    }
  }

  void _removeItem(int index, Character character) {
    final removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
      duration: const Duration(milliseconds: 400),
    );
  }

  Widget _buildRemovedItem(Character character, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.0, 0.0),
        ).animate(animation),
        child: CharacterCard(character: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        final character = _items[index];
        return SizeTransition(
          sizeFactor: animation,
          child: Dismissible(
            key: Key(character.id.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              context
                  .read<FavoritesBloc>()
                  .add(RemoveFavorite(character.id));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${character.name} removed from favorites'),
                ),
              );
            },
            child: CharacterCard(character: character),
          ),
        );
      },
    );
  }
}
