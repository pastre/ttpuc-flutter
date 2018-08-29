import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/storage/Storage.dart';

class LoginWidget extends StatelessWidget{
  Api api;
  Storage storage;

  LoginWidget(){
    print('constructed loginwidget');
    this.api = api;
    this.storage = storage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MediaQuery(data: MediaQueryData(), child:  TextField(decoration: InputDecoration(hintText: 'Usuário'),)));
  }


}