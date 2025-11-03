import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/data/model/character.dart';


import 'package:rick_and_morty_app/data/repository/character_repository.dart';

import 'package:rick_and_morty_app/presentation/bloc/characters_bloc/characters_bloc.dart';

import 'package:rick_and_morty_app/presentation/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:rick_and_morty_app/presentation/pages/detail_page.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites_page.dart';
import 'package:rick_and_morty_app/presentation/pages/home_page.dart';



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = CharacterRepository(http.Client());

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              HomePage(onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) {
            final character = state.extra as Character;
            return DetailPage(character: character);
          },
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CharactersBloc(repository: repository)..add(const CharactersFetched()),
        ),
        BlocProvider(
          create: (_) =>
              FavoritesBloc(repository: repository)..add(const FavoritesLoaded()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Rick and Morty',
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: _lightTheme,
        darkTheme: _darkTheme,
        routerConfig: router,
      ),
    );
  }
}

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
  ),
);

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.teal,
  ),
);
