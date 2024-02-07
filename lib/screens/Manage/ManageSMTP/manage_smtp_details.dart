import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/model/SMTP/SmtpDetails.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../model/SMTP/SmtpDataModel.dart';
import '../../../resources/resources.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';
import '../../../utils/DeviceDimensions.dart';

List<String> fieldOptions = ['SSL/TLS', 'STARTTLS'];

class ManageSMTPDetails extends StatefulWidget {
  PersistentTabController? tabController;
   ManageSMTPDetails({super.key,this.tabController});

  goToManageSMTPPage(BuildContext context,PersistentTabController? tabController) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) =>  ManageSMTPDetails(tabController: tabController,)));
  }

  @override
  State<ManageSMTPDetails> createState() => _ManageSMTPDetailsState();
}

class _ManageSMTPDetailsState extends State<ManageSMTPDetails> {
  String? dropdownValueSelected = fieldOptions.first;
  SmtpDetails? SmtpData;
  TextEditingController smtphostController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController fromemailController = TextEditingController();
  SmtpDataModel sendSmtpData = SmtpDataModel();
  String? emailerror;
  Future? apiResponse;
  String? smtpSecurity;


  @override
  void initState() {
    // TODO: implement initState
    apiResponse =  getSmtpDetail();
    log("BOTTOMSHEET CONTROLLER IN SMTP PAGE ${widget.tabController}");

    super.initState();
  }

  Future<void> getSmtpDetail() async {
    var response = await ApiFactory()
        .getSMTPService()
        .getSmtpDetails("getSMTP", await SharedPref.instance.getClientId());
    SmtpData = response;
    setinitialData();
    log("SMTP data in smtp page ${SmtpData!.toJson()}");
  }

