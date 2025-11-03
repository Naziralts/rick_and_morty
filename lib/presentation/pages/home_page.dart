import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/presentation/bloc/characters_bloc/characters_bloc.dart';

import '../widgets/character_card.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomePage({super.key, required this.onToggleTheme, required bool isDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CharactersBloc>().add(const CharactersFetched());
    _scrollController.addListener(_onScroll);
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => context.push('/favorites'),
          ),
        ],
      ),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state.status == CharactersStatus.failure) {
            return const Center(child: Text('Ошибка загрузки персонажей'));
          } else if (state.status == CharactersStatus.initial ||
              state.status == CharactersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final characters = state.characters;

          return LayoutBuilder(
            builder: (context, constraints) {
            
              final crossAxisCount = constraints.maxWidth < 600
                  ? 1
                  : constraints.maxWidth < 900
                      ? 2
                      : 4;

              return GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.9,
                ),
                itemCount: state.hasReachedMax
                    ? characters.length
                    : characters.length + 1,
                itemBuilder: (context, index) {
                  if (index >= characters.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final character = characters[index];
                  return CharacterCard(character: character);
                },
              );
            },
          );
        },
      ),
    );
  }
}
