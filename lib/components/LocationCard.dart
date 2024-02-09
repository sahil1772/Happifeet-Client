import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/components/DownloadProgressDialog.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageLocation/AddLocation.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:happifeet_client_app/utils/PermissionUtils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/Location/LocationData.dart';
import '../storage/runtime_storage.dart';

class LocationCard extends StatefulWidget {
  LocationData? locationDetails;

  LocationCard({Key? key, this.locationDetails, this.eventListener});

  Function? eventListener;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

enum events { DELETE, EDIT, QR }

class _LocationCardState extends State<LocationCard> {
  @override
  void initState() {
    // TODO: implement initState
    // log("locationDetails List ${widget.locationDetails!.park_name}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        padding: const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 0),
        // margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
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
                    child: Image.network(widget.locationDetails!.image!),
                    // child: Image.asset(widget.city!.location_image!),
                  ),
                  // color: Theme.of(context).primaryColor,
                  // child: const SizedBox(
                  //   width: 80,
                  //   height: 80,
                  // ),
                ),
              ),
              Expanded(
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
                            color: ColorParser().hexToColor(RuntimeStorage
                                .instance
                                .clientTheme!
                                .top_title_background_color!),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text(
                          widget.locationDetails!.address1!,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: ColorParser().hexToColor(RuntimeStorage
                                .instance.clientTheme!.body_text_color!),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text(
                          widget.locationDetails!.address2!,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: ColorParser().hexToColor(RuntimeStorage
                                .instance.clientTheme!.body_text_color!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 10),
              const SizedBox(
                width: 35,
              ),
              Container(
                height: 60,
                width: 35,
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
                    InkWell(
                        onTap: () {
                          log("Editing Park ID => ${widget.locationDetails!.park_id!}");
                          AddLocation.gotoAddLocation(
                              context, true, widget.locationDetails!.park_id!);
                        },
                        child: SvgPicture.asset(
                            "assets/images/location/editing.svg")),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(color: Colors.grey.shade200),
                    InkWell(
                        onTap: () {
                          print(
                              "TO DELETE PARK => ${widget.locationDetails!.toJson()}");
                          showDialog(
                            context: context,
                            builder: (context) {
                              return showAlertDialog(context);
                            },
                          );
                        },
                        child: SvgPicture.asset(
                            "assets/images/location/delete.svg")),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                        onTap: () async {
                          bool result = await PermissionUtils.permissionRequest();
                          if (result) {
                            widget.locationDetails!.qrImage != null
                                ? showDialog(
                                    context: context,
                                    builder: (dialogcontext) {
                                      return DownloadProgressDialog(
                                        filePath:
                                            widget.locationDetails!.qrImage!,
                                      );
                                    })
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "QR image not available to download")));
                          } else {
                            print("No permission to read and write.");
                          }
                          // _saveImage(context: context,downloadImage: widget.locationDetails!.qrImage!);
                        },
                        child: SvgPicture.asset(
                            "assets/images/location/qrCode.svg")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _saveImage({required BuildContext context,required String downloadImage}) async {
  //   String? message;
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //
  //   try {
  //     // Download image
  //     final http.Response response = await http.get(Uri.parse(downloadImage));
  //
  //     // Get temporary directory
  //     final dir = await getTemporaryDirectory();
  //
  //     // Create an image name
  //     var filename = '${dir.path}/image.png';
  //
  //     // Save to filesystem
  //     final file = File(filename);
  //     await file.writeAsBytes(response.bodyBytes);
  //
  //     // Ask the user to save it
  //     final params = SaveFileDialogParams(sourceFilePath: file.path);
  //     final finalPath = await FlutterFileDialog.saveFile(params: params);
  //
  //     if (finalPath != null) {
  //       message = 'Image saved to disk';
  //     }
  //   } catch (e) {
  //     message = 'An error occurred while saving the image';
  //   }
  //
  //   if (message != null) {
  //     scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  //   }
  // }

  AlertDialog showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        deleteLocation(() {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location Deleted Successfully!")));
          widget.eventListener!(events.DELETE);
        }, (message) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        });
      },
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      title: const Text("Are you sure?"),
      content: RichText(
          text: TextSpan(children: [
        const TextSpan(
            text: "Please confirm if you want to delete ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        TextSpan(
            text: "${widget.locationDetails!.park_name}",
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const TextSpan(
            text: " ?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
      ])),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    return alert;
  }

  void deleteLocation(Function onSuccess, Function onError) async {
    BaseResponse response = await ApiFactory()
        .getLocationService()
        .deleteLocationData(widget.locationDetails!.park_id!);
    if (response.status == "1") {
      onSuccess();
    } else {
      onError(response.msg);
    }
  }


}
