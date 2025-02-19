import 'package:flutter/material.dart';
import 'package:quickremind/controller/settings_controller.dart';
import 'package:quickremind/screens/welcome_screen.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/controller/weather_controller.dart';
import 'package:quickremind/controller/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsController()),
        ChangeNotifierProvider(create: (context) => TimetableController()),
        ChangeNotifierProvider(create: (context) => WeatherController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickRemind',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomeScreen(),
    );
  }
}
