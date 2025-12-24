class AppConfig {
  // GANTI sesuai alamat backend kamu
  // Emulator Android
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Kalau pakai HP fisik (ganti IP laptop kamu)
  // static const String baseUrl = 'http://192.168.1.10:8000/api';

  // ===== AUTH =====
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String getUser = '/get-user';

  // ===== PRODUK (NANTI) =====
  static const String products = '/products';
}
