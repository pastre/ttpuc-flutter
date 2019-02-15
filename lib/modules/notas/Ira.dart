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



  @override
  Widget buildScreen(BuildContext ctx) {
    Widget test = Text(
      '${ira.toStringAsFixed(2)}',
//      style: TextStyle(color: PUC_COLOR),
    );
    return test;

  }

  changeDisplay() {
    setState(() {
      this.isExpanded != this.isExpanded;
    });
  }
}
