import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';

import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/pages/review_cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    await Wakelock.enable();
  }
  runApp(const MainAppConfig());
}

class MainAppConfig extends StatelessWidget {
  const MainAppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          background: Color(0xFFF5F5F5),
          onBackground: Colors.black,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ReviewCartScreen(),
      },
    );
  }
}
