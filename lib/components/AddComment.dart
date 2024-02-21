import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:happifeet_client_app/model/AssignedUsers/AssignedUserData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/FeedbackStatus/FeedbackStatusDetails.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/screens/Reports/StatusDetailPage.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:image_picker/image_picker.dart';

class AddComment extends StatefulWidget {
  String? reportId;
  String? assignedTo;
  Function? onSuccess;
  Function? onFailure;
  Function? dataCallback;
  Function? onRequest;
  bool? isQuickComment;

  @override
  State<AddComment> createState() => _AddCommentState();

  AddComment(
      {this.reportId,
      this.assignedTo,
      this.onSuccess,
      this.onFailure,
      this.dataCallback,
      this.onRequest,
      this.isQuickComment});

  gotoAddComment(BuildContext context, String reportId, String? assignedTo,
      Function onSuccess, Function onRequest) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => StatusDetailPage()));
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => AddComment(
                  reportId: reportId,
                  assignedTo: assignedTo,
                )))
        .then((value) {
      onSuccess();
      onRequest();
    });
  }
}

class _AddCommentState extends State<AddComment> {
  final _form = GlobalKey<FormState>();

  String? dropdownValueSelected = "";

  List<XFile>? imageFile = [];

  Status isStatusSelected = Status.Pending;

  TextEditingController commentsController = TextEditingController();

