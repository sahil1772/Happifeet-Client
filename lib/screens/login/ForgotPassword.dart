import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/screens/login/OTPPage.dart';

import '../../network/ApiFactory.dart';
import '../../utils/ColorParser.dart';

class ForgotPasswordWidget extends StatefulWidget{

  const ForgotPasswordWidget({super.key});

  goToForgotPasswordPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordWidget() ));
  }



  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
  
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget>{

  String? email;
  String? emailerror;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Stack(
        children: [
          SvgPicture.asset("assets/images/login/loginBG.svg",fit: BoxFit.fill,width: MediaQuery.of(context).size.width,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80,),
                Center(child: Image.asset("assets/images/login/logo.png")),
                SizedBox(height: 30,),
               Text("Forgot Password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text("Enter Your Email id For The Verification Process We Will Send 4 Digits Code to Your Email",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400) ,textAlign: TextAlign.center),
                ),
                SizedBox(height: 30,),
                TextField(
                  onChanged: (value){
                    email = value;
                  },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // labelText: labelText,

                      hintText: 'Email ID',
                      hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      errorText: getEmailError(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: ColorParser().hexToColor("#D7D7D7"), width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              width: 1, color: ColorParser().hexToColor("#D7D7D7"))),
                    )
                ),
                SizedBox(height: 10,),

                SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(320, 51),
                    backgroundColor: ColorParser().hexToColor("#01825C"),

                    // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //     RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.0),
                    //         // side: BorderSide(color: Colors.red)
                    //     )
                    // ),
                  ),
                  onPressed: () async{


                    Future.delayed(
                        Duration(seconds: 3),
                            () {
                          OtpPageWidget().goToOtpPage(context);
                        });


                    var response = await ApiFactory().sendForgotPasswordDetails().sendForgotPasswordDetails("forgotpassword",email!, "123456");

                    log("RESPONSE FORGOT PASSWORD ${response.status}");
                    if(response.status == 1){
                      log("VALID USERNMAE IN FORGOT PASSWORD PAGE");



                    }else{
                      log("INVALID USERNAME IN FORGOT PASSWORD PAGE");
                    }

                    // OtpPageWidget().goToOtpPage(context);


                  },
                  child: Text("Get OTP",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white)),)
                // SvgPicture.asset("assets/images/login/logo.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}