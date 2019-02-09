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
  Bubble({this.message, this.time, this.isMe, this.username});

  final String message, time, username;
  final isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = !isMe
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
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  '@' + username,
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                  textAlign: TextAlign.end,
                ),
              ),
              Text(message),
              Text(
                time,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 10.0,
                ),
              ),
//              Padding(
//                padding: EdgeInsets.only(right: 48.0),
//                child: Text(message),
//              ),
//              Container(
////                bottom: 0.0,
////                right: 0.0,
//                child: Row(
//                  children: <Widget>[
//                    Text(time,
//                        style: TextStyle(
//                          color: Colors.black38,
//                          fontSize: 10.0,
//                        )),
//                    SizedBox(width: 3.0,),
//                  ],
//                ),
//              )
            ],
            crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
          ),
        )
      ],
    );
  }
}

class _GrupoWidgetState extends State<GrupoWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController _textCtrl;
  ScrollController _scrlCtrl;
  DatabaseReference _messagesRef;

  StreamSubscription _messagesSubscription;
  FirebaseDatabase database = FirebaseDatabase(app: app);

  List<Message> messages;

  String username, prevString;
  bool isMuted = false, inTheEnd = false;
  double currScroll = 0.0;

  FocusNode _focusNode = FocusNode();
  AnimationController _controller;
  Animation _animation;

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
//        print('${_scrlCtrl.position.maxScrollExtent}, ${messages.length}');
        toEnd();
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print('Messages is $messages');
//    toEnd();
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                getMessages(),
                inTheEnd ? SizedBox() : getDownButton()
              ],
            ),
          ),
          getKeyboard()
//          Expanded(child: ,),
        ],
      ),
//      backgroundColor: Colors.white,

      backgroundColor: Color(0xfff1f4e3),
    );
  }

  Widget getMessages() {
    List<Widget> tmp = List<Widget>();
    for (Message message in messages)
      tmp.add(Bubble(
        message: message.message,
        isMe: message.username == username,
        username: message.username,
        time:
            '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')} - ${message.timestamp.day.toString().padLeft(2, '0')}/${message.timestamp.month.toString().padLeft(2, '0')}',
      ));
    return NotificationListener<ScrollNotification>(
      onNotification: (a) {
        print('ROLANDO ${a}');
        double diff = _scrlCtrl.position.maxScrollExtent - _scrlCtrl.offset;
        print('Diff is ${diff}');
        if (diff > 200 && inTheEnd)
          setState(() {
            inTheEnd = false;
          });
        else if (diff < 200 && !inTheEnd)
          setState(() {
            inTheEnd = true;
          });
      },
      child: ScrollConfiguration(
        child: ListView(
          children: tmp,
          shrinkWrap: true,
          controller: _scrlCtrl,
        ),
        behavior: MyBehavior(),
      ),
    );
  }

  Widget getKeyboard() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                controller: _textCtrl,

//                      maxLength: 85,
                decoration: InputDecoration(hintText: 'Digite uma mensagem'),
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

  toEnd() => _scrlCtrl.animateTo(_scrlCtrl.position.maxScrollExtent,
      duration: Duration(milliseconds: 300), curve: Curves.ease);

  Widget getDownButton() {
    return Positioned(
      right: 8.0,
      bottom: 8.0,
      child: FloatingActionButton(
        onPressed: toEnd,
        mini: true,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
