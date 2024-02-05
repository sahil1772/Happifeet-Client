import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/AddClient.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/ClientListing.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../model/ClientUsers/ClientUserData.dart';
import '../network/ApiFactory.dart';
import '../utils/ColorParser.dart';

class ClientListingCard extends StatefulWidget{
  ClientUserData? clientUserData;

  Function? refreshCallback;

  ClientListingCard({Key? key,this.clientUserData,this.refreshCallback});

  @override
  State<ClientListingCard> createState() => _ClientListingCardState();
  
}

class _ClientListingCardState extends State<ClientListingCard>{
  bool isEdit = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: const EdgeInsets.only(left: 10,top: 0,bottom: 0,right: 0),
        // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        margin:  const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black,
          // ),
          boxShadow: const [BoxShadow(blurRadius: 3,color: Colors.black12,spreadRadius: 2),],
          borderRadius: BorderRadius.circular(10),
        ),


        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 170,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.clientUserData!.client_name!,
                            // overflow: TextOverflow.ellipsis,
                            maxLines:1,
                            style: TextStyle(
                                color:   ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                          ),
                          // Text(
                          //   'Working Team',
                          //   // overflow: TextOverflow.ellipsis,
                          //   maxLines:1,
                          //   style: TextStyle(
                          //       color:   ColorParser().hexToColor("#757575"),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //       letterSpacing: 0.5),
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/manageUser/mail.svg"),
                                const SizedBox(
                                  width: 15,
                                ),
                                 Text(
                                  widget.clientUserData!.email_address!,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!), ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/manageUser/call.svg"),
                                const SizedBox(
                                  width: 15,
                                ),
                                 Text(
                                  widget.clientUserData!.contact_no!,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color:  ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!), ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                           Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0),
                            child: Row(
                              children: [

                                Text(
                                  'Note* Lorem ipsum dolor sit amet',
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color:  ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!), ),
                                ),
                              ],
                            ),
                          ),



                        ],
                      ),
                    ),
                    // SizedBox(width: 10),
                    const SizedBox(width: 35,),


                  ],
                ),
              ),
              Container(
                // height: 60,
                // width: 45,
                width: MediaQuery.of(context).size.width / 8.5,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color:  Colors.grey.shade200,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8,),
                    InkWell(
                      onTap: () {
                        AddClientWidget().gotoAddClientPage(context,widget.clientUserData!.id, isEdit,(){
                          print("CARD VARUN ALOO BHAVAAAAA");
                          widget.refreshCallback!();
                        });
                      },
                        child: SvgPicture.asset("assets/images/location/editing.svg")),
                    const SizedBox(height: 8,),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 8,),
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete Client User"),
                                  content: Text(
                                      "Are you sure you want to delete this client user?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          var response = await ApiFactory().getClientService().deleteClientUserData("delete_client_user", widget.clientUserData!.id!);
                                          if(response.status == "1"){
                                            log("Client User Deleted Successfully");

                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Client User Deleted Successfully")));
                                           Navigator.pop(context);

                                          }else{
                                            log("Error in client user delete");
                                          }

                                        }, child: Text("Yes")),
                                    TextButton(
                                        onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                            .pop(),
                                        child: Text("No")),
                                  ],
                                );
                              });
                        },
                        child: SvgPicture.asset("assets/images/location/delete.svg")),
                    const SizedBox(height: 8,),
                    Divider(color: Colors.grey.shade200),


                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}