import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Expandable.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:flutter/scheduler.dart';

class NotasWidget extends GenericAppWidget {
//  NotasWidget({ List<ListTile> key }) : super(list: key);

  NotasWidget() : super(state: NotasState(), name: 'Notas');

  @override
  State<StatefulWidget> createState() {
    return NotasState();
  }
}

class NotasState extends GenericAppState<NotasWidget> {
  var list;

  @override
  Widget build(BuildContext ctx) {
    return super.build(ctx);
  }

  @override
  void preinit() {
    list = [];
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    return RefreshIndicator(
      child: _buildList(ctx),
      onRefresh: () => refreshData().then((newData) => compareData(newData)),
      color: PUC_COLOR,
    );
  }

  @override
  bool hasLoaded() {
    return this.list.length != 0;
  }

  @override
  void updateLocal(data) {
    this.storage.setNotas(data);
  }

  @override
  Future loadLocal() async {
    return this.storage.getNotas();
  }

  @override
  Future apiCall() async {
    return this.api.getNotas();
  }

  @override
  void updateState(data) {
    setState(() {
      if (data == null) {
        print('NULL DATA');
        return;
      }
      var ret = json.decode(data);
      this.list = ret;
      print('OBA');
    });
  }

  VoidCallback reorderShit(int index) {
    print('Called back! $index ${this.list}');

    for (int i = 0; i < this.list.length; i++) {
      if (this.list[i]['isExpanded'] == null)
        this.list[i]['isExpanded'] = false;
      if (i == index) {
        this.list[i]['isExpanded'] = !this.list[i]['isExpanded'];
//        print('Got I, $i, ${this.list[i]}');
      } else {
        this.list[i]['isExpanded'] = false;
      }
    }

    this.updateState(json.encode(this.list));
  }

  Widget _buildList(context) {
    List<Widget> list = new List<Widget>();
    for (var i in this.list) {
      if (i['faltaspresencas'] == '--/--%') continue;
      if (i['faltaspresencas'] == '**/**%') continue;
      if (i['faltaspresencas'] == '**/**') continue;
      var maxFaltas =
          int.parse(i['hahr'].split("/")[0].replaceAll(' ', '')) * 0.25;
      int nFaltas = int.parse(i["faltaspresencas"].split('/')[0]);
      list.add(
        NotaWidget(
          i['disciplina'],
          i['nota1'],
          i['nota2'],
          i['nota3'],
          i['nota4'],
          (maxFaltas - nFaltas).round(),
          this.list.indexOf(i),
          isExpanded: i['isExpanded'],
          media: isNumeric(i['media']) ? i['media'] : null,
          mediaFinal: isNumeric(i['media_final']) ? i['media_final'] : null,
        ),
      );

      i['index'] = this.list.indexOf(i);
    }
    return new ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, int) {
        return list[int];
      },
      shrinkWrap: true,
    );
  }

  Widget buildTableCell(materia, n1, n2, n3, n4, faltas) {
    String subt = 'Nota 1: $n1  Nota 2: $n2';
    if (n3 != '--/--') subt += '\nNota 3: $n3';
    if (n4 != '--/--') subt += '  Nota 4: $n4';

    return new Stack(
      children: <Widget>[
        ListTile(
          title: Text('$materia'),
          subtitle: buildText(n1, n2, n3, n4, faltas),
          isThreeLine: true,
          trailing: Icon(Icons.keyboard_arrow_down),
          onTap: () {
            print(' Touched!!');
          },
        ),
//      Divider(height: 1.0, indent: 16.0,)
      ],
    );
  }

  Widget buildText(n1, n2, n3, n4, faltas) {
    MaterialColor corFaltas = Colors.lightBlue;
    if (faltas <= 4) {
      corFaltas = Colors.red;
    }

    String subt = 'Nota 1: $n1  Nota 2: $n2\n';
    if (n3 != '--/--') subt += 'Nota 3: $n3';
    if (n4 != '--/--') subt += '  Nota 4: $n4';
    subt += 'Você ainda pode faltar ';
    return new RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: subt, style: TextStyle(color: SUBTEXT_COLOR)),
          TextSpan(text: '$faltas ', style: TextStyle(color: corFaltas)),
          TextSpan(text: 'aulas', style: TextStyle(color: SUBTEXT_COLOR)),
        ],
      ),
    );
  }

  Future<String> refreshData() async {
    String ret = await this.apiCall();
    print('Ret is $ret');
    return ret;
  }

  void compareData(newData) {
    this.storage.setNotas(newData);
    this.updateState(newData);
  }
}

class NotaWidget extends StatefulWidget {
  String materia, n1, n2, n3, n4, media, mediaFinal;
  int faltas, index;

  bool isExpanded;

  NotaWidget(
      this.materia, this.n1, this.n2, this.n3, this.n4, this.faltas, this.index,
      {this.isExpanded = false, this.media = null, this.mediaFinal = null});

  @override
  State<StatefulWidget> createState() => NotaState();
}

