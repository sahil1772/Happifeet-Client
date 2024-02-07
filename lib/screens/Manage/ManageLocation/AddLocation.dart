import 'dart:developer';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:happifeet_client_app/i18n/locale_keys.g.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Location/Features.dart';
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/resources/resources.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/CalendarUtils.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../network/ApiFactory.dart';
import '../../../utils/ColorParser.dart';

class AddLocation extends StatefulWidget {
  AddLocation({super.key, this.isEdit, this.parkId});

  bool? isEdit = false;
  String? parkId = "";

  static gotoAddLocation(BuildContext context, bool? isEdit, String? parkId) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => AddLocation(isEdit: isEdit, parkId: parkId)));
  }

  @override
  State<AddLocation> createState() => _AddLocationState();
}

Future<Map<String, dynamic>> getLanguages() async {
  Map<String, dynamic> lang = {};
  lang.addAll({"en": "English"});
  lang.addAll(await SharedPref.instance.getLanguageList());

  return Future.value(lang);
}

class _AddLocationState extends State<AddLocation>
    with SingleTickerProviderStateMixin {
  // FORM VARIABLE USED FOR VALIDATIONS
  final _form = GlobalKey<FormState>();

  //IMAGE PICKER INSTANCE TO USE FOR PICKING FROM CAMERA OR GALLERY

  //LocationDataModel USED FOR STORING FORM DATA AND USED TO POST TO SERVER
  LocationDataModel? locationData;

  //PICKER FILE INSTANCES USED TO STORE PICKED OR CAPURED FILES
  XFile? locationImage;
  List<XFile>? galleryImages = [];

  //PARK ID STORE IN VARIABLE ON SUCCESSFUL ENGLISH DATA INSERTION
  String? park_Id = "";

  // CONTROLLERS
  TabController? _controller;

  //MISC VARIABLES
  Map<String, dynamic> languages = {};
  Map<String, Map<String, TextEditingController>> dataControllers = {};
  List<Features>? features = [];
  List<String> selectedMonths = [];
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  List<String?> months = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  TextEditingController locationNameController = TextEditingController();
  TextEditingController addressNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController reserveLinkController = TextEditingController();

  double? labelTextSize = 12.0;
  double? fontLabelTextSize = 14.0;

  List<String?>? selectedFeaturesID = [];
  List<String?>? otherFeatures = [];
  Map<String, List<TextField>> otherFeaturesWidgets = {};

  BuildContext? buildContext;

  bool isMainCity = false;
  bool showByMonth = true;

  bool isChecked = false;

  double HEADER_HEIGHT = 4;

  Future<LocationDataModel?>? apiResponse;

  Future<BaseResponse?>? englishSubmissionResponse;
  Future<BaseResponse?>? otherLanguageSubmissionResponse;
  Future<List<Features>?>? featuresResponse;

  bool selectAll = false;
  bool showDeleteLocationImage = false;
  Map<int, bool> showDeleteGalleryImage = {};

  @override
  void initState() {
    // TODO: implement initState
    locationData = LocationDataModel();

    getLanguages().then((value) {
      languages = value;
      otherFeaturesWidgets.addAll({
        "en": [
          TextField(
            controller: TextEditingController(),
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
        ]
      });

      log("languages.keys => ${value.keys}");
      log("languages.keys.length => ${value.keys.length}");

      _controller = TabController(length: value.keys.length, vsync: this);

      _controller!.addListener(() {
        setState(() {
          // context.setLocale(Locale("en"));
          log("CONTROLLER INDEX ${languages.keys.elementAt(_controller!.index)}");
          if (_controller!.indexIsChanging) {
            log("tab is changing");
            switch (languages.keys.elementAt(_controller!.index)) {
              case "spa":
                context.setLocale(const Locale("es"));
                break;
              case "rsa":
                context.setLocale(const Locale("rsa"));
                break;
              default:
                context.setLocale(
                    Locale(languages.keys.elementAt(_controller!.index)));
                break;
            }
          } else {
            log("INSIDE ELSE OF LISTENER${_controller!.index}");
            switch (languages.keys.elementAt(_controller!.index)) {
              case "spa":
                context.setLocale(const Locale("es"));
                break;
              case "rsa":
                context.setLocale(const Locale("rsa"));
                break;
              default:
                context.setLocale(
                    Locale(languages.keys.elementAt(_controller!.index)));
                break;
            }
          }
          locationImage = null;
          galleryImages!.clear();
          apiResponse = getLocationData(widget.parkId);
        });
      });
      if (dataControllers.keys
          .contains(languages.keys.elementAt(_controller!.index))) {
        log("ALREADY HAS CONTROLLERS");
        Map<String, TextEditingController>? controllers =
            dataControllers[languages.keys.elementAt(_controller!.index)];
        locationNameController = controllers!["locationName"]!;
        addressNameController = controllers["address"]!;
        descriptionController = controllers["description"]!;
        cityController = controllers["city"]!;
        stateController = controllers["state"]!;
        zipController = controllers["zip"]!;
        latitudeController = controllers["latitude"]!;
        longitudeController = controllers["longitude"]!;
      } else {
        dataControllers.addAll({
          "en": {
            "locationName": locationNameController,
            "address": addressNameController,
            "description": descriptionController,
            "city": cityController,
            "state": stateController,
            "zip": zipController,
            "latitude": latitudeController,
            "longitude": longitudeController,
          }
        });
      }

      apiResponse = getLocationData(widget.parkId);
      featuresResponse = getFeatures();
      setState(() {
        context.setLocale(Locale(languages.keys.elementAt(0)));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
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
                height: DeviceDimensions.getHeaderSize(context, HEADER_HEIGHT),
                width: DeviceDimensions.getDeviceWidth(context),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!),
                    ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.top_title_background_color!)
                  ],
                )),
                child: Container(
                  margin: DeviceDimensions.getHeaderEdgeInsets(context),
                  child: Center(
                    child: Text(
                      "Add Location",
                      // "Select Location".tr(),
                      // "Select Location".language(context),
                      // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                      style: TextStyle(
                          color: ColorParser().hexToColor(RuntimeStorage
                              .instance.clientTheme!.top_title_text_color!),
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )),
            Container(
              height:
                  DeviceDimensions.getBottomSheetHeight(context, HEADER_HEIGHT),
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
                    child: Text(
                      LocaleKeys.Select_Language,
                      style: TextStyle(
                          fontSize: 18,
                          color: ColorParser().hexToColor(RuntimeStorage
                              .instance
                              .clientTheme!
                              .top_title_background_color!)),
                    ).tr(),
                  ),
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _controller,
                      indicatorWeight: 1,
                      indicatorPadding: const EdgeInsets.all(0),
                      labelColor: ColorParser().hexToColor(RuntimeStorage
                          .instance.clientTheme!.top_title_background_color!),
                      indicatorColor: ColorParser().hexToColor(RuntimeStorage
                          .instance.clientTheme!.top_title_background_color!),
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

  /*
  *
                    otherFeaturesWidgets = {};
                    List<String?> otherFeatures =
                        locationData!.otherFeatures == null
                            ? []
                            : locationData!.otherFeatures!;
                    List<TextField> otherFeaturesFields =
                        locationData!.otherFeatures == null
                            ? [
                                TextField(
                                  controller: TextEditingController(),
                                  decoration: InputDecoration(
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
                                )
                              ]
                            : [];
                    otherFeatures.forEach((element) {
                      otherFeaturesFields.add(TextField(
                        controller: TextEditingController(text: element),
                        decoration: InputDecoration(
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
                      ));
                    });

                    otherFeaturesWidgets.addAll({
                      languages.keys.elementAt(_controller!.index):
                          otherFeaturesFields
                    });*/

  Widget loadEnglishBody() {
    return Form(
      key: _form,
      child: FutureBuilder<LocationDataModel?>(
          future: apiResponse,
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
                          const Row(
                            children: [
                              Text(
                                "Location Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid location name!";
                                }
                                return null;
                              },
                              controller: locationNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Location",
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
                    // ===========================  Todo ==> Address & Street
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Address & Street",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid address!";
                                }
                                return null;
                              },
                              controller: addressNameController,
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
                    // =========================== Todo ==>  City
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "City",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid city!";
                                }
                                return null;
                              },
                              controller: cityController,
                              decoration: InputDecoration(
                                hintText: "Enter City",
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
                    // =========================== Todo ==>  Zip Code
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Zip",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid city!";
                                }
                                return null;
                              },
                              controller: zipController,
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
                    // =========================== Todo ==>  State
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "State",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid state!";
                                }
                                return null;
                              },
                              controller: stateController,
                              decoration: InputDecoration(
                                hintText: "Enter State",
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
                    // =========================== Todo ==>  Description
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid description!";
                                }
                                return null;
                              },
                              controller: descriptionController,
                              minLines: 3,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Enter Description",
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
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xffc4c4c4),
                                      ),
                                    ),
                                    height: 64,
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
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: OutlinedButton(
                                                  onPressed: () {
                                                    _showBottomSheet(1);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              width: 0.0,
                                                              color: ColorParser().hexToColor(
                                                                  RuntimeStorage
                                                                      .instance
                                                                      .clientTheme!
                                                                      .top_title_background_color!),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))),
                                                  ),
                                                  child: Text(
                                                    "Choose File",
                                                    style: TextStyle(
                                                        color: ColorParser()
                                                            .hexToColor(
                                                                RuntimeStorage
                                                                    .instance
                                                                    .clientTheme!
                                                                    .top_title_background_color!)),
                                                  )),
                                            ),
                                          ]),
                                    ),
                                  ),
                                  widget.isEdit!
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  showDeleteGalleryImage
                                                      .forEach((key, value) {
                                                    showDeleteGalleryImage[
                                                        key] = false;
                                                  });
                                                  showDeleteLocationImage =
                                                      !showDeleteLocationImage;
                                                  setState(() {});
                                                },
                                                onLongPress: () {},
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Image border
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        48),
                                                    // Image radius
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        Image.network(snapshot
                                                            .data!.parkImages!),
                                                        showDeleteLocationImage
                                                            ? Center(
                                                                child: ClipRect(
                                                                  // <-- clips to the 200x200 [Container] below
                                                                  child:
                                                                      BackdropFilter(
                                                                    filter:
                                                                        ImageFilter
                                                                            .blur(
                                                                      sigmaX:
                                                                          5.0,
                                                                      sigmaY:
                                                                          5.0,
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width:
                                                                          200.0,
                                                                      height:
                                                                          200.0,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  title: const Text("Confirm Image Deletion"),
                                                                                  content: const Text("Please confirm if you wan to delete this image?"),
                                                                                  actions: [
                                                                                    TextButton(onPressed: () {}, child: const Text("Cancel")),
                                                                                    ElevatedButton(
                                                                                        style: ButtonStyle(
                                                                                          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                                                                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                                              side: BorderSide(
                                                                                                width: 0.0,
                                                                                                color: ColorParser().hexToColor(RuntimeStorage.instance.clientTheme!.top_title_background_color!),
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(10.0))),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                        child: const Text(
                                                                                          "Confirm and Delete",
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        ))
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          child: const Icon(
                                                                              color: Colors.white,
                                                                              Icons.delete),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : const SizedBox()
                                ],
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
                          widget.isEdit!
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color(0xffc4c4c4),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text(
                                                    galleryImages!.isEmpty
                                                        ? "No File Selected"
                                                        : galleryImages!
                                                                    .length ==
                                                                1
                                                            ? galleryImages!
                                                                .first.name
                                                            : "${galleryImages!.length} ${galleryImages!.length == 1 ? "File" : "Files"} Selected",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: OutlinedButton(
                                                      onPressed: () {
                                                        if (galleryImages!
                                                                    .length +
                                                                snapshot
                                                                    .data!
                                                                    .galleryImages!
                                                                    .length >=
                                                            5) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "Only 5 images are allowed")));
                                                        } else {
                                                          _showBottomSheet(2);
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .transparent),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    width: 0.0,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0))),
                                                      ),
                                                      child: Text(
                                                        "Choose File",
                                                        style: TextStyle(
                                                          color: ColorParser()
                                                              .hexToColor(
                                                                  RuntimeStorage
                                                                      .instance
                                                                      .clientTheme!
                                                                      .top_title_background_color!),
                                                        ),
                                                      )),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 3 / 5,
                                                crossAxisSpacing: 10,
                                                crossAxisCount: 5),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shrinkWrap: true,
                                        itemCount: snapshot
                                            .data!.galleryImages!.length,
                                        itemBuilder: (context, index) {
                                          if (!showDeleteGalleryImage
                                              .containsKey(index)) {
                                            showDeleteGalleryImage
                                                .addAll({index: false});
                                          }

                                          return InkWell(
                                            onTap: () {
                                              showDeleteLocationImage = false;
                                              showDeleteGalleryImage
                                                  .forEach((key, value) {
                                                showDeleteGalleryImage[key] =
                                                    false;
                                              });

                                              showDeleteGalleryImage[index] =
                                                  !showDeleteGalleryImage[
                                                      index]!;
                                              setState(() {});
                                            },
                                            onLongPress: () {},
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Image border
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(48),
                                                // Image radius
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Image.network(
                                                        height: 100,
                                                        width: 150,
                                                        fit: BoxFit.cover,
                                                        snapshot.data!
                                                                .galleryImages![
                                                            index]!),
                                                    showDeleteGalleryImage[
                                                            index]!
                                                        ? Center(
                                                            child: ClipRect(
                                                              // <-- clips to the 200x200 [Container] below
                                                              child:
                                                                  BackdropFilter(
                                                                filter:
                                                                    ImageFilter
                                                                        .blur(
                                                                  sigmaX: 5.0,
                                                                  sigmaY: 5.0,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Center(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDeleteDailog(
                                                                            context:
                                                                                context,
                                                                            onResult:
                                                                                () {
                                                                              apiResponse = getLocationData(widget.parkId);
                                                                              setState(() {});
                                                                            },
                                                                            fileName:
                                                                                snapshot.data!.galleryImages![index]!.split("/").toList().last);
                                                                      },
                                                                      child: const Icon(
                                                                          color:
                                                                              Colors.white,
                                                                          Icons.delete),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Main City Location
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Main City Location",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                                height: 64,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: const Text(
                                    "Is Main City Location ?",
                                  ),
                                  value: isMainCity,
                                  onChanged: (bool? value) {
                                    isMainCity = value!;
                                    setState(() {});
                                  },
                                )),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Latitude
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Latitude",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid latitude!";
                                }
                                return null;
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: false),
                              controller: latitudeController,
                              decoration: InputDecoration(
                                hintText: "Enter Latitude",
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
                    // =========================== Todo ==>  Longitude
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Longitude",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                " *",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "Enter valid longitude!";
                                }
                                return null;
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: false),
                              controller: longitudeController,
                              decoration: InputDecoration(
                                hintText: "Enter Longitude",
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
                    // =========================== Todo ==>  Reserve Link
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Reserve Link",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: reserveLinkController,
                              decoration: InputDecoration(
                                hintText: "Enter Reserve Link",
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
                    // =========================== Todo ==>  Available For Months
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Available For Months",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            showByMonth = true;
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: showByMonth
                                                          ? ColorParser().hexToColor(
                                                              RuntimeStorage
                                                                  .instance
                                                                  .clientTheme!
                                                                  .top_title_background_color!)
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                        ),
                                        child: Text(
                                          "Month Wise",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: showByMonth
                                                  ? ColorParser().hexToColor(
                                                      RuntimeStorage
                                                          .instance
                                                          .clientTheme!
                                                          .top_title_background_color!)
                                                  : const Color(0xff828385)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                showByMonth = false;
                                                selectedMonths.clear();
                                              });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        width: 0.0,
                                                        color: !showByMonth
                                                            ? Colors.transparent
                                                            : ColorParser().hexToColor(
                                                                RuntimeStorage
                                                                    .instance
                                                                    .clientTheme!
                                                                    .top_title_background_color!),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            ),
                                            child: Text("Date Range",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: !showByMonth
                                                        ? ColorParser().hexToColor(
                                                            RuntimeStorage
                                                                .instance
                                                                .clientTheme!
                                                                .top_title_background_color!)
                                                        : const Color(
                                                            0xff828385)))),
                                      ),
                                    ],
                                  ),
                                ),
                                showByMonth
                                    ? GridView.extent(
                                        shrinkWrap: true,
                                        maxCrossAxisExtent: 60.0,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 20.0,
                                        // maximum item width
                                        // spacing between rows
                                        // spacing between columns
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0.0,
                                        ),
                                        // padding around the grid
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: months.map((item) {
                                          bool? isSelected =
                                              selectedMonths.contains(item);
                                          return InkWell(
                                            onTap: () {
                                              if (!isSelected) {
                                                selectedMonths.add(item);
                                              } else {
                                                selectedMonths.remove(item);
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? ColorParser().hexToColor(
                                                          RuntimeStorage
                                                              .instance
                                                              .clientTheme!
                                                              .top_title_background_color!)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: isSelected
                                                          ? ColorParser().hexToColor(
                                                              RuntimeStorage
                                                                  .instance
                                                                  .clientTheme!
                                                                  .top_title_background_color!)
                                                          : const Color(
                                                              0xff8A8A8A))),
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateFormat("MMM").format(
                                                          DateFormat("MM")
                                                              .parse((int.parse(
                                                                      item!))
                                                                  .toString())),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xff8A8A8A)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Row(
                                        children: [
                                          Flexible(
                                            child: InkWell(
                                              onTap: () async {
                                                selectedStartDate =
                                                    await CalendarUtils
                                                        .showPicker(
                                                            context: context);
                                                setState(() {});
                                              },
                                              child: Container(
                                                height: 56,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff8A8A8A),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                        DateFormat(
                                                                "dd MMM yyyy")
                                                            .format(
                                                                selectedStartDate),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Resources
                                                                .colors
                                                                .hfText)),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    SvgPicture.asset(
                                                        "assets/images/comments/datepicker.svg"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: InkWell(
                                              onTap: () async {
                                                selectedEndDate =
                                                    await CalendarUtils
                                                        .showPicker(
                                                            context: context);
                                                setState(() {});
                                              },
                                              child: Container(
                                                height: 56,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xff8A8A8A),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                        DateFormat(
                                                                "dd MMM yyyy")
                                                            .format(
                                                                selectedEndDate),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Resources
                                                                .colors
                                                                .hfText)),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    SvgPicture.asset(
                                                        "assets/images/comments/datepicker.svg"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: showByMonth
                                      ? OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectAll = !selectAll;
                                              if (selectAll) {
                                                selectedMonths.addAll(
                                                    months.map((e) => e!));
                                              } else {
                                                selectedMonths.clear();
                                              }
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 2,
                                                        color: selectAll
                                                            ? ColorParser().hexToColor(
                                                                RuntimeStorage
                                                                    .instance
                                                                    .clientTheme!
                                                                    .top_title_background_color!)
                                                            : Colors
                                                                .transparent),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0))),
                                          ),
                                          child: Text(
                                            selectAll
                                                ? "Unselect All"
                                                : "Select All",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: selectAll
                                                    ? ColorParser().hexToColor(
                                                        RuntimeStorage
                                                            .instance
                                                            .clientTheme!
                                                            .top_title_background_color!)
                                                    : const Color(0xff828385)),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    // =========================== Todo ==>  Features
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Features",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: FutureBuilder(
                              future: featuresResponse,
                              builder: (context, snapshot) {
                                return GridView.extent(
                                  shrinkWrap: true,
                                  maxCrossAxisExtent: 120.0,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  // maximum item width
                                  // spacing between rows
                                  // spacing between columns
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0.0,
                                  ),
                                  // padding around the grid
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: features!.map((item) {
                                    bool? isSelected =
                                        selectedFeaturesID!.contains(item.id!);
                                    return InkWell(
                                      onTap: () {
                                        if (!isSelected) {
                                          selectedFeaturesID!.add(item.id!);
                                        } else {
                                          selectedFeaturesID!.remove(item.id);
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: isSelected
                                                    ? ColorParser().hexToColor(
                                                        RuntimeStorage
                                                            .instance
                                                            .clientTheme!
                                                            .top_title_background_color!)
                                                    : const Color(0xff8A8A8A))),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SvgPicture.network(item.icon!,
                                                  colorFilter: ColorFilter.mode(
                                                      isSelected
                                                          ? ColorParser().hexToColor(
                                                              RuntimeStorage
                                                                  .instance
                                                                  .clientTheme!
                                                                  .top_title_background_color!)
                                                          : const Color(
                                                              0xff8A8A8A),
                                                      BlendMode.srcIn)),
                                              Text(
                                                item.name!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: isSelected
                                                        ? ColorParser().hexToColor(
                                                            RuntimeStorage
                                                                .instance
                                                                .clientTheme!
                                                                .top_title_background_color!)
                                                        : const Color(
                                                            0xff8A8A8A)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),

                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Other Features",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i < otherFeaturesWidgets["en"]!.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: otherFeaturesWidgets["en"]![i],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            otherFeaturesWidgets["en"]!.add(TextField(
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: TextEditingController(),
                              decoration: InputDecoration(
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
                            ));

                            setState(() {});
                          },
                          child: Text(
                            "Add More +",
                            style: TextStyle(
                              color: ColorParser().hexToColor(RuntimeStorage
                                  .instance
                                  .clientTheme!
                                  .top_title_background_color!),
                            ),
                          )),
                    ),
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
                                    activeColor: ColorParser().hexToColor(
                                        RuntimeStorage.instance.clientTheme!
                                            .top_title_background_color!),
                                    showOnOff: true,
                                    valueFontSize: 16,
                                    activeText: "Active",
                                    inactiveText: "InActive",
                                    onToggle: (bool value) {
                                      isChecked = value;
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
                        child: FutureBuilder(
                          future: englishSubmissionResponse,
                          builder: (context, snapshot1) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorParser().hexToColor(
                                      RuntimeStorage.instance.clientTheme!
                                          .button_background!),
                                ),
                                onPressed: () {
                                  log("Connection STATE => ${snapshot1.connectionState.name}");
                                  if (snapshot1.connectionState ==
                                          ConnectionState.none ||
                                      snapshot1.connectionState ==
                                          ConnectionState.done) {
                                    setState(() {
                                      englishSubmissionResponse =
                                          submit_English_Details();
                                    });
                                  } else if (snapshot1.connectionState ==
                                      ConnectionState.waiting) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Location submission already in progress")));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Center(
                                    child: snapshot1.connectionState ==
                                                ConnectionState.none ||
                                            snapshot1.connectionState ==
                                                ConnectionState.done
                                        ? const Text(
                                            "Submit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : const SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            )),
                                  ),
                                ));
                          },
                        ))
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

  Widget otherLanguageFields() {
    bool isEnglishFormFilled = false;

    TextEditingController? locationNameController =
        TextEditingController(text: "");
    TextEditingController? addressController = TextEditingController(text: "");
    TextEditingController? streetController = TextEditingController(text: "");
    TextEditingController? cityController = TextEditingController(text: "");
    TextEditingController? descriptionController =
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

    if (!otherFeaturesWidgets.keys
        .contains(languages.keys.elementAt(_controller!.index))) {
      otherFeaturesWidgets[languages.keys.elementAt(_controller!.index)] = [];
      otherFeaturesWidgets[languages.keys.elementAt(_controller!.index)]!
          .add(TextField(
        controller: TextEditingController(),
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
      ));
    }

    if (dataControllers.keys
        .contains(languages.keys.elementAt(_controller!.index))) {
      log("ALREADY HAS CONTROLLERS");
      Map<String, TextEditingController>? controllers =
          dataControllers[languages.keys.elementAt(_controller!.index)];
      locationNameController = controllers!["locationName"];
      addressController = controllers["address"];
      descriptionController = controllers["description"];
      streetController = controllers["street"];
      cityController = controllers["city"];
    } else {
      log("DOESN'T HAVE CONTROLLERS");
      dataControllers.addAll({
        languages.keys.elementAt(_controller!.index): {
          "locationName": locationNameController,
          "address": addressController,
          "street": streetController,
          "city": cityController,
          "description": descriptionController
        }
      });
    }

    // log("Controllers ::::: \n $dataControllers");

    return Form(
      key: _form,
      child: FutureBuilder<LocationDataModel?>(
        future: apiResponse,
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
                  !isEnglishFormFilled
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    LocaleKeys.Please_Fill_English,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                        letterSpacing: 0.2),
                                  ).tr()
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  // ===========================  Todo ==> Location Name
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              LocaleKeys.Location_Name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (text) {
                              if (text!.isEmpty) {
                                return LocaleKeys.Provide_Valid_Data.tr();
                              }
                              return null;
                            },
                            controller: locationNameController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.Enter_Location.tr(),
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

                  // ===========================  Todo ==> Address
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              LocaleKeys.Address_Street,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (text) {
                              if (text!.isEmpty) {
                                return LocaleKeys.Provide_Valid_Data.tr();
                              }
                              return null;
                            },
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.Enter_Address.tr(),
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

                  // ===========================  Todo ==> Street
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              LocaleKeys.Street,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (text) {
                              if (text!.isEmpty) {
                                return LocaleKeys.Provide_Valid_Data.tr();
                              }
                              return null;
                            },
                            controller: streetController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.Enter_Street.tr(),
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

                  // ===========================  Todo ==> City
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              LocaleKeys.City,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (text) {
                              if (text!.isEmpty) {
                                return LocaleKeys.Provide_Valid_Data.tr();
                              }
                              return null;
                            },
                            controller: cityController,
                            decoration: InputDecoration(
                              hintText: LocaleKeys.Enter_City.tr(),
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

                  // =========================== Todo ==>  Description
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              LocaleKeys.Description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (text) {
                              if (text!.isEmpty) {
                                return LocaleKeys.Provide_Valid_Data.tr();
                              }
                              return null;
                            },
                            controller: descriptionController,
                            minLines: 3,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "Enter Description",
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

                  Container(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              LocaleKeys.Other_features,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ).tr(),
                            const Text(
                              " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              for (int i = 0;
                                  i <
                                      otherFeaturesWidgets[languages.keys
                                              .elementAt(_controller!.index)]!
                                          .length;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: otherFeaturesWidgets[languages.keys
                                      .elementAt(_controller!.index)]![i],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          otherFeaturesWidgets[
                                  languages.keys.elementAt(_controller!.index)]!
                              .add(TextField(
                            controller: TextEditingController(),
                            decoration: InputDecoration(
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
                          ));

                          setState(() {});
                        },
                        child: Text(
                          LocaleKeys.Add_More,
                          style: TextStyle(
                              color: ColorParser().hexToColor(SharedPref
                                  .instance
                                  .clientTheme
                                  .top_title_background_color!)),
                        ).tr()),
                  ),
                  // Container(
                  //     width: DeviceDimensions.getDeviceWidth(context),
                  //     margin: EdgeInsets.only(top: 24),
                  //     height: 5,
                  //     decoration: BoxDecoration(
                  //         color: Color(0x30aeaeae),
                  //         borderRadius: BorderRadius.circular(56))),

                  // // =========================== Todo ==>  Other Features
                  // Container(
                  //     child: Padding(
                  //   padding: const EdgeInsets.only(top: 24.0, bottom: 10),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         LocaleKeys.Other_features,
                  //         style: TextStyle(
                  //             color: Colors.black, fontWeight: FontWeight.w700),
                  //       ).tr(),
                  //       Align(
                  //         alignment: Alignment.centerRight,
                  //         child: TextButton(
                  //             onPressed: () {
                  //               setState(() {});
                  //             },
                  //             child: Text(LocaleKeys.Add_More).tr()),
                  //       )
                  //     ],
                  //   ),
                  // )),

                  Padding(
                      padding: const EdgeInsets.only(bottom: 56.0, top: 24),
                      child: FutureBuilder(
                        future: otherLanguageSubmissionResponse,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorParser().hexToColor(
                                    RuntimeStorage.instance.clientTheme!
                                        .button_background!),
                              ),
                              onPressed: () {
                                submitDetails();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                        },
                      ))
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
        },
      ),
    );
  }

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      _handleLostFiles(files);
    } else {
      _handleError(response.exception);
    }
  }

  Future<List<Features>?> getFeatures() async {
    var response = ApiFactory().getLocationService().getFeatures();
    features = await response;

    return response;
  }

  bool checkValidation() {
    bool isFormFilled = true;

    for (var element
        in dataControllers[languages.keys.elementAt(_controller!.index)]!
            .entries) {
      log(element.key, error: element.value.text);
      if (element.value.text == "") {
        isFormFilled = false;
        break;
      } else {
        isFormFilled = true;
      }
    }

    return isFormFilled;
  }

  void _handleLostFiles(List<XFile> files) {}

  void _handleError(PlatformException? exception) {}

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
      log("value of captured image  $pickedFile");
      if (pickedFile != null) {
        dismissListener(pickedFile);
      } else {
        log("picked file is null");
      }
    } catch (e) {
      log('exception in pick image$e');
    }
  }

  Future<void> submitDetails() async {
    final isValid = _form.currentState!.validate();
    locationData = LocationDataModel();
    if (!isValid) {
      return;
    }
    if (dataControllers.keys
        .contains(languages.keys.elementAt(_controller!.index))) {
      log("ALREADY HAS CONTROLLERS");
      Map<String, TextEditingController>? controllers =
          dataControllers[languages.keys.elementAt(_controller!.index)];

      locationData!.locationName = controllers!["locationName"]!.text;
      locationData!.addressStreet = controllers["address"]!.text;
      locationData!.description = controllers["description"]!.text;
      locationData!.city = controllers["city"]!.text;
      locationData!.street = controllers["street"]!.text;
    }
    List<String> otherFeatures = [];

    for (int i = 0;
        i <
            otherFeaturesWidgets[languages.keys.elementAt(_controller!.index)]!
                .length;
        i++) {
      String data =
          otherFeaturesWidgets[languages.keys.elementAt(_controller!.index)]![i]
              .controller!
              .text;
      if (data.isNotEmpty) {
        otherFeatures.add(data);
      }
    }
    locationData!.otherFeatures = otherFeatures;
    BaseResponse response = await ApiFactory()
        .getLocationService()
        .submitLocationLanguageData(
            locationData!,
            widget.isEdit! ? widget.parkId! : park_Id!,
            languages.keys.elementAt(_controller!.index),
            locationImage,
            galleryImages);
    if (response.status == 1) {
      _controller!.index = (_controller!.index + 1 > languages.length - 1)
          ? _controller!.index
          : (_controller!.index + 1);

      setState(() {
        switch (languages.keys.elementAt(_controller!.index)) {
          case "spa":
            context.setLocale(const Locale("es"));
            break;
          case "rsa":
            context.setLocale(const Locale("rsa"));
            break;
          default:
            context.setLocale(
                Locale(languages.keys.elementAt(_controller!.index)));
            break;
        }
      });
      if (_controller!.index + 1 > languages.length - 1) {
        ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
            content: Text(
                "Location ${widget.isEdit! ? "Updated" : "Created"} Successfully.")));
        Navigator.of(buildContext!).pop();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.msg!)));
    }
  }

  Future<BaseResponse?>? submit_English_Details() async {
    log("DATA TO SUBMIT ===============================================================");
    log("Location Name : ${locationNameController.text}");
    log("Address & Street : ${addressNameController.text}");
    log("City : ${cityController.text}");
    log("State : ${stateController.text}");
    log("Description : ${descriptionController.text}");
    log("Location Images : ${null}");
    log("Main City Location :  $isMainCity");
    log("Latitude : ${latitudeController.text}");
    log("Longitude : ${longitudeController.text}");
    log("Reserve Link : ${reserveLinkController.text}");
    log("Availability Type : ${showByMonth ? "Months" : "Date"}");
    if (showByMonth) {
      log("Start Date : ${DateFormat("MM dd yyyy").format(selectedStartDate)}");
      log("End Date : ${DateFormat("MM dd yyyy").format(selectedEndDate)}");
    } else {
      log("Available Months : $selectedMonths");
    }
    log("Features : $selectedFeaturesID");
    log("Park Image : ${locationImage?.name}");
    log("Gallery Images : ${galleryImages!.length}");
    log("Status : $isChecked");

    final isValid = _form.currentState!.validate();

    if (showByMonth) {
      if (selectedMonths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select avability of parks")));
        return null;
      }
    } else {}

    if (selectedFeaturesID!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select park features")));
      return null;
    }

    if (!widget.isEdit!) {
      if (galleryImages!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please select park gallery images.")));
        return null;
      }

      if (locationImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select park image.")));
        return null;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid park details. Please provide park details.")));
      return null;
    }

    List<String> otherFeatures = [];

    for (int i = 0; i < otherFeaturesWidgets["en"]!.length; i++) {
      String data = otherFeaturesWidgets["en"]![i].controller!.text;
      if (data.isNotEmpty) {
        otherFeatures.add(data);
      }
    }

    log("Other Features : $otherFeatures");

    log("===============================================================");

    locationData!.locationName = locationNameController.text;
    locationData!.addressStreet = addressNameController.text;
    locationData!.city = cityController.text;
    locationData!.state = stateController.text;
    locationData!.zip = zipController.text;
    locationData!.latitude = latitudeController.text;
    locationData!.longitude = longitudeController.text;
    locationData!.description = descriptionController.text;
    locationData!.parkAvailability = showByMonth ? "months" : "dates";
    locationData!.parkAvailabilityMonths = selectedMonths;
    locationData!.parkFeatures = selectedFeaturesID!;
    locationData!.otherFeatures = otherFeatures;
    locationData!.mainCityLocation = isMainCity ? "1" : "0";
    locationData!.status = isChecked ? "1" : "0";

    if (!showByMonth) {
      locationData!.startDate =
          DateFormat("MM dd yyyy").format(selectedStartDate);
      locationData!.endDate = DateFormat("MM dd yyyy").format(selectedEndDate);
    }

    Future<BaseResponse> response = widget.isEdit!
        ? ApiFactory()
            .getLocationService()
            .updateLocationData(locationData!, locationImage, galleryImages!)
        : ApiFactory()
            .getLocationService()
            .submitLocationData(locationData!, locationImage!, galleryImages!);
    BaseResponse baseResponse = await response;
    if (baseResponse.status == "1") {
      park_Id = baseResponse.park_id.toString();
      _controller!.index = (_controller!.index + 1 > languages.length - 1)
          ? _controller!.index
          : (_controller!.index + 1);
      setState(() {
        switch (languages.keys.elementAt(_controller!.index)) {
          case "spa":
            context.setLocale(const Locale("es"));
            break;
          case "rsa":
            context.setLocale(const Locale("rsa"));
            break;
          default:
            context.setLocale(
                Locale(languages.keys.elementAt(_controller!.index)));
            break;
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(baseResponse.msg!)));
    }

    return response;
  }

  Future<LocationDataModel?> getLocationData(String? park_id) async {
    if (park_id == null) {
      return Future.value(null);
    }
    showDeleteGalleryImage.clear();

    Map<String, String> params = {"park_id": park_id};
    if (languages.keys.elementAt(_controller!.index) != "en") {
      params.addAll({
        "lang": languages.keys.elementAt(_controller!.index) == "es"
            ? "spa"
            : languages.keys.elementAt(_controller!.index)
      });
    }
    LocationDataModel data =
        await ApiFactory().getLocationService().editLocationData(params);

    if (languages.keys.elementAt(_controller!.index) == "en") {
      locationData = data;
      locationNameController.text = locationData!.locationName!;
      addressNameController.text = locationData!.addressStreet!;
      cityController.text = locationData!.city!;
      stateController.text = locationData!.state!;
      zipController.text = locationData!.zip!;
      descriptionController.text = locationData!.description!;
      isMainCity = locationData!.mainCityLocation! == "1" ? true : false;
      latitudeController.text = locationData!.latitude!;
      longitudeController.text = locationData!.longitude!;
      reserveLinkController.text = locationData!.reservationlink!;
      isChecked = locationData!.status! == "Y" ? true : false;
      selectedFeaturesID = locationData!.parkFeatures!;
      selectedMonths = locationData!.parkAvailabilityMonths!;

      if (languages.keys.elementAt(_controller!.index) == "en") {
        otherFeaturesWidgets = {};
        List<String?> otherFeatures = locationData!.otherFeatures == null ||
                locationData!.otherFeatures!.isEmpty
            ? []
            : locationData!.otherFeatures!;
        List<TextField> otherFeaturesFields =
            locationData!.otherFeatures == null ||
                    locationData!.otherFeatures!.isEmpty
                ? [
                    TextField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
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
                    )
                  ]
                : [];
        otherFeatures.forEach((element) {
          otherFeaturesFields.add(TextField(
            controller: TextEditingController(text: element),
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
          ));
        });

        otherFeaturesWidgets.addAll({"en": otherFeaturesFields});
      }
    } else {
      try {
        locationData = data;

        otherFeaturesWidgets = {};
        List<String?> otherFeatures = locationData!.otherFeatures == null ||
                locationData!.otherFeatures!.isEmpty
            ? []
            : locationData!.otherFeatures!;
        List<TextField> otherFeaturesFields =
            locationData!.otherFeatures == null ||
                    locationData!.otherFeatures!.isEmpty
                ? [
                    TextField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
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
                    )
                  ]
                : [];
        otherFeatures.forEach((element) {
          otherFeaturesFields.add(TextField(
            controller: TextEditingController(text: element),
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
          ));
        });

        otherFeaturesWidgets.addAll({
          languages.keys.elementAt(_controller!.index): otherFeaturesFields
        });

        if (dataControllers
            .containsKey(languages.keys.elementAt(_controller!.index))) {
          dataControllers[languages.keys.elementAt(_controller!.index)]![
                  "locationName"]!
              .text = locationData!.locationName!;
          dataControllers[languages.keys.elementAt(_controller!.index)]![
                  "address"]!
              .text = locationData!.addressStreet!;
          dataControllers[languages.keys.elementAt(_controller!.index)]![
                  "street"]!
              .text = locationData!.state!;
          dataControllers[languages.keys.elementAt(_controller!.index)]![
                  "city"]!
              .text = locationData!.city!;
          dataControllers[languages.keys.elementAt(_controller!.index)]![
                  "description"]!
              .text = locationData!.description!;
        } else {
          dataControllers.addAll({
            languages.keys.elementAt(_controller!.index): {
              "locationName":
                  TextEditingController(text: locationData!.locationName!),
              "address":
                  TextEditingController(text: locationData!.addressStreet!),
              "street": TextEditingController(text: locationData!.street!),
              "city": TextEditingController(text: locationData!.city!),
              "description":
                  TextEditingController(text: locationData!.description!)
            }
          });
        }
      } catch (e) {
        log("Error occured while handeling language data $e");
        throw e;
      }

      log("DATA CONTROLLERS ${dataControllers[languages.keys.elementAt(_controller!.index)]}");
    }

    return Future.value(data);
  }

  showDeleteDailog(
      {required BuildContext context,
      required String fileName,
      required Function onResult}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Image Deletion"),
          content:
              const Text("Please confirm if you wan to delete this image?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.0,
                        color: ColorParser().hexToColor(RuntimeStorage
                            .instance.clientTheme!.top_title_background_color!),
                      ),
                      borderRadius: BorderRadius.circular(10.0))),
                ),
                onPressed: () {
                  log("User has requested to delete => $fileName");

                  Map<String, dynamic> params = {
                    "park_id": widget.isEdit! ? widget.parkId : park_Id,
                    "image_name": fileName
                  };
                  ApiFactory()
                      .getLocationService()
                      .deleteImage(params)
                      .then((value) {
                    Navigator.of(context).pop();

                    onResult();
                  });
                },
                child: const Text(
                  "Confirm and Delete",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      },
    );
  }
}
