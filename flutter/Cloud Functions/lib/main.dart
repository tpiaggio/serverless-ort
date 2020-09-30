import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Practico Serverless'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List nameList = [
    "Rolling", "Bitles", "Dedors", "Ledseplin", 
    "Pinfloi", "Kwin", "Elvis",  "Flitwud", 
    "Aba", "ArtiMonkis", "DeClash",  "Nirbana",
    "Colplei", "BlaKis", "EriKlaptn",  "PolMacarni", 
  ];

  Widget _buildListItem(BuildContext context, DocumentSnapshot info){
    return ListTile(
      onTap: (){},
      title: Row(
        children: [
          Expanded(
            child: Text(
              info.data["name"],

            ),
          ),
        ],
      ),
      trailing: 
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.blueGrey,
                padding: EdgeInsets.all(10),
                child: Text(
                  info.data["votes"].toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              InkWell(
                  onTap: (){
                      info.reference.updateData({"votes":info.data["votes"]+1});
                  },
                child: Container(
                  width: 50,
                  child: Icon(Icons.arrow_upward)),
              ),
              InkWell(
                  onTap: (){
                      info.reference.delete();
                  },
                child: Container(
                  width: 30,
                  child: Icon(Icons.delete)),
              )
            ],
          ),
    );
  }
  FirebaseUser firebaseUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.currentUser().then((thisUser){
      setState(() {
      firebaseUser = thisUser;
      });
    });
  }

  void refreshUser(){
    // _auth.currentUser().then((thisUser){
    //   if(thisUser!=firebaseUser){
    //     setState(() {
    //     firebaseUser = thisUser;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    // _auth.currentUser().then((thisUser){
    //   if(thisUser!=firebaseUser){
    //     setState(() {
    //     firebaseUser = thisUser;
    //     });
    //   }
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          
          StreamBuilder<FirebaseUser>(
            stream: _auth.onAuthStateChanged,
            builder: (context, snapshot) {
                firebaseUser = snapshot?.data;
              return FlatButton(
                  child: Text((firebaseUser==null) ? 'Sign In': 'Sign out'),
                  textColor: Theme
                      .of(context)
                      .buttonColor,
                  onPressed: () async {
                    
                    if (firebaseUser == null) {
//6
                       Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailPasswordForm()),
                      );
                      return;
                    }
                    await _auth.signOut();
                    refreshUser();
                    final String uid = firebaseUser.email;
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(uid + ' has successfully signed out.'),
                    ));
                  },
                );
            }
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('bandnames').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Text("Loading");
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder:(context, index)=>
              _buildListItem(context, snapshot.data.documents[index])
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Firestore.instance.collection('bandnames').add({"name":nameList[Random().nextInt(nameList.length)], "votes":0});
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), 
    );
  }
}


class RegisterEmailSection extends StatefulWidget {
  final String title = 'Register';



  @override
  State<StatefulWidget> createState() => 
      RegisterEmailSectionState();
}
class RegisterEmailSectionState extends State<RegisterEmailSection> {
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _success;
String _userEmail;
String error;


@override
Widget build(BuildContext context) {
    if((_success??false)&&_userEmail!=null){
      Future.delayed(Duration(seconds: 1)).then((_){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 
                'Password'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _register();
                }
              },
              child: const Text('Submit'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(_success == null
                ? ''
                : (_success
                    ? 'Successfully registered ' + _userEmail
                    : error),
                    style: TextStyle(color: (_success!=null&&!_success) ? Colors.red : Colors.black),),
          ),
          
        ],
      ),
    ),
  );
}

void _register() async {
  final FirebaseUser user = (await 
      _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).catchError((signInError){
    setState(() {
      _success = false;
      this.error = signInError.message;
    });
  })
  ).user;
  if (user != null) {
    setState(() {
      _success = true;
      _userEmail = user.email;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  } else {
    setState(() {
      _success = true;
    });
  }
}

@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
}


class EmailPasswordForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => EmailPasswordFormState();
}
class EmailPasswordFormState extends State<EmailPasswordForm> {
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String error;
  @override
  Widget build(BuildContext context) {
    if((_success??false)&&_userEmail!=null){
      Future.delayed(Duration(seconds: 1)).then((_){
        Navigator.of(context).pop();
      });
    }
    return Scaffold(
       appBar: AppBar(
      title: Text("Sign In"),
    ),
          body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
            obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _signInWithEmailAndPassword();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _success == null
                    ? ''
                    : (_success
                    ? 'Successfully signed in ' + _userEmail
                    : error),
                style: TextStyle(color: Colors.red),
              ),
            ),
          RichText(text: TextSpan(
              text: 'Click here to Register',
              style:  TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterEmailSection()),
                  );
                }),)
          ],
        ),
      ),
    );
  }


void _signInWithEmailAndPassword() async {
  final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
    email: _emailController.text,
    password: _passwordController.text,
  ).catchError((signInError){
    setState(() {
      _success = false;
      this.error = signInError.message;
    });
  })).user;
  
  if (user != null) {
    setState(() {
      _success = true;
      _userEmail = user.email;
    });
  } else {
    setState(() {
      _success = false;
    });
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}