import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distance_tracker/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CheckPointPage extends StatefulWidget {
  final double _distance;

  CheckPointPage(this._distance);

  @override
  _CheckPointPageState createState() => _CheckPointPageState();
}

class _CheckPointPageState extends State<CheckPointPage> {
  Position _oldPosition, _newPosition, _lastCheckpoint;
  StreamSubscription<Position> _positionStream;

  double _totalDistance = 0.0;

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Geolocator _geolocator = Geolocator();

  List<double> _checkPoints = List();

  DocumentReference _docRef =
      Firestore.instance.collection('targets').document();

  @override
  void initState() {
    startTracking();

    setData();

    initNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
        child: Column(
          children: <Widget>[
            Text(
              'TRACKING NOW...',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 100),
              textScaleFactor: 2.8,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _checkPoints.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: Text('Checkpoint ${index + 1}',
                        style: TextStyle(color: Colors.grey)),
                    trailing: Text('${_checkPoints[index].round()} m',
                        style: TextStyle(fontWeight: FontWeight.bold)));
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setCheckPointDistance();
        },
        label: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            'ADD CHECKPOINT',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  void startTracking() {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((position) {
      _oldPosition = position;
      _lastCheckpoint = position;
    });

    _positionStream = _geolocator
        .getPositionStream(
            LocationOptions(accuracy: LocationAccuracy.bestForNavigation))
        .listen((Position currentPosition) {
      _newPosition = currentPosition;

      if (_oldPosition != null) {
        _geolocator
            .distanceBetween(_oldPosition.latitude, _oldPosition.longitude,
                _newPosition.latitude, _newPosition.longitude)
            .then((distance) {
          _totalDistance += distance;

          if (_totalDistance >= widget._distance) {
            _positionStream.cancel();

            displayNotification();

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ResultPage();
            }));
          }
        });
      }

      _oldPosition = _newPosition;
    });
  }

  void setCheckPointDistance() {
    if (_lastCheckpoint != null && _newPosition != null) {
      _geolocator
          .distanceBetween(_lastCheckpoint.latitude, _lastCheckpoint.longitude,
              _newPosition.latitude, _newPosition.longitude)
          .then((distance) {
        setState(() {
          _checkPoints.add(distance);
        });
        _docRef.updateData({
          'checkpoints_distance': FieldValue.arrayUnion([distance])
        });

        _lastCheckpoint = _newPosition;
      });
    }
  }

  void initNotification() {
    var initializationSettings = new InitializationSettings(
        AndroidInitializationSettings('app_icon'), IOSInitializationSettings());

    localNotificationsPlugin.initialize(initializationSettings);
  }

  Future displayNotification() async {
    var platformChannelSpecifics = NotificationDetails(
        AndroidNotificationDetails(
            'channel id', 'channel name', 'channel description',
            importance: Importance.Max,
            priority: Priority.High,
            ticker: 'ticker'),
        IOSNotificationDetails());

    await localNotificationsPlugin.show(
        0,
        'Congratulations!',
        'You have walked ${widget._distance.round()} meters.',
        platformChannelSpecifics,
        payload: 'item x');
  }

  void setData() {
    _docRef.setData(
        {'target_distance': widget._distance, 'checkpoints_distance': []});
  }
}
