import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

import 'dart:ui';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(
    const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
