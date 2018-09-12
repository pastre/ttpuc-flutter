import 'dart:async';
import 'dart:convert';

import 'package:horariopucpr/modules/storage/Storage.dart';
import 'package:http/http.dart';


class Api{
  Storage s = new Storage();
  String notas = '', username = '', password = '';
//  String notas = '', username = 'bruno.pastre', password = 'asdqwe123!@#';
  bool couldLogin = false;
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  void assertData() async{
    s.getUsername().then((a){username = a;});
    s.getPassword().then((a){password = a;print('Refreshed credentials $username $password');});
  }

  _doGetNotas() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/notas',
        headers: {'authorization': basicAuth});
    this.notas =  r.body;
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

  void updateNotas() async{
    print("Updating notas");
    return await this._doGetNotas();
  }

  getNotas(){
    Map<String, dynamic> resp = json.decode(this.notas);
    if(resp['status'] == 'success')
      return resp['data'];
  }

  Future<String> nGetNotas() async{
    print('Fired request $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/notas',
        headers: {'authorization': basicAuth});

    Map<String, dynamic> resp = await json.decode(r.body);

    if(resp['status'] == 'success')
      return json.encode(resp['data']);

  }

  Future<String> getHorarios() async{
    print('Fired request $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
//    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/horario',
        headers: {'authorization': basicAuth});

    Map<String, dynamic> resp = await json.decode(r.body);
    print('Response is ${r.body}');
    if(resp['status'] == 'success')
      return json.encode(resp['data']);
  }

  Future<String> generateHorarios() async{
    username = 'tatyane.rodrigues';
    password = 'ta@@2020';
    print('Fired request to build horarios $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
//    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/horario/generate',
        headers: {'authorization': basicAuth});

    Map<String, dynamic> resp = await json.decode(r.body);
    print('Response is ${r.body}');
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