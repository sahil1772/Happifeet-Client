import 'package:flutter/material.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../utils/ColorParser.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  gotoAddLocation(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddLocation()));
  }


  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> with  SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    // TODO: implement initState

    _controller = new TabController(length: 2, vsync: this);
    super.initState();
  }
  
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
              decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ ColorParser().hexToColor("#34A846"),ColorParser().hexToColor("#83C03D")],
                  )),
              child: Column(children: [
                // SizedBox(height: 105),
                Padding(
                  padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(

                        "Add Location",
                        // "Select Location".tr(),
                        // "Select Location".language(context),
                        // widget.selectedLanguage == "1" ? 'Select Location'.language(context) : 'Select Location',
                        style: TextStyle(

                            color:  Colors.white,
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color:  Colors.white),
                  // color: Colors.white,
                  child: SingleChildScrollView(

                    child: Column(
                      children: [
                        Center(child: Text("Select Language")),
                        // DefaultTabController(
                        //     length: 2,
                        //     child: TabBar(
                        //       tabs: [
                        //         Text("English"),
                        //         Text("Español")
                        //       ],
                        //
                        //     ),
                        // ),
                        TabBar(
                          controller: _controller,
                            tabs: [
                          Text("English"),
                                  Text("Español")
                        ]),
                        Container(
                          height: 80,
                          child: TabBarView(
                            controller: _controller,
                              children: [
                                Text("Data in english"),
                                Text("Data in spanish"),
                              ]),
                        )


                      ],
                    ),
                  ),
                );
              })
        ],
      ),

    );
  }
}
