import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';


class Api{
  String notas = '';

  static final Api _singleton = new Api._internal();

  factory Api() {
    return _singleton;
  }
  Api._internal();


  _doGetNotas(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await get('https://horariopucpr.herokuapp.com/notas',
        headers: {'authorization': basicAuth});
    this.notas =  r.body;
  }

  void updateNotas(String username, String password) async{
    print("Updating notas");
    await this._doGetNotas(username, password );
  }

  getNotas(){
    Map<String, dynamic> resp = json.decode(this.notas);
    if(resp['status'] == 'success')
      return resp['data'];
  }

}