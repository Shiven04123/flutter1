import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'cart_provider.dart';
import 'login_page.dart'; // ✅ Importing login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: CanteenApp(),
    ),
  );
}

class CanteenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // ✅ Set login page as first screen
      routes: {
        '/home': (context) => HomePage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}
