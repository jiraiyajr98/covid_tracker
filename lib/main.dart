import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covidtracker/api/api_calls.dart';
import 'package:covidtracker/model/stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

BuildContext _context;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController _controller;
  bool isMapLoaded = false;
  Stats data;
  ApiCalls apiCalls = ApiCalls();
  Set<Circle> circles = Set();
  Set<CreateCircle> createCircleSet = Set();
  bool dataLoaded = false;
  bool cameraPositionReached = true;

  @override
  void initState() {
    super.initState();
    makeApiCall();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 2.5,
  );

  @override
  Widget build(BuildContext context) {
    _context = context;

    if (isMapLoaded) changeStyle();

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              isMapLoaded = true;
              changeStyle();
            },
            circles: circles,
          ),
          Visibility(
            visible: !dataLoaded,
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  backgroundBlendMode: BlendMode.darken),
              child: Center(
                child: TypewriterAnimatedTextKit(
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 1500),
                  speed: Duration(microseconds: 100000),
                  text: [
                    "Welcome to COVID-19 update tracker.\n",
                    "Loading live data. \n",
                    "while we do so .. \n",
                    "ALWAYS REMEMBER \n",
                    "Wash your hands regularly for 20 seconds, with soap and water or alcohol-based hand rub. \n",
                    "Cover your nose and mouth with a disposable tissue or flexed elbow when you cough or sneeze.\n",
                    "#STAY_HOME \n",
                    "#STAY_SAFE \n",
                  ],
                  textStyle: TextStyle(
                      fontSize: 35.0,
                      fontFamily: "Agne",
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                  alignment: AlignmentDirectional.topStart,
                  onFinished: () {
                    print("Finished Animation");
                    _goToLocation(20.5937, 78.9629,3.5);
                    setState(() {
                      dataLoaded = true;
                    });
                  }, // or Alignment.topLeft
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: dataLoaded
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 30.0,
              ),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    List<CreateCircle> createCircleSet2 = List<CreateCircle>();
                    return Theme(
                      data: ThemeData.dark(),
                      child: AlertDialog(
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Enter country name',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      setState(() {
                                        createCircleSet2.clear();
                                      });

                                      if (!["", null].contains(text))
                                        for (CreateCircle circle
                                            in createCircleSet) {
                                          if (circle._response.country
                                              .toLowerCase()
                                              .contains(text.toLowerCase())) {
                                            setState(() {
                                              createCircleSet2.add(circle);
                                            });
                                            print(createCircleSet2.toString());
                                          }
                                        }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    height: 250,
                                    width: 200,
                                    child: ListView.builder(
                                      itemCount: createCircleSet2.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            ShowAlert.show(
                                                createCircleSet2[index]
                                                    ._response);
                                          },
                                          child: Card(
                                            margin: EdgeInsets.all(5.0),
                                            child: Container(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                createCircleSet2[index]
                                                    ._response
                                                    .country,
                                                style:
                                                    TextStyle(fontSize: 20.0),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          : null,
    );
  }

  Future<void> _goToLocation(double latitude, double longitude,double zoom) async {
    CameraPosition _kLoc =
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoom);

    setState(() {
      cameraPositionReached = false;
    });

    _controller
        .animateCamera(CameraUpdate.newCameraPosition(_kLoc))
        .then((value) {
      Future.delayed(Duration(milliseconds: 3500), () {
        setState(() {
          cameraPositionReached = true;
        });
      });

      print("Camera Reached!!");
    }).catchError((onError) {
      cameraPositionReached = false;
    });
  }

  void makeApiCall() {
    apiCalls.fetchDetails().then((value) async {
      data = value;

      for (Response response in data.response) {
        if (![null, ""].contains(response.country))
          await Geocoder.local
              .findAddressesFromQuery(response.country)
              .then((addresses) {
            if (addresses != null) {
              CreateCircle createCircle =
                  CreateCircle(response, addresses.first);
              createCircleSet.add(createCircle);

              if (isMapLoaded && !dataLoaded && cameraPositionReached)
                _goToLocation(addresses.first.coordinates.latitude,
                    addresses.first.coordinates.longitude, 4.7);

              setState(() {
                circles.add(createCircle.createNewCircle());
              });
            }
          }).catchError((e) {
            print(e);
          });
      }

      setState(() {
        dataLoaded = true;
      });

      print("Data Loaded");
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> changeStyle() async {
    getJsonFile("assets/styles/dark_style.json").then(setStyle);
  }

  Future<String> getJsonFile(String key) async {
    return await rootBundle.loadString(key);
  }

  void setStyle(String style) {
    //print(style);
    _controller.setMapStyle(style);
  }
}

class CreateCircle {
  Response _response;
  Address _address;

  CreateCircle(this._response, this._address);

  Circle createNewCircle() {
    return Circle(
        circleId: CircleId(_response.country),
        center: LatLng(
            _address.coordinates.latitude, _address.coordinates.longitude),
        radius: getRadius(),
        fillColor: Colors.red.withOpacity(0.7),
        strokeColor: Colors.red.withOpacity(0.6),
        strokeWidth: 5,
        consumeTapEvents: true,
        onTap: () {
          ShowAlert.show(_response);
        });
  }

  double getRadius() {
    if (_response.cases.total >= 1 && _response.cases.total <= 1000)
      return 90000.0;
    else if (_response.cases.total >= 1001 && _response.cases.total <= 50000)
      return 180000.0;
    else if (_response.cases.total >= 50001 && _response.cases.total <= 100000)
      return 250000.0;
    else
      return 300000.0;
  }
}

class ShowAlert {
  static show(Response _response) {
    showDialog<void>(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.dark(),
          child: AlertDialog(
            title: Text(_response.country),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Confirmed :"),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _response.cases.total.toString(),
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text("Deaths :"),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _response.deaths.total.toString(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text("Recovered :"),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _response.cases.recovered.toString(),
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CLOSE'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
