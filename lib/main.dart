import 'package:device_preview/device_preview.dart'; // 1. Wajib import ini
import 'package:flutter/foundation.dart'; // 2. Untuk kReleaseMode
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_notes_screen.dart';

void main() {
  runApp(
    // 3. Bungkus aplikasi dengan DevicePreview
    DevicePreview(
      enabled: !kReleaseMode, // Aktif hanya saat debug
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 4. Tambahkan 3 baris wajib ini agar DevicePreview bekerja:
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      title: 'Modern Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.grey[200]!,
          surface: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add-note': (context) => AddNoteScreen(),
      },
    );
  }
}