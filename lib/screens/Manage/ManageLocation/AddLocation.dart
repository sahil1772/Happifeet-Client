import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:happifeet_client_app/i18n/locale_keys.g.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Location/Features.dart';
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
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
  final ImagePicker _picker = ImagePicker();

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
  dynamic _pickImageError;
  Map<String, dynamic> languages = {};
  Map<String, Map<String, TextEditingController>> dataControllers = {};
  List<Features>? features = [];
  List<String> selectedMonths = [];
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

  double HEADER_HEIGHT = 5;

  Future<LocationDataModel?>? apiResponse=null;

  @override
  void initState() {
    // TODO: implement initState
    locationData = LocationDataModel();

    getLanguages().then((value) {
      languages = value;
      getFeatures();
      otherFeaturesWidgets!.addAll({
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

          apiResponse = getLocationData(widget.parkId!);
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
          }
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

      apiResponse = getLocationData(widget.parkId!);
      setState(() {
        context.setLocale(Locale(languages.keys.elementAt(0)));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.buildContext = context;
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
                  child: Center(
                    child: const Text(
                      "Add Location",
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
                          const Text(
                            "Location Name*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                          const Text(
                            "Address & Street*",
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
                          const Text(
                            "City*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                          const Text(
                            "Zip*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                          const Text(
                            "State*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                          const Text(
                            "Description*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                            child: Container(
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
                          const Text(
                            "Latitude*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                          const Text(
                            "Longitude*",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
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
                                                          ? Theme.of(context)
                                                              .primaryColor
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
                                                  ? Theme.of(context)
                                                      .primaryColor
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
                                                              ? Colors
                                                                  .transparent
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                            ),
                                            child: Text("Date Range",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: !showByMonth
                                                        ? Theme.of(context)
                                                            .primaryColor
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
                                                selectedMonths.add(item!);
                                              } else {
                                                selectedMonths.remove(item);
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xff01825C)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: isSelected
                                                          ? const Color(
                                                              0xff49AC43)
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
                                                          new DateFormat("MM")
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
                                    : const SizedBox()
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
                              future: getFeatures(),
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
                                                    ? const Color(0xff49AC43)
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
                                                          ? const Color(
                                                              0xff49AC43)
                                                          : const Color(
                                                              0xff8A8A8A),
                                                      BlendMode.srcIn)),
                                              Text(
                                                item.name!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: isSelected
                                                        ? const Color(
                                                            0xff49AC43)
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
                          child: const Text("Add More +")),
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
                        const Text(
                          LocaleKeys.Location_Name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
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
                        const Text(
                          LocaleKeys.Address_Street,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
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
                        const Text(
                          LocaleKeys.Street,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
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
                        const Text(
                          LocaleKeys.City,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
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
                        const Text(
                          LocaleKeys.Description,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
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
                        const Text(
                          LocaleKeys.Other_features,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ).tr(),
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
                        child: const Text(LocaleKeys.Add_More).tr()),
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

  Future<void> getFeatures() async {
    var response = await ApiFactory().getLocationService().getFeatures();
    features = response!;
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
      locationData!.addressStreet = controllers!["address"]!.text;
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
        .submitLocationLanguageData(locationData!, park_Id!,
            languages.keys.elementAt(_controller!.index));
    if (response.status == 1) {
      _controller!.index = (_controller!.index + 1 > languages.length - 1)
          ? _controller!.index
          : (_controller!.index + 1);
      if (_controller!.index + 1 > languages.length - 1) {
        ScaffoldMessenger.of(buildContext!).showSnackBar(
            const SnackBar(content: Text("Location Created Successfully.")));
        Navigator.of(buildContext!).pop();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.msg!)));
    }
  }

  dabcd(Function dataCallback) {
    dataCallback("abcd");
  }

  Future<void> submit_English_Details() async {
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
    log("Available Months : $selectedMonths");
    log("Features : $selectedFeaturesID");
    log("Park Image : ${locationImage?.name}");
    log("Gallery Images : ${galleryImages!.length}");
    log("Status : $isChecked");

    final isValid = _form.currentState!.validate();

    if (showByMonth) {
      if (selectedMonths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select avability of parks")));
        return;
      }
    } else {}

    if (selectedFeaturesID!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select park features")));
      return;
    }

    if (locationImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select park image.")));
      return;
    }

    if (!widget.isEdit!) {
      if (galleryImages!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please select park gallery images.")));
        return;
      }

      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Invalid park details. Please provide park details.")));
        return;
      }
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
    BaseResponse response = widget.isEdit!
        ? await ApiFactory()
            .getLocationService()
            .updateLocationData(locationData!, locationImage!, galleryImages!)
        : await ApiFactory()
            .getLocationService()
            .submitLocationData(locationData!, locationImage!, galleryImages!);
    if (response.status == 1) {
      park_Id = response.park_id.toString();
      _controller!.index = (_controller!.index + 1 > languages.length - 1)
          ? _controller!.index
          : (_controller!.index + 1);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.msg!)));
    }
  }

  Future<LocationDataModel?> getLocationData(String? park_id) async {
    if (park_id == null) {
      return Future.value(null);
    }
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

    if(languages.keys.elementAt(_controller!.index)=="en"){
      locationData = data;
      locationNameController.text = locationData!.locationName!;
      addressNameController.text = locationData!.addressStreet!;
      cityController.text = locationData!.city!;
      stateController.text = locationData!.state!;
      zipController.text = locationData!.zip!;
      descriptionController.text = locationData!.description!;
      isMainCity =
      locationData!.mainCityLocation! == "1" ? true : false;
      latitudeController.text = locationData!.latitude!;
      longitudeController.text = locationData!.longitude!;
      reserveLinkController.text = locationData!.reservationlink!;
      isChecked = locationData!.status! == "Y" ? true : false;
      selectedFeaturesID = locationData!.parkFeatures!;
      selectedMonths = locationData!.parkAvailabilityMonths!;

      if (languages.keys.elementAt(_controller!.index) == "en") {
        otherFeaturesWidgets = {};
        List<String?> otherFeatures =
        locationData!.otherFeatures == null || locationData!.otherFeatures!.isEmpty
            ? []
            : locationData!.otherFeatures!;
        List<TextField> otherFeaturesFields =
        locationData!.otherFeatures == null || locationData!.otherFeatures!.isEmpty
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

        otherFeaturesWidgets.addAll({"en": otherFeaturesFields});
      }
    }
    else{
      locationData = data;


      otherFeaturesWidgets = {};
      List<String?> otherFeatures =
      locationData!.otherFeatures == null || locationData!.otherFeatures!.isEmpty
          ? []
          : locationData!.otherFeatures!;
      List<TextField> otherFeaturesFields =
      locationData!.otherFeatures == null || locationData!.otherFeatures!.isEmpty
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
      });
      if(dataControllers.containsKey(languages.keys.elementAt(_controller!.index))){
        dataControllers[languages.keys.elementAt(_controller!.index)]!["locationName"]!.text = locationData!.locationName!;
        dataControllers[languages.keys.elementAt(_controller!.index)]!["address"]!.text = locationData!.addressStreet!;
        dataControllers[languages.keys.elementAt(_controller!.index)]!["street"]!.text = locationData!.street!;
        dataControllers[languages.keys.elementAt(_controller!.index)]!["city"]!.text = locationData!.city!;
        dataControllers[languages.keys.elementAt(_controller!.index)]!["description"]!.text = locationData!.description!;


      }
      else{
        dataControllers.addAll({
          languages.keys.elementAt(_controller!.index): {
            "locationName": TextEditingController(text: locationData!.locationName!),
            "address": TextEditingController(text: locationData!.addressStreet!),
            "street": TextEditingController(text: locationData!.street!),
            "city": TextEditingController(text: locationData!.city!),
            "description": TextEditingController(text: locationData!.description!)
          }
        });
      }

    }

    return Future.value(data);
  }
}
