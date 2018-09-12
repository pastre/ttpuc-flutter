import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<String> getHorarios() async{
    return await _get('horarios');
  }
  void setHorarios(String horariosJson){
    _set('horarios', horariosJson);
  }


  void setEventos(String horariosJson){
    _set('eventos', horariosJson);
  }

  Future<String> getEventos() async{
    print('eventos loaded');
    return await _get('eventos');
  }

  Future<String> getUsername() async{
    return null; // TODO
  }
  Future<String> getPassword() async{
    return null; // TODO
  }


  void setLogin(bool isLogged) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', isLogged);
    return;
  }

  void setUsername(String username) async{
    print('Set username $username');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    return;
  }

  void setPassword(String password) async{
    print('Set password $password');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
    return;
  }

  void clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}