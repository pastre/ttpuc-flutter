import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/storage/Storage.dart' ;

class NotasWidget extends StatefulWidget{
  @override
  _NotasState createState() => new _NotasState();
}

class _NotasState extends State<NotasWidget>{
  var storage, list;

  _NotasState(){
    this.storage = new Storage();
    this.list = new List<ListTile>();
    this.getNotas();
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(context){
    List<ListTile> list = new List<ListTile>();
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
      subt +='\nVocê ainda pode faltar $faltas aulas';
      return new ListTile(
        title: Text('$materia'),
        subtitle:  Text(subt),
        isThreeLine: true,
      );
  }

  void getNotas() async {
    var localNotas = await this.storage.getNotas();
    this.setState((){ //TODO resolver leak de memoria aqui. s
      this.list = json.decode(localNotas);
    });
  }
}