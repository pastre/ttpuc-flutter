
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class AgendaWidget extends GenericAppWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
      return new _AgendaState();
  }

}

class _AgendaState extends GenericAppState<AgendaWidget>{

  @override
  bool hasLoaded() {
    return true;
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    return new Scaffold(body: buildActivityList(),);
  }

  Widget buildActivityList(){
    return Column(children: <Widget>[
      buildActivity('Ter', 'AGO', 21, 'TDE - Estatistica', 'Fazer pesquisa doida', Colors.green, false),
      Divider(),
      buildActivity('TER', 'AGO', 21, 'Pré-Relatório - Sistemas Digitais II', 'Experimento 26', Colors.blueAccent, true),
      Divider(),
      buildActivity('Ter', 'AGO', 21, 'Prova - Banco de Dados', 'Estudar tretas', Colors.pink, false),
    ],);
  }



  Widget buildActivity(String dayName, String month, int day, String title, String description, Color color, bool isSelected){
    return ListTile(
      leading: buildActivityDate(dayName, month, day),
      title: buildActivityTitle(title, color),
      subtitle: Text(description),
      trailing: Checkbox(value: isSelected, onChanged: (value){}),

    );
  }

  Widget buildActivityDate(String dayName, String month, int day,){
    TextStyle style = TextStyle(color: Colors.grey);
    return Column(
      children: <Widget>[
        Text(dayName, style: style,),
        Text(month, style: style,),
        Text('$day', style: style,),
      ],
    );
  }

  Widget buildActivityTitle(String title, Color color){
//    return Text(title, style: TextStyle(color: color),);

    return Row (
      children: <Widget>[
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis,)),
        SizedBox(
          height: 6.0,
          width: 20.0,
          child:Container(
            decoration: new BoxDecoration(
              color: color,
              border: Border.all(color: color, ),
              shape: BoxShape.circle,
//              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }


}


