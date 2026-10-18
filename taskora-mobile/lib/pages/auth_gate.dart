import 'dart:async';

import 'package:flutter/material.dart';

import '../data/user_data.dart';
import '../models/app_user.dart';
import '../models/task.dart';
import 'auth_page.dart';
import 'task_list_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({
    this.initialTasks,
    this.initialUsers,
    this.initialUser,
    super.key,
  });

  final List<Task>? initialTasks;
  final List<AppUser>? initialUsers;
  final AppUser? initialUser;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  List<AppUser> _users = const [];
  AppUser? _currentUser;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser;
    if (widget.initialUsers case final users?) {
      _users = List.of(users);
      _loading = false;
    } else if (widget.initialUser case final user?) {
      _users = [user];
      _loading = false;
    } else {
      _loadUsers();
    }
  }

  Future<void> _loadUsers() async {
    try {
      final users = await UserData.loadUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Kullanıcı verileri yüklenemedi.';
      });
    }
  }

  void _register(AppUser user) {
    final updatedUsers = [..._users, user];
    setState(() {
      _users = updatedUsers;
      _currentUser = user;
    });
    unawaited(_saveUsers(updatedUsers));
  }

  Future<void> _saveUsers(List<AppUser> users) async {
    try {
      await UserData.saveUsers(users);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı kaydı saklanamadı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser case final user?) {
      return TaskListPage(
        initialTasks: widget.initialTasks,
        currentUser: user,
        onLogout: () => setState(() => _currentUser = null),
      );
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _loadUsers,
                  child: const Text('Yenile'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return AuthPage(
      users: _users,
      onAuthenticated: (user) => setState(() => _currentUser = user),
      onRegistered: _register,
    );
  }
}
