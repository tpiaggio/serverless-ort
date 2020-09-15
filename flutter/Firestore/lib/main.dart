import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List nameList = ["Rolling", "Bitles", "Dedors", "Ledseplin", 
  "Pinfloi", "Kwin", "Elvis",  "Flitwud", 
   "Aba", "ArtiMonkis", "DeClash",  "Nirbana",
    "Colplei", "BlaKis", "EriKlaptn",  "PolMacarni", ];

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
                  info.data["votes"].toString()
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
