import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/AtividadeDialog.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class AgendaWidget extends GenericAppWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AgendaState();
  }

}

class AgendaState extends GenericAppState<AgendaWidget> {

  var atividades;
  List<String> weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
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
  @override
  void preinit() {
    atividades = null;
  }

  @override
  Widget buildScreen(BuildContext context) {
    print('Atividades is $atividades');
    return new Scaffold(
      body: atividades.isEmpty ? Text('Vazio!') : buildActivityList(),
      floatingActionButton: FloatingActionButton(
        onPressed: displayDialog,
        child: Icon(Icons.add),
        backgroundColor: PUC_COLOR,
        tooltip: 'Agende uma atividade',
      ),
    );
  }

  @override
  bool hasLoaded() {
    return atividades != null;
  }

  @override
  void updateLocal(data) {
    this.storage.setAtividades(data);
  }

  @override
  Future loadLocal() {
    print('Loaded local!');
    return this.storage.getAtividades();
  }

  @override
  Future apiCall() async {
    return this.api.getAtividades();
  }

  @override
  void updateState(data) {
    print('Setting state $data');
    setState(() {
      var ret = json.decode(data);
      this.atividades = ret['eventos'];
    });
  }


  Widget buildActivityList() {
    List<Widget>  options = [];
    for (var atividade in atividades) {
      String nome = atividade['nome'],
          desc = atividade['descricao'],
          materia = atividade['materia'];
      DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
          atividade['data']);
      options.add(buildActivity(
          weekdays[timestamp.weekday - 1].toUpperCase(),
          months[timestamp.month - 1].toUpperCase(),
          timestamp.day,
          nome + ' - ' + materia,
          desc,
          Colors.orange,
          false));
      options.add(Divider());
    }

    return ListView(children: options, );
    return Column(children: <Widget>
      buildActivity(
          'Ter',
          'AGO',
          21,
          'TDE - Estatistica',
          'Fazer pesquisa doida',
          Colors.green,
          false),
      Divider(),
      buildActivity(
          'TER',
          'AGO',
          21,
          'Pré-Relatório - Sistemas Digitais II',
          'Experimento 26',
          Colors.blueAccent,
          true),
      Divider(),
      buildActivity(
          'Ter',
          'AGO',
          21,
          'Prova - Banco de Dados',
          'Estudar tretas',
          Colors.pink,
          false),
    ],);
  }

  Widget buildActivity(String dayName, String month, int day, String title,
      String description, Color color, bool isSelected) {
    return ListTile(
      leading: buildActivityDate(dayName, month, day),
      title: buildActivityTitle(title, color),
      subtitle: Text(description),
//      trailing: Checkbox(value: isSelected, onChanged: (value){}),

    );
  }

  Widget buildActivityDate(String dayName, String month, int day,) {
    TextStyle style = TextStyle(color: Colors.grey);
    return Column(
      children: <Widget>[
        Text(dayName, style: style,),
        Text(month, style: style,),
        Text('$day', style: style,),
      ],
    );
  }

  Widget buildActivityTitle(String title, Color color) {
//    return Text(title, style: TextStyle(color: color),);
    return Row(
      children: <Widget>[
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis,)),
//        SizedBox(
//          height: 6.0,
//          width: 20.0,
//          child:Container(
//            decoration: new BoxDecoration(
//              color: color,
//              border: Border.all(color: color, ),
//              shape: BoxShape.circle,
////              borderRadius: BorderRadius.circular(8.0),
//            ),
//          ),
//        ),
      ],
    );
  }

  void displayDialog() {
    List<String> options = new List<String>();
//    for(var m in materias){
//      options.add(m['subject']);
//    }
    options.add('asdasd');
    options.add('asdasd');
    options.add('asdasd');
    options.add('asdasd');
    options.add('asdasd');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          AtividadeWidget(options: options, agenda: this,)),
    );
  }
}


