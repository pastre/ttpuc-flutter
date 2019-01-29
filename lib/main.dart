import 'dart:async';
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Main.dart';
import 'package:horariopucpr/modules/io/Api.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/login/Login.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cron/cron.dart';
import 'package:firebase_analytics/observer.dart';
//import 'package:flutter_crashlytics/flutter_crashlytics.dart';

final String name = 'HorarioPUCPR';
final FirebaseOptions options = const FirebaseOptions(
  googleAppID: '1:904404985413:android:6cf067addcbe68c4',
  projectID: 'horariopucpr',
  databaseURL: 'https://horariopucpr.firebaseio.com',
  apiKey: 'AIzaSyDadYY1--TzqFbIxF-wMfNyNBv7oqsHC8o',
);

FirebaseApp app;
FirebaseAnalytics analytics = FirebaseAnalytics();

//var tmp  =

void main() async {
  bool isInDebugMode = false;

  FirebaseApp.configure(name: name, options: options).then((a){
    print('CONFIGURED FIREBASE!!!!!');
    app = a;
  });

//
//  FlutterError.onError = (FlutterErrorDetails details) {
//    if (isInDebugMode) {
//      // In development mode simply print to console.
//      FlutterError.dumpErrorToConsole(details);
//    } else {
//      // In production mode report to the application zone to report to
//      // Crashlytics.
//      Zone.current.handleUncaughtError(details.exception, details.stack);
//    }
//  };
//
//  await FlutterCrashlytics().initialize();
//  runZoned<Future<Null>>(() async {
//    runApp(AppWrapper());
//  }, onError: (error, stackTrace) async {
//    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
//  });
  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {


  @override
  Widget build(BuildContext c) {
    return new App();
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AppState();
  }
}

class AppState extends State<App> {
  Api api;
  Storage storage;
  bool isLogged = false;

  AppState() {
    this.isLogged = false;
  }

  @override
  void initState() {
    super.initState();
    this.isLogged = false;
    this.api = Api();
    this.storage = Storage();
    this.storage.isLogged().then((isLogged) => changeLogin(isLogged));
  }

  VoidCallback updateLogin() {
    print("Called update login");
    this.storage.isLogged().then((isLogged) => changeLogin(isLogged));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLogged == null) this.isLogged = false;
//    return MaterialApp(home: this.isLogged ? MainScreen(updateLogin) : MainScreen(updateLogin),
    return MaterialApp(
      home: this.isLogged ? MainScreen(updateLogin) : LoginWidget(updateLogin),
      title: 'Horários PUCPR',
      color: PUC_COLOR,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }

  void changeLogin(bool isLogged) {
    print('Change login');
    this.setState(() => this.isLogged = isLogged);
  }
}



//void main() => runApp(new MaterialApp(home: new MyApp()));
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//  @override
//  void initState() {
//    super.initState();
//    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//    var a = new AndroidInitializationSettings('@mipmap/ic_launcher');
//    var i = new IOSInitializationSettings();
//    var initSetttings = new InitializationSettings(a, i);
//    flutterLocalNotificationsPlugin.initialize(initSetttings,);
//
//    var android = new AndroidNotificationDetails(
//      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//    );
//    var iOS = new IOSNotificationDetails();
//    var platform = new NotificationDetails(android, iOS);
//
//    var cron = Cron();
//    cron.schedule(Schedule.parse('* * * * *'), () async {
//      print('${DateTime.now()} sou impresso a cada minuto');
//      await flutterLocalNotificationsPlugin.show(
//          0, 'New Video is out', 'Flutter Local Notification', platform,
//          payload: 'Nitish Kumar Singh is part time Youtuber');
//
//    });
//  }
//
//  Future onSelectNotification(String payload) {
//    debugPrint("payload : $payload");
//    showDialog(
//      context: context,
//      builder: (_) => new AlertDialog(
//        title: new Text('Notification'),
//        content: new Text('$payload'),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: new AppBar(
//        title: new Text('Flutter Local Notification'),
//      ),
//      body: new Center(
//        child: new RaisedButton(
//          onPressed: showNotification,
//          child: new Text(
//            'Demo',
//            style: Theme.of(context).textTheme.headline,
//          ),
//        ),
//      ),
//    );
//  }
//
//  showNotification() async {
//
//  }
//}