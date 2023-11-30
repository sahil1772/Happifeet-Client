import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/HappiFeetAppBar.dart';
import '../../utils/ColorParser.dart';

class ProfileWidget extends StatefulWidget{
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();

}

class _ProfileWidgetState extends State<ProfileWidget>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: HappiFeetAppBar(IsDashboard: true,isCitiyList: true)
          .getAppBar(context),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green, Colors.white],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         const Text("Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                         const Text("John Wick",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Current Password"),
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
                              const Text("New Password"),
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
                              const Text("Confirm Password"),
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
                          SizedBox(
                            height: 40,
                            width: 170,
                            child: ElevatedButton(

                              onPressed: () {
                                // AddLocation().gotoAddLocation(context);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: ColorParser().hexToColor("#1A7C52"),elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                              child: Text("Save Changes",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),

                            ),
                          ),
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