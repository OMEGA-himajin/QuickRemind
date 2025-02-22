import 'package:flutter/material.dart';
import 'package:quickremind/controller/settings_controller.dart';
import 'package:quickremind/screens/welcome_screen.dart';
import 'package:quickremind/controller/timetable_controller.dart';
import 'package:quickremind/controller/weather_controller.dart';
import 'package:quickremind/controller/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quickremind/firebase_options.dart';
import 'package:quickremind/controller/subject_controller.dart';
import 'package:quickremind/controller/memo_controller.dart';
import 'package:quickremind/repository/timetable_repository.dart';
import 'package:quickremind/repository/settings_repository.dart';
import 'package:quickremind/repository/memo_repository.dart';
import 'package:quickremind/repository/subject_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final memoRepository = MemoRepository();
  final timetableRepository = TimetableRepository();
  final settingsRepository = SettingsRepository();
  final subjectRepository = SubjectRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(
          create: (_) => MemoController(repository: memoRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TimetableController(repository: timetableRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsController(repository: settingsRepository),
        ),
        ChangeNotifierProvider(create: (_) => WeatherController()),
        ChangeNotifierProvider(
          create: (_) => SubjectController(repository: subjectRepository),
        ),
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
