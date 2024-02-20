import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'StatusDetailPage.dart';

class FormToAddComment extends StatefulWidget{

  gotoFormToAddComment(BuildContext context) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => StatusDetailPage()));
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FormToAddComment()));
  }

  @override
  State<FormToAddComment> createState() => _FormToAddCommentState();

}

class _FormToAddCommentState extends State<FormToAddComment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}