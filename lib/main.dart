import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:museo_admin_application/constants/routes.dart';
import 'package:museo_admin_application/screens/coupon/coupon_access_level_list_screen.dart';
import 'package:museo_admin_application/screens/coupon/coupon_home_screen.dart';
import 'package:museo_admin_application/screens/admin/admin_list_screen.dart';
import 'package:museo_admin_application/screens/beacon/beacon_list_screen.dart';
import 'package:museo_admin_application/screens/coupon/coupon_list_screen.dart';
import 'package:museo_admin_application/screens/coupon/coupon_type_list_screen.dart';
import 'package:museo_admin_application/screens/emblem/emblem_list_screen.dart';
import 'package:museo_admin_application/screens/home_screen.dart';
import 'package:museo_admin_application/screens/login_screen.dart';
import 'package:museo_admin_application/providers/admin.dart';
import 'package:museo_admin_application/screens/museumPiece/museum_piece_list_screen.dart';
import 'package:museo_admin_application/screens/ticket/ticket_list_screen.dart';
import 'package:museo_admin_application/screens/tour/tour_list_screen.dart';
import 'package:museo_admin_application/screens/user/user_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
        admin: (context) => const AdminListScreen(),
        beacon: (context) => const BeaconListScreen(),
        couponHome: (context) => const CouponHomeScreen(),
        couponAccess: (context) => const CouponAccessLevelListScreen(),
        couponType: (context) => const CouponTypeListScreen(),
        couponList: (context) => const CouponListScreen(),
        emblem: (context) => const EmblemListScreen(),
        tour: (context) => const TourListScreen(),
        museumPiece: (context) => const MuseumPieceListScreen(),
        user: (context) => const UserListScreen(),
        ticket: (context) => const TicketListScreen(),
      },
    );
  }
}
