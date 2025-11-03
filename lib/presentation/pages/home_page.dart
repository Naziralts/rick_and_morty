import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/presentation/bloc/characters_bloc/characters_bloc.dart';

import '../widgets/character_card.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharactersBloc>().add(const CharactersFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        actions: [
          // ⭐ Переход в избранное
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () => context.push('/favorites'),
          ),
          // 🌗 Переключатель темы
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state.status == CharactersStatus.failure) {
            return const Center(child: Text('Failed to load characters'));
          } else if (state.status == CharactersStatus.initial ||
              state.status == CharactersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.characters.length
                : state.characters.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.characters.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final character = state.characters[index];
              return CharacterCard(character: character);
            },
          );
        },
      ),
    );
  }
}
