import 'package:flutter/material.dart';
// Como deve ficar a celula na lista
class MyListElement<Widget> extends ListTile{
  MyListElement() : super(
    title: Text('Map1'),
    subtitle:  Text('N1: **/**  N2: **/**\nN3: **/**  N4: **/**\nVoce ainda pode faltar 20 aulas'),
  );
}