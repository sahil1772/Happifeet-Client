import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/model/Announcement/AnnouncementData.dart';
import 'package:happifeet_client_app/model/Announcement/AnnouncementDetailLangWise.dart';
import 'package:happifeet_client_app/model/BaseResponse.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/DeviceDimensions.dart';
import 'package:happifeet_client_app/utils/LanguageUtils.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/HappiFeetAppBar.dart';
import '../../../i18n/locale_keys.g.dart';
import '../../../storage/runtime_storage.dart';
import '../../../utils/ColorParser.dart';

class AddAnnouncementWidget extends StatefulWidget {
  bool? isEdit = false;
  String? announcementId;

  AddAnnouncementWidget({super.key, this.isEdit, this.announcementId});

  static gotoAddAnnouncementPage(
      BuildContext context, bool? isEdit, String? id, Function? callback) {
    log("Annoucement Id => $id");
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(
            builder: (_) => AddAnnouncementWidget(
                  isEdit: isEdit,
                  announcementId: id,
                )))
        .then((value) => callback!());
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
  final ImagePicker _picker = ImagePicker();

  //PICKER FILE INSTANCES USED TO STORE PICKED OR CAPURED FILES
  XFile? locationImage;
  List<XFile>? galleryImages = [];
  BuildContext? buildContext;

