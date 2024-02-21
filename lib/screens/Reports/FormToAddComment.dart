import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/AddComment.dart';
import '../../components/HappiFeetAppBar.dart';
import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';
import '../../network/ApiFactory.dart';
import 'StatusDetailPage.dart';

class FormToAddComment extends StatefulWidget{
  String? reportId;
  String? assignedTo;
  Function? onSuccess;
  Function? onFailure;
  Function? dataCallback;
  Function? onRequest;


  FormToAddComment(
      {this.reportId,
      this.assignedTo,
      this.onSuccess,
      this.onFailure,
      this.dataCallback,
      this.onRequest});

  gotoFormToAddComment(BuildContext context, String reportId, String? assignedTo,
      Function onSuccess, Function onRequest) {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) => AddComment(
          reportId: reportId,
          assignedTo: assignedTo,
        )))
        .then((value) {
      onSuccess();
      onRequest();
    });
  }

  @override
  State<FormToAddComment> createState() => _FormToAddCommentState();

}

class _FormToAddCommentState extends State<FormToAddComment>{
  List<FeedbackStatusDetails>? getStatusDetails;
  Future<List<FeedbackStatusDetails>>? apiResponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<List<FeedbackStatusDetails>>? getFeedbackStatusDetails() async {
    var response = ApiFactory()
        .getFeedbackStatusService()
        .getFeedbackStatusDetails("feedback_view_report", widget.reportId!);
    log("DATA IN STATUS DETAILS ${getStatusDetails}");
    getStatusDetails = await response;

    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
          .getAppBar(context),
      body: FutureBuilder<List<FeedbackStatusDetails>>(
          future: apiResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AddComment(
                reportId: widget.reportId!,
                dataCallback: () {},
                onFailure: () {},
                onSuccess: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Comment Added.")));
                  setState(() {
                    apiResponse = getFeedbackStatusDetails();
                  });

                },
                onRequest:(){
                  // CircularProgressIndicator();
                },
                assignedTo: snapshot.data!.first.assign_to,
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }

}