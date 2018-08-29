import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/calendar/Calendar.dart';

class CalendarioWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CalendarioState();
  }

}

class _CalendarioState extends State<CalendarioWidget>{

  @override
  Widget build(context){
    return new Calendar(isExpandable: true, );
  }
}