import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/design/BottonNavigation.dart';
import 'package:horariopucpr/modules/design/Screen.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';


class MainScreen extends StatelessWidget{
  Screen screen;
  MainScreen(){
    this.screen = Screen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: BottomNavBar(this.screen),
      body:this.screen,
      appBar: AppBar(
        title: new Text('Horários PUCPR'),
        backgroundColor: PUC_COLOR,
        leading: IconButton(icon: new Icon(Icons.share), onPressed: (){print("Pressed share");},),
        actions: <Widget>[IconButton(icon: new Icon(Icons.settings), onPressed: (){print("Pressed config");})],
      ),
    );
  }

}