
import 'package:flutter/material.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({Key? key}) : super(key: key);

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  Color _rightColor = Colors.transparent;
  Color _leftColor = Colors.blue;

  bool _toDoVis = true;
  bool _ereignisseVis = false;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        bottomNavigationBar: BottomAppBar(),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Toggle
                Container(
                    height: 50,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 45,
                          child: Row(
                            children: [
                              // left
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[600]),
                                  child: IconButton(
                                      onPressed: () {
                                        _leftColor = Colors.blue;
                                        _rightColor = Colors.transparent;
                                        _toDoVis = true;
                                        _ereignisseVis = false;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.today)),
                                ),
                              ),
                              // right
                              Container(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[700]),
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Container(
                                    child: IconButton(
                                        onPressed: () {
                                          _leftColor = Colors.transparent;
                                          _rightColor = Colors.blue;
                                          _toDoVis = false;
                                          _ereignisseVis = true;
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.list)),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          height: 5,
                          child: Row(
                            children: [
                              // left
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width / 2,
                                color: _leftColor,
                              ),

                              // right
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: MediaQuery.of(context).size.width / 2,
                                color: _rightColor,
                              )
                            ],
                          ),
                        )
                      ],
                    )),

                // To-Do Page
                Visibility(
                    visible: _toDoVis,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[],
                      ),
                    )),

                // Ereignisse Page
                Visibility(
                    visible: _ereignisseVis,
                    child: Container(
                      child: Text("B"),
                    ))
              ],
            ),
          )),
        ));
  }
}
