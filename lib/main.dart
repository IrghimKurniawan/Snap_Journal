import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_journal/auth/login.dart';
import 'package:snap_journal/services/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage();
  runApp(
    ChangeNotifierProvider(
      create: (_) => languageProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snap Journal',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
