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


  Widget buildScreen(BuildContext context){
//    return Text('Settings');
    return MaterialButton(onPressed: () => this.doLogout(context), color: Colors.grey, textColor: Colors.deepOrange, child: Text('Logout'),);
  }



  void doLogout(BuildContext context){
    print('Do logout');
    this.storage.clearData();
    this.storage.setLogin(false);
    callback();
    Navigator.pop(context);
  }
}