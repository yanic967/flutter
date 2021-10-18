import 'dart:ui';
import 'package:auth_demo/model/user_model.dart';
import 'package:auth_demo/screens/next.dart';
import 'package:auth_demo/screens/profile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:auth_demo/extensions.dart";
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  CarouselController bottomCarouselController = CarouselController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        // Vor- und Nachname
        _name =
            "${loggedInUser.anrede} ${loggedInUser.name} ${loggedInUser.lastname}";

        // Dienstgrad
        "${loggedInUser.dienstgrad}" == "null" ||
                "${loggedInUser.dienstgrad}" == ""
            ? _dienstgrad = "Kein Dienstgrad angegeben."
            : _dienstgrad = "${loggedInUser.dienstgrad}";

        // Laufbahn
        "${loggedInUser.laufbahn}" == "null" || "${loggedInUser.laufbahn}" == ""
            ? _laufbahn = "Keine Laufbahn angegeben."
            : _laufbahn = "${loggedInUser.laufbahn}";

        // Standort
        "${loggedInUser.standort}" == "null" || "${loggedInUser.standort}" == ""
            ? _standort = "Kein Standort angegeben."
            : _standort = "${loggedInUser.standort}";

        // Dienstzeit
        "${loggedInUser.dienstantritt}" == "null" ||
                "${loggedInUser.dienstantritt}" == ""
            ? _dienstbeginn = DateTime.now()
            : _dienstbeginn = DateTime.parse("${loggedInUser.dienstantritt}");
      });
    });
  }

  late String _name = "";
  late String _dienstgrad = "";
  late String _laufbahn = "";
  late String _standort = "";
  DateTime _dienstbeginn = DateTime(2021);

  @override
  Widget build(BuildContext context) {
    int _passed = DateTime.now().difference(_dienstbeginn).inDays;
    int _years = (_passed ~/ 365);
    int _months = (_passed - _years * 365) ~/ 30;
    int _days = _passed - _years * 365 - _months * 30;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromRGBO(0, 153, 153, 1),
      resizeToAvoidBottomInset: true,
      appBar: NewGradientAppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, _routeToProfile());
              },
              icon: Icon(Icons.person_outline, color: Colors.white,))
        ],
        automaticallyImplyLeading: false,
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(40, 48, 72, 1),
            Color.fromRGBO(133, 147, 152, 1)
          ],
        ),
        title: Text("BWNext", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(40, 48, 72, 1),
                  Color.fromRGBO(133, 147, 152, 1)
                ]),
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home_outlined, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(_routeToHome());
                  },
                ),
                SizedBox(
                  width: 30,
                ),
                IconButton(
                  icon: Icon(Icons.explore_outlined, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(_routeToExplore());
                  },
                ),
              ],
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(72, 85, 99, 1),
              Color.fromRGBO(41, 50, 60, 1)
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10, top: 140, right: 10, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(),
                Column(
                  children: [
                    // Main Homepage Container
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 3, color: Colors.white),
                          boxShadow: [
                            BoxShadow(color: Colors.black, spreadRadius: 5, blurRadius: 10)
                          ],
                          color: Color.fromRGBO(196, 224, 229, 0.8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Überschrift
                          Center(
                              child: Text(_name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      decoration: TextDecoration.underline, fontWeight: FontWeight.bold))),
                          SizedBox(
                            height: 10,
                          ),

                          // Dienstgrad
                          Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(_dienstgrad,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)))),
                          SizedBox(
                            height: 10,
                          ),

                          // Laufbahn
                          Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(_laufbahn,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)))),
                          SizedBox(
                            height: 10,
                          ),

                          // Standort
                          Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(_standort,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)))),
                          SizedBox(
                            height: 10,
                          ),

                          // Dienstzeit
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: Column(
                                children: <Widget>[
                                  // Values
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Jahre
                                      Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(5))),
                                          child: Center(
                                              child: Text(_years.toString(),
                                                  style:
                                                      GoogleFonts.staatliches(
                                                          fontSize: 25)))),

                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Monate
                                      Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(5))),
                                          child: Center(
                                              child: Text(_months.toString(),
                                                  style:
                                                      GoogleFonts.staatliches(
                                                          fontSize: 25)))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Tage
                                      Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(5))),
                                          child: Center(
                                              child: Text(_days.toString(),
                                                  style:
                                                      GoogleFonts.staatliches(
                                                          fontSize: 25)))),
                                    ],
                                  ),

                                  // Titles
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Jahre
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(5))),
                                        child: Center(
                                            child: Text("Jahr(e)",
                                                style: TextStyle(
                                                    fontSize: 15))),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Monate
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(5))),
                                        child: Center(
                                            child: Text("Monat(e)",
                                                style: TextStyle(
                                                    fontSize: 15))),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      // Tage
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(5))),
                                        child: Center(
                                            child: Text("Tag(e)",
                                                style: TextStyle(
                                                    fontSize: 15))),
                                      )
                                    ],
                                  ),
                                ],
                              )))
                        ],
                      ),
                    ),
                    // Homepage Icons
                    Container(
                        padding: EdgeInsets.all(20),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            /* border: Border.all(width: 2, color: Colors.white) */),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Icon 1 (Settings)
                            Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.settings),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            // Icon 2 (List)
                            Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(context, _routeToNext());
                                  },
                                  icon: Icon(Icons.format_list_numbered),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            // Icon 4 (Share)
                            Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.share),
                                ))
                          ],
                        )), // Homepage InfoCenter

                    SizedBox(
                      height: 30,
                    ),
                    Container(height: 4, color: Colors.white),
                    SizedBox(
                      height: 20,
                    ),
                    // Homepage Infocenter
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Erster Container
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 3, color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    )),
                                Text("Auslandseinsatz Mali",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Zweiter Container
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 3, color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.info_outline,
                                        color: Colors.white)),
                                Text("Förderungen beantragen",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Route _routeToNext() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const NextScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Route _routeToProfile() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Route _routeToExplore() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Route _routeToHome() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
