import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage _singleton = new Storage._internal();
  var notas;

  factory Storage() {
    return _singleton;
  }

  Storage._internal();

  static void _set(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> _get(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void setRouterIp(String data) {
    _set('router-ip', data);
    print('Configured IP');
  }

  Future<String> getRouterIp() async {
    return await _get('router-ip');
  }



}