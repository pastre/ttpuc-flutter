import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Horarios.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';


class Screen extends StatefulWidget {
  _ScreenState state;

  Screen() {
    this.state = new _ScreenState();
  }

  @override
  State<StatefulWidget> createState() {
    return this.state;
  }

  void updateState(value) {
    this.state.updateScreen(value);
  }

}

class _ScreenState extends State<Screen> {
  var possibleScreens, currentScreen;

  _ScreenState() {
    possibleScreens = Map<int, Widget>();
    for (var i = 0; i < SCREENS.length; i++) {
      possibleScreens[i] = SCREENS[i].screenWidget;
    }
    this.currentScreen = possibleScreens[1];
  }

  @override
  Widget build(BuildContext context) {
    return this.currentScreen;
  }

  void updateScreen(value) {
    this.setState(() {
      bool updateHorario = false;
      if (possibleScreens[value] is HorariosWidget && this.currentScreen is HorariosWidget)
        updateHorario = true;
      else
        updateHorario = false;

      this.currentScreen = possibleScreens[value];

      if(this.currentScreen is HorariosWidget && updateHorario)
        (this.currentScreen as HorariosWidget).setToday();
      print('New screen is $currentScreen, updateHorar: $updateHorario');
    });
  }

}