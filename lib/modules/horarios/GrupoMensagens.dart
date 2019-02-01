import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(message),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}


class _GrupoWidgetState extends State<GrupoWidget> {
  TextEditingController _textCtrl;
  ScrollController _scrlCtrl;
  DatabaseReference _messagesRef;

  StreamSubscription _messagesSubscription;
  FirebaseDatabase database = FirebaseDatabase(app: app);

  List<Message> messages;

  String username, prevString;

  bool isMuted = false;

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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () => setState(() {
                  isMuted = !isMuted;
                }),
          ),
        ],
        backgroundColor: PUC_COLOR,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.separated(
                separatorBuilder: (BuildContext ctx, int i) {
                  return SizedBox(
                    height: 12.0,
//                    color: Color(0xfff1f4e3),
                  );
                },
                itemBuilder: (BuildContext ctx, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          trailing: Container(
                            child: Row(
                              children: <Widget>[
                                username != messages[index].username
                                    ? Icon(Icons.account_circle)
                                    : SizedBox(),
                                Expanded(
                                  child: Card(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '@' + messages[index].username,
                                              style:
                                                  TextStyle(color: Colors.black54),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                          mainAxisAlignment: username ==
                                                  messages[index].username
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                        ),
                                        Divider(),
                                        Text(
                                          '${messages[index].message} \t',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '${messages[index].timestamp.hour.toString().padLeft(2, '0')}:${messages[index].timestamp.minute.toString().padLeft(2, '0')} - ${messages[index].timestamp.day.toString().padLeft(2, '0')}/${messages[index].timestamp.month.toString().padLeft(2, '0')}/${messages[index].timestamp.year.toString()}',
                                              style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: 12.0),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                          mainAxisAlignment: username ==
                                                  messages[index].username
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
                                    color: username == messages[index].username
//                                        ? Color(0xFF7eccfc)
                                        ? Colors.lightGreenAccent
//                                        : Color(0xfff1f4e3),
                                        : Colors.white,
                                    elevation: 8.0,
                                  ),
                                ),
                                username == messages[index].username
                                    ? Icon(Icons.account_circle)
                                    : SizedBox(),
                              ],
                              mainAxisAlignment:
                                  username == messages[index].username
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: messages.length,
                controller: _scrlCtrl,
                physics: ScrollPhysics(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: TextField(
                      controller: _textCtrl,
                      maxLength: 85,
                      decoration:
                          InputDecoration(hintText: 'Digite uma mensagem'),
//                      inputFormatters: <TextInputFormatter>[
//                        LengthLimitingTextInputFormatter(85),
//
//                      ],
//                      inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(85)],
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
                  width: 32.0,
                ),
              ],
            ),
          ),
        ],
      ),
//      backgroundColor: Colors.white,
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
      FocusScope.of(context).requestFocus(new FocusNode());
      _textCtrl.clear();
    });
  }

  bool isMyMessage(msg) => msg['username'] == username;

  toEnd() => _scrlCtrl.animateTo(600.0 * messages.length,
      duration: Duration(milliseconds: 500), curve: Curves.ease);
}
