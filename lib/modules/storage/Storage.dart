import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import './Evento.dart';

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

  void setLogin(bool isLogged) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', isLogged);
    return;
  }

  void clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}