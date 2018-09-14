import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/design/BottonNavigation.dart';
import 'package:horariopucpr/modules/design/Screen.dart';
import 'package:horariopucpr/modules/storage/Storage.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/telas/SettingsWidget.dart';

class MainScreen extends StatelessWidget{
  Screen screen;
  VoidCallback updateLogin;

  MainScreen(VoidCallback updateLogin){
    this.screen = Screen();
    this.updateLogin = updateLogin;
    print('Loaded main screen');
    Api().assertData();
  }

  void showConfig(context){
    print('Showing confing');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsWidget(updateLogin)),
    );
  }


  void doLogout(BuildContext context){
    print('Do logout');
    Storage().clearData();
    Storage().setLogin(false);
    updateLogin();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: BottomNavBar(this.screen),
      body:this.screen,
      appBar: AppBar(
        title: new Text('Horários PUCPR'),
        backgroundColor: PUC_COLOR,
        leading: IconButton(icon: new Icon(Icons.share), onPressed: (){print("Pressed share");},),
        actions: <Widget>[IconButton(icon: new Icon(Icons.exit_to_app), onPressed: () => doLogout(context)
        )],
      ),
    );
  }

}