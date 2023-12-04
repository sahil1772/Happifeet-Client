import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../i18n/locale_keys.g.dart';
import '../../../utils/ColorParser.dart';
import '../ManageLocation/AddLocation.dart';

class AddAnnouncementWidget extends StatefulWidget{

  gotoAddAnnouncementPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddAnnouncementWidget()));

  }


  @override
  State<AddAnnouncementWidget> createState() => _AddAnnouncementWidgetState();
  
}

Map<String, String> getLanguages() {
  Map<String, String> lang = {};
  lang.addAll({"en": "English"});
  lang.addAll({"es": "Español"});
  lang.addAll({"ru": "Russian"});
  lang.addAll({"zh": "Chinese"});

  return lang;
}

class _AddAnnouncementWidgetState extends State<AddAnnouncementWidget> with SingleTickerProviderStateMixin{

  TabController? _controller;
  Map<String, String> languages = getLanguages();
  double? labelTextSize = 14.0;

  @override
  void initState() {
    // TODO: implement initState
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
    context.setLocale(const Locale("en"));
    _controller!.dispose();
    super.dispose();
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
                      top: MediaQuery.of(context).size.height / 7.5),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Announcement",
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            LocaleKeys.Title,
            style: TextStyle(
                fontSize: labelTextSize,
                color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            // controller: en_clientNameController,
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
        //  Upload Image
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Upload Image",
            style: TextStyle(
                fontSize: labelTextSize,
                color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(border: Border.all(color:Color(0xffc4c4c4),),borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 10,right: 200,bottom: 10),
              child: OutlinedButton(
                onPressed: () {  },
                child: Text("Choose Image"),

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
                fontSize: labelTextSize,
                color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            // controller: en_clientNameController,
            maxLines: 5,
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
          padding: const EdgeInsets.only(bottom: 56.0),
          child: ElevatedButton(
              onPressed: () {
                // submitDetails();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Submit"),
              )),
        )
      ],
    );
  }

  otherLanguageFields(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            LocaleKeys.Title,
            style: TextStyle(
                fontSize: labelTextSize,
                color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            // controller: en_clientNameController,
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
        //  Upload Image
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Upload Image",
            style: TextStyle(
                fontSize: labelTextSize,
                color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(border: Border.all(color:Color(0xffc4c4c4),),borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 10,right: 200,bottom: 10),
              child: OutlinedButton(
                onPressed: () {  },
                child: Text("Choose Image"),

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
                fontSize: labelTextSize,
                color: const Color(0xff757575)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextField(
            // controller: en_clientNameController,
            maxLines: 5,
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
          padding: const EdgeInsets.only(bottom: 56.0),
          child: ElevatedButton(
              onPressed: () {
                // submitDetails();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Submit"),
              )),
        )
      ],
    );

}
}