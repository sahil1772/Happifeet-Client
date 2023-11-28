import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/i18n/locale_keys.g.dart';

import '../../../components/HappiFeetAppBar.dart';
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

  List<Map<String, Map<TextField, TextEditingController>>> dataControllers = [];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      context.setLocale(Locale("en"));

      // context.setLocale(Locale(languages.keys.elementAt(_controller!.index)));
    });
    _controller = TabController(length: languages.keys.length, vsync: this);
    _controller!.addListener(() {
      setState(() {
        // context.setLocale(Locale("en"));

        context.setLocale(Locale(languages.keys.elementAt(_controller!.index)));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    context.setLocale(Locale("en"));
    super.dispose();
  }

  double? labelTextSize = 14.0;

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
                      top: MediaQuery.of(context).size.height / 9),
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
                          isScrollable: true,
                          indicatorWeight: 1,
                          indicatorPadding: const EdgeInsets.all(0),
                          labelColor: const Color(0xff49AC43),
                          indicatorColor: const Color(0xff49AC43),
                          tabs: [
                            for (int i = 0; i < languages.keys.length; i++)
                              Text(
                                languages.values.elementAt(i).toUpperCase(),
                                style: TextStyle(
                                  fontSize: labelTextSize,
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
      children: [
        addressBlock(),
        imagesBlock(),
        infoBlock(),
        availabilityBlock(),
        featuresBlock(),
      ],
    );
  }

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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        LocaleKeys.Main_City_Location,
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ).tr(),
                    ),
                  ],
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main Site *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Location Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Address & Street *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "City *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "State *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Zip *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Latitude *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Longitude *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main City Location",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main Site *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Location Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Address & Street *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "City *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "State *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Zip *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Latitude *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Longitude *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main City Location",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main Site *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Location Name *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Address & Street *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "City *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "State *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Zip *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Latitude *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Longitude *",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main City Location",
                        style: TextStyle(
                            fontSize: labelTextSize,
                            color: const Color(0xff757575)),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
    return Column(
      children: [
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
      ],
    );
  }
}
