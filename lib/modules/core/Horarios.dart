import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class HorariosWidget extends GenericAppWidget {
  HorariosWidget() : super(state: HorariosState(), name: 'Horarios');

  @override
  State<StatefulWidget> createState() {
    this.state = new HorariosState();
    return this.state;
  }

  void setToday() {
    print('Set today!!');
    this.state.setToday();
  }

  void updateChild() {
    print('Updating child!!!');
    this.state.forceUpdate();
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

  bool hasMaterias;

  @override
  Widget build(BuildContext ctx) {
    return super.build(ctx);
  }

  @override
  void preinit() {
    materias = [];
    hasMaterias = true;
    for (var i = 0; i < this.dias.length; i++) {
      _tabs.add(new Tab(
        text: this.dias[i],
      ));
      todayInt =
          DateTime.now().weekday - 1 == 6 ? 0 : DateTime.now().weekday - 1;
    }
    tabController = new TabController(
      length: dias.length,
      vsync: this,
      initialIndex: todayInt,
    );
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    return new Scaffold(
      appBar: this.hasMaterias ? buildTabBar() : null,
      body: this.hasMaterias ? buildTabView() : buildEmpty(),
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
      setState(() {
        this.materias.add(PLACEHOLDER);
        this.hasMaterias = false;
      });
    } else {
      this.hasMaterias = true;
      print('Setting state with materias $ret');
      setState(() {
        this.materias = ret;
      });
    }
  }

  Widget buildEmpty() {
    return Container(
        child: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Icon(
            Icons.info,
            color: Colors.grey.withAlpha(150),
            size: 64.0,
          ),
          Text(
            'Ops!',
            style: TextStyle(fontSize: 32.0, color: Colors.grey.withAlpha(150)),
          ),
          Text(
              'Parece que você não gerou a sua grade\nVá ao seu perfil de usuário para fazer isso',
              style:
                  TextStyle(fontSize: 16.0, color: Colors.grey.withAlpha(150))),
//           Container(
//              child: Center(
//                child: Text(
//                  'Não tem problema!\nUse o botão a baixo para adicionar novas atividades, como provas ou trabalhos',
//                ),
//              ),
//             margin: EdgeInsets.only(right: 8.0, left: 8.0),
//
//            ),
        ],
      ),
    ));
  }

  Widget buildTabView() {
    return new TabBarView(
      children: _tabs.map((tab) => buildCardList(tab.text)).toList(),
      controller: tabController,
    );
  }

  Widget buildTabBar() {
    TabBar tabBar = new TabBar(
      tabs: _tabs,
      controller: tabController,
      labelColor: PUC_COLOR,
      unselectedLabelColor: PUC_COLOR,
      indicatorColor: PUC_COLOR,
    );
    return tabBar;
  }

  Widget buildCardList(String key) {
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
      for (var j in i['teachers']) professores.add(j);
      cards.add(buildCard(i['subject'], time, professores, local));
    }
    if (cards.isEmpty)
      return Container(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.directions_bike,
              color: Colors.grey,
              size: 64.0,
            ),
            Text(
              '  Você não tem aulas hoje\nAproveite para dar um rolê :)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );

    return ListView.builder(
      itemBuilder: (_, int) => cards[int],
      itemCount: cards.length,
    );
  }

  Widget buildCard(title, horario, professores, sala) {
    String sbt = '$horario\n';
    for (String professor in professores) sbt += '$professor\n';
    sbt += sala;
    return Card(
      child: ListTile(
        title: cardTitle(title),
        subtitle: Text(
          sbt,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      elevation: 2.0,
    );
  }

  Widget cardTitle(String title) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            softWrap: true,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  void setToday() {
    try {
      print('YAAAAY Tab controler is $tabController');
      tabController.animateTo(todayInt);
    } catch (e) {
      print(e);
    }
  }

  void forceUpdate() {
    print('Forcing setState');
//    setState((){this.materias = [];});
  }
}
