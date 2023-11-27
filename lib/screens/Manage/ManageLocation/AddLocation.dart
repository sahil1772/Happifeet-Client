import 'package:flutter/material.dart';

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

class _AddLocationState extends State<AddLocation>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    // TODO: implement initState

    _controller = TabController(length: 2, vsync: this);
    _controller!.addListener(() {
      setState(() {});
    });
    super.initState();
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
                      top: MediaQuery.of(context).size.height / 8),
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Select Language",
                          style: TextStyle(fontSize: 18),
                        ),
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
                            Text(
                              "English".toUpperCase(),
                              style: TextStyle(
                                fontSize: labelTextSize,
                              ),
                            ),
                            Text("Español".toUpperCase(),
                                style: TextStyle(fontSize: labelTextSize))
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
                              loadContent(),
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
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Client Name *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 16),

                      border: OutlineInputBorder(
                        borderSide: BorderSide( color: const Color(0xffc4c4c4),),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Main Site *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:

                      EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Location Name *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Address & Street *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "City *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "State *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Zip *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Latitude *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Longitude *",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Main City Location",
                    style: TextStyle(
                        fontSize: labelTextSize, color: Color(0xff757575)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      border: OutlineInputBorder(
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
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: Text(
                "Park Address",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ),
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
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
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
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: Text(
                "Park Images",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ),
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
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main Site *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Location Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Address & Street *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "City *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "State *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Zip *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Latitude *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Longitude *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main City Location",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
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
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: Text(
                "Park Info",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ),
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
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main Site *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Location Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Address & Street *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "City *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "State *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Zip *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Latitude *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Longitude *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main City Location",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
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
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: Text(
                "Park Availability",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ),
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
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Client Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main Site *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Location Name *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Address & Street *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "City *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "State *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Zip *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Latitude *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Longitude *",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Main City Location",
                        style: TextStyle(
                            fontSize: labelTextSize, color: Color(0xff757575)),
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
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 5),
              child: Text(
                "Park Features",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xff01825C),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
