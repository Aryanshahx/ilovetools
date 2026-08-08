import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';

class ILoveToolsApp extends StatelessWidget {
  const ILoveToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iLoveTools',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
