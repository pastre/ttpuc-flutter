import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/storage/Storage.dart';


class SettingsWidget extends StatelessWidget{
  VoidCallback callback;
  Storage storage;

  SettingsWidget(VoidCallback callback){
    this.callback = callback;
    this.storage = Storage();
  }

  @override
  Widget build(BuildContext context) {
    print('Builded settings');
//    return Text('carregando...');
    return Scaffold(appBar: AppBar(title: Text('Configurações'), backgroundColor: PUC_COLOR,),body: this.buildScreen(context),backgroundColor: Colors.white,);
  }

  Widget buildLogoutButton(BuildContext context) {
    return MaterialButton(onPressed: () => this.doLogout(context), color: Colors.white, textColor: PUC_COLOR, child: Text('Logout'),);
  } 

  Widget buildOptionsList(){
    return ListView(  // This next line does the trick.
      children: <Widget>[
        ListTile(
          title: MaterialButton(
            onPressed: () => {},
            child: Text('Sobre'), ),
          leading: Icon(Icons.question_answer),),
//        MaterialButton(onPressed: () => {}, child: Text('Adicionar materia'),),
      ],
    );
  }

  Widget buildScreen(BuildContext context){
    Widget logoutBtt = this.buildLogoutButton(context);
    return Stack(children: <Widget>[
      Positioned(
          child:
            ListView.builder(itemBuilder: (a, b){

            }),
          top: 0.0,
          left: 0.0,
      ),
      Positioned(child: logoutBtt, bottom: 0.0, right: 0.0, left: 0.0,)
    ],
      fit: StackFit.expand,
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