import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/ClientListing.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../model/ClientUsers/AddClientUser.dart';
import '../../../model/ClientUsers/ClientUserData.dart';
import '../../../model/ClientUsers/EditClientUser.dart';
import '../../../model/ClientUsers/UpdateClientUser.dart';
import '../../../network/ApiFactory.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

class AddClientWidget extends StatefulWidget {
  String? id;
  bool? isEdit;

  AddClientWidget({Key? key, this.id, this.isEdit});

  gotoAddClientPage(
      BuildContext context, String? id, bool? isEdit, Function? callback) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddClientWidget(
                  id: id,
                  isEdit: isEdit,
                ))).then((value) {
      print("I AM HERE BC $value");
      callback!();
    });
  }

  @override
  State<AddClientWidget> createState() => _AddClientWidgetState();
}

class _AddClientWidgetState extends State<AddClientWidget> {
  TextEditingController clinetNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController contactNoController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailnotifController = new TextEditingController();
  TextEditingController userTypeController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();
  bool isActive = false;
  bool emailNotification = false;
  AddClientUser addClientUser = AddClientUser();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  EditClientUser? editClientData;
  String? emailerror;
  UpdateClientUser dataToUpdate = UpdateClientUser();
  bool? isRefresh;
  late Future<EditClientUser?> apiResponse;

  @override
  void initState() {
    // TODO: implement initState
    apiResponse = getClientData();

    super.initState();
  }

  Future<EditClientUser?> getClientData() {
    log("GET ASSIGNED USER DATA FOR EDIT");
    if (widget.id == null) {
      log("ID IS NULL");
      return Future.value(null);
    } else {
      log("ID FOUND");
      return getClientDataForEdit();
    }
  }

  Future<EditClientUser?> getClientDataForEdit() async {
    var response = await ApiFactory()
        .getClientService()
        .editClientUserData("edit_client_users", widget.id!);

    editClientData = response;
    log("CLIENT EDIT DATA ${editClientData!.toJson()}");
    setInitialData();
    return editClientData;
  }

