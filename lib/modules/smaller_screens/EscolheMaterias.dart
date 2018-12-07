import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class Picker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PickerState();
  }
}

class PickerState extends State<Picker> {

  var resp, dups, api, result, storage;

  @override
  void initState() {
    super.initState();
    this.resp = [];
    this.dups = [];
    this.result = [];
    this.storage = Storage();
    this.api = Api();

    this.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildScreen(context),
      appBar: AppBar(
        title: Text('Montando sua grade'),
//        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
        backgroundColor: PUC_COLOR,
        actions: <Widget>[
          IconButton(onPressed: () {
            print('Pressed info!');
            showModalBottomSheet(context: this.context,builder: (BuildContext context){
              return Text('Estamos tentando montar a sua grade automaticamente\n'+
              'Qualquer conflito será mostrado nesta página, e pedimos que você escolha a matéria certa\n'+
              'Esse processo só precisa ser feito uma vez', );
            });
          }, icon: Icon(Icons.info_outline),)
        ],
      ),
    );
  }

  int startTime(i) {
    var tmp = i['starttime'].split(':');
//    print('Tmp is $tmp');
    var ret = int.parse(tmp[0]) * 100 + int.parse(tmp[1]);
    print('Ret is $ret');
    return ret;
  }

  void done(List<Conflito> conflitos) {
    var days = {
      'Seg': 0,
      'Ter': 1,
      'Qua': 2,
      'Qui': 3,
      'Sex': 4,
      'Sáb': 5,
      'Dom': 6
    };
    var list = [];
    for (var i in resp) {
      Map q = i;
      list.add(q);
    }
    for (var i in conflitos) {
//      print('Loop');
      Map toAppend = i.selected();
      bool found = false;
      int day = days[toAppend['day']];
      int starttime = startTime(toAppend);
      for (int j = 0; j < resp.length; j++) {
        Map k = resp[j];
        int d = days[k['day']];
        int s = startTime(k);
//        print('Days $day $d $s $starttime ${(s == starttime) && (day > d)}');
        if ((s == starttime) && (day > d)) {
          print('Achei um lugar');
          list.insert(j, toAppend);
          found = true;
          break;
        }
        if (found) break;
      }
    }
    Map<String, dynamic> r = {'horarios': list};
    String ret = json.encode(r);
//    debugPrint('Response is $ret');
    storage.setHorarios(ret);
    api.setHorarios(ret);
    Navigator.pop(this.context);
  }

  Widget buildScreen(BuildContext context) {
    if (resp.isEmpty) return Text('Loading');
    List<Conflito> conflitos = buildConflitos();
    List<ListTile> tiles = new List<ListTile>();
    for (Conflito c in conflitos)
      tiles.add(ListTile(title: c,));
//    tiles.add(ListTile(title: MaterialButton(onPressed: (){done(conflitos);}, child: Text('Pronto'),),));
    tiles.add(ListTile(title: Material(color: PUC_COLOR,
      borderRadius: BorderRadius.circular(30.0),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: () {
          done(conflitos);
        },
        child: Text('Pronto', style: TextStyle(color: Colors.white),),
      ),
    ), //trailing: SizedBox(width: 8.0,),leading: SizedBox(width: 4.0),
    ),);
    return ListView(children: tiles,);
  }

  List<Conflito> buildConflitos() {
    var done = [];
    List<Conflito> ret = new List<Conflito>();
    for (var i in dups) {
      if (done.contains(i)) continue;
      var toAppend = [];
      for (var j in dups) {
        if (i['subject'] == j['subject']) {
          toAppend.add(j);
          done.add(j);
        }
      }
      print('Created conflito $toAppend');
      if (toAppend.isNotEmpty) ret.add(new Conflito(conflito: toAppend,));
    }

    return ret;
  }

  void updateData() async {
    var ret = await this.api.generateHorarios();
    ret = json.decode(ret);
    print('Ret is $ret');
    setState(() {
      resp = ret['horarios'];
      dups = ret['duplicados'];
    });
  }
}


class Conflito extends StatefulWidget {
  var conflito;
  int _selectedIndex = 0;

  Conflito({this.conflito});

  @override
  State<StatefulWidget> createState() {
    return _ConflitoState();
  }

  selected() => conflito[_selectedIndex];
}

class _ConflitoState extends State<Conflito> {

  Map<String, String> dias = {
    'Seg': 'Segunda',
    'Ter': 'Terça',
    'Qua': 'Quarta',
    'Qui': 'Quinta',
    'Sex': 'Sexta',
    'Sáb': 'Sábado',
    'Dom': 'Domingo'
  };

  void onChange(int value) {
    setState(() {
      widget._selectedIndex = value;
    });
  }


  Widget buildText(option) {
    var rows = <Widget>[];
    String teachers = '',
        classrooms = '';
    for (var i in option['teachers'])
      teachers += i;
    for (var i in option['classrooms']) {
      print("${option['classrooms'].indexOf(i)} < ${option['classrooms']
          .length}");
      String toAppend = '${i['sala']} - ${i['lugar']}';
//      toAppend = toAppend.replaceFirst(' - ', '\n') + 'ou';
      if (option['classrooms'].indexOf(i) < option['classrooms'].length - 1)
        classrooms += toAppend + '\n';
      else
        classrooms += toAppend;
    }
    rows.add(Row(children: <Widget>[Text(option['subject'],
      style: TextStyle(fontSize: 16.0, color: Colors.black,),
      overflow: TextOverflow.ellipsis,),
    ],),);
    rows.add(Row(children: <Widget>[
      Text(dias[option['day']], style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,)
    ],),);
    rows.add(Row(children: <Widget>[Text(
      '${option['starttime']} - ${option['endtime']}',
      style: TextStyle(color: Colors.grey),
      overflow: TextOverflow.ellipsis,)
    ],),);
    rows.add(Row(children: <Widget>[
      Expanded(
        child: Text(classrooms, style: TextStyle(color: Colors.grey,),
          overflow: TextOverflow.clip,),
      )
    ],),);
    rows.add(Row(
      children: <Widget>[Text(teachers, style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,)
      ],),);
    return Column(children: rows,);
  }

  Widget buildCard(option) {
    return new Expanded(child: Card(
        child: Padding(padding: EdgeInsets.fromLTRB(12.0, 4.0, 0.0, 4.0),
          child: buildText(option),)
    ),);
  }

  Row buildRadio(int val) {
    return Row(children: <Widget>[
      buildCard(widget.conflito[val]),
      new Radio(value: val,
        groupValue: widget._selectedIndex,
        onChanged: (int val) => onChange(val),
        activeColor: PUC_COLOR,),
    ],
    );
  }

  List<Widget> makeRadios() {
    List<Widget> ret = new List<Widget>();
    for (var i = 0; i < widget.conflito.length; i++) {
      ret.add(buildRadio(i));
    }
    ret.add(Divider());
    return ret;
  }

  Widget buildList(BuildContext context) {
    return new ListView.builder(itemBuilder: (BuildContext context, int index) {
      return new Card(child: ListTile(
        title: Text("asd"),
        subtitle: Text('qwe'),
      )
      );
    }, shrinkWrap: true,);
  }

  @override
  Widget build(BuildContext context) {
//    return buildList(context );
    return new Column(children: makeRadios());
  }
}

