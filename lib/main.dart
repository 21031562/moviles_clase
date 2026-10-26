import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/global_values.dart';
import 'package:flutter_application_1/components/theme_app.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/add_note_nube_screen_.dart';
import 'package:flutter_application_1/screens/add_note_screen.dart';
import 'package:flutter_application_1/screens/api_popular_screen.dart';
import 'package:flutter_application_1/screens/dashboard_screens.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/notes_screens.dart';
import 'package:flutter_application_1/screens/notes_screens_nube.dart';
import 'package:flutter_application_1/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.banTheme,
      builder: (context, value, _) {
        ThemeData tema = ThemeData.light();
        switch (value) {
          case 0:
            tema = ThemeData.dark();
            break;
          case 1:
            tema = ThemeData.light();
            break;
          case 2:
            tema = ThemeApp.warmTheme();
            break;
          default:
            tema = ThemeData.light();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            "/dash": (context) => DashboardScreens(),
            "/note": (context) => NotesScreens(),
            "/add": (context) => AddNoteScreen(),
            "/register": (context) => RegisterScreen(),
            "/notesNube": (context) => NotesScreensNube(),
            "/addNube": (context) => AddNoteNubeScreen(),
            "/movie": (context) => ApiPopularScreen(),
          },
          theme: tema,
          home: LoginScreen(),
        );
      },
    );
  }
}
