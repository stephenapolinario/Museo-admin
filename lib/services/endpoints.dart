import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  Uri admin({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/admin/$endpoint');
  }
}
