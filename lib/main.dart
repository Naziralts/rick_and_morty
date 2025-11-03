import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_app/app.dart';


Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();

// Инициализация Hive

await Hive.initFlutter();

// Открываем боксы (Hive хранилища)

await Hive.openBox('cache_box');      // Кеш страниц персонажей

await Hive.openBox('favorites_box');  // Избранные персонажи

// Запуск приложения

runApp(const MyApp());

}