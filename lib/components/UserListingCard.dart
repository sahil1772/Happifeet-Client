import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

class UserListingCard extends StatefulWidget{
  @override
  State<UserListingCard> createState() => _UserListingCardState();

}

class _UserListingCardState extends State<UserListingCard>{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.only(left: 10,top: 0,bottom: 0,right: 0),
        // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        margin:  const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black,
          // ),
          boxShadow: [BoxShadow(blurRadius: 3,color: Colors.black12,spreadRadius: 2),],
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
                            'Alfred B. Maclay',
                            // overflow: TextOverflow.ellipsis,
                            maxLines:1,
                            style: TextStyle(
                                color:   ColorParser().hexToColor("#01825C"),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                          ),
                          Text(
                            'Working Team',
                            // overflow: TextOverflow.ellipsis,
                            maxLines:1,
                            style: TextStyle(
                                color:   ColorParser().hexToColor("#757575"),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/manageUser/mail.svg"),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'tester7701@gmail.com',
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: Colors.grey ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/images/manageUser/call.svg"),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '8788888888',
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color:  Colors.grey ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
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
                                  style: TextStyle(color:  Colors.grey ),
                                ),
                              ],
                            ),
                          ),



                        ],
                      ),
                    ),
                    // SizedBox(width: 10),
                    SizedBox(width: 35,),


                  ],
                ),
              ),
              Container(
                height: 60,
                width: 55,
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
                    SizedBox(height: 8,),
                    SvgPicture.asset("assets/images/location/editing.svg"),
                    SizedBox(height: 8,),
                    Divider(color: Colors.grey.shade200),
                    SizedBox(height: 8,),
                    SvgPicture.asset("assets/images/location/delete.svg"),
                    SizedBox(height: 8,),
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