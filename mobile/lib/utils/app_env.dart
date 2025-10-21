import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  // static String get imageUrl => dotenv.env['IMAGE_URL'] ?? '';
}
