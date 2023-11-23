import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget{
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();

}

class _ProfileWidgetState extends State<ProfileWidget>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("PROFILE"),
      ),
    );
  }
}