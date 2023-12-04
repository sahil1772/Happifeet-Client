import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/screens/Manage/ManageAnnouncements/AnnouncementListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/ClientListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageLocation/LocationListing.dart';
import 'package:happifeet_client_app/screens/Manage/ManageSMTP/manage_smtp_details.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';

import '../../components/HappiFeetAppBar.dart';
import 'ManageUsers/AssignedUserListing.dart';

class ManageWidget extends StatefulWidget{
  const ManageWidget({super.key});

  @override
  State<ManageWidget> createState() => _ManageWidgetState();

}

class _ManageWidgetState extends State<ManageWidget>{
   // List<PermissionData> data = new PermissionData() as List<PermissionData>;
   bool? isSmtpAllowed  = false;
   bool? isUsersAllowed  = false;
   bool? isLocationAllowed = false;
   bool? isAnnouncementAllowed  = false;

   Future<void> checkPermissions() async {

       isSmtpAllowed = await SharedPref.instance.getPermissionSmtp();
       isLocationAllowed = await SharedPref.instance.getPermissionlocation();
       isUsersAllowed = await SharedPref.instance.getPermissionUser();
       isAnnouncementAllowed = await SharedPref.instance.getPermissionAnnouncement();

     log("value of isSmtpAllowed $isSmtpAllowed");
     log("value of isLocationAllowed $isLocationAllowed");
     log("value of isUsersAllowed $isUsersAllowed");
     log("value of isAnnouncementAllowed $isAnnouncementAllowed");
     setState(() {

     });
   }
  @override
  void initState() {
    // TODO: implement initState
    // checkPermissions();
    SharedPref.instance.setPermissions();

    checkPermissions();

    super.initState();
  }

  // checkPermissions()  async{
  //   log("DATAAAAA ${await SharedPref.instance.getPermissionlocation()}");
  //   if(await SharedPref.instance.getPermissionlocation()){
  //     data.name = "Manage Location";
  //     data.img = "assets/images/manage/location.svg";
  //   } if( await SharedPref.instance.getPermissionUser()){
  //     data.name = "Manage Users";
  //     data.img = "assets/images/manage/users.svg";
  //   } if(await SharedPref.instance.getPermissionAnnouncement()){
  //     data.name = "Manage Announcement";
  //     data.img = "assets/images/manage/announcement.svg";
  //   } if(await SharedPref.instance.getPermissionSmtp()){
  //     data.name = "Manage SMTP Details";
  //     data.img = "assets/images/manage/smtp.svg";
  //   }
  //   log("AFTER ADDING DATA ${data!.toJson()}");
  // }




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
                        'Manage',
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
                        children: [
                   GridView(
                       padding: const EdgeInsets.all(0),
                       gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
                           maxCrossAxisExtent: 180,
                           // childAspectRatio: (itemWidth / itemHeight),
                           childAspectRatio: 1,
                           crossAxisSpacing: 20,
                           mainAxisSpacing: 20),

                       shrinkWrap: true,
                       physics: const ScrollPhysics(),
                     children: [
                       if(isLocationAllowed!)
                       InkWell(
                         onTap:(){
                           LocationListing().gotoManageLocation(context);
                },
                         child: Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.black12,),borderRadius: const BorderRadius.all(Radius.circular(14))),
                           width: 150,
                           height: 130,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset("assets/images/manage/location.svg"),
                               const SizedBox(height: 5,),
                                Text("Manage \nLocation",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                             ],
                           ),
                         ),
                       ),
                       if(isUsersAllowed!)
                         InkWell(
                           onTap: () {
                             const AssignedUserListing().goToAssignedUserListing(context);
                    },
                           child: Container(
                             decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(14),)),
                             width: 150,
                             height: 130,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 SvgPicture.asset("assets/images/manage/users.svg"),
                                 const SizedBox(height: 5,),
                                  Text("Manage \nUsers",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                               ],
                             ),
                           ),
                         ),
                       if(isAnnouncementAllowed!)
                       InkWell(
                         onTap: (){
                      AnnouncementListingWidget().gotoAnnouncementListingPage(context);
                    },
                         child: Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.black12,),borderRadius: const BorderRadius.all(Radius.circular(14))),
                           width: 150,
                           height: 130,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset("assets/images/manage/announcement.svg"),
                               const SizedBox(height: 5,),
                                Text("Manage \nAnnouncement",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                             ],
                           ),
                         ),
                       ),
                       if(isSmtpAllowed!)
                       InkWell(
                         onTap:(){
                           const ManageSMTPDetails().goToManageSMTPPage(context);
                         },
                         child: Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(14),)),
                           width: 150,
                           height: 130,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset("assets/images/manage/smtp.svg"),
                               const SizedBox(height: 5,),
                                Text("Manage \nSMTP Details",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                             ],
                           ),
                         ),
                       ),
                       InkWell(
                         onTap:(){
                           ClientListingWidget().gotoClientListingPage(context);
                         },
                         child: Container(
                           decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(14),)),
                           width: 150,
                           height: 130,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SvgPicture.asset("assets/images/manage/smtp.svg"),
                               const SizedBox(height: 5,),
                               Text("Manage Clients",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),textAlign: TextAlign.center),
                             ],
                           ),
                         ),
                       ),

                     ],
                  )
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