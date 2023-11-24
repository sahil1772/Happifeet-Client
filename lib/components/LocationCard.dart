import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationCard extends StatefulWidget{
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
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
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


        child: Flex(
          direction: Axis.horizontal,
          children: [
            Card(
              child: SizedBox(
                width: 80,
                height: 80,
                child: SvgPicture.asset("assets/images/location/locationImg.svg"),
                // child: Image.asset(widget.city!.location_image!),
              ),
              // color: Theme.of(context).primaryColor,
              // child: const SizedBox(
              //   width: 80,
              //   height: 80,
              // ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'City Name',
                      // overflow: TextOverflow.ellipsis,
                      maxLines:1,
                      style: TextStyle(
                          color:   Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        'Thomasville Rd, ',
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
            // SizedBox(width: 20,),
            Flexible(

              child: Column(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: ScrollPhysics(),

                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    itemBuilder: (BuildContext, index) {
                      return Container(
                        height: 24,
                        // margin: EdgeInsets.only(right: 0),
                        width: 24,
                        // child: Image.asset("assets/images/amenities/Accessible.png"),
                        // child: amenitiesList == [] ? Image.asset("assets/images/amenities/Accessible.png") : Image.network(amenitiesList![0]),
                        child: SvgPicture.asset("assets/images/location/editing.svg")

                        // decoration: BoxDecoration(
                        //   color: Theme.of(context).primaryColor,
                        //   shape: BoxShape.circle,
                        // ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 5,); },),
                ],

                // children: [
                //   Row(
                //     children: [
                //       Icon(Icons.star,color: Colors.amber,),
                //       Text('${widget.city!.rating}'),
                //     ],
                //   ),
                //   Row(
                //     children: [
                //       Icon(Icons.location_on_rounded,color: Colors.deepOrangeAccent,),
                //       Text(widget.city!.distance!),
                //     ],
                //   ),
                //
                // ],
              ),

            )
          ],
        ),
      ),
    );
  }

}