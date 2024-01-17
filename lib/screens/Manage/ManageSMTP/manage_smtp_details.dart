import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/model/SMTP/SmtpDetails.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../resources/resources.dart';
import '../../../utils/ColorParser.dart';
List<String> fieldOptions = ['Item 1','Item 2','Item 3',"Item 4"];
class ManageSMTPDetails extends StatefulWidget{
  const ManageSMTPDetails({super.key});




  goToManageSMTPPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageSMTPDetails()));
  }

  @override
  State<ManageSMTPDetails> createState() => _ManageSMTPDetailsState();

}

class _ManageSMTPDetailsState extends State<ManageSMTPDetails>{
  

  String? dropdownValueSelected = fieldOptions.first;
  List<SmtpDetails> SmtpData = [];
  TextEditingController smtphostController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController fromemailController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    getSmtpDetail();

    super.initState();



  }
  
  void getSmtpDetail() async{
    var response = await ApiFactory().getSMTPService().getSmtpDetails("smtp", "41");
    SmtpData = response;
    setinitialData();
    log("SMTP data in smtp page ${SmtpData.first}");
  }

   setinitialData() async{
    if( SmtpData.first.smtp_host != null ){
      smtphostController.text = SmtpData.first.smtp_host!;
    }

    if( SmtpData.first.email_from_name != null ){
      emailController.text = SmtpData.first.email_from_name!;
    }
    if( SmtpData.first.smtp_username != null ){
      usernameController.text = SmtpData.first.smtp_username!;
    }
    if( SmtpData.first.smtp_password != null ){
      passwordController.text = SmtpData.first.smtp_password!;
    }
    if( SmtpData.first.smtp_port != null ){
      portController.text = SmtpData.first.smtp_port!;
    }
    if( SmtpData.first.from_email_id != null ){
      fromemailController.text = SmtpData.first.from_email_id!;
    }
    if( SmtpData.first.smtp_security != null ){
log("INSIDEIFFFFFFFFFFFFF");
     setState(() async{
       dropdownValueSelected = SmtpData.first.smtp_security!;
       log("OHHHHHHHHH $dropdownValueSelected");
     });
    }
    setState(() {

    });

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
             decoration:  BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topLeft,
                   end: Alignment.bottomRight,
                   colors: [ColorParser().hexToColor("#34A846"),ColorParser().hexToColor("#83C03D") ],
                 )),
             child: Column(
                 children: [
               // SizedBox(height: 105),
               Padding(
                 padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
                 child: const Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(

                       'Manage SMTP Details',
                       // "Select Location".tr(),
                       // "Select Location".language(context),
                       // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                       style: TextStyle(

                           color:  Colors.white,
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
                 padding: const EdgeInsets.symmetric(horizontal: 16),
                 decoration:  const BoxDecoration(
                     borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(25),
                         topRight: Radius.circular(25)),
                     color:  Colors.white),
                 // color: Colors.white,
                 child: SingleChildScrollView(

                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 22),
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Text("SMTP Host"),
                             const SizedBox(height: 8,),
                             TextField(
                               controller: smtphostController,

                                 onChanged: (value){

                                 },

                                 decoration: InputDecoration(
                                   filled: true,
                                   fillColor: Colors.white,
                                   // labelText: labelText,
                                   hintText: 'SMTP Host',
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
                             const Text("Email id"),
                             const SizedBox(height: 8,),
                             TextField(
                               controller: emailController,
                                 onChanged: (value){

                                 },

                                 decoration: InputDecoration(
                                   filled: true,
                                   fillColor: Colors.white,
                                   // labelText: labelText,
                                   hintText: 'Email id',
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
                             const Text("Username"),
                             const SizedBox(height: 8,),
                             TextField(
                               controller: usernameController,
                                 onChanged: (value){

                                 },

                                 decoration: InputDecoration(
                                   filled: true,
                                   fillColor: Colors.white,
                                   // labelText: labelText,
                                   hintText: 'Username',
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
                             const Text("Password"),
                             const SizedBox(height: 8,),
                             TextField(
                               controller: passwordController,
                                 onChanged: (value){

                                 },

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
                           ],
                         ),
                         const SizedBox(
                           height: 20,
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Text("Port"),
                             const SizedBox(height: 8,),
                             TextField(
                               controller: portController,
                                 onChanged: (value){

                                 },

                                 decoration: InputDecoration(
                                   filled: true,
                                   fillColor: Colors.white,
                                   // labelText: labelText,
                                   hintText: 'Port',
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
                             const Text("From Email"),
                             const SizedBox(height: 8,),
                             TextField(
                               controller: fromemailController,
                                 onChanged: (value){

                                 },

                                 decoration: InputDecoration(
                                   filled: true,
                                   fillColor: Colors.white,
                                   // labelText: labelText,
                                   hintText: 'From Email',
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
                             const Text("Connection Security"),
                             const SizedBox(height: 8,),
                             Container(
                               child: SizedBox(
                                 height: 60,
                                 child: DropdownButtonFormField(
                                     dropdownColor: Colors.white,

                                     // isDense: true,
                                     //   isExpanded: true,
                                     decoration:   InputDecoration(
                                       enabledBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                                         borderRadius: BorderRadius.all(Radius.circular(15)),

                                       ),
                                       focusedBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                                         borderRadius: BorderRadius.all(Radius.circular(15)),
                                       ),
                                     ),

                                     value: dropdownValueSelected,
                                     icon: const Icon(Icons.arrow_drop_down_sharp),
                                     iconSize: 30,


                                     items: fieldOptions.map<DropdownMenuItem<String>>((value) {

                                       return DropdownMenuItem<String>(

                                         value: value,
                                         child: Text(value,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                                       );
                                     }).toList(),
                                     onChanged: (value) {
                                       setState(() {
                                         log("before ${value}");
                                         dropdownValueSelected = value!;
                                         // ListOfFeedbackDetails.first.value = value;
                                         log("after ${dropdownValueSelected}");
                                       });
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

                           },
                           child: const Text("Submit",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white)),),
                         const SizedBox(height: 50,),

                         /** SUBMIT BUTTON **/


                       ],
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