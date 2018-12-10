import 'dart:async';

import 'package:flutter/material.dart';

import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/smaller_screens/LoadingScreen.dart';



abstract class GenericAppWidget extends StatefulWidget{
  var state;
  GenericAppWidget({this.state});



  @override
  State<StatefulWidget> createState() {
    return this.state;
  }
}

class GenericAppState<GenericAppWidget> extends State{
  Api api;
  Storage storage;



  @override
  void initState() {
    super.initState();
    this.preinit();
    this.api = new Api();
    this.storage = new Storage();
    this.fetchData();
  }

  void preinit(){
    // OVERRIDE THIS METHOD TO LOAD FIELDS
  }

  @override
  Widget build(BuildContext ctx){
    print("Builded");
    if(!this.hasLoaded()){
      this.fetchData();
      return new Scaffold(body: LoadingWidget(),);
    }
    return this.buildScreen(ctx);
  }

  Widget buildScreen(BuildContext ctx){
    // OVERRIDE THIS METHOD TO BUILD THE SCREEN
  }

  bool hasLoaded(){
    // OVERRIDE THIS METHOD WHEN THE SCREEN IS READY TO BE PRESENTED
  }
  

  void updateLocal(data){
    // OVERRIDE WITH STORAGE FUNCTION TO PERSIST DATA
  }

  Future apiCall() async{
    // OVERRIDE WITH API CALL
  }
  Future loadLocal() async{
    // OVERRIDE WITH GET DATA FROM STORAGE
  }
  void updateState(data){
    // OVERRIDE THIS WITH setState BEHAVIOUR
  }

  void fetchData() async{
    print("Fetching data");
    var localData = await this.loadLocal();
    print('Loaded local');
    if(localData == null) {
      print('Null');
      await this.apiCall().then((data) {
        this.updateLocal(data);
      });
    }
      localData = await this.loadLocal();
      print('loadedLocal $localData');
      updateState(localData);
  }

}
