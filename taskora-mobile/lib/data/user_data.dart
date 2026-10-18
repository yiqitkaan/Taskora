import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/app_user.dart';
import 'local_json_storage.dart';

class UserData {
  const UserData._();

  static Future<List<AppUser>> loadUsers() async {
    final saved = await LocalJsonStorage.read('users');
    final text = saved ?? await rootBundle.loadString('assets/data/users.json');
    final decoded = jsonDecode(text) as List<dynamic>;
    final users = decoded
        .map((item) => AppUser.fromJson(item as Map<String, dynamic>))
        .toList();
    if (saved == null) await saveUsers(users);
    return users;
  }

  static Future<void> saveUsers(List<AppUser> users) => LocalJsonStorage.write(
    'users',
    jsonEncode(users.map((user) => user.toJson()).toList()),
  );
}
