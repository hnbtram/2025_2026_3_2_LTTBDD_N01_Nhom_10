import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/add_task_screen.dart';
import 'services/task_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String languageCode = 'vi';
  try {
    final prefs = await SharedPreferences.getInstance();
    languageCode = prefs.getString('language') ?? 'vi';
  } catch (e) {
    print('Không thể đọc SharedPreferences: $e');
    languageCode = 'vi';
  }

  runApp(MyApp(languageCode: languageCode));
}

class MyApp extends StatefulWidget {
  final String languageCode;

  const MyApp({super.key, this.languageCode = 'vi'});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.languageCode);
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _saveLanguage(locale.languageCode);
  }

  void _saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);
    } catch (e) {
      print('Không thể lưu ngôn ngữ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();
    if (taskService.allTasks.isEmpty) {
      taskService.addSampleData();
    }

    return MaterialApp(
      title: 'Todo Tree',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/add_task': (context) => const AddTaskScreen(),
      },
    );
  }
}
