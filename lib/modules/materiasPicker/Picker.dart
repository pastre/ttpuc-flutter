

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

  var resp, api;

  @override
  void initState() {
    super.initState();
    this.resp = [];
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
    var items = <ListTile>[];
    for(var i in resp['duplicados'])
      items.add(buildRadio(i));
    return ListView(children: items, );
  }

  Widget buildTile(data){
    return ListTile(title:buildCard(data),);
//    print('Tile is $data');
  }


  int tmp = 0;

  Widget buildRadio(item){
    return RadioListTile(value: false, groupValue: tmp, onChanged: (asd) => this._handleOptionChanged(asd));
  }
  void _handleOptionChanged(int value){

  }
  Widget buildCard(data){
    return new Card(
      child: RadioListTile(value: false, groupValue: tmp, onChanged: (asd) => this._handleOptionChanged(asd) ),
    );
  }

  List<Group> groupItems(data){
    var done = [];
    List<Group> ret = new List<Group>();
    for(var i in data){
      if(!done.contains(i)){
        Group toAppend = new Group();
        for(var j in data) {
          if (i['subject'] == j['subject']) {
            toAppend.addOption(j);
            done.add(j);
          }
        }
        ret.add(toAppend);
      }
    }

    return ret;
  }

  void updateData() async{
    var ret = await this.api.generateHorarios();
    ret = json.decode(ret);
    print('Ret is $ret');
    setState((){
      resp = ret;
    });
  }
}


class Group{
  var options;
  int _radioValue = 0;
  Group() {
    this.options = [];
  }

  Widget getWidget(){
    return ListView(children: <Widget>[],);
  }


  void addOption(opt){
    this.options.add(opt);
  }
}