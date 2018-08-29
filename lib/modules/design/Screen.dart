import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/telas/HorariosWidget.dart';
import 'package:horariopucpr/modules/telas/NotasWidget.dart';
import 'package:horariopucpr/modules/telas/CalendarioWidget.dart';
import 'package:horariopucpr/modules/telas/PlaceholderWidget.dart';
class Screen extends StatefulWidget{
  _ScreenState state;
  Screen(){
    this.state  = new _ScreenState();
  }

  @override
  State<StatefulWidget> createState() {
    return this.state;
  }

  void updateState(value){
    this.state.updateScreen(value);
  }

}

class _ScreenState extends State<Screen>{
  var possibleScreens, currentScreen;
  _ScreenState(){
    possibleScreens = {0: HorariosWidget(), 1: NotasWidget(), 2: PlaceholderWidget(),3: CalendarioWidget(),};
    this.currentScreen = possibleScreens[1];
  }

  @override
  Widget build(BuildContext context) {
    return this.currentScreen;
  }

  void updateScreen(value){
    this.setState((){this.currentScreen = possibleScreens[value];});
  }

}