import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import './Evento.dart';

class Storage{

  Future<String> getEventos() async{
    List<Evento> eventos = [
      Evento(descricao: 'Fazer lista de exericios', dia: 31, mes: 08, materia: 'Estatística', nome: 'TDE 1'),
      Evento(descricao: 'Fazer experimento 23', dia: 05, mes: 09, materia: 'Sistemas Digitais 2', nome: 'Atividade'),
      Evento(descricao: 'Fazer lista de exericios', dia: 31, mes: 08, materia: 'Estatística', nome: 'TDE 1'),
      Evento(descricao: 'Fazer lista de exericios', dia: 31, mes: 08, materia: 'Estatística', nome: 'TDE 1'),
      Evento(descricao: 'Fazer lista de exericios', dia: 31, mes: 08, materia: 'Estatística', nome: 'TDE 1'),
      Evento(descricao: 'Fazer lista de exericios', dia: 31, mes: 08, materia: 'Estatística', nome: 'TDE 1'),
      Evento(descricao: 'Fazer lista de exericios', dia: 31, mes: 08, materia: 'Estatística', nome: 'TDE 1'),
    ];
    return json.encode(eventos);
  }

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

  void setHorarios(String horariosJson){
    _set('horarios', horariosJson);
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