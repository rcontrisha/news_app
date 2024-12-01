import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://newsapi.org/v2";
  static const String apiKey = "70aae780585e452391d481f301376973";

  Future<List<dynamic>> fetchTopHeadlines({
    String country = 'us',
    String? category, // Tambahkan parameter kategori
  }) async {
    // Bangun URL dengan kategori jika tersedia
    final String url = category != null && category != 'All'
        ? '$baseUrl/top-headlines?country=$country&category=$category&apiKey=$apiKey'
        : '$baseUrl/top-headlines?country=$country&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to fetch headlines');
    }
  }
}
