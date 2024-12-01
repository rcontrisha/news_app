import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Impor url_launcher
import '../services/local_storage_service.dart'; // Impor layanan local storage

class NewsDetailScreen extends StatefulWidget {
  final dynamic article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    // Mengecek apakah artikel sudah ada di favorit ketika halaman dibuka
    _checkIfFavorited();
  }

  // Fungsi untuk membuka URL di browser
  Future<void> launcher(String url) async {
    final Uri _url = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (!await launchUrl(_url)) {
      throw Exception("Failed to launch URL: $_url");
    }
  }

  // Mengecek apakah artikel sudah ada di favorit
  void _checkIfFavorited() async {
    bool isFavorited = await isArticleFavorited(widget.article);
    setState(() {
      _isFavorited = isFavorited;
    });
  }

  // Fungsi untuk menyimpan artikel ke favorit
  void _saveArticleToFavorites(BuildContext context) async {
    await addArticleToFavorites(widget.article); // Tambahkan artikel ke favorit
    setState(() {
      _isFavorited = true; // Ubah status menjadi favorit
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article saved to favorites!')),
    );
  }

  // Fungsi untuk menghapus artikel dari favorit
  void _removeArticleFromFavorites(BuildContext context) async {
    await removeArticleFromFavorites(
        widget.article['title']); // Hapus artikel dari favorit
    setState(() {
      _isFavorited = false; // Ubah status menjadi tidak favorit
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article removed from favorites!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar berita
                  widget.article['urlToImage'] != null
                      ? Image.network(widget.article['urlToImage'])
                      : const Icon(Icons.image_not_supported, size: 100),
                  const SizedBox(height: 16),
                  // Judul berita
                  Text(
                    widget.article['title'] ?? 'No title',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Tanggal berita
                  Text(widget.article['publishedAt'] ?? 'No date'),
                  const SizedBox(height: 16),
                  // Konten berita
                  Text(
                    widget.article['content'] ?? 'No content available',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Tombol "Read Full Article" (75%)
                Flexible(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {
                      launcher(widget.article['url']);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Read Full Article',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Spacer antar tombol
                // Tombol "Save" atau "Saved" (25%)
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isFavorited) {
                        _removeArticleFromFavorites(
                            context); // Hapus artikel jika sudah disimpan
                      } else {
                        _saveArticleToFavorites(
                            context); // Simpan artikel jika belum disimpan
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      backgroundColor:
                          _isFavorited ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isFavorited ? 'Saved' : 'Save',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
