import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'utils/themes.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsLink',
      theme: AppThemes.lightTheme, // Gaya tema yang didefinisikan
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
