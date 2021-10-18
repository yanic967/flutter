import 'dart:ui';
import 'package:auth_demo/extensions.dart';
import 'package:intl/intl.dart';

import 'package:auth_demo/model/user_model.dart';
import 'package:card_settings/helpers/platform_functions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String dienstantrittValue = "";
  String dienstantrittText = "";
  DateTime dienstantrittDateTime = DateTime.now();

  final GlobalKey<FormState> _settingsFormKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _auth = FirebaseAuth.instance;

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
        "${loggedInUser.anrede}" == "null" || "${loggedInUser.anrede}" == ""
            ? anredeValue = "Herr"
            : anredeValue = "${loggedInUser.anrede}";
        // Vorname
        nameSettingsController.text = "${loggedInUser.name}";
        // Nachname
        lastnameSettingsController.text = "${loggedInUser.lastname}";
        // Geburtsdatum
        _geburtsdatumValueText = "${loggedInUser.geburtstag}";
        // Straße
        "${loggedInUser.anschrift}" == "null"
            ? anschriftSettingsController.text = ""
            : anschriftSettingsController.text = "${loggedInUser.anschrift}";
        // Hausnummer
        "${loggedInUser.hausnummer}" == "null"
            ? hausnummerSettingsController.text = ""
            : hausnummerSettingsController.text = "${loggedInUser.hausnummer}";
        // PLZ
        "${loggedInUser.plz}" == "null"
            ? plzSettingsController.text = ""
            : plzSettingsController.text = "${loggedInUser.plz}";
        // Ort
        "${loggedInUser.ort}" == "null"
            ? ortSettingsController.text = ""
            : ortSettingsController.text = "${loggedInUser.ort}";
        // Dienstantritt
        "${loggedInUser.dienstantritt}" == "null"
            ? dienstantrittValue = ""
            : dienstantrittValue = "${loggedInUser.dienstantritt}";
        dienstantrittDateTime = DateTime.parse(dienstantrittValue);
        dienstantrittText =
            "${dienstantrittDateTime.day}.${dienstantrittDateTime.month}.${dienstantrittDateTime.year}";
        // Laufbahn
        laufbahnValue = "${loggedInUser.laufbahn}";
        if (laufbahnValue == "") {
          _dienstgradValues = ["Laufbahn erforderlich"];
          laufbahnValue = "Neueinstieg";
        } else if (laufbahnValue == "Neueinstieg") {
          _dienstgradValues = ["Neueinstieg"];
        } else if (laufbahnValue == "Mannschafter") {
          _dienstgradValues = [
            "Soldat",
            "Gefreiter",
            "Obergefreiter",
            "Hauptgefreiter",
            "Stabsgefreiter",
            "Oberstabsgefreiter"
          ];
        } else if (laufbahnValue == "Unteroffizier") {
          _dienstgradValues = [
            "Unteroffizier",
            "Fahnenjunker",
            "Stabsunteroffizier",
            "Feldwebel",
            "Fähnrich",
            "Oberfeldwebel",
            "Hauptfeldwebel",
            "Oberfähnrich",
            "Stabsfeldwebel",
            "Oberstabsfeldwebel"
          ];
        } else if (laufbahnValue == "Offizier") {
          _dienstgradValues = [
            "Leutnant",
            "Oberleutnant",
            "Hauptmann",
            "Stabshauptmann",
            "Major",
            "Oberstleutnant",
            "Brigadegeneral",
            "Generalmajor",
            "Generalleutnant",
            "General"
          ];
        }
        // Dienstgrad
        "${loggedInUser.dienstgrad}" == "null" ||
                "${loggedInUser.dienstgrad}" == ""
            ? dienstgradValue = _dienstgradValues[0]
            : dienstgradValue = "${loggedInUser.dienstgrad}";
        // Dienstverhältnis
        "${loggedInUser.dienstverhaeltnis}" == "null" ||
                "${loggedInUser.dienstverhaeltnis}" == ""
            ? verhaeltnisValue = "Ausstehend"
            : verhaeltnisValue = "${loggedInUser.dienstverhaeltnis}";
        // Standort
        "${loggedInUser.standort}" == "null"
            ? standortSettingsController.text = ""
            : standortSettingsController.text = "${loggedInUser.standort}";

        // E-Mail
        emailValue = "${loggedInUser.email}";

        // Telefon
        "${loggedInUser.telefon}" == "null"
            ? telefonSettingsController.text = ""
            : telefonSettingsController.text = "${loggedInUser.telefon}";
      });
    });
  }

  // Persönliche Informationen //
  // Geschlecht
  final anredeSettingsController = DropdownButtonFormField(items: []);
  String anredeValue = "Herr";
  // Vorname
  final nameSettingsController = TextEditingController();
  String nameValue = "";
  // Nachname
  late final lastnameSettingsController = TextEditingController();
  String lastnameValue = "";
  // E-Mail
  final emailSettingsController = TextEditingController();
  String emailValue = "";
  // Telefon
  final telefonSettingsController = TextEditingController();
  String telefonValue = "";
  // Geburtstag
  final geburtsdatumSettingsController = TextEditingController();
  DateTime _geburtsdatumValue = DateTime(2000, 01, 01);
  String _geburtsdatumValueText = "";

  // Anschrift //
  // Straße
  final anschriftSettingsController = TextEditingController();
  String _anschriftValue = "";
  // Hausnummer
  final hausnummerSettingsController = TextEditingController();
  String hausnummerValue = "";
  // Postleitzahl
  final plzSettingsController = TextEditingController();
  String plzValue = "";
  // Ort
  final ortSettingsController = TextEditingController();
  String ortValue = "";

  // Dienstliche Informationen
  // Laufbahn
  final laufbahnSettingsController = DropdownButtonFormField(items: []);
  String laufbahnValue = "Mannschafter";

  // Dienstgrad
  final dienstgradSettingsController = DropdownButtonFormField(items: []);
  List<String> _dienstgradValues = [""];
  String dienstgradValue = "";

  // Dienstverhältnis
  final verhaeltnisSettingsController = DropdownButtonFormField(items: []);
  String verhaeltnisValue = "Ausstehend";

  final standortSettingsController = TextEditingController();
  String standortValue = "Standort";
  final verwendungSettingsController = DropdownButtonFormField(items: []);
  String verwendungValue = "Verwendung";
  final erfahrungsstufenSettingsController = DropdownButtonFormField(items: []);
  String erfahrungsstufenValue = "Erfahrungsstufeneinstieg";
  // Informationen für Zulagen und Förderungen
  final familienstandSettingsController = DropdownButtonFormField(items: []);
  String familienstandValue = "Ledig";
  final kinderanzahlSettingsController = TextEditingController();
  String kinderanzahlValue = "0";
  final schlafortSettingsController = DropdownButtonFormField(items: []);
  String schlafortValue = "Heimschläfer";
  final steuererklaerungSettingsController = DropdownButtonFormField(items: []);
  String steuererklaerungValue = "Ja / Nein";
  final steuererklaerungWertSettingsController = TextEditingController();
  String steuererklaerungWertValue = "Letzte Rückzahlung";
  final vwlSettingsController = DropdownButtonFormField(items: []);
  bool vwlValue = false;
  final vwlWertSettingsController = TextEditingController();
  String vwlWertValue = "Monatliche Sparsumme";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(8, 32, 50, 1),
        appBar: NewGradientAppBar(
          actions: [
            Padding(
                padding: EdgeInsets.all(5),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                  child: MaterialButton(
                    onPressed: () {
                      _handleSubmit();
                    },
                    child: Text("Speichern"),
                  ),
                ))
          ],
          title: Text("Mein Profil",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(40, 48, 72, 1),
              Color.fromRGBO(133, 147, 152, 1)
            ],
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, _routeToHome());
              },
              icon: Icon(Icons.arrow_back)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
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
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _settingsFormKey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                // Persönliche Informationen Slide
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(blurRadius: 3, color: Colors.black)
                        ],
                        color: Color.fromRGBO(58, 96, 115, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: <Widget>[
                      // Überschrift
                      Container(
                          height: 40,
                          padding: EdgeInsets.all(6),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(10)),
                              boxShadow: [BoxShadow(blurRadius: 5)],
                              color: Colors.black),
                          child: Text(
                            "Person",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),

                      // Anrede
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _checkAnrede(anredeValue),
                            items: <String>["Herr", "Frau", "Divers"]
                                .map<DropdownMenuItem<String>>(
                                    (String dropdownValue) {
                              return DropdownMenuItem<String>(
                                value: dropdownValue,
                                child: Text(dropdownValue),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                anredeValue = newValue!;
                              });
                            },
                            underline: Container(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                decoration: TextDecoration.none),
                            dropdownColor: Colors.grey,
                          )),

                      SizedBox(
                        height: 20,
                      ),
                      // Vorname
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                              autofocus: false,
                              controller: nameSettingsController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{3,}$');
                                if (value!.isEmpty) {
                                  return ("Dein Name wird benötigt.");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid name(Min. 3 Character)");
                                }
                                return null;
                              },
                              onSaved: (value) {
                                nameValue = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              decoration: InputDecoration(
                                labelText: "Vorname",
                                labelStyle: TextStyle(color: Colors.white),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                hintText: "Vorname",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))),

                      SizedBox(
                        height: 20,
                      ),

                      // Nachname
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                              autofocus: false,
                              controller: lastnameSettingsController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{3,}$');
                                if (value!.isEmpty) {
                                  return ("Dein Name wird zur Registrierung benötigt.");
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter Valid name(Min. 3 Character)");
                                }
                                return null;
                              },
                              onSaved: (value) {
                                lastnameValue = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              decoration: InputDecoration(
                                labelText: "Nachname",
                                labelStyle: TextStyle(color: Colors.white),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                hintText: "Nachname",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))),

                      SizedBox(
                        height: 20,
                      ),

                      // Geburtsdatum
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        child: Material(
                          color: Colors.transparent,
                          child: MaterialButton(
                            onPressed: () {
                              _pickBirthday();
                            },
                            child: Text(
                              _geburtsdatumValueText == ""
                                  ? "Geburtsdatum auswählen"
                                  : "Geburtsdatum: $_geburtsdatumValueText",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Adresse

                      // Straße und Hausnummer //
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Straße
                            Container(
                                width: 250,
                                child: TextFormField(
                                    autofocus: false,
                                    controller: anschriftSettingsController,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{3,}$');
                                      if (value!.isEmpty) {
                                        return ("Dein Name wird zur Registrierung benötigt.");
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("Enter Valid name(Min. 3 Character)");
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _anschriftValue = value!;
                                    },
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    decoration: InputDecoration(
                                      labelText: "Straße",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 4)),
                                      hintText: "Straße",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ))),

                            SizedBox(
                              width: 10,
                            ),
                            // Hausnummer
                            Container(
                                width: 90,
                                child: TextFormField(
                                    autofocus: false,
                                    controller: hausnummerSettingsController,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{1,}$');
                                      if (value!.isEmpty) {}
                                      if (!regex.hasMatch(value)) {}
                                      return null;
                                    },
                                    onSaved: (value) {
                                      hausnummerValue = value!;
                                    },
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    decoration: InputDecoration(
                                      labelText: "Nr.",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 4)),
                                      hintText: "Nr.",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ))),
                          ]),

                      SizedBox(
                        height: 10,
                      ),

                      // PLZ und Ort //
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // PLZ
                            Container(
                                width: 100,
                                child: TextFormField(
                                    autofocus: false,
                                    controller: plzSettingsController,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{1,}$');
                                      if (value!.isEmpty) {}
                                      if (!regex.hasMatch(value)) {}
                                      return null;
                                    },
                                    onSaved: (value) {
                                      plzValue = value!;
                                    },
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    decoration: InputDecoration(
                                      labelText: "PLZ",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 4)),
                                      hintText: "PLZ",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ))),

                            SizedBox(
                              width: 10,
                            ),
                            // Ort
                            Container(
                                width: 240,
                                child: TextFormField(
                                    autofocus: false,
                                    controller: ortSettingsController,
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{1,}$');
                                      if (value!.isEmpty) {}
                                      if (!regex.hasMatch(value)) {}
                                      return null;
                                    },
                                    onSaved: (value) {
                                      ortValue = value!;
                                    },
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    decoration: InputDecoration(
                                      labelText: "Ort",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 4)),
                                      hintText: "Ort",
                                      hintStyle:
                                          TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ))),
                          ]),
                    ])),

                SizedBox(height: 20),
                // Dienstrelevante Informationen
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(58, 96, 115, 1),
                      border: Border.all(width: 4, color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Überschrift
                      Container(
                          height: 40,
                          padding: EdgeInsets.all(6),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(10)),
                              boxShadow: [BoxShadow(blurRadius: 5)],
                              color: Colors.black),
                          child: Text(
                            "Dienst",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      // Dienstantritt
                      Container(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Material(
                            color: Colors.transparent,
                            child: MaterialButton(
                              onPressed: () {
                                _pickDienstantritt();
                              },
                              child: Text(
                                dienstantrittValue == ""
                                    ? "Dienstbeginn angeben"
                                    : "Dienstantritt: $dienstantrittText",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Laufbahn
                      SizedBox(height: 10),
                      Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            "Laufbahn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: laufbahnValue,
                            items: <String>[
                              "Neueinstieg",
                              "Mannschafter",
                              "Unteroffizier",
                              "Offizier"
                            ].map<DropdownMenuItem<String>>(
                                (String dropdownValue) {
                              return DropdownMenuItem<String>(
                                value: dropdownValue,
                                child: Text(dropdownValue),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue == "") {
                                  _dienstgradValues = ["Laufbahn erforderlich"];
                                  laufbahnValue = "Neueinstieg";
                                } else if (newValue == "Neueinstieg") {
                                  _dienstgradValues = ["Neueinstieg"];
                                } else if (newValue == "Mannschafter") {
                                  _dienstgradValues = [
                                    "Soldat",
                                    "Gefreiter",
                                    "Obergefreiter",
                                    "Hauptgefreiter",
                                    "Stabsgefreiter",
                                    "Oberstabsgefreiter"
                                  ];
                                } else if (newValue == "Unteroffizier") {
                                  _dienstgradValues = [
                                    "Unteroffizier",
                                    "Fahnenjunker",
                                    "Stabsunteroffizier",
                                    "Feldwebel",
                                    "Fähnrich",
                                    "Oberfeldwebel",
                                    "Hauptfeldwebel",
                                    "Oberfähnrich",
                                    "Stabsfeldwebel",
                                    "Oberstabsfeldwebel"
                                  ];
                                } else if (newValue == "Offizier") {
                                  _dienstgradValues = [
                                    "Leutnant",
                                    "Oberleutnant",
                                    "Hauptmann",
                                    "Stabshauptmann",
                                    "Major",
                                    "Oberstleutnant",
                                    "Brigadegeneral",
                                    "Generalmajor",
                                    "Generalleutnant",
                                    "General"
                                  ];
                                }
                                laufbahnValue = newValue!;
                                dienstgradValue = _dienstgradValues[0];
                              });
                            },
                            underline: Container(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                            dropdownColor: Colors.grey,
                          )),

                      SizedBox(height: 10),
                      // Dienstgrad
                      Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            "Dienstgrad",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dienstgradValue,
                            items: _dienstgradValues
                                .map<DropdownMenuItem<String>>(
                                    (String dropdownValue) {
                              return DropdownMenuItem<String>(
                                value: dropdownValue,
                                child: Text(dropdownValue),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dienstgradValue = newValue!;
                              });
                            },
                            underline: Container(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                            dropdownColor: Colors.grey,
                          )),

                      SizedBox(height: 10),
                      // Dienstverhältnis
                      Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            "Dienstverhältnis",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: verhaeltnisValue,
                            items: <String>[
                              "Ausstehend",
                              "Freiwilliger Wehrdienst",
                              "Soldat auf Zeit",
                              "Berufssoldat"
                            ].map<DropdownMenuItem<String>>(
                                (String dropdownValue) {
                              return DropdownMenuItem<String>(
                                value: dropdownValue,
                                child: Text(dropdownValue),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                verhaeltnisValue = newValue!;
                              });
                            },
                            underline: Container(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                            dropdownColor: Colors.grey,
                          )),

                      SizedBox(height: 20),
                      // Standort
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                              autofocus: false,
                              controller: standortSettingsController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{2,}$');
                                if (value!.isEmpty) {}
                                if (!regex.hasMatch(value)) {}
                                return null;
                              },
                              onSaved: (value) {
                                standortValue = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              decoration: InputDecoration(
                                labelText: "Standort",
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                hintText: "Standort",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                // Kontakt
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(blurRadius: 3, color: Colors.black)
                      ],
                      color: Color.fromRGBO(58, 96, 115, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Überschrift
                      Container(
                          height: 40,
                          padding: EdgeInsets.all(6),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(10)),
                              boxShadow: [BoxShadow(blurRadius: 5)],
                              color: Colors.black),
                          child: Text(
                            "Kontakt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),

                      SizedBox(height: 10),
                      // E-Mail
                      Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            "E-Mail",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                              enabled: false,
                              autofocus: false,
                              controller: emailSettingsController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{2,}$');
                                if (value!.isEmpty) {}
                                if (!regex.hasMatch(value)) {}
                                return null;
                              },
                              onSaved: (value) {},
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: emailValue,
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                hintStyle: TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))),

                      SizedBox(height: 10),
                      // Telefon
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                              autofocus: false,
                              controller: telefonSettingsController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{2,}$');
                                if (value!.isEmpty) {}
                                if (!regex.hasMatch(value)) {}
                                return null;
                              },
                              onSaved: (value) {
                                telefonValue = value!;
                              },
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.white,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              decoration: InputDecoration(
                                labelText: "Telefon",
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                hintStyle: TextStyle(color: Colors.white54),
                                hintText: "Telefon",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))),
                    ],
                  ),
                )
              ]),
            ),
          ),
        )));
  }

  // Page Routes
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
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(seconds: 2));
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
          const WelcomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  void _handleSubmit() async {
    final FormState form = _settingsFormKey.currentState!;
    if (form.validate()) {
      form.save();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;

      UserModel userModel = UserModel();

      // writing all the values
      userModel.email = user!.email;
      userModel.uid = user.uid;

      userModel.name = nameValue;
      userModel.lastname = lastnameValue;
      userModel.anrede = anredeValue;
      userModel.geburtstag = _geburtsdatumValueText;
      userModel.anschrift = _anschriftValue;
      userModel.hausnummer = hausnummerValue;
      userModel.ort = ortValue;
      userModel.plz = plzValue;
      userModel.dienstantritt = dienstantrittValue;
      userModel.laufbahn = laufbahnValue;
      userModel.dienstgrad = dienstgradValue;
      userModel.dienstverhaeltnis = verhaeltnisValue;
      userModel.standort = standortValue;
      userModel.telefon = telefonValue;
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.refreshProfile());

      Navigator.pushReplacement(context, _routeToHome());
    } else {}
  }

  String _checkAnrede(anrede) {
    if (anrede != null) {
      return anrede;
    } else if (anrede == null) {
      return "Herr";
    }
    return "Herr";
  }

  void _pickDienstantritt() async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1930),
            lastDate: DateTime.now())
        .then((pickedDienstantritt) {
      if (pickedDienstantritt == null) {
        return;
      }
      setState(() {
        dienstantrittValue = "$pickedDienstantritt";
        dienstantrittText =
            "${pickedDienstantritt.day}.${pickedDienstantritt.month}.${pickedDienstantritt.year}";
      });
    });
  }

  void _pickBirthday() async {
    showDatePicker(
            context: context,
            initialDate: _geburtsdatumValue,
            firstDate: DateTime(1930),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _geburtsdatumValue = pickedDate;
        _geburtsdatumValueText =
            "${pickedDate.year}.${pickedDate.month}.${pickedDate.day}";
      });
    });
  }
}
