import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/telas/NotasWidget.dart' as notas;
import 'modules/design/NavScreenComposite.dart';

void main() {
  runApp(Test());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      color: new Color(0xFFAD0000),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.subject), text: 'Horários'),
                Tab(icon: Icon(Icons.book), text: 'Notas',),
                Tab(icon: Icon(Icons.person_pin), text: 'Professores',),
                Tab(icon: Icon(Icons.calendar_today), text: 'Agenda',),
              ],
            ),
            backgroundColor:  new Color(0xFFAD0000),
            title: Text('Horários PUCPR'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.subject),
              new notas.NotasWidget(),

//              Icon(Icons.subject),
              Icon(Icons.verified_user),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }
}

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print('Returning');
    return MaterialApp(home:MainScreen(),

    //TODO:  theme: ,
    );
  }
}