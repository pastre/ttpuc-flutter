import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';


class Api{
  String notas;
  Api(){
    this.notas = '';
  }

  _doGetNotas(String username, String password) async {
    String username = 'bruno.pastre';
    String password = 'asdqwe123!@#';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/notas',
        headers: {'authorization': basicAuth});
    this.notas =  r.body;
  }

  void updateNotas(username, password) async{
    await this._doGetNotas(username, password );
  }

  getNotas(){
    Map<String, dynamic> resp = json.decode(this.notas);
    if(resp['status'] == 'success')
      return resp['data'];
  }

}