import 'package:flutter/material.dart';
import 'package:news_app/screens/profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/news_detail_screen.dart';
import '../screens/favorite_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String newsDetail = '/news-detail';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case newsDetail:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => NewsDetailScreen(article: arguments['article']),
        );
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
