import 'dart:async';
import 'dart:convert';

import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:http/http.dart';

//String domain = 'http://192.168.25.14:5000/';
String domain = 'https://horariopucpr.herokuapp.com/';

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
    print('Basic get with $username, $password @ $url');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Response r = await get('$domain$url',
        headers: {'authorization': basicAuth}, ).timeout(Duration(minutes: 5));
    return r.body;
  }

  _doPost(String url, var body) async {
    await assertData();
    print('Basic post with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Response r = await post('$domain$url',
        headers: {'authorization': basicAuth}, body: body);

    return r.body;
  }

  _doPut(String url, var body) async {
    await assertData();
    print('Basic put with $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Response r = await put('$domain$url',
        headers: {'authorization': basicAuth}, body: body);

    return r.body;
  }

  _doDelete(String url) async{
    await assertData();
    print('Basic put with $username, $password');
    url = Uri.encodeFull(url);
    print('URL IS $url');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

//    Response r = await delete('https://horariopucpr.herokuapp.com/$url',
//        headers: {'authorization': basicAuth}, );
    Response r = await delete('$domain$url',
        headers: {'authorization': basicAuth}, );

    return r.body;
  }

  Future<bool> _doCheckAuth() async {
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('${this.username}:${this.password}'));
    print('${this.username}:${this.password}');

    print("Fired request for login $username $password");
    Response r = await get(domain + 'dadosPessoais',
        headers: {'authorization': basicAuth});
    print('Return from login is $r.body');
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
      return json.encode(resp['data']);
    }
  }

  Future<String> getHorarios() async {
    print('Called getHorarios()');
    String body;
    Map<String, dynamic> resp;
    return '';
    do{
      body = await _doGet('horario');
      resp = await json.decode(body);
      print('got $resp from API HORARIOS');
    }while(resp['status'] != 'success');
    return json.encode(resp['data']);
  }

  void setHorarios(String horariosJson) async {
    print('Firing request for $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await put('https://horariopucpr.herokuapp.com/horario',
        body: horariosJson, headers: {'authorization': basicAuth});
    print('Res is ${r.body}');
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
    return await true;
    return await _doCheckAuth();
  }

  Future<String> getEventos() async {
    print('Fired request $username, $password');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);
    print('loading eventos');
    Response r = await get(domain + 'agenda',
        headers: {'authorization': basicAuth});

    Map<String, dynamic> resp = await json.decode(r.body);
    if (resp['status'] == 'success') {
      print('return from api is ${resp['data']}');
      return json.encode(resp['data']);
    }
  }

  Future addAtividade(String nome, String descricao, int timestamp, String materia) async {
   String body =  await _doPut('agenda', {
      'nome': nome,
      'descricao': descricao,
      'data': timestamp.toString(),
      'materia': materia
    });
   Map<String, dynamic> resp = await json.decode(body);
   if (resp['status'] == 'success') return json.encode(resp['data']);

  }

  Future<String> updateAtividade(String nome, String materia, String descricao, int timestamp, agendaId) async{
    String url = 'agenda/$agendaId';
    String body =  await _doPost(url, {
      'nome': nome,
      'descricao': descricao,
      'data': timestamp.toString(),
      'materia': materia
    });
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  Future<String> deleteAtividade(agendaId) async{
    String url = 'agenda/$agendaId';
    print('Url is $url');
    String body =  await _doDelete(url);
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  Future<String> getAtividades() async{
    String body = await _doGet('agenda');
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  Future<String> getMaterias() async{
    String body = await _doGet('agenda/materias');
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  Future<String> getUserData() async {
    String body = await _doGet('userData');
    Map<String, dynamic> resp = await json.decode(body);
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }

  Future<String> getAjustes() async {
    String body = await _doGet('ajustes');
    Map<String, dynamic> resp = await json.decode(body);
//    print(' RESP IS, $resp');
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }


  Future<String> generateAjustes() async {
    String body = await _doGet('ajustes/generate');
    print('BODY IS $body');
    Map<String, dynamic> resp = await json.decode(body);
    print('Fired request to build ajustes $username, $password');
    if (resp['status'] == 'success') return json.encode(resp['data']);
  }


}
