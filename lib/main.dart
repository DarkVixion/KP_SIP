import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/service/firebase_options.dart';
import 'package:fluttersip/main_page.dart';
import 'package:fluttersip/service/global_service.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final globalState = GlobalState();
  await globalState.initialize();  // Initialize UserService
  runApp(
    ChangeNotifierProvider(
    create: (context) => globalState,
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}