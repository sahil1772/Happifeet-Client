import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:happifeet_client_app/components/HappiFeetAppBar.dart';
import 'package:happifeet_client_app/i18n/locale_keys.g.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Trails/TrailPayload.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';
import 'package:image_picker/image_picker.dart';

class AddTrail extends StatefulWidget {
  AddTrail({super.key, this.isEdit, this.trailId});

  bool? isEdit;
  String? trailId;

  static goToAddTrail(BuildContext context, bool? isEdit, String? trailId) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => AddTrail(isEdit: isEdit, trailId: trailId)));
  }

  @override
  State<AddTrail> createState() => _AddTrailState();
}

class _AddTrailState extends State<AddTrail>
    with SingleTickerProviderStateMixin {
// FORM VARIABLE USED FOR VALIDATIONS -- TRAILS
  final _form = GlobalKey<FormState>();

  //IMAGE PICKER INSTANCE TO USE FOR PICKING FROM CAMERA OR GALLERY  -- TRAILS
  final ImagePicker _picker = ImagePicker();

  //PICKER FILE INSTANCES USED TO STORE PICKED OR CAPURED FILES
  XFile? locationImage;
  List<XFile>? galleryImages = [];

  //Trail ID STORE IN VARIABLE ON SUCCESSFUL ENGLISH DATA INSERTION
  String? trailId = "";

  // CONTROLLERS
  TabController? _controller;

  //MISC VARIABLES
  dynamic _pickImageError;
  Map<String, dynamic> languages = {};
  Map<String, Map<String, TextEditingController>> dataControllers = {};

  //DISPLAY VARIABLES
  double? labelTextSize = 12.0;
  double? fontLabelTextSize = 14.0;
  double HEADER_HEIGHT = 5.0;

  //SCOPED CONTEXT
  BuildContext? buildContext;

  //Controllers for English Form
  TextEditingController trailNameController = new TextEditingController();
  TextEditingController trailDescriptionController =
      new TextEditingController();
  TextEditingController trailDistanceController = new TextEditingController();
  TextEditingController trailOpeningController = new TextEditingController();
  TextEditingController trailOpening2Controller = new TextEditingController();

  List<Difficulty> difficulties = [];

  String? selectedDifficultyID = "";
  bool isChecked = true;

  Future<TrailPayload?>? response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLanguages().then((value) {
      languages = value;
      _controller = TabController(length: value.keys.length, vsync: this);

      _controller!.addListener(() {
        setState(() {
          // context.setLocale(Locale("en"));
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
          response = getTrailData();
        });
      });

      if (dataControllers.containsKey("en")) {
        trailNameController = dataControllers["en"]!["trailName"]!;
        trailDescriptionController = dataControllers["en"]!["trailDesc"]!;
        trailDistanceController = dataControllers["en"]!["trailDistance"]!;
        trailOpeningController = dataControllers["en"]!["trailOpen_1"]!;
        trailOpening2Controller = dataControllers["en"]!["trailOpen_2"]!;
      } else {
        dataControllers.addAll({
          "en": {
            "trailName": trailNameController,
            "trailDesc": trailNameController,
            "trailDistance": trailNameController,
            "trailOpen_1": trailNameController,
            "trailOpen_2": trailNameController,
          },
        });
      }

      difficulties.add(Difficulty(name: "Easy", id: "Easy"));
      difficulties.add(Difficulty(name: "Moderate", id: "Moderate"));
      difficulties.add(Difficulty(name: "Difficult", id: "Difficult"));
      response = getTrailData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
            .getAppBar(context),
        body: Stack(
          children: [
            Container(
                height: DeviceDimensions.getHeaderSize(context, HEADER_HEIGHT),
                width: DeviceDimensions.getDeviceWidth(context),
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
                  margin: EdgeInsets.only(
                      top: HappiFeetAppBar(
                              isCitiyList: false, IsDashboard: false)
                          .getAppBar(context)
                          .preferredSize
                          .height,
                      bottom: DeviceDimensions.BOTTOMSHEET_TOP_MARGIN),
                  child: const Center(
                    child: Text(
                      "Add Trail",
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
                      child: Column(
                        children: [
                          _controller!.index == 0
                              ? loadEnglishBody()
                              : otherLanguageFields(),
                        ],
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

  Future<Map<String, dynamic>> getLanguages() async {
    Map<String, dynamic> lang = {};
    lang.addAll({"en": "English"});
    lang.addAll(await SharedPref.instance.getLanguageList());

    return Future.value(lang);
  }

  Widget loadEnglishBody() {
    return Form(
      key: _form,
      child: FutureBuilder<TrailPayload?>(
          future: response,
          builder: (context, snapshot) {
            Widget toReturnWidget;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                toReturnWidget = const Center(
                    child: Padding(
                  padding: EdgeInsets.all(56.0),
                  child: CircularProgressIndicator(),
                ));
                break;
              case ConnectionState.done:
                if (snapshot.data != null) {
                  log("Connection Done => ${snapshot.data!.toJson()}");
                }
                toReturnWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ===========================  Todo ==> Location Name
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Trail Name*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid Trail name!";
                                }
                                return null;
                              },
                              controller: trailNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Trail",
                                hintStyle: const TextStyle(
                                    color: Color(0xffabaaaa), fontSize: 13),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffc4c4c4),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffc4c4c4),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Distance
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Distance *",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid distance!";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              controller: trailDistanceController,
                              decoration: InputDecoration(
                                hintText: "Enter Zip*",
                                hintStyle: const TextStyle(
                                    color: Color(0xffabaaaa), fontSize: 13),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffc4c4c4),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffc4c4c4),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Opening Time (Trial days & timing)
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Opening Time (Trial days & timing) *",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: TextFormField(
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Enter valid opening time!";
                                      }
                                      return null;
                                    },
                                    controller: trailOpeningController,
                                    decoration: InputDecoration(
                                      hintText: "Enter Trail",
                                      hintStyle: const TextStyle(
                                          color: Color(0xffabaaaa),
                                          fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffc4c4c4),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 16),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffc4c4c4),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: TextFormField(
                                    controller: trailOpening2Controller,
                                    decoration: InputDecoration(
                                      hintText: "Enter Trail",
                                      hintStyle: const TextStyle(
                                          color: Color(0xffabaaaa),
                                          fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffc4c4c4),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 16),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffc4c4c4),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Location(Images / Photos)
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location (Images / Photos)",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xffc4c4c4),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          locationImage == null
                                              ? "No File Selected"
                                              : locationImage!.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: OutlinedButton(
                                            onPressed: () {
                                              _showBottomSheet(1);
                                            },
                                            child: const Text("Choose File"),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 0.0,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            )),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Gallery(Images / Photos)
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Gallery (Images / Photos)",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "(Only 5 allowed)",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xffc4c4c4),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          galleryImages!.isEmpty
                                              ? "No File Selected"
                                              : "${galleryImages!.length == 1 ? galleryImages!.first.name : "${galleryImages!.length} ${galleryImages!.length == 1 ? "File" : "Files"} Selected"}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: OutlinedButton(
                                            onPressed: () {
                                              if (galleryImages!.length >= 5) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Only 5 images are allowed")));
                                              } else {
                                                _showBottomSheet(2);
                                              }
                                            },
                                            child: const Text("Choose File"),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 0.0,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            )),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    // ===========================  Todo ==> Description
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Trail Description*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid address!";
                                }
                                return null;
                              },
                              controller: trailDescriptionController,
                              minLines: 3,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Enter Address",
                                hintStyle: const TextStyle(
                                    color: Color(0xffabaaaa), fontSize: 13),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffc4c4c4),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xffc4c4c4),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Difficulty Level
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Difficulty Level*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: DropdownMenu<String>(
                              width:
                                  DeviceDimensions.getDeviceWidth(context) - 32,
                              enableSearch: false,
                              inputDecorationTheme: InputDecorationTheme(
                                  alignLabelWithHint: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: Color(0xffc4c4c4))),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffc4c4c4)),
                                      borderRadius: BorderRadius.circular(10))),
                              requestFocusOnTap: false,
                              label: const Text('Select'),
                              initialSelection: selectedDifficultyID,
                              onSelected: (String? difficulty) {
                                selectedDifficultyID = difficulty;
                                log("Selected PARK => $difficulty");
                              },
                              dropdownMenuEntries: [
                                for (int i = 0; i < difficulties.length; i++)
                                  DropdownMenuEntry<String>(
                                    value: difficulties[i].id!,
                                    label: difficulties[i].name!,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Status
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FlutterSwitch(
                                    width: 120,
                                    value: isChecked,
                                    activeColor: Colors.green,
                                    showOnOff: true,
                                    valueFontSize: 16,
                                    activeText: "Active",
                                    inactiveText: "InActive",
                                    onToggle: (bool value) {
                                      isChecked = value!;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )),
                        ],
                      ),
                    )),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 56.0, top: 16),
                      child: ElevatedButton(
                          onPressed: () {
                            submit_English_Details();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text("Submit"),
                          )),
                    )
                  ],
                );
                break;
              case ConnectionState.active:
                toReturnWidget = const Center(
                    child: Padding(
                  padding: EdgeInsets.all(56.0),
                  child: CircularProgressIndicator(),
                ));
                break;
              case ConnectionState.none:
                toReturnWidget = const Center(
                    child: Padding(
                  padding: EdgeInsets.all(56.0),
                  child: CircularProgressIndicator(),
                ));
                break;
            }

            return toReturnWidget;
          }),
    );
  }

  otherLanguageFields() {
    bool isEnglishFormFilled = false;

    TextEditingController? otherLang_trailNameController =
        TextEditingController(text: "");
    TextEditingController? otherLang_trailDistanceController =
        TextEditingController(text: "");
    TextEditingController? otherLang_trailDescriptionController =
        TextEditingController(text: "");
    TextEditingController? otherLang_trailOpenTime_1_Controller =
        TextEditingController(text: "");
    TextEditingController? otherLang_trailOpenTime_2Controller =
        TextEditingController(text: "");

    log("English Form Details :::");
    for (var element in dataControllers["en"]!.entries) {
      log(element.key, error: element.value.text);
      if (element.value.text == "") {
        isEnglishFormFilled = false;
        break;
      } else {
        isEnglishFormFilled = true;
      }
    }

    if (dataControllers.keys
        .contains(languages.keys.elementAt(_controller!.index))) {
      log("ALREADY HAS CONTROLLERS");
      Map<String, TextEditingController>? controllers =
          dataControllers[languages.keys.elementAt(_controller!.index)];
      otherLang_trailNameController = controllers!["trailName"];
      otherLang_trailDistanceController = controllers["trailDistance"];
      otherLang_trailDescriptionController = controllers["trailDesc"];
      otherLang_trailOpenTime_1_Controller = controllers["trailOpen_1"];
      otherLang_trailOpenTime_2Controller = controllers["trailOpen_2"];
    } else {
      log("DOESN'T HAVE CONTROLLERS");
      dataControllers.addAll({
        languages.keys.elementAt(_controller!.index): {
          "trailName": otherLang_trailNameController,
          "trailDistance": otherLang_trailDistanceController,
          "trailDesc": otherLang_trailDescriptionController,
          "trailOpen_1": otherLang_trailOpenTime_1_Controller,
          "trailOpen_2": otherLang_trailOpenTime_2Controller
        }
      });
    }
    return Form(
        key: _form,
        child: FutureBuilder<TrailPayload?>(
            future: response,
            builder: (context, snapshot) {
              Widget toReturnWidget;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  toReturnWidget = const Center(
                      child: Padding(
                    padding: EdgeInsets.all(56.0),
                    child: CircularProgressIndicator(),
                  ));
                  break;
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    log("Connection Done => ${snapshot.data!.toJson()}");
                  }
                  toReturnWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ===========================  Todo ==> Location Name
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              LocaleKeys.Trail_Name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Enter valid Trail name!";
                                  }
                                  return null;
                                },
                                controller: otherLang_trailNameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Trail",
                                  hintStyle: const TextStyle(
                                      color: Color(0xffabaaaa), fontSize: 13),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      // =========================== Todo ==>  Distance
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              LocaleKeys.Distance,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Enter valid city!";
                                  }
                                  return null;
                                },
                                controller: otherLang_trailDistanceController,
                                decoration: InputDecoration(
                                  hintText: "Enter Zip*",
                                  hintStyle: const TextStyle(
                                      color: Color(0xffabaaaa), fontSize: 13),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      // =========================== Todo ==>  Opening Time (Trial days & timing)
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              LocaleKeys.Opening_Time,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Enter valid Trail name!";
                                        }
                                        return null;
                                      },
                                      controller:
                                          otherLang_trailOpenTime_1_Controller,
                                      decoration: InputDecoration(
                                        hintText: "Enter Trail",
                                        hintStyle: const TextStyle(
                                            color: Color(0xffabaaaa),
                                            fontSize: 13),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffc4c4c4),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 16),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffc4c4c4),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller:
                                          otherLang_trailOpenTime_2Controller,
                                      decoration: InputDecoration(
                                        hintText: "Enter Trail",
                                        hintStyle: const TextStyle(
                                            color: Color(0xffabaaaa),
                                            fontSize: 13),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffc4c4c4),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 16),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xffc4c4c4),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                      // ===========================  Todo ==> Description
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              LocaleKeys.Trail_Description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Enter valid address!";
                                  }
                                  return null;
                                },
                                controller:
                                    otherLang_trailDescriptionController,
                                minLines: 3,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  hintText: "Enter Address",
                                  hintStyle: const TextStyle(
                                      color: Color(0xffabaaaa), fontSize: 13),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 56.0, top: 16),
                        child: ElevatedButton(
                            onPressed: () {
                              submit_Other_Language_DATA();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text("Submit"),
                            )),
                      )
                    ],
                  );
                  break;
                case ConnectionState.active:
                  toReturnWidget = const Center(
                      child: Padding(
                    padding: EdgeInsets.all(56.0),
                    child: CircularProgressIndicator(),
                  ));
                  break;
                case ConnectionState.none:
                  toReturnWidget = const Center(
                      child: Padding(
                    padding: EdgeInsets.all(56.0),
                    child: CircularProgressIndicator(),
                  ));
                  break;
              }
              return toReturnWidget;
            }));
  }

  Future<TrailPayload?> getTrailData() async {
    if (widget.trailId == null) {
      return Future.value(null);
    }
    Map<String, String> params = {"trail_id": widget.trailId!};
    if (languages.keys.elementAt(_controller!.index) != "en") {
      params.addAll({
        "lang": languages.keys.elementAt(_controller!.index) == "es"
            ? "spa"
            : languages.keys.elementAt(_controller!.index)
      });
    }
    TrailPayload data =
        await ApiFactory().getTrailService().getTrailDetails(params);

    if (languages.keys.elementAt(_controller!.index) == "en") {
      trailNameController.text = data.trailName!;
      trailDistanceController.text = data.trailDistance!;
      trailDescriptionController.text = data.trailDescription!;
      trailOpeningController.text = data.trailOpeningTime!;
      trailOpening2Controller.text = data.trailOpeningTime2!;

      selectedDifficultyID = data.trailDifficulty!;
    } else {
      if (dataControllers.keys
          .contains(languages.keys.elementAt(_controller!.index))) {
        log("ALREADY HAS CONTROLLERS");
        Map<String, TextEditingController>? controllers =
            dataControllers[languages.keys.elementAt(_controller!.index)];
        controllers!["trailName"]!.text = data.trailName!;
        controllers["trailDistance"]!.text = data.trailDistance!;
        controllers["trailDesc"]!.text = data.trailDescription!;
        controllers["trailOpen_1"]!.text = data.trailOpeningTime!;
        controllers["trailOpen_2"]!.text = data.trailOpeningTime2!;
      } else {
        log("DOESN'T HAVE CONTROLLERS");
        dataControllers.addAll({
          languages.keys.elementAt(_controller!.index): {
            "trailName": TextEditingController(text: data.trailName!),
            "trailDistance": TextEditingController(text: data.trailDistance!),
            "trailDesc": TextEditingController(text: data.trailDescription!),
            "trailOpen_1": TextEditingController(text: data.trailOpeningTime!),
            "trailOpen_2": TextEditingController(text: data.trailOpeningTime2!)
          }
        });
      }
    }

    return data;
  }

  Future<void> submit_English_Details() async {
    bool isFormValid = _form.currentState!.validate();

    if (!isFormValid) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(
          SnackBar(content: Text("Please provide valid trail details!")));
      return;
    }

    TrailPayload payload = TrailPayload(
        trailDescription: trailDescriptionController.text,
        trailDistance: trailDistanceController.text,
        trailName: trailNameController.text,
        trailDifficulty: selectedDifficultyID,
        status: isChecked ? "1" : "0",
        trailOpeningTime: trailOpeningController.text,
        trailOpeningTime2: trailOpening2Controller.text);

    if (widget.isEdit!) {
      payload.trail_id = widget.trailId;
    }

    BaseResponse response = widget.isEdit!
        ? await ApiFactory()
            .getTrailService()
            .updateTrailData(payload, locationImage, galleryImages)
        : await ApiFactory()
            .getTrailService()
            .submitTrailData(payload, locationImage, galleryImages);
    if (response.status == "1") {
      trailId = response.trail_id.toString();
      int currentIndex = _controller!.index;
      if (currentIndex + 1 > languages.length - 1) {
        ScaffoldMessenger.of(buildContext!).showSnackBar(
            const SnackBar(content: Text("Trail Created Successfully.")));
        Navigator.of(buildContext!).pop();
        return;
      } else {
        _controller!.index++;
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.msg!)));
    }
  }

  void _showBottomSheet(int i) {
    log("Image Picker Called For Case : $i");
    showModalBottomSheet(
        context: buildContext!,
        builder: (context) => Container(
            height: DeviceDimensions.getDeviceHeight(context) / 6,
            width: DeviceDimensions.getDeviceWidth(context),
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  onPressed: () {
                    getFromCamera((file) {
                      switch (i) {
                        case 1:
                          locationImage = file;
                          break;
                        case 2:
                          galleryImages!.add(file);
                          break;
                      }
                      Navigator.of(context).pop();
                      setState(() {});
                    });
                  },
                  icon: SvgPicture.asset(
                      "assets/images/location/camera_icon.svg"),
                  label: const Text("Take From Camera"),
                ),
                TextButton.icon(
                    onPressed: () {
                      getFromGallery((file) {
                        switch (i) {
                          case 1:
                            if (file.length > 1) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(buildContext!).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Cannot select multiple images for park image!")));

                              setState(() {});
                              return;
                            } else if (file.length == 1) {
                              List<XFile> data = file;
                              locationImage = data.first;
                            }
                            break;
                          case 2:
                            galleryImages!.addAll(file);
                            break;
                        }
                        Navigator.of(context).pop();
                        setState(() {});
                      });
                    },
                    icon: SvgPicture.asset(
                        "assets/images/location/pick_from_gallery.svg"),
                    label: const Text("Choose From Gallery")),
              ],
            )));
  }

  void getFromGallery(Function dismissListener) async {
    // try {
    log("inside gallery functiom");
    List<XFile> pickedFile = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxWidth: 1800,
    );
    if (pickedFile != null) {
      log("DATA RECEIVED FROM PICKER => TYPE ${pickedFile.runtimeType} ");
      log("DATA RECEIVED FROM PICKER => Length ${pickedFile.length}");
      dismissListener(pickedFile);
    }
    // } catch (e) {
    //   log('exception in pick image${e}');
    //   throw e;
    // }
  }

  void getFromCamera(Function dismissListener) async {
    try {
      log("inside camera functiom");
      XFile? pickedFile = await ImagePicker().pickImage(
        imageQuality: 100,
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      log("value of captured image  ${pickedFile}");
      if (pickedFile != null) {
        dismissListener(pickedFile);
      } else {
        log("picked file is null");
      }
    } catch (e) {
      log('exception in pick image${e}');
    }
  }

  Future<void> submit_Other_Language_DATA() async {
    final isValid = _form.currentState!.validate();
    TrailPayload payload = TrailPayload();
    if (!isValid) {
      return;
    }
    if (dataControllers.keys
        .contains(languages.keys.elementAt(_controller!.index))) {
      log("ALREADY HAS CONTROLLERS");
      Map<String, TextEditingController>? controllers =
          dataControllers[languages.keys.elementAt(_controller!.index)];

      payload.lang = languages.keys.elementAt(_controller!.index);
      payload.trail_id = widget.trailId ?? trailId;
      payload.trailName = controllers!["trailName"]!.text;
      payload.trailDistance = controllers["trailDistance"]!.text;
      payload.trailDescription = controllers["trailDesc"]!.text;
      payload.trailOpeningTime = controllers["trailOpen_1"]!.text;
      payload.trailOpeningTime2 = controllers["trailOpen_2"]!.text;
    }

    BaseResponse response = await ApiFactory()
        .getTrailService()
        .submitOtherLanguageTrailData(payload);
    if (response.status == 1) {
      int currentIndex = _controller!.index;
      if (currentIndex + 1 > languages.length - 1) {
        ScaffoldMessenger.of(buildContext!).showSnackBar(
            const SnackBar(content: Text("Trail Created Successfully.")));
        Navigator.of(buildContext!).pop();
        return;
      } else {
        _controller!.index++;
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.msg!)));
    }
  }
}

class Difficulty {
  String? id;
  String? name;

  Difficulty({this.id, this.name});
}
