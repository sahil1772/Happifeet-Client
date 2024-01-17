import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/screens/Login/OTPPage.dart';

import '../../network/ApiFactory.dart';
import '../../utils/ColorParser.dart';

class ForgotPasswordWidget extends StatefulWidget{

  const ForgotPasswordWidget({super.key});

  goToForgotPasswordPage(BuildContext context){

    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordWidget() ));
  }



  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
  
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget>{
  EmailOTP myauth = EmailOTP();

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
                const SizedBox(height: 80,),
                Center(child: Image.asset("assets/images/login/logo.png")),
                const SizedBox(height: 30,),
               const Text("Forgot Password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("Enter Your Email id For The Verification Process We Will Send 4 Digits Code to Your Email",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400) ,textAlign: TextAlign.center),
                ),
                const SizedBox(height: 30,),
                TextField(
                  onChanged: (value){
                    setEmailError(EmailValidator.validate(value)
                        ? null
                        : "Please enter valid email");

                    setState(() {
                      email = value;
                    });
                  },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      // labelText: labelText,

                      hintText: 'Email ID',
                      hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                const SizedBox(height: 10,),

                const SizedBox(height: 30,),
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


                    var response = await ApiFactory().getLoginService().sendEmailIfForgotPassword("sendResetPasswordOTP",email!);

                    log("RESPONSE FORGOT PASSWORD ${response.status}");
                    if(response.status == 1){
                      log("VALID USERNMAE IN FORGOT PASSWORD PAGE");
                      OtpPageWidget().goToOtpPage(context,email!);



                    }else{
                      log("INVALID USERNAME IN FORGOT PASSWORD PAGE");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Not Found")));
                    }

                    // OtpPageWidget().goToOtpPage(context);


                  },
                  child: const Text("Get OTP",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white)),)
                // SvgPicture.asset("assets/images/login/logo.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}