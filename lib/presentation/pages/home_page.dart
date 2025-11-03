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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CharactersBloc>().add(const CharactersFetched());
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
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.onToggleTheme,
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

          // ✅ Адаптивная сетка карточек
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              double childAspectRatio;

              // 🔹 Подбираем количество колонок и пропорции под экран
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1;
                childAspectRatio = 3.5; // телефон — длинные карточки
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 2;
                childAspectRatio = 2.2; // планшет — сбалансированные карточки
              } else {
                crossAxisCount = 4;
                childAspectRatio = 1.3; // веб — квадратные карточки
              }

              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
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

                  // 🎞 Добавляем лёгкую анимацию появления
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 250 + (index % 10) * 30),
                    builder: (context, value, child) => Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    ),
                    child: CharacterCard(character: character),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
