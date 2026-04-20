import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appname = "Nomed";


      static String get apiBaseUrl =>
    "http://${dotenv.env['API_HOST']}:3000/api/";

static String get apiSocketUrl =>
    "http://${dotenv.env['API_HOST']}:3000";

  static String get apiMapKey => dotenv.env['G_MAP_API']!;

  static const bool isDemoMode = true;
}
