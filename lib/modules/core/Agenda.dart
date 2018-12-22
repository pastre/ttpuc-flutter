import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/smaller_screens/AdicionaAtividade.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/smaller_screens/AtualizaAtividade.dart';
import 'package:horariopucpr/modules/smaller_screens/LoadingScreen.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AgendaWidget extends GenericAppWidget {
  AgendaWidget() : super(state: AgendaState(), name: "Agenda");

  @override
  State<StatefulWidget> createState() {
    return new AgendaState();
  }
}

class AgendaState extends GenericAppState<AgendaWidget> {
  var atividades;
  bool loadingDelete = false;
  Map<int, String> weekdays = {
    1: 'Seg',
    2: 'Ter',
    3: 'Qua',
    4: 'Qui',
    5: 'Sex',
    6: 'Sáb',
    7: 'Dom'
  };
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
      body: this.loadingDelete
          ? LoadingWidget(
              message: 'Deletando atividade...',
            )
          : atividades.isEmpty ? buildEmpty() : buildActivityList(),
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
    return ListView.builder(
      itemBuilder: (BuildContext ctx, int index) {
        String nome = atividades[index]['nome'],
            desc = atividades[index]['descricao'],
            materia = atividades[index]['materia'];
        DateTime timestamp =
            DateTime.fromMillisecondsSinceEpoch(atividades[index]['data']);
        return Evento(
            nome, materia, desc, timestamp, atividades[index]['id'], this);
      },
      itemCount: atividades.length,
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
        ],
      ),
    ));
  }

  void displayDialog() {
    List<String> options = new List<String>();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AtividadeWidget(
                options: options,
                agenda: this,
              )),
    );
  }
}

class Evento extends StatefulWidget {
  String nome;
  String desc;
  String materia;
  DateTime timestamp;
  var agendaId;
  AgendaState state;

  Evento(this.nome, this.materia, this.desc, this.timestamp, this.agendaId,
      this.state);

  String get dayName => weekdays[timestamp.weekday].toUpperCase();

  String get month => months[timestamp.month - 1].toUpperCase();

  int get day => timestamp.day;

  @override
  State createState() => EventoState();

  void updateActivities() {
    state.fetchData();
  }
}

class EventoState extends State<Evento> {
  bool isDeleting = false, isUpdating = false;

  @override
  void initState() {
    isDeleting = false;
    isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    print('Is updating... $isUpdating');
    return this.isDeleting
        ? LoadingWidget(
            message: 'Deletando atividade',
            bgColor: Colors.white10,
          )
        : this.isUpdating
            ? LoadingWidget(
                message: 'Atualizando atividade',
                bgColor: Colors.white10,
              )
            : activity();
  }

  Widget activity() {
    TextStyle style = TextStyle(color: Colors.grey);
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: Column(
          children: <Widget>[
            Text(
              this.widget.dayName,
              style: style,
            ),
            Text(
              this.widget.month,
              style: style,
            ),
            Text(
              '${this.widget.day}',
              style: style,
            ),
          ],
        ),
        title: Row(
          children: <Widget>[
            Flexible(
                child: Text(
              this.widget.nome + ' - ' + this.widget.materia,
            )),
          ],
        ),
        subtitle: Text(this.widget.desc),
        onTap: () => this.updateScreen(),
      ),
      actions: <Widget>[],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Deletar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => delete('Deletar', this.widget.agendaId),
        ),
      ],
    );
  }

  delete(a, b) {
    this.setState(() {
      isDeleting = true;
    });
    this.widget.state.api.deleteAtividade(this.widget.agendaId).then((val) {
      this.widget.state.storage.setAtividades(val);
    }).then((a) {
      this.widget.updateActivities();
      this.setState(() {
        isDeleting = false;
      });
    });
  }

  doUpdate(String nome, String materia, String desc, int timestamp) {
    print('Updating... $nome $materia $desc $timestamp');
    this.setState(() {
      this.isUpdating = true;
    });
    Api()
        .updateAtividade(nome, materia, desc, timestamp, this.widget.agendaId)
        .then((val) {
      print('Atividades updated!!! is $val');
      Storage().setAtividades(val);
      this.widget.state.fetchData();
      this.setState(() {
        this.isUpdating = false;
      });
    });
  }

  updateScreen() {
    print('UPDATE ${this.widget.agendaId}');
    Storage().getMaterias().then((materias) {
      Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (ctx) => AtualizaAtividade(
                  this.widget.nome,
                  this.widget.materia,
                  this.widget.desc,
                  this.widget.timestamp,
                  this.widget.agendaId,
                  json.decode(materias)['materias'],
                  doUpdate)));
    });
  }
}
