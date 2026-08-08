import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

class ILoveToolsApp extends StatelessWidget {
  const ILoveToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iLoveTools',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
