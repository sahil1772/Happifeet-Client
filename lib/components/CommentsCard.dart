import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../resources/resources.dart';
import '../storage/runtime_storage.dart';

class CommentsCard extends StatefulWidget {
  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 435,
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
        // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black,
          // ),
          boxShadow: [
            BoxShadow(blurRadius: 3, color: Colors.black12, spreadRadius: 2),
          ],
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/location.svg",colorFilter: ColorFilter.mode(ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!), BlendMode.srcIn),),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Tallahassee, FL 32309, USA",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/profile.svg",colorFilter: ColorFilter.mode(ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!), BlendMode.srcIn),),
                            SizedBox(
                              width: 10,
                            ),
                            Text("John Wikk",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                          ],
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/email.svg",colorFilter: ColorFilter.mode(ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!), BlendMode.srcIn),),
                            SizedBox(
                              width: 10,
                            ),
                            Text("tester7701@gmail.com",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        SvgPicture.asset("assets/images/comments/visible.svg"),
                        SizedBox(
                          height: 4,
                        ),
                        Divider(color: Colors.grey.shade200),
                        SizedBox(
                          height: 4,
                        ),
                        SvgPicture.asset("assets/images/comments/delete.svg"),
                        SizedBox(
                          height: 4,
                        ),
                        Divider(color: Colors.grey.shade200),
                        SizedBox(
                          height: 4,
                        ),
                        SvgPicture.asset("assets/images/comments/contact.svg"),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            //////////////////////////////////////////

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Share Anonymously",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                        ),
                        Text("Yes",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Recommend",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        Text("HappiLy",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Assigned By",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        Text("User 1",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                      ],
                    ),
                    VerticalDivider(
                      color: Colors.grey.shade200,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rating",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        RatingBar.builder(
                            glow: false,
                            glowColor: ColorParser().hexToColor("#C99700"),

                            // initialRating: 3,
                            itemSize: 22,
                            direction: Axis.horizontal,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (BuildContext, index) {
                              // return SvgPicture.asset("assets/images/feedback/star_rating.svg",colorFilter: ColorFilter.mode(ColorParser().hexToColor("#C99700"), BlendMode.srcIn),);
                              return Icon(Icons.star,
                                  size: 10,
                                  color: ColorParser().hexToColor("#C99700"));
                            },
                            onRatingUpdate: (rating) {}),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Date",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        Text("09 Jan, 2023",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Assigned By",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                        Text("User 2",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        // AddLocation().gotoAddLocation(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                  maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}
