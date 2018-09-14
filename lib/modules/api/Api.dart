import 'dart:async';
import 'dart:convert';

import 'package:horariopucpr/modules/storage/Storage.dart';
import 'package:http/http.dart';


class Api{
  Storage s = new Storage();
  String username = '', password = '';
//  String notas = '', username = 'bruno.pastre', password = 'asdqwe123!@#';
  bool couldLogin = false;
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  assertData() async{
    username = await s.getUsername();
    password = await s.getPassword();
//      await s.getPassword().then((a){password = a;print('Refreshed credentials $username $password');});
    print('Asserted data $username, $password');
  }

  _doGet(String url) async{
    await assertData();
    print('Basic get with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/$url',
        headers: {'authorization': basicAuth});
    return r.body;
  }

  Future<bool> _doCheckAuth() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('${this.username}:${this.password}'));
    print('${this.username}:${this.password}');

    print("Fired request for login $username $password");
    Response r = await get('https://horariopucpr.herokuapp.com/dadosPessoais',
        headers: {'authorization': basicAuth});
    print(r.body);
    return json.decode(r.body)['status'] == 'success';
  }

  Future<String> nGetNotas() async{
    String body = await _doGet('notas');
    Map<String, dynamic> resp = await json.decode(body);
    print('Resp is $resp');
    if(resp['status'] == 'success') {
      print('Returning data');
      return json.encode(resp['data']);
    }

  }

  Future<String> getHorarios() async{
    print('Called getHorarios()');
    String body = await _doGet('horario');
    Map<String, dynamic> resp = await json.decode(body);
    if(resp['status'] == 'success')
      return json.encode(resp['data']);
  }

  void setHorarios(String horariosJson){
    print('Firing request');
    put('0.0.0.0/horarios', body: horariosJson);
//    put('https://horariopucpr.herokuapp.com/horarios', body: horariosJson);
  }

  Future<String> generateHorarios() async{
    String body = await _doGet('horario/generate');
    Map<String, dynamic> resp = await json.decode(body);
    print('Fired request to build horarios $username, $password');
    if(resp['status'] == 'success')
      return json.encode(resp['data']);
  }

  Future<bool> setCredentials(String username, String password) async{
    this.username = username;
    this.password = password;
    return await _doCheckAuth();
   }

   Future<String> getEventos() async{
     print('Fired request $username, $password');
     String basicAuth =
         'Basic ' + base64Encode(utf8.encode('$username:$password'));
     print(basicAuth);
     print('loading eventos');
     Response r = await get('https://horariopucpr.herokuapp.com/agenda',
         headers: {'authorization': basicAuth});

     Map<String, dynamic> resp = await json.decode(r.body);
     if(resp['status'] == 'success') {
       print('return from api is ${resp['data']}');
       return json.encode(resp['data']);
     }
   }

}