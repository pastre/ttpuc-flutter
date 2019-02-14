import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/agenda/Agenda.dart';
import 'package:horariopucpr/modules/horarios/Horarios.dart';
import 'package:horariopucpr/modules/notas/Notas.dart';

Color TATY_COLOR = Colors.pinkAccent;
Color SUBTEXT_COLOR =  Color(0xFF919199);
Color PUC_COLOR = Color(0xFFA00503);
List<ScreenOption> SCREENS = [
  ScreenOption(nome: 'Horários', icon: Icon(Icons.subject), screenWidget: HorariosWidget()),
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
    Text('Bem vindo ao aplicativo não oficial da PUCPR.', overflow: TextOverflow.clip,),
    Text('Esse aplicativo tem como missão unificar o ecossistema da universidade, trazendo ao aluno a melhor forma de acompanhamento acadêmico', overflow: TextOverflow.clip,),
    Text('A filosofia é simples: nada é tão bom que não possa ser melhorado. Se acha que podemos melhorar em qualquer quesito, não hesite em enviar um email para pastre68@gmail.com'),
    Text('Agora, estamos testando as mensagens no grupo! Para conferir, basta clicar em qualquer horário na tela de Horários!', overflow: TextOverflow.clip,),
//    Text('\t└Novidades implementadas', overflow: TextOverflow.clip,),
  ];
}

List<Widget> getNextSteps(){
  TextStyle style = TextStyle();
  return <Widget>[
    Text('- Colocar uma foto no perfil', overflow: TextOverflow.clip,),
    Text('- Melhorar essa caixa de texto', overflow: TextOverflow.clip,),
//    Text('\t├Criar um "grupo da sala" com as matérias no horário', overflow: TextOverflow.clip,),
    Text('- Conectar no Wi-Fi da PUC sozinho', overflow: TextOverflow.clip,),
    Text('- Buscar professores', overflow: TextOverflow.clip,),
    Text('- Botão de compartilhar o app', overflow: TextOverflow.clip,),
    Text('- Arquivar Atividades', overflow: TextOverflow.clip,),
    Text('- Mostrar progresso no curso', overflow: TextOverflow.clip,),
    SizedBox(height: 4.0,),
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


class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
        ),
      ),
    );
  }
}