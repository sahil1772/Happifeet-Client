import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Login/ResetPassword.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/ColorParser.dart';

class OtpPageWidget extends StatefulWidget {
  String? email;

  OtpPageWidget({super.key, this.email});

  goToOtpPage(BuildContext context, String email) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpPageWidget(email: email,)));
  }

  @override
  State<OtpPageWidget> createState() => _OtpPageWidgetState();
}


class _OtpPageWidgetState extends State<OtpPageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    log("EMAIL IS ----------> ${widget.email}");
    super.initState();
  }
  TextEditingController otpController = TextEditingController();
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/login/loginBG.svg",
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Center(child: Image.asset("assets/images/login/logo.png")),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Enter OTP",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                      "Enter the 4 Digits Code That You Have Received on Your Email",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
                  height: 40,
                ),

                /** OTP field **/
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PinCodeTextField(
                    controller: otpController,
                    appContext: context,
                    length: 4,
                    keyboardType: TextInputType.number,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    pinTheme: PinTheme(
                      activeColor: ColorParser().hexToColor("#01825C"),
                      inactiveColor: ColorParser().hexToColor("#01825C"),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.white,
                    ),
                  ),
                ),
                // SizedBox(height: 30,),

                RichText(
                  text: const TextSpan(children: [
                    TextSpan(
                      text: 'Didn’t Receive Code ',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                          decoration: TextDecoration.underline),
                    ),
                  ]),
                ),

                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(320, 51),
                    backgroundColor: ColorParser().hexToColor("#01825C"),

                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //     RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //         // side: BorderSide(color: Colors.red)
                    //     )
                    // ),
                  ),
                  onPressed: () async {
                    log("OTP IS --> ${otpController.text}");
                    var response = await ApiFactory()
                        .getLoginService()
                        .sendOtpToResetPassword(
                            "submitResetPasswordOTP", widget.email!, otpController.text);

                    log("RESPONSE SUBMIT OTP ${response.status}");
                    if (response.status == 1) {
                      log("OTP VARIFIED SUCCESSFULLY");
                      ResetPasswordWidget().goToResetPasswordPage(context,widget.email!);
                    } else {
                      log("OTP VARIFICATION FAILED");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid OTP")));
                    }
                  },
                  child: const Text("Continue",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                )
                // SvgPicture.asset("assets/images/login/logo.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
