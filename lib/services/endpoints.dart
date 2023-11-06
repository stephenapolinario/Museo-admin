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

  Uri emblem({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/emblem/$endpoint');
  }

  Uri museumInformation({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/museumInformation/$endpoint');
  }

  Uri product({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/product/$endpoint');
  }

  Uri productCategory({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/product/category/$endpoint');
  }

  Uri quiz({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/quiz/$endpoint');
  }

  Uri ticket({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/ticket/$endpoint');
  }

  Uri tour({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/tour/$endpoint');
  }

  Uri user({required String endpoint}) {
    return Uri.parse('${dotenv.get('URL_API')}/user/$endpoint');
  }
}
