import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:horariopucpr/main.dart';
import 'package:horariopucpr/modules/io/Storage.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

class GrupoWidget extends StatefulWidget {
  final String msgKey;
  final String subtitle;

  const GrupoWidget({Key key, this.msgKey, this.subtitle}) : super(key: key);

  @override
  _GrupoWidgetState createState() => _GrupoWidgetState();
}

class Message {
  String username;
  String message;
  DateTime timestamp;

  Message(this.username, this.message, this.timestamp);

  Message.fromDict(Map<String, dynamic> map) {
    print('MAP IS $map');
    username = map['username'];
    message = map['message'];
    timestamp =
        DateTime.fromMillisecondsSinceEpoch(int.parse(map['timestamp']));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _GrupoWidgetState extends State<GrupoWidget> {
  TextEditingController _textCtrl;
  ScrollController _scrlCtrl;
  DatabaseReference _messagesRef;

  StreamSubscription _messagesSubscription;
  FirebaseDatabase database = FirebaseDatabase(app: app);

  List<Message> messages;

  String username;

  @override
  void initState() {
    super.initState();
    Storage().getUsername().then((username) => this.username = username);
    _textCtrl = TextEditingController();
    _scrlCtrl = ScrollController();

    database = FirebaseDatabase(app: app);
    messages = List();
    _messagesRef = FirebaseDatabase.instance
        .reference()
        .child('messages/groups/${widget.msgKey}');
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _messagesSubscription =
        _messagesRef.limitToLast(200).onChildAdded.listen((Event event) {
      var tmp = event.snapshot.value;
      print('TMP IS $tmp');
      setState(() {
        messages.add(Message(tmp['username'], tmp['message'],
            DateTime.fromMillisecondsSinceEpoch(int.parse(tmp['timestamp']))));
        print('${_scrlCtrl.position.maxScrollExtent}, ${messages.length}');
        toEnd();
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Messages is $messages');
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(
          this.widget.subtitle,
          overflow: TextOverflow.clip,
        ),
        backgroundColor: PUC_COLOR,
      ),
      body: FractionallySizedBox(
        heightFactor: 1.0,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            itemBuilder: (BuildContext ctx, int index) {
              return index < messages.length
                  ? ListTile(
                      trailing: Container(
                        child: Row(
                          children: <Widget>[
                            username != messages[index].username
                                ? Icon(Icons.account_circle)
                                : SizedBox(),
                            Card(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '@' + messages[index].username,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Divider(),
                                  Text(messages[index].message),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                              ),
                              color: Color(0xFF7eccfc),
                            ),
                            username == messages[index].username
                                ? Icon(Icons.person_pin)
                                : SizedBox(),
                          ],
                          mainAxisAlignment:
                              username == messages[index].username
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                        ),
                        padding: EdgeInsets.only(left: 3.0),
                      ),
                    )
                  : Row(
                      children: <Widget>[
                        Flexible(
                          child: Card(
                            child: TextField(
                              controller: _textCtrl,
                              decoration: InputDecoration(
                                  hintText: 'Digite uma mensagem'),
                            ),
                          ),
                        ),
                        Container(
                          child: RawMaterialButton(
                            onPressed: () => sendMessage(),
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.send,
                              color: SUBTEXT_COLOR,
                            ),
                          ),
                          width: 36.0,
                        ),
                      ],
                    );
            },
            itemCount: messages.length + 1,
            controller: _scrlCtrl,
            physics: ScrollPhysics(),
          ),
        ),
      ),
      backgroundColor: Color(0xfff1f4e3),
    );
  }

  sendMessage() {
//    print('Pushed');
    _messagesRef.push().set(<String, String>{
      'username': "" + this.username,
      'message': _textCtrl.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    }).whenComplete(() {
      //TODO: UNCOMMENT THIS BEFORE COMMITING
//      _ctrl.clear();
    });
  }

  toEnd() => _scrlCtrl.animateTo(600.0 * messages.length,
      duration: Duration(milliseconds: 500), curve: Curves.ease);
}
