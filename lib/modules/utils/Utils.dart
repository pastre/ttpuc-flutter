import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Horarios.dart';
import 'package:horariopucpr/modules/core/Notas.dart';
import 'package:horariopucpr/modules/materiasPicker/Picker.dart';
import 'package:horariopucpr/modules/telas/PlaceholderWidget.dart';

Color TATY_COLOR = Colors.pinkAccent;
Color SUBTEXT_COLOR =  Color(0xFF919199);
Color PUC_COLOR = Color(0xFFA00503);
List<ScreenOption> SCREENS = [
  ScreenOption(nome: 'Horarios', icon: Icon(Icons.subject), screenWidget: HorariosWidget()),
  ScreenOption(nome: 'Notas', icon: Icon(Icons.book), screenWidget: NotasWidget()),
  ScreenOption(nome: 'Eu', icon: Icon(Icons.person), screenWidget: Placeholder()),
];

final GlobalKey<ScaffoldState> LOGIN_SCAFFOLD_KEY = new GlobalKey<ScaffoldState>();
//Color PUC_COLOR = TATY_COLOR;




class ScreenOption{
  String nome;
  Icon icon;
  Widget screenWidget;
  ScreenOption({this.nome, this.icon, this.screenWidget,});
}