import 'dart:async';

import 'package:flutter/material.dart';

import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/login/LoadingScreen.dart';



abstract class GenericAppWidget extends StatefulWidget{
  var state;
  String name;
  GenericAppWidget({this.state, this.name}){
    print('${this.name} was instantiated');
    this.state.fetchData();
  }

  @override
  State<StatefulWidget> createState() {
    print('Creating state for $name');
    return this.state;
  }
}

class GenericAppState< T extends GenericAppWidget> extends State<GenericAppWidget>{
  Api api;
  Storage storage;
  bool isLoading;
  bool needsScaffold = true;

  @override
  void initState() {
    super.initState();
    this.preinit();
    this.api = new Api();
    this.storage = new Storage();
    this.isLoading = false;
    needsScaffold = false;
    this.fetchData();
  }

  void preinit(){
    // OVERRIDE THIS METHOD TO LOAD FIELDS
  }

  @override
  Widget build(BuildContext ctx){
    print("Builded ${(widget.name)}");
    if(!this.hasLoaded() || isLoading){
      this.fetchData();
      print('Returinig LOADING SCREEN while loading data');
      return loadingScreen();
    }
    return this.buildScreen(ctx);
  }


  Widget loadingScreen(){
    if(needsScaffold)
    return Scaffold(body: LoadingWidget(),);
    return LoadingWidget();
  }

  Widget buildScreen(BuildContext ctx){
    // OVERRIDE THIS METHOD TO BUILD THE SCREEN
  }

  bool hasLoaded(){
    // OVERRIDE THIS METHOD WHEN THE SCREEN IS READY TO BE PRESENTED
  }
  

  void updateLocal(data){
    print('Updated local for $this');
    // OVERRIDE WITH STORAGE FUNCTION TO PERSIST DATA
  }

  Future apiCall() async{
    print('API call for $this');
    // OVERRIDE WITH API CALL
  }
  Future loadLocal() async{
    // OVERRIDE WITH GET DATA FROM STORAGE
  }
  void updateState(data){
    // OVERRIDE THIS WITH setState BEHAVIOUR
  }

  void fetchData() async{
    //if(this.isLoading) return;
    print("Fetching data for ${this}");
    var localData = await this.loadLocal();
    if(localData is Map){
      localData.forEach((k, v){
        if(v == null) localData = null;
      });
    }
    if(localData == null) {
      print('Null');
      await this.apiCall().then((data) {
        this.updateLocal(data);
      });
    }
      localData = await this.loadLocal();
      print('loadedLocal $localData');
      if(mounted)
        updateState(localData);
  }

  Future updateData() async{
    await this.apiCall().then((data) {
      this.updateLocal(data);
      this.updateState(data);
    });
  }

}
