import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/storage/Storage.dart' ;
import 'package:horariopucpr/modules/api/Api.dart';


class NotasWidget extends StatefulWidget{
  @override
  _NotasState createState() => new _NotasState();
}

class _NotasState extends State<NotasWidget>{
  var storage, list, api;


  @override
  void initState() {
    super.initState();
    this.storage = new Storage();
    this.api = new Api();
    this.list = new List<ListTile>();
    getNotas();
  }

  @override
  Widget build(BuildContext context) {
    if(this.list.length == 0) {
      this.getNotas();
      return new Text("Carregando...");
    }
    return _buildList(context);
  }

  Widget _buildList(context){
    List<Card> list = new List<Card>();
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
      return new Card(child: ListTile(
        title: Text('$materia'),
        subtitle:  Text(subt),
        isThreeLine: true,
      )
      );

  }

  void getNotas() async {
    var localNotas = await this.storage.getNotas();
    if(localNotas == null){
      await this.api.updateNotas('bruno.pastre', 'asdqwe123!@#');
      localNotas = this.api.getNotas();
      this.storage.setNotas(json.encode(localNotas));
      this.setState((){this.list = localNotas;});
    }
    else {
      this.setState(() {
        this.list = json.decode(localNotas);
      });
    }
  }
}