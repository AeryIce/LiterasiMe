import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home_page.dart';
import 'models/book_history_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/book_recommendation_model.dart';
import 'theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:literasime/pages/login_page.dart';
import 'pages/profile_page.dart';

// ✅ Tambahkan ini untuk integrasi Firebase yang benar
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BookHistoryAdapter());
  await Hive.openBox<BookHistory>('book_history');

  Hive.registerAdapter(BookRecommendationAdapter());
  await Hive.openBox<BookRecommendation>('book_recommendation');

  await dotenv.load(fileName: ".env");

  // ✅ Inisialisasi Firebase dengan konfigurasi multi-platform
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔒 Optional: paksa logout saat pertama dijalankan (untuk pengujian)
  // await FirebaseAuth.instance.signOut();

  runApp(const LiterasiMeApp());
}

class LiterasiMeApp extends StatelessWidget {
  const LiterasiMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiterasiMe',
      debugShowCheckedModeBanner: false,
      theme: literasiMeTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/profil': (context) => const ProfilePage(),
      },
    );
  }
}

// ✅ AuthGate tetap dipertahankan
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage(); // Sudah login
        }

        return const LoginPage(); // Belum login
      },
    );
  }
}
