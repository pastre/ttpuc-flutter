import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Generic.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class HorariosWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _HorariosState();
  }

}

class _HorariosState extends GenericAppState<HorariosWidget> with TickerProviderStateMixin{
  var dias =  ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', ];
  List<Tab> _tabs = <Tab>[];
  TabController tabController;


  @override
  initState() {
    super.initState();
    for(var i = 0; i < this.dias.length; i++){
      print("$i, ${this.dias[i]}");
      _tabs.add(new Tab(text: this.dias[i], ));
    }
    tabController = new TabController(length: _tabs.length, vsync: this, initialIndex: 1, );
  }

  @override
  Widget build(BuildContext context) {
    Widget tabBar =  buildTabBar();
    Widget tabBarView = buildTabView();
    return new Scaffold(appBar: tabBar, body: tabBarView, );
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
    var cards = <Card>[
      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
      buildCard('Estatistica', '19:45 - 21:15', ['Rosane Aparecida'], 'Sala 224 - Bloco Vermelho'),
    ];
    return ListView.builder(itemBuilder: (_, int) => cards[int], itemCount: cards.length,);
  }

  Widget buildCard(title, horario, professores, sala){
    String sbt = '$horario\n';
    for(String professor in professores)
      sbt += '$professor\n';
    sbt += sala;
    return Card(child: ListTile(title: Text(title), subtitle: Text(sbt, style: TextStyle(color: Colors.grey),),),);
  }
}

