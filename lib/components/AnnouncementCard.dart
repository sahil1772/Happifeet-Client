import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/screens/Manage/ManageAnnouncements/AddAnnouncement.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';

import '../model/Announcement/AnnouncementData.dart';
import '../utils/ColorParser.dart';

class AnnouncementCard extends StatefulWidget {
  AnnouncementData? announcemntData;
  Function? callback;

  AnnouncementCard({super.key, this.announcemntData, this.callback});

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  List? createdDate;

  @override
  void initState() {
    // TODO: implement initState
    createdDate = widget.announcemntData!.created_at!.split("-");
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
          boxShadow: const [
            BoxShadow(blurRadius: 3, color: Colors.black12, spreadRadius: 2),
          ],
          borderRadius: BorderRadius.circular(10),
        ),

        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text("22",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w400,color: Resources.colors.buttonColorDark),),
                            // Text("June",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.buttonColorDark)),
                            // Text("2023",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Resources.colors.buttonColorDark)),

                            Text(
                              ' ${createdDate![0].toString().split(" ")[0]}',
                              style: TextStyle(
                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                  fontSize: 24),
                            ),
                            Text("${createdDate![1]}",
                                style: TextStyle(
                                    color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                    fontSize: 14)),
                            Text("${createdDate![2]}",
                                style: TextStyle(
                                    color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.announcemntData!.title!,
                              // overflow: TextOverflow.ellipsis,
                              // maxLines:2,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              maxLines: 1,
                              style:  TextStyle(
                                  color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: Text(
                                widget.announcemntData!.description!,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style:  TextStyle(color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.body_text_color!)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(width: 10),
              const SizedBox(
                width: 15,
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
                        onTap: () =>
                            AddAnnouncementWidget.gotoAddAnnouncementPage(
                                context,
                                true,
                                widget.announcemntData!.id,
                                () => widget.callback!()),
                        child: SvgPicture.asset(
                            "assets/images/activityReport/visible.svg")),
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
