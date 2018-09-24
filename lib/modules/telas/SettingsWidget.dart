import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/io/Storage.dart';


class SettingsWidget extends StatefulWidget{
  VoidCallback callback;

  SettingsWidget(VoidCallback callback){
    this.callback = callback;
  }
  @override
  State<StatefulWidget> createState() {
    return new SettingsState(callback);
  }

}

class SettingsState extends State<SettingsWidget>{
  VoidCallback callback;
  Storage storage;
  Api api;
  SettingsState(VoidCallback callback){
    this.callback = callback;
    this.api = Api();
    this.storage = Storage();
  }

  @override
  Widget build(BuildContext context) {
    print('Builded settings');
//    return Text('carregando...');
    return Scaffold(appBar: AppBar(title: Text('Ajustes'),
      backgroundColor: PUC_COLOR,),
      body: this.buildScreen(context),
      backgroundColor: Colors.white,
    );
  }

  Widget buildScreen(BuildContext context){
    Widget logoutBtt = this.buildLogoutButton(context);

    return Container(
      child: Column(
        children: <Widget>[
          getUserCard(),
//          getData(),
          logoutBtt,
        ],
      ),
    );
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

  Widget getUserCard(){
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
              Text('Joao da silva')
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8.0,),
          Row(
            children: <Widget>[
              Text('@joao.silva')
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8.0,),
          Row(
            children: <Widget>[
              Text('Código do aluno: 101893127316')
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8.0,),
          Divider(indent: 8.0,)
    ],));
  }

  Widget getData(){
      return Column(
        children: <Widget>[
          SizedBox(height: 8.0,),
          Row(
            children: <Widget>[
              Text('Ultima atualizacao das notas: 14:59 - 12/12/12'),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
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
          Divider(),
        ],
      );
  }


  void doLogout(BuildContext context){
    print('Do logout');
    this.storage.clearData();
    this.storage.setLogin(false);
    callback();
    Navigator.pop(context);
  }



}