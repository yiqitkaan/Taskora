import 'package:flutter/services.dart';

class LocalJsonStorage {
  const LocalJsonStorage._();

  static const _channel = MethodChannel('com.yigitkaan.taskora/storage');
  static final Map<String, String> _memoryFallback = {};

  static Future<String?> read(String key) async {
    try {
      return await _channel.invokeMethod<String>('read', {'key': key});
    } on MissingPluginException {
      return _memoryFallback[key];
    }
  }

  static Future<void> write(String key, String json) async {
    try {
      await _channel.invokeMethod<void>('write', {'key': key, 'value': json});
    } on MissingPluginException {
      _memoryFallback[key] = json;
    }
  }
}
