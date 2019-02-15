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
                      children: <Widget>[Text('Versão: '), Text('0.1')],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        Text('Notas do desenvolvedor: '),
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
      body: Column(
        children: <Widget>[
          UserCardWidget(),
          barraProgresso,
          Row(
            children: <Widget>[
              Text(
                'Saldo na impressora self-service: ',
                style: titleStyle,
              ),
              SaldoWiget()
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Divider(
            indent: 8.0,
          ),


          Row(
            children: <Widget>[
              Text(
                'Código da carteirinha:',
                style: titleStyle,
              ),
              CodigoCarteirinhaWidget()
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Divider(
            indent: 16.0,
          ),
          Row(children: <Widget>[
            Text(
              'IRA (Índice de Rendimento Acadêmico):',
              style: titleStyle,
            ),
            IraWidget(),
          ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Divider(height: 16.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Picker(this.horarios)));
                },
                color: Colors.white,
                textColor: PUC_COLOR,
                child: Text('Montar sua grade'),
                elevation: 0.0,
              ),
            ],
          ),
//          Divider(height: 16.0,),
          Expanded(
            child: Align(
              child: logoutBtt,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
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


    Expanded(
      child: IconButton(
//        icon: CALENDAR_ICON,
        onPressed: () {
          Widget col = Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Saldo da impressora self-service:')
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                children: <Widget>[Text(this.userData['saldo'])],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Picker(this.horarios)));
        },
        tooltip: 'Montando sua grade',
      ),
    );
  }



  void doAlert(Widget child) {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[child],
          );
//        Container(child: child, margin: EdgeInsets.all(0.0),);
        });
  }


  Widget getProgressoCurso() {
    return Column(
      children: <Widget>[
        Padding(
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
                  value: 0.99,
                  valueColor: AlwaysStoppedAnimation<Color>(PUC_COLOR),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
