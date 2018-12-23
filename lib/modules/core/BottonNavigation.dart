import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Screen.dart';

import 'package:horariopucpr/modules/utils/Utils.dart';

class BottomNavBar extends StatefulWidget{
  Widget screen;
  BottomNavBar(screen){
   this.screen = screen;
  }
  @override
  State<StatefulWidget> createState() {
    return new _BottomNavBarState(this.screen);
  }

}

class _BottomNavBarState extends  State<BottomNavBar>{
  var list;
  var currIndex;
  Screen screen;
  _BottomNavBarState(screen){
//    this.list = [
//      BottomNavigationBarItem(icon: Icon(Icons.subject),
//        title: Text( 'Horários'),
//      ),
//      BottomNavigationBarItem(icon: Icon(Icons.book),
//        title: Text( 'Notas'),
//      ),
//      BottomNavigationBarItem(icon: Icon(Icons.person_pin),
//        title: Text( 'Professores'),
//      ),
//      BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
//        title: Text( 'Agenda'),
//      ),
//    ];
    this.list = new List<BottomNavigationBarItem>();
    for(ScreenOption i in SCREENS){
      this.list.add(BottomNavigationBarItem(icon: i.icon, title: Text(i.nome)));
    }
    this.screen = screen;
    this.currIndex = 1;
  }
  @override
  Widget build(BuildContext context) {
    return new BottomNavigationBar(items: this.list,
      onTap: (value) => this.updateValue(value),
      currentIndex: this.currIndex,
      fixedColor: PUC_COLOR,
    type: BottomNavigationBarType.fixed,
    );
  }

  void updateValue(int){
    this.screen.updateState(int);
    print("New state $int");
    this.setState((){this.currIndex = int;});
  }

}