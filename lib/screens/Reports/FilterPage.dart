import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/model/AssignedUsers/AssignedUserData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../../model/Trails/TrailListingData.dart';
import '../../resources/resources.dart';
import '../../storage/runtime_storage.dart';

List<String> fieldOptions = ['Item 1', 'Item 2', 'Item 3', "Item 4"];

enum FilterPages { STATUS, COMMENTS, ACTIVITY }

class FilterPage extends StatefulWidget {
  FilterPage({super.key, this.params, this.filterData, required this.page});

  FilterMap? params;
  Function? filterData;
  FilterPages page = FilterPages.COMMENTS;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

enum FilterType { Trail, Park }

enum FilterStatus { UnAssigned, Resolved, Pending }

enum FilterFunctionType { Website, Mobile, None }

class _FilterPageState extends State<FilterPage> {
  FilterType type = FilterType.Park;
  FilterStatus status = FilterStatus.Resolved;
  FilterFunctionType functionType = FilterFunctionType.None;
  String? dropdownValueSelected = fieldOptions.first;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Map<String, dynamic> parks = {};
  List<TrailListingData>? trailList;
  String? selectedParkId = "";
  String? selectedTrailId = "";
  String? selectedAssignedTo = "";

  List<AssignedUserData>? userListing = [];

  TextEditingController keywordController = TextEditingController();

  bool showAssignedUser = false;
  bool showType = false;
  bool showStatus = false;
  bool showKeyword = false;
  bool formType = false;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.params == null) {
      widget.params = FilterMap();
    } else {
      if (widget.params!.type != null) {
        type = FilterType.values.byName(widget.params!.type!);
      }
      if (widget.params!.status != null) {
        status = FilterStatus.values.byName(widget.params!.status!);
      }
      if (widget.params!.functionType != null) {
        functionType =
            FilterFunctionType.values.byName(widget.params!.functionType!);
      }
      if (widget.params!.popupDatepickerFromDateSearch != null) {
        selectedStartDate = DateFormat("yyyy-MM-dd")
            .parse(widget.params!.popupDatepickerFromDateSearch!);
      }
      if (widget.params!.popupDatepickerToDateSearch != null) {
        selectedEndDate = DateFormat("yyyy-MM-dd")
            .parse(widget.params!.popupDatepickerToDateSearch!);
      }
      selectedParkId = widget.params!.main_park_id ?? "";
      keywordController.text = widget.params!.frm_keyword ?? "";
    }

    SharedPref.instance.getParks().then((value) {
      parks = value;
      setState(() {
        context.setLocale(Locale("en"));
      });
    });

    SharedPref.instance.getTrails().then((value) {
      log("trail value ${value}");
      trailList = value;
      log("TRAIL LISTING IN FILTER PAGE ${trailList!.first.toJson()}");
    });

    // if (widget.showAssignedUser) getAssignedUserListing();

    switch (widget.page) {
      case FilterPages.COMMENTS:
        showAssignedUser = false;
        showType = true;
        showStatus = true;
        showKeyword = true;
        formType = true;
        break;
      case FilterPages.ACTIVITY:
        showAssignedUser = false;
        showType = true;
        showStatus = false;
        showKeyword = false;
        formType = true;
        break;
      case FilterPages.STATUS:
        showAssignedUser = true;
        showType = true;
        showStatus = true;
        showKeyword = true;
        formType = true;
        getAssignedUserListing();
        break;
    }
    setState(() {});

