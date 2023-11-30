import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/Location/LocationData.dart';

class LocationCard extends StatefulWidget{
  LocationData? locationDetails;

  LocationCard({Key? key,this.locationDetails});

  @override
  State<LocationCard> createState() => _LocationCardState();

}

class _LocationCardState extends State<LocationCard>{
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: SvgPicture.asset("assets/images/location/locationImg.svg"),
                    // child: Image.asset(widget.city!.location_image!),
                  ),
                  // color: Theme.of(context).primaryColor,
                  // child: const SizedBox(
                  //   width: 80,
                  //   height: 80,
                  // ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.locationDetails!.park_name!,
                        // overflow: TextOverflow.ellipsis,
                        // maxLines:2,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                            color:   Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.0),
                        child: Text(
                          widget.locationDetails!.address!,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(color: Colors.grey ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.0),
                        child: Text(
                          'Tallahassee, FL 32309, USA',
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(color:  Colors.grey ),
                        ),
                      ),
                      /** amenities listing horizontal **/

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         height:24,
                      //         child: ListView.builder(
                      //           shrinkWrap: true,
                      //             scrollDirection: Axis.horizontal,
                      //             itemCount: 3,
                      //             itemBuilder: (BuildContext, index) {
                      //           return Container(
                      //             height: 24,
                      //             margin: EdgeInsets.only(right: 10),
                      //             width: 24,
                      //             // child: Image.asset("assets/images/amenities/Accessible.png"),
                      //             // child: amenitiesList == [] ? Image.asset("assets/images/amenities/Accessible.png") : Image.network(amenitiesList![0]),
                      //             child: index > amenitiesList!.length - 1 ? Image.asset("assets/images/amenities/Accessible.png")  : Image.network(amenitiesList![index]),
                      //
                      //             // decoration: BoxDecoration(
                      //             //   color: Theme.of(context).primaryColor,
                      //             //   shape: BoxShape.circle,
                      //             // ),
                      //           );
                      //         }),
                      //       ),
                      //
                      //
                      //     ],
                      //   ),
                      // ),

                    ],
                  ),
                ),
              ),
              // SizedBox(width: 10),
              SizedBox(width: 35,),
              Container(
                height: 60,
                width: 35,
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
                    SvgPicture.asset("assets/images/location/editing.svg"),
                    SizedBox(height: 5,),
                    Divider(color: Colors.grey.shade200),
                    SvgPicture.asset("assets/images/location/delete.svg"),
                    Divider(color: Colors.grey.shade200),
                    SizedBox(height: 5,),
                    SvgPicture.asset("assets/images/location/qrCode.svg"),
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