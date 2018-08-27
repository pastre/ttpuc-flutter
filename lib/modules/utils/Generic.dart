import 'package:flutter/material.dart';

import 'package:horariopucpr/modules/storage/Storage.dart' ;
import 'package:horariopucpr/modules/api/Api.dart';

abstract class GenericAppState<T extends StatefulWidget> extends State{
  Api api;
  Storage storage;
  var data, setStorageData, getStorageData, fetchApiData, updateApiData;

  @override
  void initState() {
    super.initState();
    this.api = new Api();
    this.storage = new Storage();
    this.fetchData();
  }
  void setCallbacks(setStorageData, getStorageData, fetchApiData, updateApiData){this.setStorageData = setStorageData;
    this.getStorageData = getStorageData;
    this.fetchApiData = fetchApiData;
    this.updateApiData = updateApiData;
  }

  void fetchData(){

  }

}