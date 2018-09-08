import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/materiasPicker/Picker.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class HorariosWidget extends GenericAppWidget{
  HorariosWidget({ List<ListTile> key }) : super(list: key);
  @override
  State<StatefulWidget> createState() {
    return HorariosState();
  }
}


class HorariosState extends GenericAppState<HorariosWidget> with TickerProviderStateMixin{
  var PLACEHOLDER = 'asd';
  var materias;
  var dias =  ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom' ];
  List<Tab> _tabs = <Tab>[];
  TabController tabController;


  @override
  Widget build(BuildContext ctx) {
    return super.build(ctx);
  }

  @override
  void preinit(){
    materias = [];
    tabController = new TabController(length: _tabs.length, vsync: this, initialIndex: 1, );
  }

  @override
  Widget buildScreen(BuildContext ctx){
//    return Text('Carregado com sucesso');
    for(var i = 0; i < this.dias.length; i++){
//      print("$i, ${this.dias[i]}");
      _tabs.add(new Tab(text: this.dias[i], ));
    }
    print('My data is ${materias}');
    Widget tabBar =  buildTabBar();
    Widget tabBarView = buildTabView();
    return new Scaffold(appBar: tabBar, body: tabBarView, );
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
    print('Loding local...');
    return this.storage.getHorarios();
  }

  @override
  Future apiCall() async {
    return this.api.getHorarios();
  }

  @override
  void updateState(data) {
    var ret =  json.decode(data)['horarios'];
    print('Setting state ${ret}');
    if(ret.isEmpty){
      this.materias.add(PLACEHOLDER);
      print('Empty!!!');
      buildMaterias();
    }else {
      setState(() {
        this.materias = ret['horarios'];
      });
    }
  }

  void buildMaterias(){
    Navigator.push(
        this.context,
        MaterialPageRoute(builder: (context) => Picker()));
  }

  Widget buildTabView(){
    return new TabBarView(children: _tabs.map((tab) => buildCardList(tab.text)).toList(),
      controller: tabController,
    );
  }

  Widget buildTabBar(){
    TabBar tabBar = new TabBar(tabs: _tabs,
      controller: tabController,
      labelColor: PUC_COLOR,
      unselectedLabelColor: Color(0xFF919199),
      indicatorColor: PUC_COLOR,
    );
    return tabBar;
  }

  Widget buildCardList(String key){
//    var cards = <Card>[
//      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
//      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
//      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
//      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
//      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
//    ];
    if(materias.contains(PLACEHOLDER)){
      return MaterialButton(child: Text('Aguardando insercao das materias'), onPressed: buildMaterias,);
    }
    var cards = <Card>[];
    print('Materias is $materias');
    for(var i in materias) {
      if(!i['dia'].contains(key)) continue;
      print('I is $i');
      String time = i['horaInicio'] + ' - ' + i['horaFim'];
      String local = 'Sala ${i['sala']} - Bloco ${i['bloco']}';
      cards.add(buildCard(i['nome'], time, i['professores'].split(','),local ));
    }
    if(cards.isEmpty)
      return Text('Voce nao tem aulas hoje');
    return ListView.builder(itemBuilder: (_, int) => cards[int], itemCount: cards.length,);
  }

  Widget buildCard(title, horario, professores, sala){
    String sbt = '$horario\n';
    for(String professor in professores)
      sbt += '$professor\n';
    sbt += sala;
    return Card(child: ListTile(
      title: cardTitle(title),
      subtitle: Text(sbt, style: TextStyle(color: Colors.grey),),),elevation: 2.0,
    );
  }

  Widget cardTitle(String title){
    return Row(children: <Widget>[
      Text(title),
      eventButton(),
    ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  Widget eventButton(){
    return SizedBox(
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.lightBlue,),
        onPressed: () => print('asd'),
        iconSize: 20.0,),
      height: 25.0, width: 25.0,);
  }


  void _showAddMateria(){
    showDialog(context: null);
  }
}