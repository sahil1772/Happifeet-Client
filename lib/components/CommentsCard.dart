import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/model/Comments/CommentData.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../resources/resources.dart';

class CommentsCard extends StatefulWidget {
  CommentsCard({super.key, this.data, this.onClick});

  CommentData? data;

  Function? onClick;

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //   color: Colors.black,
        // ),
        boxShadow: [
          const BoxShadow(
              blurRadius: 3, color: Colors.black12, spreadRadius: 2),
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
            child: SizedBox(
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/location.svg"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.data?.park_name}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorParser().hexToColor("#757575")),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/profile.svg"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${widget.data?.user_name == "" ? "-" : widget.data?.user_name}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Resources.colors.hfText)),
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/email.svg"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${widget.data?.email_address == "" ? "-" : widget.data?.email_address}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Resources.colors.hfText)),
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
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              widget.onClick!(widget.data!.id);
                            },
                            child: SvgPicture.asset(
                                "assets/images/comments/visible.svg")),

                        Divider(color: Colors.grey.shade200),
                        // const SizedBox(
                        //   height: 4,
                        // ),
                        // InkWell(
                        //     child: SvgPicture.asset(
                        //         "assets/images/comments/delete.svg")),
                        // const SizedBox(
                        //   height: 4,
                        // ),
                        // Divider(color: Colors.grey.shade200),

                        InkWell(
                            child: SvgPicture.asset(
                                "assets/images/comments/contact.svg")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 0,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            end: BorderSide(
                      width: 1,
                      color: Colors.grey.shade200,
                    ))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Share Anonymously",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Resources.colors.hfText),
                        ),
                        Text("-",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Resources.colors.hfText)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Rating",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Resources.colors.hfText)),
                      RatingBar.builder(
                          glow: false,
                          tapOnlyMode: false,
                          ignoreGestures: true,
                          glowColor: ColorParser().hexToColor("#C99700"),
                          initialRating: double.parse(
                              "${widget.data?.rating == "" ? "0" : widget.data?.rating}"),
                          maxRating: double.parse(
                              "${widget.data?.rating == "" ? "0" : widget.data?.rating}"),
                          minRating: double.parse(
                              "${widget.data?.rating == "" ? "0" : widget.data?.rating}"),
                          itemSize: 22,
                          direction: Axis.horizontal,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, index) {
                            // return SvgPicture.asset("assets/images/feedback/star_rating.svg",colorFilter: ColorFilter.mode(ColorParser().hexToColor("#C99700"), BlendMode.srcIn),);
                            return Icon(Icons.star,
                                size: 10,
                                color: ColorParser().hexToColor("#C99700"));
                          },
                          onRatingUpdate: (rating) {}),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            end: BorderSide(
                      width: 1,
                      color: Colors.grey.shade200,
                    ))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Recommend",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Resources.colors.hfText)),
                        Text("${widget.data?.recommend}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Resources.colors.hfText)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Date",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Resources.colors.hfText)),
                      Text("${widget.data?.add_date}",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Resources.colors.hfText)),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            end: BorderSide(
                      width: 1,
                      color: Colors.grey.shade200,
                    ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Assigned By",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Resources.colors.hfText)),
                        Text(
                            "${widget.data?.assigned_by == "" ? "-" : widget.data?.assigned_by}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Resources.colors.hfText)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Assigned To",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Resources.colors.hfText)),
                      Text(
                          "${widget.data?.assigned_to == "" ? "-" : widget.data?.assigned_to}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Resources.colors.hfText)),
                    ],
                  ),
                ],
              )),

          /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // AddLocation().gotoAddLocation(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Resources.colors.buttonColorlight,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: Text(
                      "${widget.data?.status}",
                      style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              "${widget.data?.description}",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Resources.colors.hfText),
            ),
          ),
        ],
      ),
    );
  }
}
