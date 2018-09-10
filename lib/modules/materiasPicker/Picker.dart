

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class Picker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PickerState();
  }
}

class PickerState extends State<Picker>{

  var resp, dups, api;

  @override
  void initState() {
    super.initState();
    this.resp = [];
    this.dups = [];
    this.api = Api();
    this.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: buildScreen(context),
        appBar: AppBar(
            title: Text('Montando sua grade'),
            automaticallyImplyLeading: false
            ,backgroundColor: PUC_COLOR,),
        );
  }

  Widget buildScreen(BuildContext context){
    if(resp.isEmpty){
      return Text('Loading');
    }
    return ListView(children: buildConflitos(), );
  }

  List<Conflito> buildConflitos(){
    var done = [];
    List<Conflito> ret = new List<Conflito>();
    for(var i in dups){
      if(done.contains(i)) continue;
      var toAppend = [];
      for(var j in dups){
        if(i['subject'] == j['subject'] ){
          toAppend.add(j);
          done.add(j);
        }
      }
      print('Created conflito $toAppend');
      if(!toAppend.isEmpty) ret.add(new Conflito(conflito: toAppend,));
    }

    return ret;
  }

  void updateData() async{
    var ret = await this.api.generateHorarios();
    ret = json.decode(ret);
    print('Ret is $ret');
    setState((){
      resp = ret['horarios'];
      dups = ret['duplicados'];
    });
  }
}


class Conflito extends StatefulWidget{
  var conflito;
  Conflito({this.conflito});

  @override
  State<StatefulWidget> createState() {
    return _ConflitoState();
  }
}

class _ConflitoState extends State<Conflito>{

  int _selectedIndex = 0;

  void onChange(int value){
    setState(() {
      _selectedIndex = value;
    });
  }

  Card buildCard(option){
    return Card(
        child: Text(option['subject'],),

    );
  }

  Row radio(int val){
    return Row(children: <Widget>[
      buildCard(widget.conflito[val]),
      new Radio(value: val, groupValue: _selectedIndex, onChanged: (int val) => onChange(val), ),
    ],);

  }

  List<Widget> makeRadios(){
    List<Widget> ret = new List<Widget>();
    for(var i = 0; i < widget.conflito.length; i++){
      ret.add(radio(i));
    }
    ret.add(Divider());
    return ret;
  }

  Widget buildList(BuildContext context){
    return new ListView.builder(itemBuilder: (BuildContext context, int index){
      return new Card(child: ListTile(
        title: Text("asd"),
        subtitle: Text('qwe'),
        )
      );
    }, shrinkWrap: true,);
  }

  @override
  Widget build(BuildContext context) {
    return buildList(context);
    return new Column( children: makeRadios(),);
  }
}

