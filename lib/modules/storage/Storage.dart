import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'Nota.dart';

List<Nota> getNotas(){
  var ret = new List<Nota>();

  ret.add(new Nota('1', '**/**', '**/**', '**/**', '**/**', '20'));
  ret.add(new Nota('2','**/**', '**/**', '**/**', '**/**', '19'));
  ret.add(new Nota('3','**/**', '**/**', '**/**', '**/**', '18'));
  ret.add(new Nota('4','**/**', '**/**', '**/**', '**/**', '17'));
  ret.add(new Nota('5','**/**', '**/**', '**/**', '**/**', '16'));

  return ret;
}

class Storage{
  static final Storage _singleton = new Storage._internal();
  var notas;
  factory Storage() {
    return _singleton;
  }
  Storage._internal();

  static void _set(key, value) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  static Future<String> _get(key) async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<String> getNotas() async {
    return await _get('notas');
  }
  void setNotas(String notasJson){
    _set('notas', notasJson);
  }

  Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged');
  }

  void setLogin(bool isLogged) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', isLogged);
  }
}