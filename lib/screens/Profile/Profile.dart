import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/screens/Login/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../utils/ColorParser.dart';

class ProfileWidget extends StatefulWidget{
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();

}

class _ProfileWidgetState extends State<ProfileWidget>{
  var newPasswordController=TextEditingController();
  var confirmPasswordController=TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void setBoolForLogOut() async {
    /** update checkIfLoggedIn value in shared pref   **/
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: HappiFeetAppBar(IsDashboard: true,isCitiyList: false)
          .getAppBar(context),
      body: Stack(
        children: [
          Container(
            decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    ColorParser().hexToColor("#34A846"),
                    ColorParser().hexToColor("#83C03D")
                  ],
                )),
            child: const Padding(
              padding: EdgeInsets.only(left: 20,top: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height/9.5,
              child: SvgPicture.asset("assets/images/manage/manageBG.svg",)),
          DraggableScrollableSheet(
              initialChildSize: 0.67,
              minChildSize: 0.67,
              maxChildSize: 0.67,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white),
                  // color: Colors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 22),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
                            Text("John Wick",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText)),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("Current Password",style: TextStyle(fontSize:16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
                                const SizedBox(height: 8,),
                                TextField(

                                    onChanged: (value){

                                    },

                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
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
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("New Password",style: TextStyle(fontSize:16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                                const SizedBox(height: 8,),
                                TextField(
                                  controller: newPasswordController,

                                    onChanged: (value){

                                    },

                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
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
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("Confirm Password",style: TextStyle(fontSize:16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                                const SizedBox(height: 8,),
                                TextFormField(

                                  controller: confirmPasswordController,

                                    onChanged: (value){

                                    },
                                    validator: (String? value){
                                    if(value!.isEmpty){
                                      return 'Please re-enter confirm password number';
                                    }
                                    if(newPasswordController.text != confirmPasswordController.text){
                                      return "Password does not match";
                                    }
                                    },


                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText: labelText,
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
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 170,
                                  child: ElevatedButton(

                                    onPressed: () {
                                      // AddLocation().gotoAddLocation(context);
                                      if(_formkey.currentState!.validate()){
                                        log("Validation Done");
                                      }else{
                                        log("Validation Unsuccessful");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: ColorParser().hexToColor("#1A7C52"),elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    child: Text("Save Changes",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),

                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 170,
                                  child: ElevatedButton(

                                    onPressed: () {
                                      LoginPageWidget().gotoLogin(context);
                                      setBoolForLogOut();
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    child: Text("Log Out",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),

                                  ),
                                ),

                              ],
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