  setinitialData() async {
    if (SmtpData!.smtp_host != null) {
      smtphostController.text = SmtpData!.smtp_host!;
      // sendSmtpData!.smtpHost = SmtpData!.smtp_host!;
    }

    if (SmtpData!.email_from_name != null) {
      emailController.text = SmtpData!.email_from_name!;
      // sendSmtpData!.email =SmtpData!.email_from_name!;
    }
    if (SmtpData!.smtp_username != null) {
      usernameController.text = SmtpData!.smtp_username!;
      // sendSmtpData!.username = SmtpData!.smtp_username!;
    }
    if (SmtpData!.smtp_password != null) {
      passwordController.text = SmtpData!.smtp_password!;
      // sendSmtpData!.password = SmtpData!.smtp_password!;
    }
    if (SmtpData!.smtp_port != null) {
      portController.text = SmtpData!.smtp_port!;
      // sendSmtpData!.port = SmtpData!.smtp_port!;
    }
    if (SmtpData!.from_email_id != null) {
      fromemailController.text = SmtpData!.from_email_id!;
      // sendSmtpData!.fromEmail = SmtpData!.from_email_id!;
    }
    if (SmtpData!.smtp_security != null) {
      log("INSIDEIFFFFFFFFFFFFF ${SmtpData!.smtp_security}");

      if(SmtpData!.smtp_security == "ssl")
        {
          dropdownValueSelected = "SSL/TLS";
        }else if(SmtpData!.smtp_security == "tls"){
        dropdownValueSelected = "STARTTLS";
      }

      // setState(() async {
      //   dropdownValueSelected = SmtpData!.smtp_security!;
      //   // sendSmtpData!.smtpSecurity = SmtpData!.smtp_security!;
      //   log("OHHHHHHHHH $dropdownValueSelected");
      // });
    } else {
      log("SMTP DATA IS EMPTY");
      dropdownValueSelected = fieldOptions.first;
    }
    setState(() {});
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
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!),
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!)
                  ],
                )),
                child: Container(
                  margin: DeviceDimensions.getHeaderEdgeInsets(context),
                  child: Center(
                    child: Text(
                      "Manage SMTP Details",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(
                          color: ColorParser().hexToColor(RuntimeStorage
                              .instance.clientTheme!.top_title_text_color!),
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
              // color: Colors.white,
              child: FutureBuilder(
                future: apiResponse,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "SMTP Host",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                    controller: smtphostController,
                                    onChanged: (value) {
                                      smtphostController.text = value;

                                      log("value in smtp host${smtphostController.text}");
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
                                      hintText: 'SMTP Host',
                                      hintStyle: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                      // errorText: getEmailError(),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color:
                                              ColorParser().hexToColor("#D7D7D7"),
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
                                const Text(
                                  "Email id",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                    controller: emailController,
                                    onChanged: (value) {
                                      emailController.text = value;
                                      sendSmtpData.email_from_name = value;

                                      setEmailError(EmailValidator.validate(value)
                                          ? null
                                          : "Please enter valid email");
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
                                      hintText: 'Email id',
                                      hintStyle: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                      errorText: getEmailError(),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color:
                                              ColorParser().hexToColor("#D7D7D7"),
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
                                const Text(
                                  "Username",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                    controller: usernameController,
                                    onChanged: (value) {
                                      usernameController.text = value;
                                      sendSmtpData.smtp_username = value;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
                                      hintText: 'Username',
                                      hintStyle: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                      // errorText: getEmailError(),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color:
                                              ColorParser().hexToColor("#D7D7D7"),
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
                                const Text(
                                  "Password",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                    controller: passwordController,
                                    onChanged: (value) {
                                      passwordController.text = value;
                                      sendSmtpData!.smtp_password = value;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                      // errorText: getEmailError(),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color:
                                              ColorParser().hexToColor("#D7D7D7"),
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
                                const Text(
                                  "Port",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                    controller: portController,
                                    onChanged: (value) {
                                      portController.text = value;
                                      sendSmtpData.smtp_port = value;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
                                      hintText: 'Port',
                                      hintStyle: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                      // errorText: getEmailError(),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color:
                                              ColorParser().hexToColor("#D7D7D7"),
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
                                const Text(
                                  "From Email",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextField(
                                    controller: fromemailController,
                                    onChanged: (value) {
                                      fromemailController.text = value;
                                      sendSmtpData.from_email_id = value;
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
                                      hintText: 'From Email',
                                      hintStyle: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w400),
                                      // errorText: getEmailError(),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color:
                                              ColorParser().hexToColor("#D7D7D7"),
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
                                const Text(
                                  "Connection Security",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  child: SizedBox(
                                    height: 60,
                                    child: DropdownButtonFormField(
                                        dropdownColor: Colors.white,

                                        // isDense: true,
                                        //   isExpanded: true,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorParser()
                                                    .hexToColor("#D7D7D7")),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorParser()
                                                    .hexToColor("#D7D7D7")),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
                                          ),
                                        ),
                                        value: dropdownValueSelected,
                                        icon: const Icon(Icons.arrow_drop_down_sharp),
                                        iconSize: 30,
                                        items: fieldOptions
                                            .map<DropdownMenuItem<String>>((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Resources.colors.hfText)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {


                                            log("value on chnaged ${value}");
                                            if(value == "SSL/TLS"){
                                            setState(() {
                                              smtpSecurity = "ssl";
                                            });
                                            log("value1${smtpSecurity}");
                                            }else if(value == "STARTTLS"){
                                              setState(() {
                                                smtpSecurity = "tls";
                                              });
                                              log("value2${smtpSecurity}");
                                            }
                                            // dropdownValueSelected = value!;
                                            // sendSmtpData!.smtpSecurity = value;
                                            // ListOfFeedbackDetails.first.value = value;


                                        }),
                                  ),
                                ),
                                // DropdownButton(
                                //   isExpanded: true,
                                //     value: dropdownValueSelected,
                                //     icon: const Icon(Icons.arrow_drop_down_sharp),
                                //     iconSize: 50,
                                //     items: fieldOptions.map<DropdownMenuItem<String>>((value) {
                                //
                                //       return DropdownMenuItem<String>(
                                //         value: value,
                                //         child: Text(value),
                                //       );
                                //     }).toList(),
                                //     onChanged: (value) {
                                //       setState(() {
                                //         log("before ${value}");
                                //         dropdownValueSelected = value!;
                                //         // ListOfFeedbackDetails.first.value = value;
                                //         log("after ${dropdownValueSelected}");
                                //       });
                                //     }),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(320, 51),
                                backgroundColor: ColorParser().hexToColor(
                                    RuntimeStorage.instance.clientTheme!
                                        .top_title_background_color!),

                                // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                //     RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(12.0),
                                //         // side: BorderSide(color: Colors.red)
                                //     )
                                // ),
                              ),
                              onPressed: () async {
                                log("SMTP VALUE BEFORE SUBMIT ${smtpSecurity}");
                                sendSmtpData.client_id =
                                await SharedPref.instance.getClientId();
                                sendSmtpData.smtp_host = smtphostController.text;
                                sendSmtpData.email_from_name = emailController.text;
                                sendSmtpData.smtp_username = usernameController.text;
                                sendSmtpData.smtp_password = passwordController.text;
                                sendSmtpData.smtp_port = portController.text;
                                sendSmtpData.from_email_id = fromemailController.text;
                                sendSmtpData.smtp_security = smtpSecurity;

                                log("SMTP DATA TO SEND ${sendSmtpData!.toJson()}");

                                var response = await ApiFactory()
                                    .getSMTPService()
                                    .sendSmtpDetails(sendSmtpData!);
                                if (response.status == "1") {
                                  log("SMTP DATA SEND SUCCESSFILLY");
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Data submitted successfully")));
                                  Future.delayed(Duration(seconds: 2),
                                          () {
                                        widget.tabController!.jumpToTab(0);

                                      });
                                } else {
                                  log("Error in submitting smtp data");
                                }
                              },
                              child: const Text("Submit",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white)),
                            ),
                            const SizedBox(
                              height: 50,
                            ),

                            /** SUBMIT BUTTON **/
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }

                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
