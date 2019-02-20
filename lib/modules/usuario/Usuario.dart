import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horariopucpr/modules/core/Generic.dart';
import 'package:horariopucpr/modules/horarios/Horarios.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/horarios/EscolheMaterias.dart';
import 'package:horariopucpr/modules/notas/Ira.dart';
import 'package:horariopucpr/modules/usuario/CodigoCarteirinhaWidget.dart';
import 'package:horariopucpr/modules/usuario/ProgressoCurso.dart';
import 'package:horariopucpr/modules/usuario/Saldo.dart';
import 'package:horariopucpr/modules/usuario/UserCard.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/io/Storage.dart';

class UsuarioWidget extends StatefulWidget {
  VoidCallback callback;
  HorariosWidget horarios;

  UsuarioWidget(VoidCallback callback, HorariosWidget horarios) {
    this.callback = callback;
    this.horarios = horarios;
    print('Instantiated usuario');
  }

  @override
  State<StatefulWidget> createState() {
    return new UsuarioState(callback, this.horarios);
  }
}

class UsuarioState extends State<UsuarioWidget> {
  VoidCallback callback;
  HorariosWidget horarios;

  final key = new GlobalKey<ScaffoldState>();

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
  Widget build(BuildContext context) {
    Widget logoutBtt = this.buildLogoutButton(context);
    Widget barraProgresso = BarraProgressoCurso();
    TextStyle titleStyle =
        TextStyle(color: PUC_COLOR, fontWeight: FontWeight.bold);
    List<Widget> widgets = [];
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text('Ajustes'),
        backgroundColor: PUC_COLOR,
        actions: <Widget>[
          // TODO: Quando for para arquivar a atividade
//          IconButton(icon: Icon(Icons.archive, color: Colors.white,), onPressed: () {
//            Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext ctx){
//              return ArchievedActivities();
//            }));
//          }),
//          IconButton(icon: Icon(Icons.delete), onPressed: (){
//            Storage().resetData().then((ok){
//              doAlert(Text('SEUS DADOS FORAM APAGADOS!'));
//            });
//          }),
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                print('Pressed info');
                doAlert(Column(
                  children: <Widget>[
                    Text(
                      ' › Horários PUCPR',
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[Text('Versão: '), Text('0.2')],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Text('Sobre: '),
                        Column(
                          children: getNotasDev(),
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )
                      ],
//                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Divider(),

                    Column(
                      children: <Widget>[
                        Text('Notas dessa versão: '),
                        Column(
                          children: getDoneSteps(),
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )
                      ],
//                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Text('Vindo ai: '),
//                        SizedBox(height: 2.0,),
                        Column(
                          children: getNextSteps(),
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )
                      ],
//                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Divider(),
                    Text(
                      'Por favor, inclua a versão se for enviar algum erro para o desenvolvedor!',
                      overflow: TextOverflow.clip,
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.start,
                ));
              })
        ],
      ),
      body: ListView(
        children: <Widget>[
          UserCardWidget(),
          barraProgresso,
          Divider(
            height: 8.0,
          ),
          ListTile(
            title: Text(
              'Saldo na impressora self service',
              textDirection: TextDirection.ltr,
              style: titleStyle,
            ),
            trailing: SaldoWiget(),
          ),
          ListTile(
            title: Text(
              'Código da carteirinha:',
              style: titleStyle,
            ),
            trailing: CodigoCarteirinhaWidget(),
          ),
          ListTile(
            title: Text(
              'IRA (Índice de Rendimento Acadêmico):',
              style: titleStyle,
            ),
            trailing: IraWidget(),
          ),
          Divider(
            height: 8.0,
          ),
          ListTile(
            title: MaterialButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Picker(this.horarios),
                  ),
                );
              },
              color: Colors.white,
              textColor: PUC_COLOR,
              child: Text('Montar sua grade'),
              elevation: 0.0,
            ),
          ),
          ListTile(
            title: logoutBtt,
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Future loadLocal() async {
    return Storage().getUserData();
  }

  Widget buildLogoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

  void doAlert(Widget child) {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[child],
          );
        });
  }

  void doLogout(BuildContext context) {
    print('Do logout');
    Storage().setLogin(false);
    Storage().clearData().then((ok) {
      print('DID IT? $ok');
      callback();
      Navigator.pop(context);
    });
  }
}
