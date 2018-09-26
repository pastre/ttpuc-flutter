import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';


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
    possibleScreens = Map<int, Widget>();
    for(var i = 0;i < SCREENS.length; i++){
      possibleScreens[i] = SCREENS[i].screenWidget;
    }
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