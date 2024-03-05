import 'package:flutter/material.dart';

import 'features/home/home_page.dart';

void main() {
  runApp(const MainAppConfig());
}

class MainAppConfig extends StatelessWidget {
  const MainAppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainApp();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
