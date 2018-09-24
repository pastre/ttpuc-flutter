import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';

class LoginWidget extends StatefulWidget{
  VoidCallback callback;
  LoginWidget(VoidCallback callback){
    this.callback = callback;
  }
  @override
  State<StatefulWidget> createState() {
    return LoginState(callback);
  }
}

class LoginState extends State<LoginWidget>{
  VoidCallback callback;
  Api api;
  Storage storage;
  TextEditingController userCtrl, pwdCtrl;
  bool isLoading = false;
  LoginState(VoidCallback callback){
    this.api = Api();
    this.storage = Storage();
    this.callback = callback;
    this.userCtrl = new TextEditingController();
    this.pwdCtrl = new TextEditingController();

  }

  void stopLogin(String message){
    setState(() {
      this.isLoading = false;
    });
    LOGIN_SCAFFOLD_KEY.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text(message),
        )
    );
  }

  void loginAction(isLogged)async{
    if(isLogged){
      String username = this.userCtrl.text, password = this.pwdCtrl.text;
      print('Logged!');
      this.storage.setLogin(isLogged);
      this.storage.setUsername(username);
      this.storage.setPassword(password);
      callback();
    }
    else {
      stopLogin('Usuário ou senha incorretos. Tente novamente');
    }
  }

  VoidCallback login(context)  {
    if(this.userCtrl.text == ''){
      FocusScope.of(context).requestFocus(new FocusNode());
      LOGIN_SCAFFOLD_KEY.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 4),
            content: Text('Campo de usuário está vazio!'),
          )
      );
      return null;
    }
    if(this.pwdCtrl.text == ''){
      print('Null user!');
      LOGIN_SCAFFOLD_KEY.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 4),
            content: Text('Campo de senha está vazio!'),
          )
      );
      return null;
    }
    print('text is ${this.userCtrl.text}, ${this.pwdCtrl.text}');
    setState((){isLoading = true;});
    //this.userCtrl.text = 'bruno.pastre';
    //this.pwdCtrl.text = 'asdqwe123!@#';
    this.api.setCredentials(this.userCtrl.text, this.pwdCtrl.text).then((b)
    {
      if(b){
        this.loginAction(b);
      }else{
        stopLogin('Erro no servidor! Tente novamente logo mais');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 128.0,
        child: Image.asset('assets/puc_logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: this.userCtrl,
      onFieldSubmitted: (text) => this.login(context),
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white,
        hintText: 'Usuário',

        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: this.pwdCtrl,
      onFieldSubmitted: (_) => this.login(context),
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white,
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(color: PUC_COLOR,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () => this.login(context),
          color: Colors.white,
          child: Text('Login', style: TextStyle(color: PUC_COLOR)),
        ),
      ),
    );



    return Scaffold(
      key: LOGIN_SCAFFOLD_KEY,
      backgroundColor: PUC_COLOR,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            isLoading?
            SpinKitRing(color: Colors.white, size: 16.0,): SizedBox(height: 0.0,),
            isLoading?
            SizedBox(height: 24.0, child: Text('Validando', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)): SizedBox(height: 0.0,),
            loginButton,
          ],
        ),
      ),
    );
  }



}