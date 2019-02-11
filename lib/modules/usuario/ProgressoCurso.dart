import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:horariopucpr/main.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/login/LoadingScreen.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class Materia {
  String nome, carga, periodo;
  bool completed;

  Materia(this.nome, this.completed, this.carga, this.periodo);
}

class BarraProgressoCurso extends GenericAppWidget {
  BarraProgressoCurso()
      : super(state: BarraProgressoCursoState(), name: "BarraProgresso");

  @override
  State<StatefulWidget> createState() {
    return BarraProgressoCursoState();
  }
}

class BarraProgressoCursoState extends GenericAppState<BarraProgressoCurso> {
  bool hasGenerated = null, canLoad = true;

  Map<String, dynamic> by_periods;


  @override
  void preinit() {
    by_periods = Map<String, dynamic>();

  }

  void generateProgress() {
    this.setState(() {
      isLoading = true;
    });
    Api().generateAjustes().then((data) {
      Storage().setAjustes(data);
      updateState(data);
    });
  }


  @override
  Widget buildScreen(BuildContext ctx) {
    if (isLoading) return LoadingWidget();
    if (!hasGenerated) {
      Widget test = OutlineButton(
        onPressed: generateProgress,
        borderSide: BorderSide(color: Colors.white),
        child: Text(
          'Carregar seu progresso no curso',
          style: TextStyle(color: PUC_COLOR),
        ),
      );
      return Container(child: test);
    }

    int sumConc = 0, sumTt = 0;

    by_periods.forEach((key, materias) {
      for (var i in materias) {
        if (i['completed']) sumConc += int.parse(i['carga'].toString());
        sumTt += int.parse(i['carga'].toString());
      }
    });
    double pctConcluida = sumConc / sumTt;
    print(' LEN IS  ${by_periods.keys.length}');
    print('PCT IS $pctConcluida $sumConc $sumTt');
    return GestureDetector(
      onTap: () {
        print(' BY PERIODS IS $by_periods');
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
          return DetailedProgressoCurso(by_periods);
        }));
        print('Pressed');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Progresso no curso: '),
            ),
            Flexible(
              child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                value: pctConcluida,
                valueColor: AlwaysStoppedAnimation<Color>(PUC_COLOR),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${(pctConcluida * 100).round()}%',
                style: TextStyle(color: PUC_COLOR),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget loadingScreen() {
    return Text('ASDADASDASDAS ');
  }

  @override
  bool hasLoaded() {
    return hasGenerated != null;
  }

  @override
  void updateLocal(data) {
    Storage().setAjustes(data);
  }

  @override
  Future loadLocal() {
    return Storage().getAjustes();
  }

  @override
  Future apiCall() {
    return Api().getAjustes();
  }

  @override
  void updateState(data) {
    if (data == null) return;
    var ret = json.decode(data)['ajustes'];
    if (ret is bool) {
      setState(() {
        hasGenerated = false;
      });
    } else {
//      ret = ret['by_periods'];
      setState(() {
        Map<String, dynamic> tmp = Map<String, dynamic>();
        for(int i = 0; i < ret.length; i ++) {
          if (ret[i] == null)continue;
          tmp.putIfAbsent(i.toString(), () => ret[i]);
        }
//        print(' TMP IS $tmp');
        by_periods = tmp;
        hasGenerated = true;
      });
    }
  }
}

class DetailedProgressoCurso extends StatelessWidget {
  var materias;

  DetailedProgressoCurso(this.materias);

  @override
  Widget build(BuildContext context) {
//    var byPeriodo = this.groupByPeriodos();
    debugPrint('DICT IS ${materias.runtimeType.toString()} ${materias.keys}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PUC_COLOR,
        title: Text('Seu progresso no curso'),
      ),
      body: ListView.builder(
        itemCount: materias.keys.length,
        itemBuilder: (context, int) {
          print('INT IS $int');
          return PeriodoWidget(materias[(int + 1).toString()], int + 1);
        },
        shrinkWrap: true,
      ),
    );
  }
//
//  List groupByPeriodos() {
//    var all = new List.from(completed)..addAll(missing);
//    all = all.toSet().toList();
//    List ret = [], done = [];
//    for (Map<String, dynamic> i in all) {
//      var group = [];
//      if (done.contains(i['periodo'])) continue;
//      for (Map<String, dynamic> j in all) {
//        if (i['periodo'] == j['periodo']) group.add(j);
//      }
//      done.add(i['periodo']);
//      print('Done is $done');
//      ret.add(group.toSet().toList());
////      if(i['periodo'] == 10 ||i['periodo'] == '10') print('################################################################');
//    }
//    return ret;
//  }
}

class PeriodoWidget extends StatelessWidget {
  List materias;
  var periodo;

  PeriodoWidget(this.materias, this.periodo);

  int pctConcluida() {
    int ret = 0;
    print(' Materias is $materias');
    for (var i in materias) {
      if (i['completed']) ret++;
    }
    print('Materias is $ret, ${materias.length}');
    return (ret / materias.length * 100).round();
  }

  List<Widget> getMaterias() {
    List<Widget> l = [];
    for (var i in materias) {
      l.add(MateriaWidget(i));
    }

    return l;
  }

  @override
  Widget build(BuildContext context) {
//    print('Materias is ${materias[0]}');
    String title = '${periodo}º Período';
    String pct = '${pctConcluida()}% concluído';
    return ExpansionTile(
      title: Row(
        children: <Widget>[
          Text(title),
          Text(pct),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      children: getMaterias(),
    );
  }
}

class MateriaWidget extends StatelessWidget {
  Map<String, dynamic> data;

  MateriaWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        this.data['nome'],
        style: TextStyle(color: Colors.black38),
      ),
      trailing: data['completed']
          ? Icon(
              Icons.check,
              color: Colors.lightBlueAccent,
            )
          : Icon(
              Icons.clear,
              color: Colors.red,
            ),

    );
  }
}
