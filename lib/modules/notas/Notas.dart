import 'package:horariopucpr/modules/api/Api.dart';
import 'package:horariopucpr/modules/storage/Storage.dart' ;
import 'package:horariopucpr/modules/storage/Nota.dart' ;
import 'dart:convert';

class Notas{
  var api, storage;
  Notas(){
    this.api = new Api();
    this.storage = new Storage();
  }

  void updateNotas() async {
    await this.api.updateNotas('bruno.pastre', 'asdqwe123!@#');
    var notas = this.api.getNotas();
    this.storage.setNotas(json.encode(notas));
    print("Done updating notas");
  }

  List<Nota> getNotas(){
    var ret = new List<Nota>();
    var localNotas = this.storage.getNotas().then((notas){
      print("Got $notas");
    });
    print("Local notas $localNotas");
    return ret;
  }
}