    super.initState();
  }

  Future<void> getAssignedUserListing() async {
    var response = await ApiFactory().getUserService().getUserData(
        "list_assigned_users", await SharedPref.instance.getUserId());

    userListing = response;

    setState(() {});
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate) {
      if (picked.isAfter(selectedEndDate)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Start date must be before end date")));
      } else {
        setState(() {
          selectedStartDate = picked;
        });
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate) {
      if (picked.isBefore(selectedStartDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("End date must be after start date")));
      } else {
        setState(() {
          selectedEndDate = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorParser().hexToColor(
                              RuntimeStorage.instance.clientTheme!
                                  .top_title_background_color!),
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/comments/close.svg"),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Close",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                /** Type **/
                showType
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage
                                    .instance.clientTheme!.body_text_color!)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              trailList != null
                                  ? OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          type = FilterType.Trail;
                                          widget.params!.type = type.name;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        side: BorderSide(
                                          color: type == FilterType.Trail
                                              ? ColorParser().hexToColor(
                                                  RuntimeStorage
                                                      .instance
                                                      .clientTheme!
                                                      .top_title_background_color!)
                                              : Colors.grey,
                                        ),
                                      ),
                                      child: Text(
                                        "Trail",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: type == FilterType.Trail
                                                ? ColorParser().hexToColor(
                                                    RuntimeStorage
                                                        .instance
                                                        .clientTheme!
                                                        .top_title_background_color!)
                                                : Colors.grey),
                                      ),
                                    )
                                  : SizedBox(),
                              trailList != null
                                  ? const SizedBox(
                                      width: 16,
                                    )
                                  : SizedBox(),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    type = FilterType.Park;
                                    widget.params!.type = type.name;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    color: type != FilterType.Park
                                        ? Colors.grey
                                        : ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                  ),
                                ),
                                child: Text(
                                  "Park",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: type != FilterType.Park
                                          ? Colors.grey
                                          : ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      )
                    : SizedBox(),

                /** Main location **/
                Text("Main Location",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorParser().hexToColor(RuntimeStorage
                            .instance.clientTheme!.body_text_color!))),
                const SizedBox(
                  height: 10,
                ),
                type == FilterType.Park
                    ? Container(
                        child: DropdownMenu<String>(
                          width: MediaQuery.of(context).size.width - 32,
                          enableSearch: false,
                          inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          requestFocusOnTap: false,
                          label: const Text('Select'),
                          initialSelection: selectedParkId,
                          onSelected: (String? park) {
                            selectedParkId = park;
                            log("Selected PARK => $park");
                            setState(() {});
                          },
                          dropdownMenuEntries: [
                            for (int i = 0; i < parks.keys.length; i++)
                              DropdownMenuEntry<String>(
                                value: parks.keys.elementAt(i),
                                label: parks.values.elementAt(i),
                              )
                          ],
                        ),
                      )
                    : type == FilterType.Trail && trailList != null
                        ? Container(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 32,
                              enableSearch: false,
                              inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              requestFocusOnTap: false,
                              label: const Text('Select'),
                              initialSelection: selectedParkId,
                              onSelected: (String? trail) {
                                selectedParkId = trail;
                                log("Selected Trail => $trail");
                                setState(() {});
                              },
                              dropdownMenuEntries: [
                                for (int i = 0; i < trailList!.length; i++)
                                  DropdownMenuEntry<String>(
                                    value: trailList![i].trail_id!,
                                    label: trailList![i].trail_name!,
                                  ),
                              ],
                            ),
                          )
                        : SizedBox(),
                showAssignedUser
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text("Assigned To",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorParser().hexToColor(RuntimeStorage
                                      .instance
                                      .clientTheme!
                                      .body_text_color!))),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 32,
                              enableSearch: false,
                              inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              requestFocusOnTap: false,
                              label: const Text('Select'),
                              initialSelection: selectedAssignedTo,
                              onSelected: (String? userId) {
                                selectedAssignedTo = userId;
                                log("Selected Assigned To => $userId");
                                setState(() {});
                              },
                              dropdownMenuEntries: [
                                for (int i = 0; i < userListing!.length; i++)
                                  DropdownMenuEntry<String>(
                                    value: userListing![i].id!,
                                    label: userListing![i].name!,
                                  ),
                              ],
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
                const SizedBox(
                  height: 16,
                ),

                /** Status **/
                showStatus
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage
                                    .instance.clientTheme!.body_text_color!)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    status = FilterStatus.Resolved;
                                    widget.params!.status = status.name;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    color: status == FilterStatus.Resolved
                                        ? ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: status == FilterStatus.Resolved
                                          ? ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!)
                                          : Colors.grey),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    status = FilterStatus.Pending;
                                    widget.params!.status = status.name;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    color: status != FilterStatus.Pending
                                        ? Colors.grey
                                        : ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                  ),
                                ),
                                child: Text(
                                  "Pending",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: status != FilterStatus.Pending
                                          ? Colors.grey
                                          : ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : SizedBox(),

                /** Keyword **/

                showKeyword
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Keyword",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage
                                    .instance.clientTheme!.body_text_color!)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                    controller: keywordController,
                                    style: const TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      prefixIcon: SvgPicture.asset(
                                        "assets/images/comments/Search.svg",
                                        colorFilter: ColorFilter.mode(
                                            ColorParser().hexToColor(
                                                RuntimeStorage
                                                    .instance
                                                    .clientTheme!
                                                    .top_title_background_color!),
                                            BlendMode.srcIn),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minHeight: 24, minWidth: 60),
                                      prefixIconColor: ColorParser().hexToColor(
                                          RuntimeStorage.instance.clientTheme!
                                              .top_title_background_color!),
                                      labelText: ' Search',
                                      // labelText: widget.selectedLanguage == "1"
                                      //     ? "Search".language(context)
                                      //     : "Search",
                                      labelStyle: TextStyle(
                                          color: ColorParser()
                                              .hexToColor("#9E9E9E")),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      )
                    : SizedBox(),

                /** DATE FIELD **/

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorParser().hexToColor(RuntimeStorage
                                  .instance.clientTheme!.body_text_color!)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectStartDate(context);
                          },
                          child: Container(
                            height: 56,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorParser().hexToColor("#9E9E9E"),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "${selectedStartDate.day}-${selectedStartDate.month}-${selectedStartDate.year}"
                                        .split(' ')[0],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Resources.colors.hfText)),
                                SizedBox(
                                  width: 16,
                                ),
                                SvgPicture.asset(
                                    "assets/images/comments/datepicker.svg"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Date",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorParser().hexToColor(RuntimeStorage
                                  .instance.clientTheme!.body_text_color!)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectEndDate(context);
                          },
                          child: Container(
                            height: 56,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorParser().hexToColor("#9E9E9E"),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "${selectedEndDate.day}-${selectedEndDate.month}-${selectedEndDate.year}"
                                        .split(' ')[0],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Resources.colors.hfText)),
                                SizedBox(
                                  width: 16,
                                ),
                                SvgPicture.asset(
                                    "assets/images/comments/datepicker.svg"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                /** Type **/
                formType
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorParser().hexToColor(RuntimeStorage
                                    .instance.clientTheme!.body_text_color!)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    functionType = FilterFunctionType.Website;
                                    widget.params!.functionType =
                                        functionType.name;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    color: functionType ==
                                            FilterFunctionType.Website
                                        ? ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  "QR Code",
                                  style: TextStyle(
                                      color: functionType ==
                                              FilterFunctionType.Website
                                          ? ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!)
                                          : Colors.grey),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    functionType = FilterFunctionType.Mobile;
                                    widget.params!.functionType =
                                        functionType.name;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: BorderSide(
                                    color: functionType !=
                                            FilterFunctionType.Mobile
                                        ? Colors.grey
                                        : ColorParser().hexToColor(
                                            RuntimeStorage.instance.clientTheme!
                                                .top_title_background_color!),
                                  ),
                                ),
                                child: Text(
                                  "App",
                                  style: TextStyle(
                                      color: functionType !=
                                              FilterFunctionType.Mobile
                                          ? Colors.grey
                                          : ColorParser().hexToColor(
                                              RuntimeStorage
                                                  .instance
                                                  .clientTheme!
                                                  .top_title_background_color!)),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
                const SizedBox(
                  height: 36,
                ),
                /** submit button **/

                SizedBox(
                  height: 56,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      print("TO POST MAP ${widget.params!.toJson()}");

                      // bool showAssignedUser = false;
                      // bool showType = false;
                      // bool showStatus = false;
                      // bool showKeyword = false;
                      // bool formType = false;

                      switch (widget.page) {
                        case FilterPages.COMMENTS:
                          widget.params!.type = type.name;
                          widget.params!.main_park_id = selectedParkId;
                          widget.params!.status = status.name;
                          widget.params!.frm_keyword = keywordController.text;
                          widget.params!.popupDatepickerToDateSearch =
                              "${selectedEndDate.year}-${selectedEndDate.month}-${selectedEndDate.day}";
                          widget.params!.popupDatepickerFromDateSearch =
                              "${selectedStartDate.year}-${selectedStartDate.month}-${selectedStartDate.day}";
                          if (functionType != FilterFunctionType.None) {
                            widget.params!.functionType = functionType.name;
                          } else {
                            widget.params!.functionType = null;
                          }

                          break;
                        case FilterPages.ACTIVITY:
                          widget.params!.type = type.name;
                          widget.params!.main_park_id = selectedParkId;
                          widget.params!.popupDatepickerToDateSearch =
                              "${selectedEndDate.year}-${selectedEndDate.month}-${selectedEndDate.day}";
                          widget.params!.popupDatepickerFromDateSearch =
                              "${selectedStartDate.year}-${selectedStartDate.month}-${selectedStartDate.day}";
                          if (functionType != FilterFunctionType.None) {
                            widget.params!.functionType = functionType.name;
                          } else {
                            widget.params!.functionType = null;
                          }

                          break;
                        case FilterPages.STATUS:
                          widget.params!.type = type.name;
                          widget.params!.main_park_id = selectedParkId;
                          widget.params!.assignedTo = selectedAssignedTo;
                          widget.params!.status = status.name;
                          widget.params!.frm_keyword = keywordController.text;

                          widget.params!.popupDatepickerToDateSearch =
                              "${selectedEndDate.year}-${selectedEndDate.month}-${selectedEndDate.day}";
                          widget.params!.popupDatepickerFromDateSearch =
                              "${selectedStartDate.year}-${selectedStartDate.month}-${selectedStartDate.day}";
                          if (functionType != FilterFunctionType.None) {
                            widget.params!.functionType = functionType.name;
                          } else {
                            widget.params!.functionType = null;
                          }

                          break;
                      }

                      widget.filterData!(widget.params);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorParser().hexToColor(RuntimeStorage
                            .instance.clientTheme!.top_title_background_color!),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
