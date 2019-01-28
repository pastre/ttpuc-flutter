import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/horarios/Horarios.dart';
import 'package:horariopucpr/modules/config/Usuario.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';


class Screen extends StatefulWidget {
  _ScreenState state;
  UsuarioWidget userWidget;

  Screen({this.userWidget}) {
    this.state = new _ScreenState(userWidget: this.userWidget);
  }

  @override
  State<StatefulWidget> createState() {
    return this.state;
  }

  void updateState(value) {
    this.state.updateScreen(value);
  }

  HorariosWidget getHorarios(){
    return this.state.getHorarios();
  }
}

class _ScreenState extends State<Screen> {
  var possibleScreens, currentScreen;
  UsuarioWidget userWidget;

  _ScreenState({this.userWidget}) {
    possibleScreens = Map<int, Widget>();
    for (var i = 0; i < SCREENS.length; i++) {
      possibleScreens[i] = SCREENS[i].screenWidget;
    }
    this.currentScreen = possibleScreens[1];

//    this.widget.userWidget.forceLoad();
    print('Construtor ta la');

  }

  @override
  Widget build(BuildContext context) {
    return this.currentScreen;
  }

  void updateScreen(value) {


//    for (var i = 0; i < SCREENS.length; i++)
//      print('Local data from ${SCREENS[i].nome} is ${possibleScreens[i].loadLocal()}');

    print('ARRIBA');
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

  HorariosWidget getHorarios() {
    for (var i = 0; i < possibleScreens.length; i++) {
      if(possibleScreens[i] is HorariosWidget)
        return possibleScreens[i];
    }
  }

}