  setInitialData() {
    if (editClientData!.client_name != null) {
      clinetNameController.text = editClientData!.client_name!;
    }
    if (editClientData!.email_address != null) {
      // setEmailError(EmailValidator.validate(editClientData!.email_address!)
      //     ? null
      //     : "Enter valid email id");
      emailController.text = editClientData!.email_address!;
    }
    if (editClientData!.contact_no != null) {
      contactNoController.text = editClientData!.contact_no!;
    }
    if (editClientData!.username != null) {
      usernameController.text = editClientData!.username!;
    }
    if (editClientData!.email_notification != null) {
      if (editClientData!.email_notification == "Y") {
        setState(() {
          emailNotification = true;
        });
      } else {
        setState(() {
          emailNotification = false;
        });
      }
    }

    if (editClientData!.is_active != null) {
      log("editClientData!.is_active VALUE --> ${editClientData!.is_active}");
      if (editClientData!.is_active == "Y") {
        setState(() {
          isActive = true;
        });
      } else {
        setState(() {
          isActive = false;
        });
      }
    }
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
                      "${widget.isEdit! ?"Edit":"Add"} Assigned User",
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
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              Widget toReturnWidget;
                              switch (snapshot.connectionState) {
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Text("Client Name",style: TextStyle(color: Colors.black),),
                                              Text(
                                                " *",
                                                style:
                                                    TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: clinetNameController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                clinetNameController.text = value;
                                                addClientUser.client_name = value;
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
                                                            .hexToColor(
                                                                "#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor(
                                                                "#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Text("Email Id",style: TextStyle(color: Colors.black),),
                                              Text(
                                                " *",
                                                style:
                                                    TextStyle(color: Colors.red),
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
                                                setEmailError(EmailValidator
                                                        .validate(value)
                                                    ? null
                                                    : "Please enter valid email");

                                                emailController.text = value;
                                                addClientUser.email_address =
                                                    value;
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
                                                            .hexToColor(
                                                                "#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor(
                                                                "#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text("Contact No",style: TextStyle(color: Colors.black),),
                                              Text(
                                                " *",
                                                style:
                                                    TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: contactNoController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                contactNoController.text = value;
                                                addClientUser.contact_no = value;
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
                                                            .hexToColor(
                                                                "#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor(
                                                                "#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text("Username",style: TextStyle(color: Colors.black),),
                                              Text(
                                                " *",
                                                style:
                                                    TextStyle(color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          TextFormField(
                                              controller: usernameController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter value for this field';
                                                }
                                              },
                                              onChanged: (value) {
                                                usernameController.text = value;
                                                addClientUser.username = value;
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
                                                            .hexToColor(
                                                                "#D7D7D7"),
                                                        width: 1)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: ColorParser()
                                                            .hexToColor(
                                                                "#D7D7D7"))),
                                              )),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (!widget.isEdit!)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Text("Password",style: TextStyle(color: Colors.black),),
                                                Text(
                                                  " *",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                                controller: passwordController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter value for this field';
                                                  }
                                                },
                                                onChanged: (value) {
                                                  passwordController.text = value;
                                                },
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  // labelText: labelText,
                                                  hintText: 'Password',
                                                  hintStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  // errorText: getEmailError(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              color: ColorParser()
                                                                  .hexToColor(
                                                                      "#D7D7D7"),
                                                              width: 1)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: ColorParser()
                                                                  .hexToColor(
                                                                      "#D7D7D7"))),
                                                )),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (!widget.isEdit!)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Confirm Password",style: TextStyle(color: Colors.black),),
                                                Text(
                                                  " *",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextFormField(
                                                controller:
                                                    confirmpasswordController,
                                                onChanged: (value) {
                                                  confirmpasswordController.text =
                                                      value;
                                                  addClientUser.password = value;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter value for this field';
                                                  }
                                                  if (passwordController.text !=
                                                      confirmpasswordController
                                                          .text) {
                                                    return "Password does not match";
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  // labelText: labelText,
                                                  hintText: 'Confirm Password',
                                                  hintStyle: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  // errorText: getEmailError(),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              color: ColorParser()
                                                                  .hexToColor(
                                                                      "#D7D7D7"),
                                                              width: 1)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: ColorParser()
                                                                  .hexToColor(
                                                                      "#D7D7D7"))),
                                                )),
                                          ],
                                        ),
                                      if (!widget.isEdit!)
                                        SizedBox(
                                          height: 20,
                                        ),

                                      Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Row(
                                                  children: [
                                                    Text("Email Notification", style: TextStyle(
                                                        color: Colors.black,
                                                        ),),
                                                    Text(
                                                      " *",
                                                      style:
                                                      TextStyle(color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 10.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        FlutterSwitch(
                                                            width: 120,
                                                            value: emailNotification,
                                                            activeColor:   ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                            showOnOff: true,
                                                            valueFontSize: 16,
                                                            activeText: "Active",
                                                            inactiveText: "InActive",
                                                            onToggle: (value) {
                                                              setState(() {
                                                                log("toggle ${value}");
                                                                if (value) {
                                                                  addClientUser
                                                                      .email_notification =
                                                                  "Y";
                                                                } else {
                                                                  addClientUser
                                                                      .email_notification =
                                                                  "N";
                                                                }
                                                                emailNotification = value;
                                                              });
                                                            }
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Row(
                                                  children: [
                                                    Text("Status", style: TextStyle(
                                                        color: Colors.black,
                                                        ),),
                                                    Text(
                                                      " *",
                                                      style:
                                                      TextStyle(color: Colors.red),
                                                    ),
                                                  ],
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
                                                            activeColor:   ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                            showOnOff: true,
                                                            valueFontSize: 16,
                                                            activeText: "Active",
                                                            inactiveText: "InActive",
                                                            onToggle: (value) {
                                                              setState(() {
                                                                log("toggle ${value}");
                                                                if (value) {
                                                                  addClientUser.status = "Y";
                                                                } else {
                                                                  addClientUser.status = "N";
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
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 170,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (widget.isEdit!) {
                                                  /** IF UPDATING NEW USER **/
                                                  log("API CALLED FOR UPDATE USER ${widget.id}");
                                                  dataToUpdate.id = widget.id;
                                                  dataToUpdate.client_name =
                                                      clinetNameController.text;
                                                  dataToUpdate.email_address =
                                                      emailController.text;
                                                  dataToUpdate.contact_no =
                                                      contactNoController.text;
                                                  dataToUpdate.username =
                                                      usernameController.text;
                                                  dataToUpdate.password =
                                                      confirmpasswordController
                                                          .text;
                                                  if (emailNotification) {
                                                    dataToUpdate
                                                        .email_notifiction = "Y";
                                                  } else {
                                                    dataToUpdate
                                                        .email_notifiction = "N";
                                                  }

                                                  if (isActive) {
                                                    dataToUpdate.status = "Y";
                                                  } else {
                                                    dataToUpdate.status = "N";
                                                  }

                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    var response =
                                                        await ApiFactory()
                                                            .getClientService()
                                                            .updateClientUserData(
                                                                dataToUpdate);
                                                    if (response.status == "1") {
                                                      log("CLIENT DATA UPDATED SUCCESSFULLY!");
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "CLIENT data updated successfully")));
                                                      Future.delayed(
                                                          Duration(seconds: 2),
                                                          () {
                                                        Navigator.pop(
                                                            context, [true]);
                                                      });
                                                    } else {
                                                      log("CLIENT DATA UPDATION FAILED");
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Please enter required field")));
                                                  }
                                                } else {
                                                  /** IF ADDING NEW USER **/

                                                  log("API CALLED FOR ADD USER");
                                                  if (_formkey.currentState!
                                                      .validate()) {
                                                    var response =
                                                        await ApiFactory()
                                                            .getClientService()
                                                            .submitClientUserData(
                                                                addClientUser);
                                                    if (response.status == "1") {
                                                      log("USER DATA SUBMIT SUCCESS");
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Data Submitted Successfully")));

                                                      Future.delayed(
                                                          Duration(seconds: 2),
                                                          () {
                                                        Navigator.pop(
                                                            context, true);
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "${response.msg}")));
                                                    }
                                                  } else {
                                                    log("Validation Unsuccessful");
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: ColorParser()
                                                      .hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
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
    );
  }
}
