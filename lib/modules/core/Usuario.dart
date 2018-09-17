import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/storage/Storage.dart';


class UsuarioWidget extends StatefulWidget{
  VoidCallback callback;

  UsuarioWidget(VoidCallback callback){
    this.callback = callback;
  }
  @override
  State<StatefulWidget> createState() {
    return new UsuarioState(callback);
  }

}

class UsuarioState extends State<UsuarioWidget>{
  VoidCallback callback;
  Storage storage;
  Api api;
  UsuarioState(VoidCallback callback){
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
          Divider(indent: 8.0,),
          getProgressoCurso(),
          Divider(indent: 8.0,),
          getData(),
          Divider(indent: 8.0,),
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
      ],
    );
  }

  Widget getProgressoCurso(){
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
                      valueColor: AlwaysStoppedAnimation<Color>(PUC_COLOR)  ,
                    ),
                ),
              ],),
          ),
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