import 'package:flutter/material.dart';
import 'package:password_generator/screens/home_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Generator',
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFF131419),
      ),
      home: HomeScreen(),
    );
  }
}
