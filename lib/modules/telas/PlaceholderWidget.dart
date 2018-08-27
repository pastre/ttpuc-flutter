import 'package:flutter/material.dart';

class PlaceholderWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _PlaceholderState();
  }

}

class _PlaceholderState extends State<PlaceholderWidget>{
  @override
  Widget build(BuildContext context) {
    return Text('Esta tela ainda está em configuração :)');
  }

}