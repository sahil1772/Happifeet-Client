import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportsWidget extends StatefulWidget{
  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();

}

class _ReportsWidgetState extends State<ReportsWidget>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("REPORTS"),
      ),
    );
  }
}