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


  Future<String> getHorarios() async{
    return await _get('horarios');
  }
  void setHorarios(String horariosJson){
    print('Setting horarios $horariosJson');
    _set('horarios', horariosJson);
  }


  Future<String> getUsername() async{
    return await _get('username');
  }
  Future<String> getPassword() async{
    return await _get('password');
  }


  Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged');
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

  Future<String> getAtividades() async{
    return await _get('atividades');
  }
  void setAtividades(String atividadesJson) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('atividades', atividadesJson);
    return;
  }

  Future<bool> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    bool ret = await prefs.clear();
    return ret;
  }

  Future<bool> resetData() async {
    final prefs = await SharedPreferences.getInstance();
    var uname = await getUsername();
    var pwd = await this.getPassword();
    setUsername(uname);
    setPassword(pwd);
    bool ret = await prefs.clear();
    return ret;
  }


  void setMaterias(data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('materias', data);
    return;
  }
  Future<String> getMaterias() async {
    return await _get('materias');
  }

  void setUserData(userDataJson) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', userDataJson);
  }


  Future<String> getUserData() async{
    return await _get('userData');
  }
  void setAjustes(data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ajustes', data);
  }

  Future<String> getAjustes() async {
    return await _get('ajustes');
  }

  void setIra(data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ira', data);

  }

  Future<String> getIra() async {
    return await _get('ira');
  }

  setSaldo(data) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('saldo', data);
  }

  Future<String> getSaldo() async {
    return await _get('saldo');
  }




}