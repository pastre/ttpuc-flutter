import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/core/Horarios.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/smaller_screens/EscolheMaterias.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/io/Storage.dart';


class UsuarioWidget extends GenericAppWidget {
  VoidCallback callback;
  HorariosWidget horarios;
  UsuarioWidget(VoidCallback callback, HorariosWidget horarios) {
    this.callback = callback;
    this.horarios = horarios;
  }

  @override
  State<StatefulWidget> createState() {
    return new UsuarioState(callback, this.horarios);
  }
}

class UsuarioState extends GenericAppState<UsuarioWidget> {
  VoidCallback callback;
  HorariosWidget horarios;

  UsuarioState(VoidCallback callback, HorariosWidget horarios) {
    this.callback = callback;
    this.horarios = horarios;
  }

  Map<String, dynamic> userData;

  @override
  void preinit() {
    this.userData = null;
  }


  @override
  Widget buildScreen(BuildContext context) {
    Widget logoutBtt = this.buildLogoutButton(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
        backgroundColor: PUC_COLOR,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info_outline), onPressed: () {
            print('Pressed info');
          })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            getUserCard(),
            Divider(indent: 8.0,),
            //getProgressoCurso(),
            getData(),
            Divider(indent: 8.0,),
            logoutBtt,
          ],
        ),
      ),
      backgroundColor: Colors.white,

    );
  }

  @override
  bool hasLoaded() {
    return this.userData != null;
  }

  @override
  void updateLocal(data) {
    this.storage.setUserData(data);
  }

  @override
  Future apiCall() {
    return this.api.getUserData();
  }

  @override
  void updateState(data) {
    setState(() {
      if(data == null){
        print('Null data');
        return;
      }
      this.userData = json.decode(data);
    });
  }

  @override
  Future loadLocal() async {
    return this.storage.getUserData();
  }

  Widget buildLogoutButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: () => this.doLogout(context),
          color: Colors.white,
          textColor: PUC_COLOR,
          child: Text('Logout'),
          elevation: 0.0,
        ),
      ],
    );
  }

  Widget getUserCard() {
    return Container(
        child: Column(children: <Widget>[
          SizedBox(height: 8.0,),
          Row(
            children: <Widget>[
              Icon(Icons.account_circle, size: 128.0, color: Colors.blueGrey,),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8.0,),
          Row(
            children: <Widget>[
              Text(this.userData['nome'])
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8.0,),
          Row(
            children: <Widget>[
              Text("@${this.userData['username']}")
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8.0,),
        ],));
  }

  Widget getData() {
    Icon MONEY_ICON = Icon(Icons.attach_money, color: PUC_COLOR,);
    Icon COD_ICON = Icon(Icons.person_pin, color: PUC_COLOR,);
    Icon CALENDAR_ICON = Icon(Icons.calendar_today, color: PUC_COLOR,);
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Expanded(
            child: IconButton(icon: MONEY_ICON, onPressed: () {
              Widget col = Column(
                children: <Widget>[
                  Row(children: <Widget>[Text('Saldo da impressora self-service:')], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,),
                  Row(children: <Widget>[Text(this.userData['saldo'])], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,),
                 ], );
              this.doAlert(col);
            }
            ),),
        Expanded(
          child: IconButton(icon: COD_ICON, onPressed: () {
            Widget col = Column(
              children: <Widget>[
                Row(children: <Widget>[Text('Código da carteirinha:')], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,),
                Row(children: <Widget>[Text(this.userData['codigo'])], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,)
              ], );
            this.doAlert(col);
          }
          ),),
        Expanded(
          child: IconButton(icon: CALENDAR_ICON, onPressed: () {
            Widget col = Column(
              children: <Widget>[
                Row(children: <Widget>[Text('Saldo da impressora self-service:')], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,),
                Row(children: <Widget>[Text(this.userData['saldo'])], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,),
              ], );
            Navigator.push(context, MaterialPageRoute(builder: (context) => Picker(this.horarios)));
          }
          ),),
      ],),
    ],);
  }

  void doAlert(Widget child) {
    showDialog(
        context: this.context, builder: (BuildContext context) {
      return SimpleDialog(children: <Widget>[child],);
//        Container(child: child, margin: EdgeInsets.all(0.0),);
    });
  }

  Widget getData1() {
    return Column(
      children: <Widget>[
        SizedBox(height: 8.0,),
        Center(
          child: Center(
            child: Row(
              children: <Widget>[
                Text('Ultima atualizacao das notas: 14:59 - 12/12/12'),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
        SizedBox(height: 8.0,),
        SizedBox(height: 8.0,),
        Row(
          children: <Widget>[
            Text('Seu saldo de impressao self-service é \$12.42'),

          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        SizedBox(height: 8.0,),
      ],
    );
  }

  Widget getProgressoCurso() {
    return
      Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Progresso no curso: '),
            ),
            Flexible(
              child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                value: 0.5,
                valueColor: AlwaysStoppedAnimation<Color>(PUC_COLOR),
              ),
            ),
          ],),
        ),
      ],
      );
  }

  void doLogout(BuildContext context) {
    print('Do logout');
    this.storage.clearData();
    this.storage.setLogin(false);
    callback();
    Navigator.pop(context);
  }
}