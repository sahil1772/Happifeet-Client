import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/resources.dart';
import '../utils/ColorParser.dart';

class StatusCard extends StatefulWidget{
  @override
  State<StatusCard> createState() => _StatusCardState();

}

class _StatusCardState extends State<StatusCard>{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 320,
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.only(left: 0,top: 0,bottom: 0,right: 0),
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


        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.shade200
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16,left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset("assets/images/comments/location.svg"),
                            SizedBox(width: 10,),
                            Text("Tallahassee, FL 32309, USA",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: ColorParser().hexToColor("#757575")),),
                            SizedBox(width: 10,),

                          ],
                        ),

                      ],
                    ),
                  ),
                  Container(

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
                        SizedBox(height: 16,),
                        SvgPicture.asset("assets/images/comments/visible.svg"),
                        SizedBox(height: 16,),


                      ],
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assigned By",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
                        Text("1",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText)),
                        SizedBox(height: 15,),
                        Text("Feedback Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        Text("09, Jan 2023",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText)),
                        SizedBox(height: 15,),
                        Text("Days Taken to Resolve",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        Text("3",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText)),
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.grey.shade200,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assigned To",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        Text("Test",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText)),
                        SizedBox(height: 15,),
                        Text("Last Updated Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        Text("09 Jan, 2023",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText)),
                        SizedBox(height: 15,),
                        SizedBox(
                          height: 40,
                          width: 120,
                          child: ElevatedButton(

                            onPressed: () {
                              // AddLocation().gotoAddLocation(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Resources.colors.buttonColorlight,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                            child: Text("Completed",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500),),

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
              child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.hfText),maxLines: 2),
            ),

          ],
        ),




      ),
    );
  }
}