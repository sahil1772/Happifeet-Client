import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/screens/Login/ForgotPassword.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../../components/BottomNavigation.dart';
import '../../network/ApiFactory.dart';
import '../../storage/shared_preferences.dart';

class LoginPageWidget extends StatefulWidget{
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();

}

class _LoginPageWidgetState extends State<LoginPageWidget>{

  String? emailerror;
  String? email;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /** Display with status and navigation bar **/
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }


  // void getLoginData() async{
  //   var response = await ApiFactory().getLoginDetails().getLoginDetails(task, username, password)
  //   log("response inside citylist page ${response}");
  //   ListOfCities = response;
  //   ListOfCitiesTemp = response;
  //
  //   log("listofcities ${ListOfCities.length}");
  //
  //   // log("Listofcities ${ListOfCities.first.testColor}");
  //
  //   setState(() {});
  //
  //
  // }

  getEmailError() {
    return emailerror;
  }

  setEmailError(value) {
    emailerror = value;
  }
  @override
  Widget build(BuildContext context) {

    // SystemChrome.setSystemUIOverlayStyle(
    //     const SystemUiOverlayStyle(
    //         statusBarColor: Colors.white
    //       //color set to purple or set your own color
    //     )
    // );



    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

   return SafeArea(
     child: Scaffold(
       extendBodyBehindAppBar: true,
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
                       hintText: 'Email',
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
                 const SizedBox(height: 30,),
                 TextField(
                   onChanged: (value){
                     password = value;
                   },
                    obscureText: true,
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Colors.white,
                       // labelText: labelText,

                       hintText: 'Password',
                       hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                       // errorText: getEmailError(),
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
                 const SizedBox(height: 15,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     InkWell(
                       onTap: () {
                         const ForgotPasswordWidget().goToForgotPasswordPage(context);
                       },
                         child: const Text("Forgot Password",style: TextStyle(color: Colors.red,fontSize: 14),)),
                   ],
                 ),
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
                     onPressed: () async{
                     
                     var response = await ApiFactory().getLoginService().sendLoginDetails("login",email!, password!);

                     log("RESPONSE LOGIN ${response.status}");
                     if(response.status == 1){
                       log("VALID USERNMAE IN LOGIN PAGE");

                     }else{
                       log("INVALID USERNAME IN LOGIN PAGE");
                     }
                     SharedPref.instance.setPermissions();


                     BottomNavigationHappiFeet().goToBottomNavigation(context);
                     // OtpPageWidget().goToOtpPage(context);


                     },
                     child: const Text("Login",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white)),)
                 // SvgPicture.asset("assets/images/login/logo.svg"),
               ],
             ),
           ),
         ],
       ),
     ),
   );
  }
}