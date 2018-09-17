import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/calendar/Calendar.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class CalendarioWidget extends GenericAppWidget{

  CalendarioWidget({ List<ListTile> key }) : super(list: key);
  @override
  State<StatefulWidget> createState() {
    return CalendarioState();
  }
}

class CalendarioState extends GenericAppState<CalendarioWidget>{
  var eventos;

  @override
  Widget build(BuildContext ctx){
    return super.build(ctx);
  }

  @override
  void preinit(){
    eventos = [];
  }

  @override
  Widget buildScreen(BuildContext ctx){
    print('Building screen');
    return new Calendar(isExpandable: true, eventos: eventos, );
  }

  @override
  bool hasLoaded(){
    return this.eventos.length != 0 || true;
  }


  @override
  void updateLocal(data) {
    this.storage.setEventos(data);
  }

  @override
  Future loadLocal() async {
    return this.storage.getEventos();
  }

  @override
  Future apiCall() async{
    return this.api.getEventos();
  }

  @override
  void updateState(data){
    setState((){
      var ret =  json.decode(json.decode(data)['eventos']);
      print('Ret is $ret');
      this.eventos = ret;
    });
  }

}