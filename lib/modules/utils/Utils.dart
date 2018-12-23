import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/agenda/Agenda.dart';
import 'package:horariopucpr/modules/horarios/Horarios.dart';
import 'package:horariopucpr/modules/notas/Notas.dart';

Color TATY_COLOR = Colors.pinkAccent;
Color SUBTEXT_COLOR =  Color(0xFF919199);
Color PUC_COLOR = Color(0xFFA00503);
List<ScreenOption> SCREENS = [
  ScreenOption(nome: 'Horarios', icon: Icon(Icons.subject), screenWidget: HorariosWidget()),
  ScreenOption(nome: 'Notas', icon: Icon(Icons.book), screenWidget: NotasWidget()),
  ScreenOption(nome: 'Agenda', icon: Icon(Icons.calendar_view_day), screenWidget: AgendaWidget()),
//  ScreenOption(nome: 'Eu', icon: Icon(Icons.person), screenWidget: Placeholder()),
];

final GlobalKey<ScaffoldState> LOGIN_SCAFFOLD_KEY = new GlobalKey<ScaffoldState>();
//Color PUC_COLOR = TATY_COLOR;




class ScreenOption{
  String nome;
  Icon icon;
  Widget screenWidget;
  ScreenOption({this.nome, this.icon, this.screenWidget,});
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

List<Widget> getNotasDev(){
  TextStyle style = TextStyle();
  return <Widget>[
    Text('\t├Versao atualizada', overflow: TextOverflow.clip,),
    Text('\t├Versao melhorada', overflow: TextOverflow.clip,),
    Text('\t├Coisas novas', overflow: TextOverflow.clip,),
    Text('\t└Novidades implementadas', overflow: TextOverflow.clip,),
  ];
}

List<Widget> getNextSteps(){
  TextStyle style = TextStyle();
  return <Widget>[
    Text('\t├Colocar uma foto no perfil', overflow: TextOverflow.clip,),
//    Text('\t├Criar um "grupo da sala" com as matérias no horário', overflow: TextOverflow.clip,),
    Text('\t├Conectar no Wi-Fi da PUC sozinho', overflow: TextOverflow.clip,),
    Text('\t├Buscar professores', overflow: TextOverflow.clip,),
    Text('\t├Botão de compartilhar o app', overflow: TextOverflow.clip,),
    Text('\t├Editar e arquivar Atividades', overflow: TextOverflow.clip,),
    Text('\t└Mostrar progresso no curso', overflow: TextOverflow.clip,),
    SizedBox(height: 4.0,),
    Text('Sugestões são sempre bem-vindas!', overflow: TextOverflow.clip,),
  ];
}

Map<int, String> weekdays = {1: 'Seg', 2: 'Ter', 3: 'Qua', 4: 'Qui', 5: 'Sex', 6: 'Sáb', 7: 'Dom'};
List<String> months = [
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez',
];
