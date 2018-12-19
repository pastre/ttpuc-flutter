import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/smaller_screens/AtividadeDialog.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/smaller_screens/LoadingScreen.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class AgendaWidget extends GenericAppWidget {


  AgendaWidget(): super(state: AgendaState(), name: "Agenda");
  @override
  State<StatefulWidget> createState() {
    return new AgendaState();
  }
}

class AgendaState extends GenericAppState<AgendaWidget> {
  var atividades;
  bool loadingDelete = false;
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

  @override
  void preinit() {
    atividades = null;
  }

  @override
  Widget buildScreen(BuildContext context) {
    print('Atividades is $atividades');
    var tmp = json.encode(atividades);
    print('Tmp is $tmp');
    return new Scaffold(
      body: atividades.isEmpty ? buildEmpty() : buildActivityList(),
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
    print('Setting state to  $data');
    setState(() {
      var ret = json.decode(data);
      this.atividades = ret['eventos'];
    });
  }

  Widget buildActivityList() {
    List<Widget> options = [];
    for (var atividade in atividades) {
      String nome = atividade['nome'],
          desc = atividade['descricao'],
          materia = atividade['materia'];
      DateTime timestamp =
          DateTime.fromMillisecondsSinceEpoch(atividade['data']);
      options.add(buildActivity(
          weekdays[timestamp.weekday ].toUpperCase(),
          months[timestamp.month - 1].toUpperCase(),
          timestamp.day,
          nome + ' - ' + materia,
          desc,
          Colors.orange,
          false,
          atividade['id'],
      ));
      options.add(Divider());
    }

    return ListView(
      children: options,
    );
  }

  Widget buildActivity(String dayName, String month, int day, String title,
      String description, Color color, bool isSelected, agendaId) {
    return buildSlideable(ListTile(
      leading: buildActivityDate(dayName, month, day),
      title: buildActivityTitle(title, color),
      subtitle: Text(description),
//      trailing: Container(child: Row(children: <Widget>[Icon(Icons.edit), Icon(Icons.delete)],), height: 30.0, width: 80.0, padding: EdgeInsets.only(right: 1.0),),
    ), agendaId);
  }

  Widget buildActivityDate(String dayName, String month, int day,) {
    TextStyle style = TextStyle(color: Colors.grey);
    return Column(
      children: <Widget>[
        Text(
          dayName,
          style: style,
        ),
        Text(
          month,
          style: style,
        ),
        Text(
          '$day',
          style: style,
        ),
      ],
    );
  }
  Widget buildActivityTitle(String title, Color color) {
    return Row(
      children: <Widget>[
        Flexible(
            child: Text(
              title,
            )),
      ],
    );
  }
  Widget buildSlideable(Widget listTile,agendaId){
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: listTile,
      actions: <Widget>[
//        new IconSlideAction(
//          caption: 'Editar',
//          color: Colors.blue,
//          icon: Icons.edit,
//          onTap: () => _showSnackBar('Editar',  month, day, title, description),
//        ),
//        new IconSlideAction(
//          caption: 'Share',
//          color: Colors.indigo,
//          icon: Icons.share,
//          onTap: () => _showSnackBar('Share'),
//        ),
      ],
      secondaryActions: <Widget>[
//        new IconSlideAction(
//          caption: 'More',
//          color: Colors.black45,
//          icon: Icons.more_horiz,
//          onTap: () => _showSnackBar('More'),
//        ),
        new IconSlideAction(
          caption: 'Deletar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deleteEvent('Deletar' , agendaId),
        ),
      ],
    );
  }

  Widget buildEmpty() {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Icon(
            Icons.info,
            color: Colors.grey.withAlpha(150),
            size: 64.0,
          ),
          Text(
            'Ops!',
            style: TextStyle(fontSize: 32.0, color: Colors.grey.withAlpha(150)),
          ),
          Text('Parece que você não agendou nenhuma atividade ',
              style:
                  TextStyle(fontSize: 16.0, color: Colors.grey.withAlpha(150))),
//           Container(
//              child: Center(
//                child: Text(
//                  'Não tem problema!\nUse o botão a baixo para adicionar novas atividades, como provas ou trabalhos',
//                ),
//              ),
//             margin: EdgeInsets.only(right: 8.0, left: 8.0),
//
//            ),
        ],
      ),
    ));
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
      MaterialPageRoute(
          builder: (context) => AtividadeWidget(
                options: options,
                agenda: this,
              )),
    );
  }

  void deleteEvent(String action, eventId) {

    this.api.deleteAtividade(eventId).then((val){
      this.storage.setAtividades(val);
      this.fetchData();
    });
  }
}