  Future<List<FeedbackStatusDetails>>? apiResponse;
  List<AssignedUserData>? userListing = [];
  Future<List<AssignedUserData>>? apiResponseListing;
  bool? textVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    getAssignedUserListing();
    log("dataaaaaaa->> ${widget.assignedTo}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: FutureBuilder<List<AssignedUserData>?>(
          future: apiResponseListing,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              log("user listing --> ${snapshot.data} ");
              userListing = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Please provide a comment";
                        }
                      },
                      onTapOutside: (value){
                        FocusManager.instance.primaryFocus?.unfocus();
                      },

                      maxLines: 4,
                      controller: commentsController,
                      decoration: const InputDecoration(
                        // labelText: labelText,
                        hintText: 'Enter Your Comments',
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey)),
                      )),

                  /** Status **/
                  const SizedBox(
                    height: 24,
                  ),
                  const Text("Status",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isStatusSelected = Status.Resolved;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(
                            color: isStatusSelected == Status.Resolved
                                ? ColorParser().hexToColor(RuntimeStorage
                                    .instance.clientTheme!.button_background!)
                                : Colors.grey,
                          ),
                        ),
                        child: Text(
                          "Resolved",
                          style: TextStyle(
                              color: isStatusSelected == Status.Resolved
                                  ? ColorParser().hexToColor(RuntimeStorage
                                      .instance.clientTheme!.button_background!)
                                  : Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isStatusSelected = Status.Pending;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(
                              color: isStatusSelected != Status.Pending
                                  ? Colors.grey
                                  : ColorParser().hexToColor(RuntimeStorage
                                      .instance
                                      .clientTheme!
                                      .button_background!),
                            ),
                          ),
                          child: Text(
                            "Pending",
                            style: TextStyle(
                              color: isStatusSelected != Status.Pending
                                  ? Colors.grey
                                  : ColorParser().hexToColor(RuntimeStorage
                                      .instance
                                      .clientTheme!
                                      .button_background!),
                            ),
                          ))
                    ],
                  ),

                  /** Assigned To **/
                  const SizedBox(
                    height: 24,
                  ),
                  const Text("Assigned To",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      (widget.assignedTo == null || widget.assignedTo!.isEmpty)
                          ?
                          // Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                          //     border: Border.all(color: Colors.grey)),
                          //   child: DropdownButton(
                          //     value: dropdownValueSelected,
                          //     isExpanded: true,
                          //     hint: Text("Select"),
                          //     underline: SizedBox(),
                          //     items: [
                          //       for (int i = 0; i < userListing!.length; i++)
                          //         DropdownMenuItem(
                          //           value: userListing![i].name!,
                          //           child: Text(userListing![i].name!),
                          //         )
                          //     ],
                          //     onChanged: (park) {
                          //       dropdownValueSelected = park;
                          //       log("Selected PARK => $park");
                          //       setState(() {});
                          //     },
                          //   ),
                          // )

                          DropdownMenu<String>(
                              expandedInsets: EdgeInsets.all(0),
                              enableSearch: false,
                              // enabled: widget.assignedTo == null,
                              enabled: true,
                              inputDecorationTheme: InputDecorationTheme(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10))),
                              requestFocusOnTap: false,
                              label: const Text('Select'),
                              initialSelection: dropdownValueSelected,
                              onSelected: (String? park) {
                                dropdownValueSelected = park;
                                log("Selected PARK => $park");
                                setState(() {});
                              },
                              dropdownMenuEntries: [
                                for (int i = 0; i < userListing!.length; i++)
                                  DropdownMenuEntry<String>(
                                    value: userListing![i].id!,
                                    label: userListing![i].name!,
                                  ),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: SizedBox(
                                height: 56,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                        "${widget.assignedTo != null && userListing!.isNotEmpty ? userListing!.where((element) => element.id == widget.assignedTo).toList().first.name : ""}"),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),

                  /** Upload File **/
                  const SizedBox(
                    height: 24,
                  ),
                  const Text("Upload File",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    // height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Resources.colors.hfText),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {
                            setState(() {
                              if (imageFile!.length < 3) {
                                textVisible = false;
                                getFromGallery();
                              } else {
                                textVisible = true;
                                !widget.isQuickComment! ?
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Max 3 images can be uploaded'))) : null;
                              }
                            });
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              side: BorderSide(
                                color: ColorParser().hexToColor(RuntimeStorage
                                    .instance.clientTheme!.button_background!),
                              ),
                            ),
                            child: Text(
                              "Choose File",
                              style: TextStyle(
                                  color: ColorParser().hexToColor(RuntimeStorage
                                      .instance
                                      .clientTheme!
                                      .button_background!)),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                           Text("${imageFile!.length} File Selected")
                        ],
                      ),
                    ),
                  ),
                  widget.isQuickComment! ?
                  Visibility(
                    visible: textVisible!,
                      child: Text("Max 3 images can be uploaded",style: TextStyle(color: Colors.red),)) : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0),
                    child: SizedBox(
                      height: 56,
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () {
                          submitComment();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorParser().hexToColor(
                                RuntimeStorage
                                    .instance.clientTheme!.button_background!),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<AssignedUserData>> getAssignedUserListing() async {
    apiResponseListing = ApiFactory().getUserService().getUserData(
        "list_assigned_users", await SharedPref.instance.getUserId());
    var response = await apiResponseListing;

    userListing = response;

    userListing!.forEach((element) {
      print("Checking User => ${element.toJson()}");
      if (element.id == widget.assignedTo) {
        print("Found Assigned To => ${element.toJson()}");
      }
    });

    if (userListing!.any((element) => element.id == widget.assignedTo)) {
      if (userListing!
          .where((element) => element.id == widget.assignedTo)
          .toList()
          .isNotEmpty) {
        dropdownValueSelected = userListing!
            .where((element) => element.id == widget.assignedTo)
            .toList()
            .first
            .id;
      }
    }

    setState(() {});
    return userListing!;
  }

  void getFromGallery() async {
    try {
      log("inside gallery functiom");
      List<XFile> pickedFile = await ImagePicker().pickMultiImage(
        imageQuality: 100,
        // source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          // imageFile = List.from(pickedFile);
          imageFile!.addAll(pickedFile);

          log("imageFile data inside gallery func ${imageFile}");
          log("inside gallery functiom 2 ${imageFile!.length}");

          if (imageFile!.length > 3) {
            imageFile!.clear();
            if(!widget.isQuickComment!){

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Max 3 files can be uploaded")));
            }else{
              setState(() {
                textVisible = true;
              });
            }

            // !widget.isQuickComment! ?
            //
            // ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("Max 3 files can be uploaded"))) : null;

          } else {
            // Future.delayed(Duration(seconds: 3),() {
            //
            //   CircularProgressIndicator();
            // });
          }
        });
      }
    } catch (e) {
      log('exception in pick image${e}');
    }
  }

  Future<void> submitComment() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    Map<String, dynamic> params = {
      "rpt_id": widget.reportId,
      "comment": commentsController.text,
      "status": isStatusSelected.name,
      "status": isStatusSelected.name,
      "assignedto": dropdownValueSelected,
    };

    BaseResponse response = await ApiFactory()
        .getFeedbackStatusService()
        .submitComment(params, imageFile);
    if (response.status == 1) {
      getAssignedUserListing();
      widget.onSuccess!();
      widget.onRequest;
    } else {
      widget.onFailure!(response.msg);
    }
  }
}
