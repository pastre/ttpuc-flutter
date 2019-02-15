import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';

class CodigoCarteirinhaWidget extends GenericAppWidget {
  CodigoCarteirinhaWidget() : super(state: CodigoCarteirinhaState(), name: 'ira');

  @override
  State<StatefulWidget> createState() => CodigoCarteirinhaState();
}

class CodigoCarteirinhaState extends GenericAppState<CodigoCarteirinhaWidget>{
  String cod;

  @override
  void preinit() {
    cod = null;
  }


  @override
  Widget buildScreen(BuildContext ctx) {
    return Row(
      children: <Widget>[
        Text(cod),
        IconButton(
          icon: Icon(
            Icons.content_copy,
            color: Colors.grey,
            size: 16.0,
          ),
          onPressed: () {
            Clipboard.setData(new ClipboardData(
                text: cod));

            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Código da carteirinha copiado!',
                ),
                duration: Duration(seconds: 3),
              ),
            );
          },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  bool hasLoaded() {
    return cod != null;
  }

  @override
  void updateLocal(data) {
    Storage().setUserData(data);
  }

  @override
  Future loadLocal() {
    return Storage().getUserData();
  }

  @override
  Future apiCall() {
    return Api().getUserData();
  }

  @override
  void updateState(data) {
    setState(() {
      if (data == null) {
        print('NULL DATA');
        return;
      }
      var ret = json.decode(data);
      this.cod = ret['codigo'];
    });


  }

}