import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/telas/NotasWidget.dart' as notas;
import 'modules/design/NavScreenComposite.dart';
import 'modules/telas/LoginWidget.dart';

void main() {
  runApp(Test());
}


class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print('Returning');
//    return MaterialApp(home:a,
    return MaterialApp(home:LoginWidget(),

    //TODO:  theme: ,
    );
  }
}

