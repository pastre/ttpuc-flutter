import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';

class SaldoWiget extends GenericAppWidget{

  SaldoWiget() : super(state: SaldoState(), name: 'Saldo');

  @override
  State<StatefulWidget> createState() {
    return SaldoState();
  }
}

class SaldoState<SaldoWiget> extends GenericAppState{
  double saldo;

  final key = new GlobalKey<ScaffoldState>();
  @override
  void preinit() {
    saldo = null;
  }

  @override
  bool hasLoaded() => saldo != null;

  @override
  void updateLocal(data) => Storage().setSaldo(data);

  @override
  Future loadLocal() => Storage().getSaldo();

  @override
  Future apiCall() => Api().getSaldo();

  @override
  void updateState(data) =>     setState(() {
    if (data == null) {
      print('NULL DATA');
      return;
    }
    var ret = json.decode(data);
    this.saldo = double.parse(ret['saldo'].replaceAll(',', '.'));
  });


  void flipLoading() => setState((){
    this.isLoading = !this.isLoading;
  });
  @override
  Widget buildScreen(BuildContext ctx) {
    return Row(
      children: <Widget>[
        Text('$saldo'),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.grey,
            size: 16.0,
          ),
          onPressed: () {
            flipLoading();
            this.updateData().then((onData) {
              flipLoading();
            });
          },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );

  }
}