import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Random Jokes',
      home: MyHomePage(title: 'Flutter Random Jokes'),
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

  String _url = "http://api.icndb.com/jokes/random";
  StreamController _streamController;
  Stream _stream;
  Response response;

  getDogsImages() async {
    _streamController.add("waiting");
    response = await get(_url);
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getDogsImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return getDogsImages();
          },
          child: Center(
            child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == "waiting") {
                  return Center(child: Text("Waiting of the Jokes....."));
                }
                return Center(
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Center(
                          child: ListBody(
                            children: [
                              Container(
                                height: 200.0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        elevation: 2.0,
                                        child:  Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text("Jokes",style: TextStyle(letterSpacing: 1.0,fontSize: 20.0),),
                                              Container(
                                                margin: EdgeInsets.only(top: 4.0),
                                                width: 90.0,
                                                height: 1.0,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(height: 20.0,),
                                              Text(snapshot.data['value']['joke'],style: TextStyle(letterSpacing: 1.0,fontSize: 18.0),),
                                            ],
                                          ),
                                        )),
                                ),
                                  )),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
        onPressed:(){
          getDogsImages();
    },),
    );
  }
}
