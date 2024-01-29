import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/FeedbackStatus/FeedbackStatusDetails.dart';
import '../../resources/resources.dart';
import '../../utils/ColorParser.dart';

List<String> fieldOptions = ['Item 1', 'Item 2', 'Item 3', "Item 4"];

class StatusDetailPage extends StatefulWidget {
  String? report_id;

  StatusDetailPage({Key? key, this.report_id});

  gotoStatusFilterPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => StatusDetailPage()));
  }

  @override
  State<StatusDetailPage> createState() => _StatusDetailPageState();
}

class _StatusDetailPageState extends State<StatusDetailPage> {
  String? dropdownValueSelected = fieldOptions.first;
  List<XFile>? imageFile = [];
  bool isSelected = true;
  bool isStatusSelected = true;
  bool isQrSelected = true;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<FeedbackStatusDetails>? getStatusDetails;
  Future<List<FeedbackStatusDetails>>? apiResponse;

  @override
  void initState() {
    // TODO: implement initState
    apiResponse = getFeedbackStatusDetails();
    super.initState();
  }

  Future<List<FeedbackStatusDetails>>? getFeedbackStatusDetails() async {
    var response =  ApiFactory()
        .getFeedbackStatusService()
        .getFeedbackStatusDetails("feedback_view_report", widget.report_id!);
    log("DATA IN STATUS DETAILS ${getStatusDetails}");
     getStatusDetails = await response;
     return getStatusDetails!;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Resources.colors.buttonColorlight,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/comments/close.svg"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Close",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 35,
              ),

              /** QUESTIONS **/

              FutureBuilder<List<FeedbackStatusDetails>?>(
                future: apiResponse,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        return GridView(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 15,
                              mainAxisExtent: 80),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Location Name",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(getStatusDetails!.first.park_name!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Share Anonymously",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(getStatusDetails!.first.anonymous_user!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("User Name",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(getStatusDetails!.first.user_name!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email Address",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(getStatusDetails!.first.email_address!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Message",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text("Maybe",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Send Updates via Email",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(
                                getStatusDetails!.first.send_updates!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rating",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(
                      getStatusDetails!.first.rating!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Recommend",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(
                      getStatusDetails!.first.recommend!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("How safe do you feel hhhgfgh",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(
                                    getStatusDetails!.first.how_safe_feel!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Zip code",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black)),
                                Text(
                                    getStatusDetails!.first.zip_code_live!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Resources.colors.hfText))
                              ],
                            ),
                          ],
                        );
                      }
                      else if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }else{
                        return Text("Something Went Wrong");
                      }

                },
              ),

              /** OLD CODE  **/
              //  Padding(
              //   padding: EdgeInsets.symmetric(vertical: 24),
              //   child: Column(
              //     children: [
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Location Name", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("401107",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //           SizedBox(width: 20,),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Share Anonymously",style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("yes",style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 10,),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("User Name", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("Maybe",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //           SizedBox(width: 20,),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Email Address", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("Test",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 10,),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Question here For Test", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("Maybe",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //           SizedBox(width: 20,),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("When At the Park How Safe You fee", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("4",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 10,),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Tell us what made you Happi / Sad today ?", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("Test",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //           SizedBox(width: 20,),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("Rate Quality Of Your Experience", style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black)),
              //               Text("Good",  style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.w300,
              //                   color: Resources.colors.hfText))
              //             ],
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              /** SELECT LANG **/
              SizedBox(
                height: 24,
              ),
              Text("Select Language",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isSelected
                            ? Resources.colors.buttonColorlight
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      "English",
                      style: TextStyle(
                          color: isSelected
                              ? Resources.colors.buttonColorlight
                              : Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isSelected
                            ? Colors.grey
                            : Resources.colors.buttonColorlight,
                      ),
                    ),
                    child: Text(
                      "Español",
                      style: TextStyle(
                          color: isSelected
                              ? Colors.grey
                              : Resources.colors.buttonColorlight),
                    ),
                  )
                ],
              ),

              /** COMMENTS **/
              SizedBox(
                height: 24,
              ),
              const Text("Comments",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                  maxLines: 4,
                  decoration: const InputDecoration(
                    // labelText: labelText,
                    hintText: 'Enter Your Comments',
                    hintStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    // errorText: getEmailError(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.grey, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                  )),

              /** Status **/
              SizedBox(
                height: 24,
              ),
              Text("Status",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isSelected
                            ? Resources.colors.buttonColorlight
                            : Colors.grey,
                      ),
                    ),
                    child: Text(
                      "Complete",
                      style: TextStyle(
                          color: isSelected
                              ? Resources.colors.buttonColorlight
                              : Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isSelected
                            ? Colors.grey
                            : Resources.colors.buttonColorlight,
                      ),
                    ),
                    child: Text(
                      "Pending",
                      style: TextStyle(
                          color: isSelected
                              ? Colors.grey
                              : Resources.colors.buttonColorlight),
                    ),
                  )
                ],
              ),

              /** Assigned To **/
              SizedBox(
                height: 24,
              ),
              const Text("Assigned To",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                          dropdownColor: Colors.white,

                          // isDense: true,
                          //   isExpanded: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorParser().hexToColor("#D7D7D7")),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorParser().hexToColor("#D7D7D7")),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          value: dropdownValueSelected,
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          iconSize: 30,
                          items: fieldOptions
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Resources.colors.hfText)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              log("before ${value}");
                              dropdownValueSelected = value!;
                              // sendSmtpData!.smtpSecurity = value;
                              // ListOfFeedbackDetails.first.value = value;
                              log("after ${dropdownValueSelected}");
                            });
                          }),
                    ),
                  ),
                ],
              ),

              /** Upload File **/
              SizedBox(
                height: 24,
              ),
              const Text("Upload File",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              SizedBox(
                height: 8,
              ),
              Container(
                // height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Resources.colors.hfText),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (imageFile!.length < 3) {
                            getFromGallery();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Max 3 images can be uploaded')));
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Resources.colors.buttonColorlight,
                          ),
                        ),
                        child: Text(
                          "Choose File",
                          style: TextStyle(
                              color: Resources.colors.buttonColorlight),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("File")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Max 3 files can be uploaded")));
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
}
