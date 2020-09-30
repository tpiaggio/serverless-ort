
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() {
  runApp(
    MaterialApp(
      home: PushMessagingExample(),
    ),
  );
}

class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}
  
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class _PushMessagingExampleState extends State<PushMessagingExample> {
  String _homeScreenText = "Waiting for token...";

  Widget _buildDialog(BuildContext context, Map<String, dynamic> item) {
    return AlertDialog(
      content: Text("${item["notification"]["title"]}, ${item["notification"]["body"]}"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, message),
    );
  }


   @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _showItemDialog(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       _showItemDialog(message);
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Push Messaging Demo'),
        ),
        body: Material(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(_homeScreenText),
              ),
            ],
          ),
        ));
  }
}