import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/storage/Storage.dart';

class LoginWidget extends StatelessWidget{
  VoidCallback callback;
  Api api;
  Storage storage;
  TextEditingController userCtrl, pwdCtrl;
  LoginWidget(VoidCallback callback){
    this.api = Api();
    this.storage = Storage();
    this.callback = callback;
    this.userCtrl = new TextEditingController();
    this.pwdCtrl = new TextEditingController();

  }

  void loginAction(isLogged)async{
    print('LoginAction $isLogged');
    if(isLogged){
      print('Logged!');
      this.storage.setLogin(isLogged);
      callback();
    }
    else print('login error');
  }

  VoidCallback login()  {
    print('text is ${this.userCtrl.text}, ${this.pwdCtrl.text}');
    this.userCtrl.text = 'bruno.pastre';
    this.pwdCtrl.text = 'asdqwe123!@#';
    this.api.setCredentials(this.userCtrl.text, this.pwdCtrl.text).then((b) => this.loginAction(b));

  }
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 128.0,
        child: Image.asset('assets/puc_logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: this.userCtrl,

      decoration: InputDecoration(
        filled: true, fillColor: Colors.white,
        hintText: 'Usuário',

        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: this.pwdCtrl,
//      initialValue: 'asdqwe123!@#',
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white,
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(color: PUC_COLOR,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () => this.login(),
          color: Colors.white,
          child: Text('Login', style: TextStyle(color: PUC_COLOR)),
        ),
      ),
    );



    return Scaffold(
      backgroundColor: PUC_COLOR,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }


}