  Future? apiResponse;

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
            switch (languages.keys.elementAt(_controller!.index)) {
              case "spa":
                context.setLocale(Locale("es"));
                break;
              case "rsa":
                context.setLocale(Locale("rsa"));
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
                context.setLocale(Locale("es"));
                break;
              case "rsa":
                context.setLocale(Locale("rsa"));
                break;
              default:
                context.setLocale(
                    Locale(languages.keys.elementAt(_controller!.index)));
                break;
            }
          }
        });
      });

      apiResponse = getAnnouncementDetails();

      setState(() {
        context.setLocale(Locale("en"));
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
    buildContext = context;
    double HEADER_HEIGHT = 4.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: HappiFeetAppBar(
          IsDashboard: false,
          isCitiyList: false,
          callback: () {
            Navigator.of(context).pop();
          }).getAppBar(context),
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
                      "${widget.isEdit! ? "Edit" : "Add"} Announcement",
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
                    child: Text(
                      LocaleKeys.Select_Language,
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorParser().hexToColor(RuntimeStorage
                            .instance.clientTheme!.top_title_background_color!),
                      ),
                    ).tr(),
                  ),
                  TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
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
    return FutureBuilder(
      future: apiResponse,
      builder: (context, snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              LocaleKeys.Title,
              style: TextStyle(fontSize: labelTextSize, color: Colors.black),
            ).tr(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextFormField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              enabled: !widget.isEdit!,
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
              style: TextStyle(fontSize: labelTextSize, color: Colors.black),
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
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.0,
                          color: ColorParser().hexToColor(RuntimeStorage
                              .instance
                              .clientTheme!
                              .top_title_background_color!),
                        ),
                        borderRadius: BorderRadius.circular(20.0))),
                  ),
                  onPressed: () {
                    !widget.isEdit! ? _showBottomSheet(1) : null;
                  },
                  child: Text(
                    "Choose Image",
                    style: TextStyle(
                      color: ColorParser().hexToColor(RuntimeStorage
                          .instance.clientTheme!.top_title_background_color!),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Description
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Description",
              style: TextStyle(fontSize: labelTextSize, color: Colors.black),
            ).tr(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextFormField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              enabled: !widget.isEdit!,
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorParser().hexToColor(RuntimeStorage
                        .instance.clientTheme!.button_background!),
                    elevation: 0),
                onPressed: () {
                  goToNextLangOrSubmit();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    widget.isEdit! ? "Next" : "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          )
        ],
      ),
    );
  }

  otherLanguageFields() {
    bool isEnglishFormFilled = false;
    if (!dataControllers
        .containsKey(languages.keys.elementAt(_controller!.index))) {
      dataControllers.addAll({
        languages.keys.elementAt(_controller!.index): {
          "title": TextEditingController(),
          "description": TextEditingController(),
        }
      });
    }

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

    return Column(
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
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            LocaleKeys.Title,
            style: TextStyle(
                fontSize: labelTextSize,
                color: ColorParser().hexToColor(RuntimeStorage
                    .instance.clientTheme!.top_title_background_color!)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == "" || value == null) {
                return LocaleKeys.Provide_Valid_Data.tr();
              }
            },
            enabled: !widget.isEdit!,
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
                fontSize: labelTextSize,
                color: ColorParser().hexToColor(RuntimeStorage
                    .instance.clientTheme!.top_title_background_color!)),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == "" || value == null) {
                return LocaleKeys.Provide_Valid_Data.tr();
              }
            },
            enabled: !widget.isEdit!,
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
        !widget.isEdit!
            ? Padding(
                padding: const EdgeInsets.only(bottom: 56.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorParser().hexToColor(RuntimeStorage
                            .instance.clientTheme!.button_background!),
                        elevation: 0),
                    onPressed: () {
                      goToNextLangOrSubmit();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              )
            : const SizedBox()
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

    if (dataControllers["en"]!["title"]!.text == "" ||
        dataControllers["en"]!["description"]!.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill details in English first.!")));
      return;
    }

    AnnouncementData data = AnnouncementData();
    data.title = dataControllers["en"]!["title"]!.text;
    data.description = dataControllers["en"]!["description"]!.text;

    dataControllers.entries.forEach((element) {
      if (element.key != "en") {
        if (data.annoucement_lang_cols == null) {
          data.annoucement_lang_cols = {};
        }
        data.annoucement_lang_cols!.addAll({
          LanguageUtils.convertLanguageCode(element.key):
              AnnouncementDetailLangWise(
                  title: dataControllers[element.key]!["title"]!.text,
                  description:
                      dataControllers[element.key]!["description"]!.text)
        });
      }
    });

    print("Form Data => ${data.toJson()}");

    BaseResponse response = await ApiFactory()
        .getAnnouncementService()
        .submitAnnouncementDetails(data, null);

    if (response.status == "1") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Announcement added successfully.")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.msg}")));
    }
  }

  void _showDialougToAddImages(int i) {
    log("Image Picker Called For Case : $i");
    showDialog(
        context: context,
        builder: (context) => Dialog(
          clipBehavior: Clip.none,
          child: Container(
            // height: DeviceDimensions.getDeviceHeight(context) / 4,
            // width: DeviceDimensions.getDeviceWidth(context),
            // padding: const EdgeInsets.all(26),

            // padding: EdgeInsets.symmetric(
            //     horizontal: 16, vertical: 16),
              height: MediaQuery.of(context)
                  .size
                  .height /
                  4,
              width:
              MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),),
                    ),
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
                  SizedBox(height: 15,),
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),),
                      ),

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
              )),
        )
    );

  }

  void _showBottomSheet(int i) {
    log("Image Picker Called For Case : $i");
    showModalBottomSheet(
        context: buildContext!,
        builder: (context) => Container(
            height: DeviceDimensions.getDeviceHeight(context) / 4,
            width: DeviceDimensions.getDeviceWidth(context),
            padding: const EdgeInsets.all(26),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

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
              ),
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

  void goToNextLangOrSubmit() {
    int currentIndex = _controller!.index;
    if (currentIndex + 1 > languages.length - 1) {
      if (_form.currentState!.validate()) {
        submitDetails();
      }
    } else {
      _controller!.index++;
    }
  }

  Future? getAnnouncementDetails() async {
    if (!widget.isEdit!) {
      return Future.value(null);
    }
    if (widget.announcementId! == null) {
      return Future.value(null);
    }
    try {
      AnnouncementData? data = await ApiFactory()
          .getAnnouncementService()
          .getAnnouncementDetails(widget.announcementId!);

      dataControllers["en"]!["title"]!.text = data!.title!;
      dataControllers["en"]!["description"]!.text = data.description!;

      data.annoucement_lang_cols!.forEach((key, value) {
        log("CHECKING CONTENT => $key => ${value.toJson()}");
        if (dataControllers.containsKey(key)) {
          dataControllers[key]!["title"]!.text = value.title!;
          dataControllers[key]!["description"]!.text = value.description!;
        } else {
          dataControllers.addAll({
            (key): {
              "title": TextEditingController(text: value.title!),
              "description": TextEditingController(text: value.description!),
            }
          });
        }
      });
      log("CONTROLLERS SET => $dataControllers");
      return Future.value(data);
    } catch (e) {
      log("ERROR OCCURED WHILE SETTING DATA => ", error: e);
      throw e;
    }
  }
}
