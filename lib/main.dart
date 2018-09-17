import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'modules/design/Main.dart';
import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/storage/Storage.dart';
import 'modules/telas/LoginWidget.dart';


void main() {
  runApp(AppWrapper());
}


class AppWrapper extends StatelessWidget{
  @override
  Widget build(BuildContext c){
    return new App();
  }
}

class App extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }


}
typedef void MyCallback(BuildContext val);

class AppState extends State<App>{
  Api api;
  Storage storage;
  bool isLogged = false;

  AppState(){
    this.isLogged = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isLogged = false;
    this.api = Api();
    this.storage = Storage();
    this.storage.isLogged().then((isLogged) => changeLogin(isLogged));
  }

  VoidCallback updateLogin(){
    print("Called update login");
    this.storage.isLogged().then(
            (isLogged) => changeLogin(isLogged));
  }


  @override
  Widget build(BuildContext context) {
    if(this.isLogged == null) this.isLogged = false;
//    return MaterialApp(home: this.isLogged ? MainScreen(updateLogin) : MainScreen(updateLogin),
        return MaterialApp(home: this.isLogged ? MainScreen(updateLogin) : LoginWidget(updateLogin),
        title: 'Horários PUCPR',
        color: PUC_COLOR,
      //TODO:  theme: ,
    );
  }

  void changeLogin(bool isLogged){
    print('Change login');
    this.setState(() => this.isLogged = isLogged);
  }
}

