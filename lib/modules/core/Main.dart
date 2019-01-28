import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/config/Usuario.dart';
import 'package:horariopucpr/modules/core/BottonNavigation.dart';
import 'package:horariopucpr/modules/core/Screen.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class MainScreen extends StatelessWidget {
  Screen screen;
  VoidCallback updateLogin;
  UsuarioWidget userWidget;

  MainScreen(VoidCallback updateLogin) {
    this.screen = Screen();
    this.updateLogin = updateLogin;
    this.userWidget = UsuarioWidget(updateLogin, this.screen.getHorarios());
    print('Loaded main screen');
    Api().assertData();
  }

  void showConfig(context) {
    print('Showing confing');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => this.userWidget),
    );
  }

  void doLogout(BuildContext context) {
    print('Do logout');
    Storage().clearData();
    Storage().setLogin(false);
    updateLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(this.screen),
      body: this.screen,
      appBar: AppBar(
        title: new Text('Horários PUCPR'),
        backgroundColor: PUC_COLOR,
//        leading: IconButton(icon: new Icon(Icons.share), onPressed: (){print("Pressed share");},),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.person), onPressed: () => showConfig(context)
//        actions: <Widget>[IconButton(icon: new Icon(Icons.exit_to_app), onPressed: () => doLogout(context)
              )
        ],
      ),
    );
  }
}
