import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../firebase_options.dart';
import '../controller/settings_controller.dart';
import '../controller/timetable_controller.dart';
import '../controller/weather_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/subject_controller.dart';
import '../controller/memo_controller.dart';
import '../repository/timetable_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/memo_repository.dart';
import '../repository/subject_repository.dart';
import '../screens/welcome_screen.dart';

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
