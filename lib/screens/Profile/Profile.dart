import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/model/Theme/ClientTheme.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/screens/Dashboard/dashboard.dart';
import 'package:happifeet_client_app/screens/Login/LoginPage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../storage/runtime_storage.dart';
import '../../utils/ColorParser.dart';
import '../../utils/DeviceDimensions.dart';

class ProfileWidget extends StatefulWidget {
  ClientTheme? clientTheme;

  PersistentTabController? controller;

  ProfileWidget({super.key, this.clientTheme,this.controller});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var currentPassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userName = "";

  String? uniqueID = "";

  @override
  void initState() {
    // TODO: implement initState
    getUserName();
    log("CONTROLLER DATA${widget.controller}");

    getDeviceDetails();

    super.initState();
  }

  Future<void> getUserName() async {


      userName = await SharedPref.instance.getUserName();
      log("user name in profile${userName}");
      setState(() {

      });


  }


  void setBoolForLogOut() async {
    /** update checkIfLoggedIn value in shared pref   **/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    double HEADER_AREA = 3.5;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: HappiFeetAppBar(IsDashboard: true, isCitiyList: false)
            .getAppBar(context),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Container(
                  height: DeviceDimensions.getHeaderSize(context, HEADER_AREA),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      ColorParser().hexToColor(RuntimeStorage
                          .instance.clientTheme!.top_title_background_color!),
                      ColorParser().hexToColor(RuntimeStorage
                          .instance.clientTheme!.top_title_background_color!)
                    ],
                  )),
                  child: Container(
                    margin: DeviceDimensions.getHeaderEdgeInsets(context),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Profile",
                          // "Select Location".tr(),
                          // "Select Location".language(context),
                          // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: ColorParser().hexToColor(RuntimeStorage
                                  .instance
                                  .clientTheme!
                                  .top_title_text_color!)),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  right: MediaQuery.of(context).size.height <= 667 ? -25 : 0,
                  top: MediaQuery.of(context).size.height <= 667
                      ? MediaQuery.of(context).size.height / 7.7
                      : MediaQuery.of(context).size.height / 9.5,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height <= 667
                          ? 140
                          : null,
                      child: SvgPicture.asset(
                        "assets/images/manage/manageBG.svg",
                      ))),
              Container(
                height:
                    DeviceDimensions.getBottomSheetHeight(context, HEADER_AREA),
                margin: EdgeInsets.only(
                    top: DeviceDimensions.getBottomSheetMargin(
                        context, HEADER_AREA)),
                padding: const EdgeInsets.symmetric(horizontal: 0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Name",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    Text( userName.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              TextButton(onPressed: () { 
                                Clipboard.setData(ClipboardData(text: uniqueID!)).then((_){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("UUID has been copied to clipboard")));
                                });
                              }, child: const Text("Copy UUID"))

                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Current Password",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                  controller: currentPassword,
                                  onChanged: (value) {
                                    currentPassword.text = value;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    // errorText: getEmailError(),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: ColorParser()
                                                .hexToColor("#D7D7D7"),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: ColorParser()
                                                .hexToColor("#D7D7D7"))),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("New Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                  controller: newPasswordController,
                                  onChanged: (value) {
                                    newPasswordController.text = value;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    // errorText: getEmailError(),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: ColorParser()
                                                .hexToColor("#D7D7D7"),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: ColorParser()
                                                .hexToColor("#D7D7D7"))),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Confirm Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                  controller: confirmPasswordController,
                                  onChanged: (value) {
                                    confirmPasswordController.text = value;
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Please re-enter confirm password number';
                                    }
                                    if (newPasswordController.text !=
                                        confirmPasswordController.text) {
                                      return "Password does not match";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    // errorText: getEmailError(),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: ColorParser()
                                                .hexToColor("#D7D7D7"),
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: ColorParser()
                                                .hexToColor("#D7D7D7"))),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // AddLocation().gotoAddLocation(context);

                                      if (_formkey.currentState!.validate()) {
                                        log("Validation Done");
                                        var response = await ApiFactory()
                                            .getProfileService()
                                            .sendPasswordDetails(
                                                "changepassword",
                                                await SharedPref.instance
                                                    .getUserId(),
                                                currentPassword.text,
                                                confirmPasswordController.text);
                                        if (response.status == 1) {
                                          log("password successfully change!!");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Password Change Successfully!")));
                                          Future.delayed(const Duration(seconds: 2),
                                              () {
                                                widget.controller!.jumpToTab(0);

                                          });
                                        } else if (response.status == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Invalid old password")));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Something went wroong")));
                                        }
                                      } else {
                                        log("Validation Unsuccessful");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorParser().hexToColor("#1A7C52"),
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      const LoginPageWidget().gotoLogin(context);
                                      setBoolForLogOut();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    child: const Text(
                                      "Log Out",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Future<void> getDeviceDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueID= iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueID= androidDeviceInfo.androidId; // unique ID on Android
    }
    setState(() {

    });
  }
}
