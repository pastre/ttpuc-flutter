import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/smaller_screens/EscolheMaterias.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class HorariosWidget extends GenericAppWidget {
  HorariosState state;

  HorariosWidget() {
    this.state = new HorariosState();
  }

  @override
  State<StatefulWidget> createState() {
    this.state = new HorariosState();
    return this.state;
  }

  void setToday() {
    print('Set today!!');
    this.state.setToday();
  }
}


class HorariosState extends GenericAppState<HorariosWidget>
    with TickerProviderStateMixin {
  var PLACEHOLDER = 'asd';
  var materias;
  var dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  List<Tab> _tabs = <Tab>[];
  TabController tabController;
  int todayInt;

  bool isBuilding;

  @override
  Widget build(BuildContext ctx) {
    return super.build(ctx);
  }

  @override
  void preinit() {
    materias = [];
    isBuilding = false;
    for (var i = 0; i < this.dias.length; i++) {
      _tabs.add(new Tab(text: this.dias[i],));
      todayInt = DateTime
          .now()
          .weekday - 1 == 6 ? 0 : DateTime
          .now()
          .weekday - 1;
    }
    tabController = new TabController(
      length: dias.length, vsync: this, initialIndex: todayInt,);

  }

  void setToday() {
    try {
      print('YAAAAY Tab controler is $tabController');
      tabController.animateTo(todayInt);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    Widget tabBarView = buildTabView();
    Widget tabBar = buildTabBar();
    return new Scaffold(appBar: tabBar,
      body: tabBarView,
    );
  }

  @override
  bool hasLoaded() {
    return this.materias.length != 0;
  }

  @override
  void updateLocal(data) {
    this.storage.setHorarios(data);
  }

  @override
  Future loadLocal() async {
    print('Loding datalocal...');
    return this.storage.getHorarios();
  }

  @override
  Future apiCall() async {
    return this.api.getHorarios();
  }

  @override
  void updateState(data) {
    print('Updating state');
    var ret = json.decode(data)['horarios']; // TODO: Checar se data é null
    print('Setting state ${ret}');
    if (ret.isEmpty) {
      this.materias.add(PLACEHOLDER);
      print('Empty!!!');
      buildMaterias();
    } else {
      print('Setting state with materias $ret');
      setState(() {
        this.materias = ret;
      });
    }
  }

  void buildMaterias() {
    if(!this.isBuilding)
      Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => Picker())).then((value) {
        this.fetchData();
      });
    this.setState((){
      this.isBuilding = true;
    });
  }

  Widget buildTabView() {
    return new TabBarView(
      children: _tabs.map((tab) => buildCardList(tab.text)).toList(),
      controller: tabController,
    );
  }

  Widget buildTabBar() {
    TabBar tabBar = new TabBar(tabs: _tabs,
      controller: tabController,
      labelColor: PUC_COLOR,
      unselectedLabelColor: PUC_COLOR,
      indicatorColor: PUC_COLOR,
    );
    return tabBar;
  }

  Widget buildCardList(String key) {
    if (materias.contains(PLACEHOLDER)) {
      return MaterialButton(child: Text('Aguardando insercao das materias'),
        onPressed: buildMaterias,);
    }
    var cards = <Card>[];
//    print('Materias is $materias');
    for (var i in materias) {
      if (!i['day'].contains(key)) continue;
//      print('I is $i');
      String time = i['starttime'] + ' - ' + i['endtime'];
      String local = '';
      var professores = [];
      for (var k = 0; k < i['classrooms'].length; k++) {
        var j = i['classrooms'][k];
        local += j['sala'] + ' - ' + j['lugar'];
        if (k != i['classrooms'].length - 1) local += '\n';
      }
      print('Local is $local');
      if (local.startsWith(' - ')) local = local.replaceFirst(' - ', '');
      for (var j in i['teachers'])
        professores.add(j);
      cards.add(buildCard(i['subject'], time, professores, local));
    }
    if (cards.isEmpty)
      return Container(child: Column(children: <Widget>[
        Icon(Icons.directions_bike, color: Colors.grey, size: 64.0,),
        Text('  Você não tem aulas hoje\nAproveite para dar um rolê :)', style: TextStyle(color: Colors.grey),),
      ],crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,),);

    return ListView.builder(
      itemBuilder: (_, int) => cards[int], itemCount: cards.length,);
  }

  Widget buildCard(title, horario, professores, sala) {
    String sbt = '$horario\n';
    for (String professor in professores)
      sbt += '$professor\n';
    sbt += sala;
    return Card(child: ListTile(
      title: cardTitle(title),
      subtitle: Text(sbt, style: TextStyle(color: Colors.grey),),),
      elevation: 2.0,
    );
  }

  Widget cardTitle(String title) {
    return Row(children: <Widget>[
      Expanded(child: Text(title, softWrap: true,),),
//      Center(child: eventButton()),
    ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
//
//  Widget eventButton(){
//    return SizedBox(
//      child: IconButton(
//        icon: Icon(Icons.add, color: Colors.lightBlue,),
//        onPressed: () => displayDialog(),
//        iconSize: 20.0,),
//      height: 25.0, width: 25.0,);
//  }


}