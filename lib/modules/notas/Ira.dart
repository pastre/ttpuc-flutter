import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class IraWidget extends GenericAppWidget {
  IraWidget() : super(state: IraState(), name: 'ira');

  @override
  State<StatefulWidget> createState() => IraState();
}

class IraState extends GenericAppState<IraWidget> {
  double ira;
  bool isExpanded = false;

  @override
  void preinit() {
    ira = null;
    isExpanded = false;
  }

  @override
  bool hasLoaded() {
    return ira != null;
  }

  @override
  void updateLocal(data) {
    Storage().setIra(data);
  }

  @override
  Future loadLocal() {
    return Storage().getIra();
  }

  @override
  Future apiCall() {
    return Api().getIra();
  }

  @override
  void updateState(data) {
    setState(() {
      if (data == null) {
        print('NULL DATA');
        return;
      }
      var ret = json.decode(data);
      this.ira = ret['ira'];
    });
  }

  changeDisplay() {
    setState(() {
      this.isExpanded != this.isExpanded;
    });
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    Widget test = Text(
      'IRA (Índice de Rendimento Acadêmico):  ${ira.toStringAsFixed(2)}',
      style: TextStyle(color: PUC_COLOR),
    );
    return test;
    if (isExpanded) {
      Widget test = Text(
        'IRA (Índice de Rendimento Acadêmico)  ${ira.toStringAsFixed(2)}',
        style: TextStyle(color: PUC_COLOR),
      );
      return Stack(
        children: <Widget>[
          FloatingActionButton(
            onPressed: changeDisplay,
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: <Widget>[
        FloatingActionButton(
          onPressed: changeDisplay,
          child: Icon(
            Icons.arrow_drop_up,
            color: Colors.grey,
          ),
          mini: true,
          backgroundColor: Colors.white,
        )
//      IconButton(icon: Icon(Icons.arrow_drop_up), onPressed: (){}, )
      ],
    );
  }
}
