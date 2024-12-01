import 'package:flutter/material.dart';
import 'package:news_app/widgets/bottom_navbar.dart';
import 'package:news_app/widgets/category_selector.dart';
import '../services/api_service.dart';
import '../widgets/news_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _articlesFuture;
  List<dynamic> _allArticles = [];
  List<dynamic> _filteredArticles = [];
  TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Technology',
    'Sports',
    'Business',
    'Health',
    'Entertainment',
  ];

  String _selectedCategory = 'All'; // Kategori yang dipilih
  bool _isLoading = false; // Status loading
  int _currentIndex = 0; // Indeks halaman aktif di bottom navigation

  @override
  void initState() {
    super.initState();
    // Memuat artikel berdasarkan kategori awal (All)
    _loadArticles();
  }

  // Fungsi untuk memuat artikel berdasarkan kategori
  void _loadArticles({String? category}) {
    setState(() {
      _isLoading = true; // Tampilkan indikator loading
    });

    _apiService.fetchTopHeadlines(category: category).then((articles) {
      setState(() {
        _allArticles = articles;
        _filteredArticles = articles; // Initial filtering: show all articles
        _isLoading = false; // Nonaktifkan indikator loading
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Nonaktifkan indikator loading jika gagal
      });
      print('Error fetching articles: $error');
    });
  }

  // Fungsi untuk melakukan filter artikel berdasarkan pencarian
  void _filterArticlesBySearch(String query) {
    String lowerQuery = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // Reset filtered articles to show all articles when search is empty
        _filteredArticles = _allArticles;
      } else {
        // Filter hanya berdasarkan query pencarian
        _filteredArticles = _allArticles.where((article) {
          String title = article['title'].toLowerCase();
          return title.contains(lowerQuery);
        }).toList();
      }
    });
  }

  // Fungsi ketika kategori dipilih
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    // Muat artikel berdasarkan kategori yang dipilih
    _loadArticles(category: category != 'All' ? category.toLowerCase() : null);
  }

  // Fungsi pencarian yang menerima query
  void _onSearch(String query) {
    _filterArticlesBySearch(
        query); // Hanya filter berdasarkan pencarian, tanpa kategori
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewsLink'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pencarian
          SearchBarWidget(
            controller: _searchController,
            onSearch: (query) {
              _onSearch(query); // Pass the query to filter articles
            },
          ),
          // Pilihan kategori
          CategorySelectorWidget(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredArticles.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = _filteredArticles[index];
                          return NewsCard(article: article);
                        },
                      )
                    : const Center(child: Text('No articles found')),
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: _currentIndex), // Menambahkan BottomNavBar
    );
  }
}
