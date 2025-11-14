import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends GetxService {
  late SharedPreferences _prefs;
  
  // Implementasi Supabase & Hive akan ada di sini.
  late final SupabaseClient _supabaseClient;
  // Untuk saat ini, kita gunakan placeholder dan shared_preferences.

  //Url & Key supabase
  static const String SUPABASE_URL = 'https://duhqgdqijglqjfcxfxio.supabase.co';
  static const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1aHFnZHFpamdscWpmY3hmeGlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3MzI1MDksImV4cCI6MjA3ODMwODUwOX0.7HOAHuu8Lw7w9-lCxNpfYF5QXp1jgJKkn2p8qNFwc9k';
  

  // Dipanggil di main.dart untuk inisialisasi asynchronous
  Future<AuthService> init() async {
    // inisialisasi supabase
    await Supabase.initialize(
      url: SUPABASE_URL, 
      anonKey: SUPABASE_ANON_KEY,
      debug: true
      );

      _supabaseClient = Supabase.instance.client;

      _prefs = await SharedPreferences.getInstance();

      return this;
  }
  
  // Placeholder: Cek status login
  bool get isLoggedIn {
    // Cek apakah ada sesi user aktif di Supabase
    return _supabaseClient.auth.currentUser != null;
  }

  // Placeholder: Logika Sign In
  Future<bool> signIn(String email, String password) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      //cek jika user ada pada database
      if(response.user != null) {
        await _prefs.setBool('isLoggedIn', true);
        return true;
      }
      // jika tidak ada
      return false;

    } on AuthException catch (e) {
      print('Supabase Auth Error:  ${e.message}');
      return false;
    } catch (e) {
      print('Error during sign in: $e');
      return false;
    }
  }

  // Placeholder: Logika Sign Out
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
    await _prefs.setBool('isLoggedIn', false);
    Get.offAllNamed('/login');
  }
  
  // Contoh implementasi shared_preferences: menyimpan tema warna
  void saveThemePreference(bool isDarkMode) {
    _prefs.setBool('isDarkMode', isDarkMode);
  }
}