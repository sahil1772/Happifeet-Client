import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:happifeet_client_app/model/AssignedUsers/UpdateAssignedUserData.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageUsers/AssignedUserListing.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../model/AssignedUsers/AssignedUserData.dart';
import '../../../model/AssignedUsers/SubmitAssignedUserData.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

class AddAssignedUserWidget extends StatefulWidget {
  String? id;
  bool? forEdit;

  AddAssignedUserWidget({Key? key, this.id, this.forEdit});

  goToAddAssignedUser(
      BuildContext context, String? id, bool forEdit, Function? callback) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddAssignedUserWidget(
                  id: id,
                  forEdit: forEdit,
                ))).then((value) {
                  log("callback called in goToAddAssignedUser!");
                  callback!();
    }
    );
  }

  @override
  State<AddAssignedUserWidget> createState() => _AddAssignedUserWidgetState();
}

class _AddAssignedUserWidgetState extends State<AddAssignedUserWidget> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController remarkController = new TextEditingController();
  bool isActive = false;
  SubmitAssignedUserData submitAssignedUserData = SubmitAssignedUserData();
  AssignedUserData? dataForEditing;
  UpdateAssignedUserData? dataForUpdation = UpdateAssignedUserData();
  String? emailerror;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late Future<AssignedUserData?> apiResponse;

  @override
  void initState() {
    // TODO: implement initState



    apiResponse = getAssignedUserData();

    // if (widget.forEdit!) {
    //   log("FOR EDIT");
    //    getUserDataForEdit();
    // } else {
    //   submitAssignedUserData.status = "N";
    //   log("FOR ADDD");
    // }

    log("ID IN ADD ASSIGNED USER ${widget.id}");

    super.initState();
  }
  Future<AssignedUserData?> getAssignedUserData(){
    log("GET ASSIGNED USER DATA FOR EDIT");
    if(widget.id == null){
      log("ID IS NULL");
      return Future.value(null);
    }else{
      log("ID FOUND");
      return getUserDataForEdit();

    }

  }

  Future<AssignedUserData?> getUserDataForEdit() async {
    var response = await ApiFactory()
        .getUserService()
        .editUserData("edit_assigned_users", widget.id!);


    dataForEditing = response;
    log("DATA FOR EDIT --> ${dataForEditing!.toJson()}");
    setInitialData();
    return dataForEditing;

  }

  setInitialData() {
    if (dataForEditing!.name != null) {
      userNameController.text = dataForEditing!.name!;
    }
    if (dataForEditing!.contactno != null) {
      contactController.text = dataForEditing!.contactno!;
    }
    if (dataForEditing!.emailid != null) {
      emailController.text = dataForEditing!.emailid!;
    }
    if (dataForEditing!.note_remark != null) {
      remarkController.text = dataForEditing!.note_remark!;
    }
    if (dataForEditing!.is_active != null) {
      if (dataForEditing!.is_active == "Y") {
        setState(() {
          isActive = true;
        });
      } else {
        setState(() {
          isActive = false;
        });
      }
    }

    //
    //   submitAssignedUserData.user_id = await SharedPref.instance.getUserId();
    // submitAssignedUserData.client_name = userNameController.text;
    // submitAssignedUserData.contact_no =  contactController.text ;
    // submitAssignedUserData.email_address =  emailController.text ;
    // submitAssignedUserData.note =  remarkController.text;
    // submitAssignedUserData.status = isActive.toString();
  }

  getEmailError() {
    return emailerror;
  }

  setEmailError(value) {
    emailerror = value;
  }



  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4.5;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false,callback: (){
        Navigator.of(context).pop();
      })
          .getAppBar(context),
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              Container(
                  height: DeviceDimensions.getHeaderSize(context, HEADER_HEIGHT),
                  width: DeviceDimensions.getDeviceWidth(context),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                          ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!)
                        ],
                      )),
                  child: Container(
                    margin: DeviceDimensions.getHeaderEdgeInsets(context),
                    child:  Center(
                      child: Text(
                        "List Assigned User",
                        // "Select Location".tr(),
                        // "Select Location".language(context),
                        // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                        style: TextStyle(
                            color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_text_color!),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),

                     Container(
                       height:
                       DeviceDimensions.getBottomSheetHeight(context, HEADER_HEIGHT),
                       margin: EdgeInsets.only(
                           top: DeviceDimensions.getBottomSheetMargin(
                               context, HEADER_HEIGHT)),
                       padding: const EdgeInsets.symmetric(horizontal: 16),
                       decoration: const BoxDecoration(
                           borderRadius: BorderRadius.only(
                               topLeft: Radius.circular(25),
                               topRight: Radius.circular(25)),
                           color: Colors.white),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 22),
                          child: Form(
                            key: _formkey,
                            child: FutureBuilder(
                              future: apiResponse,
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                Widget toReturnWidget;
                                switch(snapshot.connectionState){
                                  case ConnectionState.waiting:
                                    toReturnWidget = const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(56.0),
                                          child: CircularProgressIndicator(),
                                        ));
                                    break;
                                  case ConnectionState.done:
                                    if (snapshot.data != null) {
                                      log("Connection Done => ${snapshot.data!.toJson()}");
                                    }
                                    toReturnWidget = Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Name", style: TextStyle(
                                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                  fontWeight: FontWeight.w700),),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        " *",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: userNameController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                userNameController.text = value;
                                                submitAssignedUserData.client_name =
                                                    value;
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                // labelText: labelText,
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                                // errorText: getEmailError(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                               Text("Contact No", style: TextStyle(
                                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                  fontWeight: FontWeight.w700),),
                                              Text(
                                                " *",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: contactController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                contactController.text = value;
                                                submitAssignedUserData.contact_no =
                                                    value;
                                              },
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                // labelText: labelText,
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                                // errorText: getEmailError(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Row(
                                            children: [
                                              Text("Email ID", style: TextStyle(
                                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                  fontWeight: FontWeight.w700),),
                                              Text(
                                                " *",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: emailController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                setEmailError(
                                                    EmailValidator.validate(value)
                                                        ? null
                                                        : "Please enter valid email");

                                                emailController.text = value;
                                                submitAssignedUserData.email_address =
                                                    value;
                                                setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                // labelText: labelText,
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                                errorText: getEmailError(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                               Text("Remark", style: TextStyle(
                                                  color:ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                  fontWeight: FontWeight.w700),),
                                              Text(
                                                " *",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: remarkController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                remarkController.text = value;
                                                submitAssignedUserData.note = value;
                                              },
                                              maxLines: 5,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                // labelText: labelText,
                                                hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                                // errorText: getEmailError(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor("#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),



                                      Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                 Text(
                                                  "Status",
                                                  style: TextStyle(
                                                      color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                      fontWeight: FontWeight.w700),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 10.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        FlutterSwitch(
                                                          width: 120,
                                                          value: isActive,
                                                          activeColor: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                          showOnOff: true,
                                                          valueFontSize: 16,
                                                          activeText: "Active",
                                                          inactiveText: "InActive",
                                                            onToggle: (value) {
                                                              setState(() {
                                                                log("toggle ${value}");
                                                                if (value) {
                                                                  submitAssignedUserData.status = "Y";
                                                                } else {
                                                                  submitAssignedUserData.status = "N";
                                                                }
                                                                isActive = value;
                                                              });
                                                            }
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          )),

                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: 250),
                                      //   child: FlutterSwitch(
                                      //       padding: 6,
                                      //       width: 110,
                                      //       height: 30,
                                      //       activeColor: Colors.green,
                                      //       showOnOff: true,
                                      //       valueFontSize: 16,
                                      //       activeText: "Active",
                                      //       inactiveText: "InActive",
                                      //       value: isActive,
                                      //       onToggle: (value) {
                                      //         setState(() {
                                      //           log("toggle ${value}");
                                      //           if (value) {
                                      //             submitAssignedUserData.status = "Y";
                                      //           } else {
                                      //             submitAssignedUserData.status = "N";
                                      //           }
                                      //           isActive = value;
                                      //         });
                                      //       }
                                      //       ),
                                      // ),

                                      SizedBox(
                                        height: 30,
                                      ),

                                      SizedBox(
                                        height: 40,
                                        width: 170,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (widget.forEdit!) {
                                              /** IF UPDATING NEW USER **/
                                              log("API CALLED FOR UPDATE USER ${widget.id}");
                                              dataForUpdation!.id = widget.id;
                                              dataForUpdation!.client_name =
                                                  userNameController.text;
                                              dataForUpdation!.contact_no =
                                                  contactController.text;
                                              dataForUpdation!.email_address =
                                                  emailController.text;
                                              dataForUpdation!.note =
                                                  remarkController.text;
                                              if (isActive) {
                                                dataForUpdation!.status = "Y";
                                              } else {
                                                dataForUpdation!.status = "N";
                                              }

                                              var response = await ApiFactory()
                                                  .getUserService()
                                                  .updateUserData(dataForUpdation!);
                                              if (response.status == "1") {
                                                log("USER DATA UPDATED SUCCESSFULLY!");
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "User data updated successfully")));
                                                Future.delayed(Duration(seconds: 2),
                                                        () {
                                                      Navigator.pop(context, [true]);
                                                    });
                                              } else {
                                                log("USER DATA UPDATION FAILED");
                                              }
                                            } else {
                                              /** IF ADDING NEW USER **/

                                              log("API CALLED FOR ADD USER");
                                              if (_formkey.currentState!.validate()) {

                                                var response = await ApiFactory()
                                                    .getUserService()
                                                    .submitUserData(
                                                    submitAssignedUserData);
                                                if (response.status == "1") {
                                                  log("USER DATA SUBMIT SUCCESS");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Data Submitted Successfully")));

                                                  Future.delayed(Duration(seconds: 3),
                                                          () {
                                                        Navigator.pop(context, true);
                                                      });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Please enter required field")));
                                                }
                                              }
                                            }

                                            // AddLocation().gotoAddLocation(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)))),
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  );
                                    break;
                                  case ConnectionState.active:
                                    toReturnWidget = const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(56.0),
                                          child: CircularProgressIndicator(),
                                        ));
                                    break;
                                  case ConnectionState.none:
                                    toReturnWidget = const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(56.0),
                                          child: CircularProgressIndicator(),
                                        ));
                                    break;


                                }
                                return toReturnWidget;

                              },

                            ),
                          ),
                        ),
                      ),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
