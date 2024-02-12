import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../model/Comments/CommentData.dart';
import '../network/ApiFactory.dart';
import '../resources/resources.dart';

class CommentsCard extends StatefulWidget {
  CommentsCard({super.key, this.data, this.onClick});

  CommentData? data;

  Function? onClick;

  @override
  State<CommentsCard> createState() => _CommentsCardState();

}

class _CommentsCardState extends State<CommentsCard> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController commentController = TextEditingController();

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
                              "assets/images/comments/location.svg",
                              colorFilter: ColorFilter.mode(
                                  ColorParser().hexToColor(RuntimeStorage
                                      .instance
                                      .clientTheme!
                                      .top_title_background_color!),
                                  BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.data?.park_name}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/images/comments/profile.svg",colorFilter: ColorFilter.mode( ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!), BlendMode.srcIn),),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${widget.data?.user_name == "" ? "-" : widget.data?.user_name}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        InkWell(
                          onTap: () {
                            widget.data?.email_address != ""
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        clipBehavior: Clip.none,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 16),
                                          height: MediaQuery.of(context).size.height / 1.5,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Send email to user",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Subject",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Resources
                                                              .colors.hfText),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    TextField(
                                                        controller:
                                                            subjectController,
                                                        onChanged: (value) {},
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          // labelText: labelText,
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          // errorText: getEmailError(),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide: BorderSide(
                                                                  color: ColorParser()
                                                                      .hexToColor(
                                                                          "#D7D7D7"),
                                                                  width: 1)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: ColorParser()
                                                                      .hexToColor(
                                                                          "#D7D7D7"))),
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Comment",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Resources
                                                              .colors.hfText),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    TextField(
                                                        controller:
                                                            commentController,
                                                        onChanged: (value) {},
                                                        maxLines: 4,
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          // labelText: labelText,
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                          // errorText: getEmailError(),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide: BorderSide(
                                                                  color: ColorParser()
                                                                      .hexToColor(
                                                                          "#D7D7D7"),
                                                                  width: 1)),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: ColorParser()
                                                                      .hexToColor(
                                                                          "#D7D7D7"))),
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        var response = await ApiFactory
                                                                .getCommentService()
                                                            .sendEmailData(
                                                                widget.data!
                                                                    .email_address!,
                                                                subjectController
                                                                    .text,
                                                                commentController
                                                                    .text);
                                                        if (response!.status == "1") {
                                                          log("EMAIL DATA SENT SUCCESSFILLY");
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              content: Text("Email Sent")));
                                                          Future.delayed(Duration(seconds: 2),
                                                                  () {
                                                            Navigator.of(context).pop();
                                            
                                            
                                                              });
                                                        } else {
                                                          log("Error in submitting Email data");
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              ColorParser().hexToColor(
                                                                  RuntimeStorage
                                                                      .instance
                                                                      .clientTheme!
                                                                      .top_title_background_color!),
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)))),
                                                      child: Text(
                                                        "Send Email",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),

                                                Table(
                                                  // columnWidths: {0:FixedColumnWidth(0.6)},
                                                  defaultColumnWidth: const IntrinsicColumnWidth(),
                                                  children: [
                                                    const TableRow(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(right:10),
                                                          child: Text("Subject",style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: Colors.black),),
                                                        ),
                                                        Text("Comment", style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: Colors.black),),
                                                        Text("Added Date", style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: Colors.black),),
                                                      ],
                                                    ),
                                                    for(int i = 0; i<5; i++)
                                                    const TableRow(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(right:10,top:10),
                                                          child: Text("sfdfdddf"),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(top:10),
                                                          child: Text("gfgfgfgff ggfgfgff fgfgfgfgf ggfgfgfgf gfgfgfg"),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(top:10),
                                                          child: Text("fgfgfg fgfgfg fggfgfgf"),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                                // for(int i = 0; i<5; i++)
                                                // Row(children: [
                                                //   Column(
                                                //     children: [
                                                //       Text("abcd"),
                                                //     ],
                                                //   ),
                                                //   Column(
                                                //     children: [
                                                //       Text("hghghghghg rgrh ghghghghg hghghghg"),
                                                //     ],
                                                //   ),
                                                //   Column(
                                                //     children: [
                                                //       Text("qertuy erf"),
                                                //     ],
                                                //   ),
                                                // ],),
                                                //


                                                // SizedBox(
                                                //   height: 200,
                                                //   child: GridView.builder(
                                                //       gridDelegate:
                                                //       const SliverGridDelegateWithFixedCrossAxisCount(
                                                //         crossAxisCount: 3,
                                                //         mainAxisSpacing: 0,
                                                //         crossAxisSpacing: 20,
                                                //       ),
                                                //
                                                //       itemBuilder: (BuildContext context, index){
                                                //         return Row(
                                                //           children: [
                                                //             Text("Subject"),
                                                //             Text("Comment"),
                                                //             Text("Added Date"),
                                                //             Text("Subjedfgdrfgfgct"),
                                                //             Text("Subjegfdg fdggfffgfgfgfffffg fgfgfgfgfgfgfgfgfct"),
                                                //             Text("Subjgfgfg fgfgfect"),
                                                //           ],
                                                //         );
                                                //
                                                //       }),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                : null;
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/comments/email.svg",
                                colorFilter: ColorFilter.mode(
                                    ColorParser().hexToColor(RuntimeStorage
                                        .instance
                                        .clientTheme!
                                        .top_title_background_color!),
                                    BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  "${widget.data?.email_address == "" ? "-" : widget.data?.email_address}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: ColorParser().hexToColor(
                                          RuntimeStorage.instance.clientTheme!
                                              .body_text_color!))),
                            ],
                          ),
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
                        const SizedBox(
                          height: 12,
                        ),
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
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                        ),
                        Text("-",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                        Text("${widget.data?.recommend}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                      Text("${widget.data?.add_date}",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                        Text(
                            "${widget.data?.assigned_by == "" ? "-" : widget.data?.assigned_by}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
                      Text(
                          "${widget.data?.assigned_to == "" ? "-" : widget.data?.assigned_to}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!))),
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
                        backgroundColor:  ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
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
                  color:  ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
            ),
          ),
        ],
      ),
    );
  }
}
