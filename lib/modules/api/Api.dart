import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';


class Api{
  String notas = '', username = 'bruno.pastre', password = 'asdqwe123!@#';
  bool couldLogin = false;
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();


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

    print("Fired request for login");
    Response r = await get('https://horariopucpr.herokuapp.com/impressao',
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

  Future<bool> setCredentials(String username, String password) async{
    this.username = username;
    this.password = password;
    return await _doCheckAuth();
   }

}