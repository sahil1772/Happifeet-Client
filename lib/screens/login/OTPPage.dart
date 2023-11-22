import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/ColorParser.dart';

class OtpPageWidget extends StatefulWidget{

  const OtpPageWidget({super.key});

  goToOtpPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpPageWidget()));
  }

  @override
  State<OtpPageWidget> createState() => _OtpPageWidgetState();
  
}

class _OtpPageWidgetState extends State<OtpPageWidget>{
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
                Text("Enter OTP",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text("Enter the 4 Digits Code That You Have Received on Your Email",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400) ,textAlign: TextAlign.center),
                ),
                SizedBox(height: 30,),

               RichText(
                   text: TextSpan(
                     children: [
                       TextSpan(
                         text: 'Didn’t Receive Code ',
                         style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.black),
                       ),
                       TextSpan(
                           text: 'Resend',
                         style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.red,decoration: TextDecoration.underline),

                       ),
                     ]
                   ),),

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
                  onPressed: () {},
                  child: Text("Continue",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white)),)
                // SvgPicture.asset("assets/images/login/logo.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}