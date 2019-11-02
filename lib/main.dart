import 'package:distance_tracker/checkpoint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(DistanceTracker());

class DistanceTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  var _fabOnPress;
  var _fabColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Text(
                'SET YOUR WALKING GOAL',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 100),
                textScaleFactor: 2.8,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Set Target Distance (meters)'),
                  onTap: () {
                    setState(() {
                      _controller.text = '15';
                      _fabColor = Colors.lightBlue;
                      _fabOnPress = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CheckPointPage(double.parse(_controller.text));
                        }));
                      };
                    });
                  },
                ),
              )
            ]),
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fabOnPress,
        label: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            'START',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: _fabColor,
      ),
    );
  }
}
