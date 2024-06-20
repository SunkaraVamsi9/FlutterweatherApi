import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weatherapplication/Screens/home.dart';

Future<void> main() async {
  try {
    print('Initializing Hive...');
    await Hive.initFlutter();
    print('Opening box...');
    await Hive.openBox('myBox');
    print('Hive initialized and box opened successfully.');
  } catch (e) {
    print('Error initializing Hive: $e');
  }

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Weather(),
    );
  }
}
