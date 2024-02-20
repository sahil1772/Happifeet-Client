import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../model/AssignedUsers/AssignedUserData.dart';
import '../screens/Manage/ManageUsers/AddAssignedUser.dart';
import '../screens/Manage/ManageUsers/AssignedUserListing.dart';

class UserListingCard extends StatefulWidget {
  AssignedUserData? assignedUserdata;
  Function? refreshCallback;

  UserListingCard({super.key, this.assignedUserdata, this.refreshCallback});

  @override
  State<UserListingCard> createState() => _UserListingCardState();
}

class _UserListingCardState extends State<UserListingCard> {
  bool forEdit = true;

  @override
  void initState() {
    // TODO: implement initState
    log("DATA IN USER LISTING CARD ${widget.assignedUserdata!.toJson()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
        // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black,
          // ),
          boxShadow: const [
            BoxShadow(blurRadius: 3, color: Colors.black12, spreadRadius: 2),
          ],
          borderRadius: BorderRadius.circular(10),
        ),

        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SizedBox(
                  height: 165,
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.assignedUserdata!.name}',
                              // overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: ColorParser().hexToColor(RuntimeStorage
                                      .instance
                                      .clientTheme!
                                      .top_title_background_color!),
                                  fontSize: 18,
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
                              child: Row(mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/manageUser/mail.svg"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${widget.assignedUserdata!.emailid}',
                                    softWrap: true,
                                    maxLines: 1,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(  fontSize: 16,
                                        color: ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .body_text_color!)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/manageUser/call.svg"),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '${widget.assignedUserdata!.contactno}',
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: ColorParser().hexToColor(
                                                RuntimeStorage.instance.clientTheme!
                                                    .body_text_color!)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 1.0),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         'Note: ${widget.assignedUserdata!.note_remark}',
                            //         softWrap: true,
                            //         maxLines: 1,
                            //         overflow: TextOverflow.clip,
                            //         style: TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 10),
                      const SizedBox(
                        width: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  // height: 60,
                  // width: 45,
                  width: MediaQuery.of(context).size.width / 8.5,
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

                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                          onTap: () {
                            AddAssignedUserWidget().goToAddAssignedUser(
                                context, widget.assignedUserdata!.id, forEdit,
                                () {
                              log("CALLBACK FROM USER LISTING CARD");
                              widget.refreshCallback!();
                            });
                          },
                          child: SvgPicture.asset(
                              "assets/images/location/editing.svg")),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(color: Colors.grey.shade200),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete User"),
                                    content: Text(
                                        "Are you sure you want to delete this user?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            var response = await ApiFactory()
                                                .getUserService()
                                                .deleteUserData(
                                                    "delete_assigned_user",
                                                    widget.assignedUserdata!.id!);
                                            if (response.status == "1") {
                                              log("User Deleted Successfully");
                                              Navigator.pop(context);
                
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "User Deleted Successfully")));
                                            } else {
                                              log("Error in user delete");
                                            }
                                          },
                                          child: Text("Yes")),
                                      TextButton(
                                          onPressed: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                          child: Text("No")),
                                    ],
                                  );
                                });
                          },
                          child: SvgPicture.asset(
                              "assets/images/location/delete.svg")),
                      const SizedBox(
                        height: 8,
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
