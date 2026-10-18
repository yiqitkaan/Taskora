import 'package:flutter/material.dart';

import 'models/app_user.dart';
import 'models/task.dart';
import 'pages/auth_gate.dart';
import 'pages/task_detail_page.dart';

void main() => runApp(const TaskoraApp());

class TaskoraApp extends StatelessWidget {
  const TaskoraApp({
    super.key,
    this.initialTasks,
    this.initialUsers,
    this.initialUser,
  });

  final List<Task>? initialTasks;
  final List<AppUser>? initialUsers;
  final AppUser? initialUser;

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF2468A0);
    return MaterialApp(
      title: 'Taskora Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: brand),
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF183047),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            side: BorderSide(color: Color(0xFFE2E9EE)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: Color(0xFFDCE5EB)),
          ),
        ),
      ),
      home: AuthGate(
        initialTasks: initialTasks,
        initialUsers: initialUsers,
        initialUser: initialUser,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == TaskDetailPage.routeName &&
            settings.arguments is Task) {
          return MaterialPageRoute<Task>(
            settings: settings,
            builder: (_) => const TaskDetailPage(),
          );
        }
        return null;
      },
    );
  }
}
