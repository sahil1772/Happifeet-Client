import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../utils/ColorParser.dart';

class AddClientWidget extends StatefulWidget{

  gotoAddClientPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddClientWidget()));
  }


  @override
  State<AddClientWidget> createState() => _AddClientWidgetState();

}

class _AddClientWidgetState extends State<AddClientWidget>{
  TextEditingController userNameController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();
  TextEditingController staffController = new TextEditingController();
  TextEditingController remarkController = new TextEditingController();
  bool isActive = false;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(

                            'Add Client',
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration:  BoxDecoration(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Name"),
                                  Text(" *",style: TextStyle(color: Colors.red),),
                                ],
                              ),
                              SizedBox(height: 8,),
                              TextField(
                                  controller: userNameController,

                                  onChanged: (value){

                                  },

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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

                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Password"),
                                  Text(" *",style: TextStyle(color: Colors.red),),
                                ],
                              ),
                              SizedBox(height: 8,),
                              TextField(
                                  controller: contactController,
                                  onChanged: (value){

                                  },
                                  obscureText: true,

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                          SizedBox(
                            height: 20,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Contact No"),
                                  Text(" *",style: TextStyle(color: Colors.red),),
                                ],
                              ),
                              SizedBox(height: 8,),
                              TextField(
                                  controller: contactController,
                                  onChanged: (value){

                                  },

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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


                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Staff"),
                                  Text(" *",style: TextStyle(color: Colors.red),),
                                ],
                              ),
                              SizedBox(height: 8,),
                              TextField(
                                  controller: staffController,
                                  onChanged: (value){

                                  },

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintText: 'Username',
                                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Remark"),
                                  Text(" *",style: TextStyle(color: Colors.red),),
                                ],
                              ),
                              SizedBox(height: 8,),
                              TextField(
                                  controller: remarkController,
                                  onChanged: (value){

                                  },
                                  maxLines: 5,

                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    // labelText: labelText,
                                    hintText: 'Username',
                                    hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                          SizedBox(height: 30,),

                          SizedBox(
                            height: 70,
                            width: 90,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Switch(
                                  value: isActive,
                                  onChanged: (value){
                                    setState(() {
                                      isActive = value;
                                    });
                                  }),
                            ),
                          ),
                          isActive ? Text("Active") : Text("Inactive"),



                          // FlutterSwitch(
                          //   width: 100,
                          //   height: 40,
                          //   // activeColor: Colors.green,
                          //     activeTextColor: Colors.white,
                          //   inactiveColor: Colors.grey,
                          //   inactiveTextColor: Colors.white,
                          //   // showOnOff: true,
                          //
                          //   activeText: "Active",
                          //     inactiveText: "InActive",
                          //     value: isActive,
                          //     onToggle: (value){
                          //       setState(() {
                          //         log("toggle ${value}");
                          //         isActive = value;
                          //       });
                          //     }),





                          SizedBox(height: 30,),
                          SizedBox(
                            height: 40,
                            width: 170,
                            child: ElevatedButton(

                              onPressed: () {
                                // AddLocation().gotoAddLocation(context);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: ColorParser().hexToColor("#1A7C52"),elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                              child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),

                            ),
                          ),
                          SizedBox(height: 50,),

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