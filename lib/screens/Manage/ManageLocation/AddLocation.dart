import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/i18n/locale_keys.g.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/model/Location/Features.dart';
import 'package:happifeet_client_app/model/Location/LocationDataModel.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../network/ApiFactory.dart';
import '../../../utils/ColorParser.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  gotoAddLocation(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AddLocation()));
  }

  @override
  State<AddLocation> createState() => _AddLocationState();
}

Map<String, String> getLanguages() {
  Map<String, String> lang = {};
  lang.addAll({"en": "English"});
  lang.addAll({"es": "Español"});
  lang.addAll({"ru": "Russian"});
  lang.addAll({"zh": "Chinese"});

  return lang;
}

class _AddLocationState extends State<AddLocation>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  Map<String, String> languages = getLanguages();

  Map<String, Map<String, TextEditingController>> dataControllers = {};

  LocationDataModel? locationData;

  TextEditingController en_clientNameController =
  TextEditingController(text: "");
  TextEditingController en_locationNameController =
  TextEditingController(text: "");
  TextEditingController en_addressStreetController =
  TextEditingController(text: "");
  TextEditingController en_cityController = TextEditingController(text: "");
  TextEditingController en_stateController = TextEditingController(text: "");
  TextEditingController en_zipController = TextEditingController(text: "");
  TextEditingController en_latitudeController = TextEditingController(text: "");
  TextEditingController en_longitudeController =
  TextEditingController(text: "");
  TextEditingController en_descriptionController =
  TextEditingController(text: "");

  List<Features> features = [];

  @override
  void reassemble() {
    // TODO: implement reassemble

    super.reassemble();
  }

  @override
  void initState() {
    // TODO: implement initState

    getFeatures();

    locationData = LocationDataModel(language: "en");
    locationData!.otherLanguages = [];

    _controller = TabController(length: languages.keys.length, vsync: this);

    _controller!.addListener(() {
      setState(() {
        // context.setLocale(Locale("en"));
        log("CONTROLLER INDEX ${languages.keys.elementAt(_controller!.index)}");
        if (_controller!.indexIsChanging) {
          log("tab is changing");
          context
              .setLocale(Locale(languages.keys.elementAt(_controller!.index)));
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
      en_clientNameController = controllers!["clientName"]!;
      en_locationNameController = controllers["locationName"]!;
      en_addressStreetController = controllers["address"]!;
      en_descriptionController = controllers["description"]!;
      en_cityController = controllers["city"]!;
      en_stateController = controllers["state"]!;
      en_zipController = controllers["zip"]!;
      en_latitudeController = controllers["latitude"]!;
      en_longitudeController = controllers["longitude"]!;
    } else {
      dataControllers.addAll({
        "en": {
          "clientName": en_clientNameController,
          "locationName": en_locationNameController,
          "address": en_addressStreetController,
          "description": en_descriptionController,
          "city": en_cityController,
          "state": en_stateController,
          "zip": en_zipController,
          "latitude": en_latitudeController,
          "longitude": en_longitudeController,
        }
      });
    }

    super.initState();
  }

  double? labelTextSize = 12.0;
  double? fontLabelTextSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(IsDashboard: false, isCitiyList: false)
          .getAppBar(context),
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorParser().hexToColor("#34A846"),
                      ColorParser().hexToColor("#83C03D")
                    ],
                  )),
              child: Column(children: [
                // SizedBox(height: 105),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height / 7.5),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Location",
                        // "Select Location".tr(),
                        // "Select Location".language(context),
                        // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ])),
          DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
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
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  languages.values.elementAt(i).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: labelTextSize,
                                  ),
                                ),
                              ),
                          ]),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
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
                                  ? loadContent()
                                  : otherLanguageFields(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget loadContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addressBlock(),
        imagesBlock(),
        infoBlock(),
        availabilityBlock(),
        featuresBlock(),
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

  bool isMainCity = false;
  bool showByMonth = true;

  Widget addressBlock() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xffc4c4c4),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Client_Name,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_clientNameController,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Main_Site,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Location_Name,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_locationNameController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Address_Street,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_addressStreetController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.City,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_cityController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.State,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_stateController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Zip,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_zipController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Latitude,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_latitudeController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Longitude,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    controller: en_longitudeController,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    LocaleKeys.Main_City_Location,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                  value: isMainCity,
                  onChanged: (value) {
                    setState(() {
                      isMainCity = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: const Color(0xff01825C),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(56))),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: const Text(
                LocaleKeys.Park_Address,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ).tr(),
            ),
          ),
        )
      ],
    );
  }

  Widget imagesBlock() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xffc4c4c4),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Park Images",
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Gallery Images",
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: TextField(
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
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: const Color(0xff01825C),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(56))),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: const Text(
                LocaleKeys.Park_Images,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ).tr(),
            ),
          ),
        )
      ],
    );
  }

  Widget infoBlock() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xffc4c4c4),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //Description
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    LocaleKeys.Description,
                    style: TextStyle(
                        fontSize: labelTextSize,
                        color: const Color(0xff757575)),
                  ).tr(),
                ),
                TextField(
                  controller: en_descriptionController,
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
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: const Color(0xff01825C),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(56))),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: const Text(
                LocaleKeys.Park_Info,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ).tr(),
            ),
          ),
        )
      ],
    );
  }

  bool isChecked = false;

  Widget availabilityBlock() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xffc4c4c4),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          showByMonth = true;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(showByMonth
                            ? Theme
                            .of(context)
                            .primaryColor
                            : Colors.transparent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                      ),
                      child: Text(
                        "Choose by Month",
                        style: TextStyle(
                            fontSize: 12,
                            color: showByMonth
                                ? Colors.white
                                : Theme
                                .of(context)
                                .primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              showByMonth = false;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                showByMonth
                                    ? Colors.transparent
                                    : Theme
                                    .of(context)
                                    .primaryColor),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    side: const BorderSide(width: 0.0),
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          child: Text("Choose by Date",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: !showByMonth
                                      ? Colors.white
                                      : Theme
                                      .of(context)
                                      .primaryColor))),
                    ),
                  ],
                ),
                showByMonth
                    ? GridView(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2, crossAxisCount: 2),
                  children: List.generate(12, (index) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isChecked,
                      title: Text(DateFormat("MMMM").format(
                          DateFormat("MM").parse("${(index + 1)}"))),
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    );
                  }),
                )
                    : const SizedBox()
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: const Color(0xff01825C),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(56))),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: const Text(
                LocaleKeys.Park_Availability,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ).tr(),
            ),
          ),
        )
      ],
    );
  }

  Widget featureBlock(Features feature) {
    return const Card(
      child: SizedBox(
        width: 100,
        height: 100,
      ),
    );
  }

  Widget featuresBlock() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color(0xffc4c4c4),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child:GridView.extent(
            shrinkWrap: true,
            maxCrossAxisExtent: 150.0, // maximum item width
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 8.0, // spacing between columns
            padding: EdgeInsets.symmetric(vertical: 36.0,horizontal: 8), // padding around the grid
            physics: NeverScrollableScrollPhysics(),
            children: features.map((item) {
              return Container(
                color: Colors.blue, // color of grid items
                child: Center(
                  child: Text(
                    item.name!,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          )
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: const Color(0xff01825C),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(56))),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: const Text(
                LocaleKeys.Park_Features,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ).tr(),
            ),
          ),
        )
      ],
    );
  }

  otherLanguageFields() {
    bool isEnglishFormFilled = false;

    TextEditingController? clientNameController =
    TextEditingController(text: "");
    TextEditingController? locationNameController =
    TextEditingController(text: "");
    TextEditingController? addressController = TextEditingController(text: "");
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

    if (dataControllers.keys
        .contains(languages.keys.elementAt(_controller!.index))) {
      log("ALREADY HAS CONTROLLERS");
      Map<String, TextEditingController>? controllers =
      dataControllers[languages.keys.elementAt(_controller!.index)];
      clientNameController = controllers!["clientName"];
      locationNameController = controllers["locationName"];
      addressController = controllers["address"];
      descriptionController = controllers["description"];
    } else {
      log("DOESN'T HAVE CONTROLLERS");
      dataControllers.addAll({
        languages.keys.elementAt(_controller!.index): {
          "clientName": clientNameController,
          "locationName": locationNameController,
          "address": addressController,
          "description": descriptionController
        }
      });
    }

    // log("Controllers ::::: \n $dataControllers");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        !isEnglishFormFilled
            ? Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.red),
              borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please fill details in English first.",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      letterSpacing: 0.2),
                )
              ],
            ),
          ),
        )
            : const SizedBox(),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffc4c4c4),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //CLIENT NAME
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        LocaleKeys.Client_Name,
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ).tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: clientNameController,
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
                      ),
                    ),

                    //CLIENT LOCATION NAME
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        LocaleKeys.Location_Name,
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ).tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        controller: locationNameController,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    //ADDRESS STREET
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        LocaleKeys.Address_Street,
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ).tr(),
                    ),
                    TextField(
                      controller: addressController,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: const Color(0xff01825C),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(56))),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
                  child: const Text(
                    LocaleKeys.Park_Address,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff01825C),
                    ),
                  ).tr(),
                ),
              ),
            )
          ],
        ),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffc4c4c4),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        LocaleKeys.Description,
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ).tr(),
                    ),
                    TextField(
                      controller: descriptionController,
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
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1,
                      color: const Color(0xff01825C),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(56))),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
                  child: const Text(
                    LocaleKeys.Park_Info,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff01825C),
                    ),
                  ).tr(),
                ),
              ),
            )
          ],
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

  Future<void> getFeatures() async {
    var response = await ApiFactory().getLocationService().getFeatures();
    features = response!;
  }

  Future<void> submitDetails() async {
    bool isValid = checkValidation();

    if (isValid) {
      if (languages.keys.elementAt(_controller!.index) == "en") {
        locationData = LocationDataModel(language: "en");
        locationData!.clientName =
            dataControllers["en"]?["clientName"]?.value.text;
        locationData!.locationName =
            dataControllers["en"]?["locationName"]?.value.text;
        locationData!.addressStreet =
            dataControllers["en"]?["address"]?.value.text;
        locationData!.description =
            dataControllers["en"]?["description"]?.value.text;
        locationData!.city = dataControllers["en"]?["city"]?.value.text;
        locationData!.state = dataControllers["en"]?["state"]?.value.text;
        locationData!.zip = dataControllers["en"]?["zip"]?.value.text;
        locationData!.latitude = dataControllers["en"]?["latitude"]?.value.text;
        locationData!.longitude =
            dataControllers["en"]!["longitude"]!.value.text;
      } else {
        try {
          // log("ADDING DETAILS FOR LANGUAGE ${languages.values.elementAt(_controller!.index)}");
          LocationDataModel otherLanguage = LocationDataModel(
              language: languages.keys.elementAt(_controller!.index));

          otherLanguage.description = dataControllers[
          languages.keys.elementAt(_controller!.index)]!["description"]!
              .text;
          otherLanguage.locationName = dataControllers[languages.keys
              .elementAt(_controller!.index)]!["locationName"]!
              .text;
          otherLanguage.clientName = dataControllers[
          languages.keys.elementAt(_controller!.index)]!["clientName"]!
              .text;
          otherLanguage.addressStreet = dataControllers[
          languages.keys.elementAt(_controller!.index)]!["address"]!
              .text;

          log("NEW LANGUAGE ${otherLanguage.toJson()}");
          if (locationData!.otherLanguages != null) {
            if (locationData!.otherLanguages!.any((element) =>
            element.language ==
                languages.keys.elementAt(_controller!.index))) {
              locationData!.otherLanguages!.add(otherLanguage);
            }
          } else {
            locationData!.otherLanguages = [];
            locationData!.otherLanguages!.add(otherLanguage);
          }
        } catch (e) {
          log("ERROR OCCURRED WHILE TRYING TO ADD OTHER LANGUAGE DETAILS : $e");
        }
      }

      log("LOCATION DATA SUBMIT ::: ${locationData!.toJson()}");

      BaseResponse response = await ApiFactory()
          .getLocationService()
          .submitLocationData(locationData!);
      if (response.status == 200) {
        _controller!.index = (_controller!.index + 1 > languages.length - 1)
            ? _controller!.index
            : (_controller!.index + 1);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.msg!)));
      }
    }
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
}
