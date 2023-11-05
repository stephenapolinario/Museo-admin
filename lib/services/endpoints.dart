import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  Uri admin({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/admin/$endpoint');
  }

  Uri beacon({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/beacon/$endpoint');
  }

  Uri coupon({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/coupon/$endpoint');
  }

  Uri couponAccess({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/coupon/access/$endpoint');
  }

  Uri couponType({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/coupon/type/$endpoint');
  }
}
