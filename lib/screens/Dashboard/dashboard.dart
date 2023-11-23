import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatefulWidget{
  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();

}

class _DashboardWidgetState extends State<DashboardWidget>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("DASHBOARD"),
      ),
    );
  }
}