import 'package:flutter/material.dart';
import 'package:horariopucpr/main.dart';


class SettingsWidget extends StatelessWidget{
  MyCallback logout;

  SettingsWidget({this.logout});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: MaterialButton(onPressed: () => logout),);
  }
}