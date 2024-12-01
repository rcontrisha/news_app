import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String favoriteArticlesKey = 'favorite_articles';

// Menyimpan daftar artikel favorit
Future<void> saveFavoriteArticles(List<dynamic> articles) async {
  final prefs = await SharedPreferences.getInstance();
  final articlesJson = jsonEncode(articles); // Ubah list ke JSON string
  await prefs.setString(favoriteArticlesKey, articlesJson);
}

// Mengambil daftar artikel favorit
Future<List<dynamic>> getFavoriteArticles() async {
  final prefs = await SharedPreferences.getInstance();
  final articlesJson = prefs.getString(favoriteArticlesKey);

  if (articlesJson != null) {
    return jsonDecode(articlesJson); // Decode JSON string ke list
  }

  return []; // Jika kosong, kembalikan list kosong
}

// Menambahkan artikel ke daftar favorit
Future<void> addArticleToFavorites(dynamic article) async {
  final articles = await getFavoriteArticles();

  // Hindari duplikasi artikel berdasarkan judul (bisa disesuaikan)
  if (!articles.any((fav) => fav['title'] == article['title'])) {
    articles.add(article);
    await saveFavoriteArticles(articles);
  }
}

// Menghapus artikel dari daftar favorit
Future<void> removeArticleFromFavorites(String title) async {
  final articles = await getFavoriteArticles();
  final updatedArticles = articles.where((article) => article['title'] != title).toList();
  await saveFavoriteArticles(updatedArticles);
}

// Mengecek apakah artikel sudah ada di favorit
Future<bool> isArticleFavorited(dynamic article) async {
  final articles = await getFavoriteArticles();

  // Cek apakah artikel sudah ada berdasarkan judul
  return articles.any((fav) => fav['title'] == article['title']);
}
