import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/model/Announcement/AnnouncementData.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../i18n/locale_keys.g.dart';
import '../../../utils/ColorParser.dart';

class AddAnnouncementWidget extends StatefulWidget {
  gotoAddAnnouncementPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (_) => AddAnnouncementWidget()));
  }

  @override
  State<AddAnnouncementWidget> createState() => _AddAnnouncementWidgetState();
}

class _AddAnnouncementWidgetState extends State<AddAnnouncementWidget>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  double? labelTextSize = 14.0;
  Map<String, dynamic> languages = {};

  final _form = GlobalKey<FormState>();

  Map<String, Map<String, TextEditingController>> dataControllers = {
    "en": {
      "title": TextEditingController(),
      "description": TextEditingController()
    }
  };

  @override
  void initState() {
    // TODO: implement initState

    getLanguages().then((value) {
      languages = value;
      _controller = TabController(length: value.keys.length, vsync: this);

      _controller!.addListener(() {
        setState(() {
          log("CONTROLLER INDEX ${languages.keys.elementAt(_controller!.index)}");
          if (_controller!.indexIsChanging) {
            log("tab is changing");
            context.setLocale(Locale(
                languages.keys.elementAt(_controller!.index) == "spa"
                    ? "es"
                    : languages.keys.elementAt(_controller!.index)));
          } else {
            log("INSIDE ELSE OF LISTENER${_controller!.index}");
            context.setLocale(Locale(
                languages.keys.elementAt(_controller!.index) == "spa"
                    ? "es"
                    : languages.keys.elementAt(_controller!.index)));
          }
        });
      });

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    context.setLocale(const Locale("en"));
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double HEADER_HEIGHT = 4.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
          .getAppBar(context),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
                width: DeviceDimensions.getDeviceWidth(context),
                height: DeviceDimensions.getHeaderSize(context, HEADER_HEIGHT),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorParser().hexToColor("#34A846"),
                    ColorParser().hexToColor("#83C03D")
                  ],
                )),
                child: Container(
                  margin: DeviceDimensions.getHeaderEdgeInsets(context),
                  child: const Center(
                    child: Text(
                      "Add Announcement",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(
                  top: DeviceDimensions.getBottomSheetMargin(
                      context, HEADER_HEIGHT)),
              height:
                  DeviceDimensions.getBottomSheetHeight(context, HEADER_HEIGHT),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.white),
              // color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      LocaleKeys.Select_Language,
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                  ),
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _controller,
                      indicatorWeight: 1,
                      indicatorPadding: const EdgeInsets.all(0),
                      labelColor: const Color(0xff49AC43),
                      indicatorColor: const Color(0xff49AC43),
                      tabs: [
                        for (int i = 0; i < languages.keys.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              languages.values.elementAt(i).toUpperCase(),
                              style: TextStyle(
                                fontSize: labelTextSize,
                              ),
                            ),
                          ),
                      ]),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color(0x50aeaeae),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            _controller!.index == 0
                                ? loadContent()
                                : otherLanguageFields(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loadContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            LocaleKeys.Title,
            style: TextStyle(
                fontSize: labelTextSize, color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            validator: (text) {
              if (text!.isEmpty) {
                return LocaleKeys.Provide_Valid_Data.tr();
              }
              return null;
            },
            controller: dataControllers["en"]!["title"],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        //  Upload Image
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Upload Image",
            style: TextStyle(
                fontSize: labelTextSize, color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffc4c4c4),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, right: 200, bottom: 10),
              child: OutlinedButton(
                onPressed: () {},
                child: const Text("Choose Image"),
              ),
            ),
          ),
        ),

        //Description
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Description",
            style: TextStyle(
                fontSize: labelTextSize, color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            validator: (text) {
              if (text!.isEmpty) {
                return LocaleKeys.Provide_Valid_Data.tr();
              }
              return null;
            },
            controller: dataControllers["en"]!["description"],
            maxLines: 5,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 56.0),
          child: ElevatedButton(
              onPressed: () {
                submitDetails();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Submit"),
              )),
        )
      ],
    );
  }

  otherLanguageFields() {
    if (!dataControllers
        .containsKey(languages.keys.elementAt(_controller!.index))) {
      dataControllers.addAll({
        languages.keys.elementAt(_controller!.index): {
          "title": TextEditingController(),
          "description": TextEditingController(),
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            LocaleKeys.Title,
            style: TextStyle(
                fontSize: labelTextSize, color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            controller: dataControllers[
                languages.keys.elementAt(_controller!.index)]!["title"],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        //Description
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Description",
            style: TextStyle(
                fontSize: labelTextSize, color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            controller: dataControllers[
                languages.keys.elementAt(_controller!.index)]!["description"],
            maxLines: 5,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffc4c4c4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 56.0),
          child: ElevatedButton(
              onPressed: () {
                submitOtherDetails();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Submit"),
              )),
        )
      ],
    );
  }

  Future<Map<String, dynamic>> getLanguages() async {
    Map<String, dynamic> lang = {};
    lang.addAll({"en": "English"});
    lang.addAll(await SharedPref.instance.getLanguageList());

    return Future.value(lang);
  }

  Future<void> submitDetails() async {
    bool isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    AnnouncementData data = AnnouncementData();
    data.title = dataControllers["en"]!["title"]!.text;
    data.description = dataControllers["en"]!["description"]!.text;




    BaseResponse response = await ApiFactory()
        .getAnnouncementService()
        .submitAnnouncementDetails(data,null);
  }

  void submitOtherDetails() {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
  }

  

}
