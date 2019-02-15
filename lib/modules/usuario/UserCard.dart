import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';

class UserCardWidget extends GenericAppWidget {
  UserCardWidget() : super(state: UserCardState(), name: 'ira');

  @override
  State<StatefulWidget> createState() => UserCardState();
}

class UserCardState extends GenericAppState<UserCardWidget> {
  Map<String, dynamic> userData;

  @override
  void preinit() {
    userData = null;
  }

  @override
  bool hasLoaded() => userData != null;

  @override
  Widget buildScreen(BuildContext ctx) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 128.0,
                color: Colors.blueGrey,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[Text(this.userData['nome'])],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[Text("@${this.userData['username']}")],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }

  @override
  void updateLocal(data) => Storage().setUserData(data);

  @override
  Future loadLocal() => Storage().getUserData();

  @override
  Future apiCall() => Api().getUserData();

  @override
  void updateState(data) => setState(() {
        if (data == null) {
          print('NULL DATA');
          return;
        }
        var ret = json.decode(data);
        this.userData = ret;
      });
}
