import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/auth_state.dart';
import 'screens/home_page.dart'; // Ajuste conforme seu arquivo inicial
import 'theme.dart'; // Seu arquivo de tema

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
      ],
      child: const TreeScanApp(),
    ),
  );
}

class TreeScanApp extends StatelessWidget {
  const TreeScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Scan',
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // Usando seu tema
      home: const HomePage(),
    );
  }
}