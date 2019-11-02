import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'WOHOO!',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 100),
                  textScaleFactor: 2.8,
                ),
                Text(
                  'You have met your walking goal.',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
                  child: Image.asset('images/finish_line.png'),
                )
              ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        label: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            'HOME',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