class NotaState extends State<NotaWidget> with SingleTickerProviderStateMixin {
  bool needsExpand = false;

//  AnimationController _controller;
  @override
  void initState() {
    super.initState();
//    _controller = AnimationController(
//      vsync: this, // the SingleTickerProviderStateMixin
//      duration: Duration(milliseconds: 1),
//    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.needsExpand == null) this.needsExpand = false;
    if (this.widget.isExpanded == null) this.widget.isExpanded = false;
    Widget arrowDown = Icon(Icons.keyboard_arrow_down);
    Widget arrowLeft = Icon(Icons.keyboard_arrow_left);
    print(
        'widgetExpanded:${this.widget.isExpanded} needExpand:${this.needsExpand}');

    bool needsExpand() => this.widget.isExpanded == this.needsExpand;

    Widget subtitle = needsExpand()
        ? buildCollapsedSubtitle()
        : buildExpandedSubtitle(
            [this.widget.n1, this.widget.n2, this.widget.n3, this.widget.n4],
            this.widget.faltas);
    return ExpansionTile(
      title: Column(
        children: <Widget>[
          Text(
            '${this.widget.materia}',
          ),
          buildCollapsedSubtitle(),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      children: <Widget>[
        ListTile(
          title: buildExpandedSubtitle(
              [this.widget.n1, this.widget.n2, this.widget.n3, this.widget.n4],
              this.widget.faltas),
        ),
      ],
      initiallyExpanded: false,
    );
  }

  Widget buildExpandedSubtitle(List notas, faltas) {
    List<Widget> tmp = List<Widget>();
//    for (int i = 0; i < notas.length; i++) {
//      tmp.add(Text('Nota ${i + 1}: ${notas[i]}'));
//      tmp.add(SizedBox(
//        height: 1.0,
//      ));
//    }
    tmp.add(getNotasText());
    if (this.widget.media != null) tmp.add(getMedia());
    if (this.widget.mediaFinal != null) tmp.add(getAvFinal());
    tmp.add(getFaltasText());
    return Container(
      child: Column(
        children: tmp,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }

  Widget buildCollapsedSubtitle() {
    if (this.widget.mediaFinal != null)
      return Column(
        children: <Widget>[
          getAvFinal(),
          double.parse(this.widget.mediaFinal) >= 5
              ? getApprovedText()
              : getReprovedText()
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    if (this.widget.media != null)
      return Column(
        children: <Widget>[
          getMedia(),
          double.parse(this.widget.media) >= 7
              ? getApprovedText()
              : getPrevFinal()
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    return Column(
      children: <Widget>[getNotasText(), getFaltasText()],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget getApprovedText() {
    return Text(
      'Parabéns, você foi aprovado!',
      style: TextStyle(color: SUBTEXT_COLOR),
    );
  }

  Widget getReprovedText() {
    return Text(
      'Ops, que pena, você reprovou :(',
      style: TextStyle(color: SUBTEXT_COLOR),
    );
  }

  Widget getAvFinal() => RichText(
          text: TextSpan(children: <TextSpan>[
        TextSpan(text: 'Média final: ', style: TextStyle(color: SUBTEXT_COLOR)),
        TextSpan(
            text: '${this.widget.mediaFinal}',
            style: double.parse(this.widget.mediaFinal) < 5
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.blue)),
      ]));

  Widget getMedia() => RichText(
          text: TextSpan(children: <TextSpan>[
        TextSpan(text: 'Média: ', style: TextStyle(color: SUBTEXT_COLOR)),
        TextSpan(
            text: '${this.widget.media}',
            style: double.parse(this.widget.media) < 7
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.blue)),
      ]));

  Widget getNotasText() {
    String subt = '';
    var notas = [
      this.widget.n1,
      this.widget.n2,
      this.widget.n3,
      this.widget.n4
    ];
    notas.removeWhere((value) => value == '**/**' || value == '--/--');
    if (notas.isEmpty)
      subt += 'Não há nenhuma nota lançada';
    else
      for (String i in notas)
        if (i.isEmpty)
          continue;
        else
          subt += 'Nota ${notas.indexOf(i) + 1}: ${i.split('/')[0]} ';

    return new RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: subt,
              style:
                  TextStyle(color: SUBTEXT_COLOR, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget getPrevFinal() {
    return Text(
        'Você precisa de ${10 - (double.parse(this.widget.media))} na final',
        style: TextStyle(color: SUBTEXT_COLOR));
  }

  Widget getFaltasText() {
    MaterialColor corFaltas = Colors.lightBlue;

    if (this.widget.faltas <= 4) corFaltas = Colors.red;
    return new RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: 'Você ainda pode faltar ',
              style: TextStyle(color: SUBTEXT_COLOR)),
          TextSpan(
              text: '${this.widget.faltas} ',
              style: TextStyle(color: corFaltas)),
          TextSpan(text: 'aulas', style: TextStyle(color: SUBTEXT_COLOR)),
        ],
      ),
    );
  }
}
