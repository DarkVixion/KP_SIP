import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttersip/FrontEndOnly/Service/global_service_fe.dart';
import 'package:fluttersip/FrontEndOnly/main_page_fe.dart';
import 'package:fluttersip/views/service/firebase_options.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final globalState = GlobalStateFE();
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
      home: MainPageFE(),
    );
  }
}