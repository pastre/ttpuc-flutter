import 'dart:async';
import 'dart:convert';

import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:http/http.dart';

class Api {
  Storage s = new Storage();
  String username = '', password = '';

//  String notas = '', username = 'bruno.pastre', password = 'asdqwe123!@#';
  bool couldLogin = false;
  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }

  Api._internal();

  assertData() async {
    username = await s.getUsername();
    password = await s.getPassword();
//      await s.getPassword().then((a){password = a;print('Refreshed credentials $username $password');});
    print('Asserted data $username, $password');
  }

  _doGet(String url) async {
    await assertData();
    print('Basic get with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
//    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/$url',
        headers: {'authorization': basicAuth});
    return r.body;
  }

  _doPost(String url, var body) async {
    await assertData();
    print('Basic post with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await post('https://horariopucpr.herokuapp.com/$url',
        headers: {'authorization': basicAuth}, body: body);

    return r.body;
  }

  Future<bool> _doCheckAuth() async {
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('${this.username}:${this.password}'));
    print('${this.username}:${this.password}');

    print("Fired request for login $username $password");
    Response r = await get('https://horariopucpr.herokuapp.com/dadosPessoais',
        headers: {'authorization': basicAuth});
    print(r.body);
    try {
      return json.decode(r.body)['status'] == 'success';
    } on FormatException {
      return false;
    }
  }

  Future<String> getNotas() async {
    String body = await _doGet('notas');
    Map<String, dynamic> resp = await json.decode(body);
    print('Resp is $resp');
    if (resp['status'] == 'success') {
      print('Returning data');
      return json.encode(resp['data']);
    }
  }

  Future<String> getHorarios() async {
    print('Called getHorarios()');
    String body = await _doGet('horario');
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  void setHorarios(String horariosJson) async {
    print('Firing request for $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await put('https://horariopucpr.herokuapp.com/horario',
        body: horariosJson, headers: {'authorization': basicAuth});
    print('Res is ${r.body}');

//    put('https://horariopucpr.herokuapp.com/horarios', body: horariosJson);
  }

  Future<String> generateHorarios() async {
    String body = await _doGet('horario/generate');
    Map<String, dynamic> resp = await json.decode(body);
    print('Fired request to build horarios $username, $password');
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  Future<bool> setCredentials(String username, String password) async {
    this.username = username;
    this.password = password;
    return await _doCheckAuth();
  }

  Future<String> getEventos() async {
    print('Fired request $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);
    print('loading eventos');
    Response r = await get('https://horariopucpr.herokuapp.com/agenda',
        headers: {'authorization': basicAuth});

    Map<String, dynamic> resp = await json.decode(r.body);
    if (resp['status'] == 'success') {
      print('return from api is ${resp['data']}');
      return json.encode(resp['data']);
    }
  }

  Future addAtividade(String nome, String descricao, int timestamp, String materia) async {
   String body =  await _doPost('agenda', {
      'nome': nome,
      'descricao': descricao,
      'data': timestamp.toString(),
      'materia': materia
    });
   Map<String, dynamic> resp = await json.decode(body);
   if (resp['status'] == 'success') return json.encode(resp['data']);

  }

  Future<String> getAtividades() async{
    String body = await _doGet('agenda');
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

}
