import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Main.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/login/Login.dart';


final String name = 'HorarioPUCPR';
final FirebaseOptions options = const FirebaseOptions(
  googleAppID: '1:904404985413:android:6cf067addcbe68c4',
  projectID: 'horariopucpr',
  databaseURL: 'https://horariopucpr.firebaseio.com',
  apiKey: 'AIzaSyDadYY1--TzqFbIxF-wMfNyNBv7oqsHC8o',
);

FirebaseApp app;
//var tmp  =


void main() {
  FirebaseApp.configure(name: name, options: options).then((a){
    print('CONFIGURED FIREBASE!!!!!');
    app = a;
  });
  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {


  @override
  Widget build(BuildContext c) {
    return new App();
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

typedef void MyCallback(BuildContext val);

class AppState extends State<App> {
  Api api;
  Storage storage;
  bool isLogged = false;

  AppState() {
    this.isLogged = false;
  }

  @override
  void initState() {
    super.initState();
    this.isLogged = false;
    this.api = Api();
    this.storage = Storage();
    this.storage.isLogged().then((isLogged) => changeLogin(isLogged));
  }

  VoidCallback updateLogin() {
    print("Called update login");
    this.storage.isLogged().then((isLogged) => changeLogin(isLogged));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLogged == null) this.isLogged = false;
//    return MaterialApp(home: this.isLogged ? MainScreen(updateLogin) : MainScreen(updateLogin),
    return MaterialApp(
      home: this.isLogged ? MainScreen(updateLogin) : LoginWidget(updateLogin),
      title: 'Horários PUCPR',
      color: PUC_COLOR,

    );
  }

  void changeLogin(bool isLogged) {
    print('Change login');
    this.setState(() => this.isLogged = isLogged);
  }
}
