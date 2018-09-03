import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class NotasWidget extends GenericAppWidget{
  NotasWidget({ List<ListTile> key }) : super(list: key);
  @override
  State<StatefulWidget> createState() {
    return NotasState();
  }
}

class NotasState extends GenericAppState<NotasWidget>{

  var list;

  @override
  Widget build(BuildContext ctx) {
    // TODO: implement build
    return super.build(ctx);
  }

  @override
  void preinit(){
    list = [];
  }
  @override
  Widget buildScreen(BuildContext ctx) {
    print("WORKED");
    return _buildList(ctx);
  }



  @override
  bool hasLoaded() {
    print("List length is ${this.list.length}");
    return this.list.length != 0;
  }


  @override
  void updateLocal(data) {
    this.storage.setNotas(data);
  }

  @override
  Future apiCall() async {
    return this.api.nGetNotas();
  }

  @override
  Future loadLocal() async {
    return this.storage.getNotas();
  }

  @override
  void updateState(data) {
    setState(() {
      var ret =  json.decode(data);
      this.list = ret;
      print('OBA');
    });
  }


  Widget _buildList(context){
    List<Widget> list = new List<Widget>();
    for (var i in this.list){
      var maxFaltas = int.parse(i['hahr'].split("/")[0].substring(0, 2)) * 0.25;
      int nFaltas = int.parse(i["faltaspresencas"].split('/')[0]);
      list.add(this.buildTableCell(i['disciplina'], i['nota1'], i['nota2'], i['nota3'], i['nota4'],(maxFaltas - nFaltas).round()));
    }
    return new ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, int){
        return list[int];
      },
    );
  }

  Widget buildTableCell(materia, n1, n2, n3, n4, faltas){
    String subt = 'Nota 1: $n1  Nota 2: $n2';
    if (n3 != '--/--') subt += '\nNota 3: $n3';
    if(n4 != '--/--') subt += '  Nota 4: $n4';

//      subt +='\nVocê ainda pode faltar $faltas aulas';
//      return new Card(child: ListTile(
//        title: Text('$materia'),
//        subtitle:  buildText(n1, n2, n3, n4, faltas) ,
////        isThreeLine: true,
//      )
//      );

    return new Stack(children: <Widget>[
      ListTile(
        title: Text('$materia'),
        subtitle:  buildText(n1, n2, n3, n4, faltas),
        isThreeLine: true,
      ),
      Divider(height: 1.0, indent: 16.0,)
    ],
    );
//
//      ListTile(
//        title: Text('$materia'),
//        subtitle:  buildText(n1, n2, n3, n4, faltas),
//        isThreeLine: true,
//
//      );

  }

  Widget buildText(n1, n2, n3, n4, faltas){
    MaterialColor corFaltas =  Colors.lightBlue;
    if(faltas <= 4){
      corFaltas = Colors.red;
    }

    String subt = 'Nota 1: $n1  Nota 2: $n2\n';
    if (n3 != '--/--') subt += 'Nota 3: $n3';
    if(n4 != '--/--') subt += '  Nota 4: $n4';
    subt += 'Você ainda pode faltar ';
    return new RichText(text: TextSpan(children: <TextSpan>[
      TextSpan(text: subt, style: TextStyle(color: SUBTEXT_COLOR)),
      TextSpan(text: '$faltas ', style: TextStyle(color: corFaltas)),
      TextSpan(text: 'aulas', style: TextStyle(color: SUBTEXT_COLOR)),
    ],
    ),
    );
  }
}
