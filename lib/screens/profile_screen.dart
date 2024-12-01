import 'package:flutter/material.dart';
import 'dart:io'; // Untuk file gambar
import 'package:image_picker/image_picker.dart'; // Library untuk memilih gambar
import 'package:news_app/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan data lokal

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage; // File untuk menyimpan gambar profil
  final ImagePicker _picker = ImagePicker(); // Instance ImagePicker

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Memuat gambar profil saat aplikasi dimulai
  }

  // Fungsi untuk menyimpan path gambar ke SharedPreferences
  Future<void> _saveProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  // Fungsi untuk memuat path gambar dari SharedPreferences
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath); // Muat gambar dari path
      });
    }
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _saveProfileImage(pickedFile.path); // Simpan path gambar
    }
  }

  // Fungsi untuk mengambil gambar menggunakan kamera
  Future<void> _takeImageWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _saveProfileImage(pickedFile.path); // Simpan path gambar
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data pengguna (statis)
    const String userName = "Muflihul Hakim";
    const String userEmail = "124190070";

    int _currentIndex = 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto profil
            CircleAvatar(
              radius: 60,
              backgroundImage: _profileImage != null
                  ? FileImage(
                      _profileImage!) // Tampilkan gambar profil jika ada
                  : null, // Jika tidak ada, gunakan child untuk menampilkan ikon
              child: _profileImage == null
                  ? const Icon(Icons.person, size: 60) // Tampilkan ikon default
                  : null, // Jika ada gambar, tidak perlu child
            ),
            const SizedBox(height: 16),
            // Tombol untuk mengubah gambar profil
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick from Gallery'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _takeImageWithCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Informasi pengguna
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex),
    );
  }
}
