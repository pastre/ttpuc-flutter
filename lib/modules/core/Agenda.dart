
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class AgendaWidget extends GenericAppWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
      return new _AgendaState();
  }

}

class _AgendaState extends GenericAppState<AgendaWidget>{

  @override
  bool hasLoaded() {
    return true;
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    return new Scaffold(body: Text('Ntoas'),);
  }


}


