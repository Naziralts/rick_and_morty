import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_app/app.dart';


Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();



await Hive.initFlutter();


await Hive.openBox('cache_box');      
await Hive.openBox('favorites_box');  


runApp(const MyApp());

}