import 'package:flutter/material.dart';
import 'package:news_app/widgets/bottom_navbar.dart';
import 'package:news_app/widgets/news_card.dart';
import '../services/local_storage_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<dynamic>> _favoritesFuture;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Memuat daftar favorit pada awalnya
  }

  // Fungsi untuk memuat daftar artikel favorit
  void _loadFavorites() {
    setState(() {
      _favoritesFuture = getFavoriteArticles(); // Ambil artikel favorit
    });
  }

  // Fungsi untuk menangani pull-to-refresh (scroll down untuk refresh)
  Future<void> _onRefresh() async {
    _loadFavorites(); // Memuat ulang data favorit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh, // Memanggil fungsi _onRefresh saat diseret
        child: FutureBuilder<List<dynamic>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading favorites'));
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorite articles found'));
            } else {
              final favorites = snapshot.data!;
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final article = favorites[index];
                  return Dismissible(
                    key: Key(article['title']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      // Menghapus artikel dari favorit
                      await removeArticleFromFavorites(article['title']);
                      // Memuat ulang daftar favorit setelah artikel dihapus
                      _loadFavorites();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '${article['title']} removed from favorites')),
                      );
                    },
                    child: NewsCard(article: article),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
    );
  }
}
