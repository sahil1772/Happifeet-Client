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
import '../../../utils/ColorParser.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isEdit!) {
      log("FOR EDIT");
      getClientDataForEdit();
    } else {
      log("FOR ADDD");
    }

    super.initState();
  }

  Future<void> getClientDataForEdit() async {
    var response = await ApiFactory()
        .getClientService()
        .editClientUserData("edit_client_users", widget.id!);
    editClientData = response;
    log("CLIENT EDIT DATA ${editClientData!.toJson()}");
    setInitialData();
  }

  setInitialData() {
    if (editClientData!.client_name != null) {
      clinetNameController.text = editClientData!.client_name!;
    }
    if (editClientData!.email_address != null) {
      setEmailError(EmailValidator.validate(editClientData!.email_address!)
          ? null
          : "Enter valid email id");
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
          .getAppBar(context),
      body: Stack(
        children: [
          Container(
              height: 300,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorParser().hexToColor("#34A846"),
                  ColorParser().hexToColor("#83C03D")
                ],
              )),
              child: Column(children: [
                // SizedBox(height: 105),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add Client',
                        // "Select Location".tr(),
                        // "Select Location".language(context),
                        // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white),
                  // color: Colors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 22),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Client Name"),
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
                                    const Text("Email Id"),
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
                                      addClientUser.email_address = value;
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
                                    const Text("Contact No"),
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
                                    const Text("Username"),
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
                            if (!widget.isEdit!)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Password"),
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
                            if (!widget.isEdit!)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Confirm Password"),
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
                                      controller: confirmpasswordController,
                                      onChanged: (value) {
                                        confirmpasswordController.text = value;
                                        addClientUser.password = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter value for this field';
                                        }
                                        if (passwordController.text !=
                                            confirmpasswordController.text) {
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
                            if (!widget.isEdit!)
                              SizedBox(
                                height: 20,
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Email Notification"),
                                    Text(
                                      " *",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 290),
                                  child: FlutterSwitch(
                                      padding: 6,
                                      width: 80,
                                      height: 30,
                                      activeColor: Colors.green,
                                      showOnOff: true,
                                      valueFontSize: 16,
                                      activeText: "Yes",
                                      inactiveText: "No",
                                      value: emailNotification,
                                      onToggle: (value) {
                                        setState(() {
                                          log("toggle ${value}");
                                          if (value) {
                                            addClientUser.email_notification =
                                                "Y";
                                          } else {
                                            addClientUser.email_notification =
                                                "N";
                                          }
                                          emailNotification = value;
                                        });
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Status"),
                                    Text(
                                      " *",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 250),
                                  child: FlutterSwitch(
                                      padding: 6,
                                      width: 110,
                                      height: 30,
                                      activeColor: Colors.green,
                                      showOnOff: true,
                                      valueFontSize: 16,
                                      activeText: "Active",
                                      inactiveText: "InActive",
                                      value: isActive,
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
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                            confirmpasswordController.text;
                                        if (emailNotification) {
                                          dataToUpdate.email_notifiction = "Y";
                                        } else {
                                          dataToUpdate.email_notifiction = "N";
                                        }

                                        if (isActive) {
                                          dataToUpdate.status = "Y";
                                        } else {
                                          dataToUpdate.status = "N";
                                        }

                                        if (_formkey.currentState!.validate()) {
                                          var response = await ApiFactory()
                                              .getClientService()
                                              .updateClientUserData(
                                                  dataToUpdate);
                                          if (response.status == "1") {
                                            log("CLIENT DATA UPDATED SUCCESSFULLY!");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "CLIENT data updated successfully")));
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              Navigator.pop(context, [true]);
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
                                        if (_formkey.currentState!.validate()) {
                                          var response = await ApiFactory()
                                              .getClientService()
                                              .submitClientUserData(
                                                  addClientUser);
                                          if (response.status == "1") {
                                            log("USER DATA SUBMIT SUCCESS");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Data Submitted Successfully")));

                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              Navigator.pop(context, true);
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
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
                                        backgroundColor:
                                            ColorParser().hexToColor("#1A7C52"),
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
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
