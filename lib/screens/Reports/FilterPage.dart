import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/model/AssignedUsers/AssignedUserData.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/storage/shared_preferences.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../../resources/resources.dart';

List<String> fieldOptions = ['Item 1', 'Item 2', 'Item 3', "Item 4"];

class FilterPage extends StatefulWidget {
  FilterPage({super.key, this.params, this.filterData, required this.showAssignedUser});

  FilterMap? params;
  Function? filterData;
  bool showAssignedUser = false;



  @override
  State<FilterPage> createState() => _FilterPageState();
}

enum FilterType { Trail, Park }

enum FilterStatus { UnAssigned, Completed, Pending }

enum FilterFunctionType { Website, Mobile, None }

class _FilterPageState extends State<FilterPage> {
  FilterType type = FilterType.Park;
  FilterStatus status = FilterStatus.Completed;
  FilterFunctionType functionType = FilterFunctionType.None;
  String? dropdownValueSelected = fieldOptions.first;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  Map<String, dynamic> parks = {};
  String? selectedParkId = "";
  String? selectedAssignedTo = "";

  List<AssignedUserData>? userListing = [];

  TextEditingController keywordController = TextEditingController();

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
      setState(() {});
    });

    if (widget.showAssignedUser) getAssignedUserListing();

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
                          backgroundColor: Resources.colors.buttonColorlight,
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
                /** Trail **/
                Text(
                  "Type",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Resources.colors.hfText),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          type = FilterType.Trail;
                          widget.params!.type = type.name;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                          color: type == FilterType.Trail
                              ? Resources.colors.buttonColorlight
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        "Trail",
                        style: TextStyle(
                            color: type == FilterType.Trail
                                ? Resources.colors.buttonColorlight
                                : Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
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
                              : Resources.colors.buttonColorlight,
                        ),
                      ),
                      child: Text(
                        "Park",
                        style: TextStyle(
                            color: type != FilterType.Park
                                ? Colors.grey
                                : Resources.colors.buttonColorlight),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),

                /** Main location **/
                Text("Main Location",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Resources.colors.hfText)),
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
                        ),
                    ],
                  ),
                ),
                widget.showAssignedUser!
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text("Assigned To",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Resources.colors.hfText)),
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
                Text(
                  "Status",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Resources.colors.hfText),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          status = FilterStatus.Completed;
                          widget.params!.status = status.name;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                          color: status == FilterStatus.Completed
                              ? Resources.colors.buttonColorlight
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                            color: status == FilterStatus.Completed
                                ? Resources.colors.buttonColorlight
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
                              : Resources.colors.buttonColorlight,
                        ),
                      ),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                            color: status != FilterStatus.Pending
                                ? Colors.grey
                                : Resources.colors.buttonColorlight),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                /** Keyword **/

                Text(
                  "Keyword",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Resources.colors.hfText),
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
                            ),
                            prefixIconConstraints: const BoxConstraints(
                                minHeight: 24, minWidth: 60),
                            prefixIconColor:
                                ColorParser().hexToColor("#1A7C52"),
                            labelText: ' Search',
                            // labelText: widget.selectedLanguage == "1"
                            //     ? "Search".language(context)
                            //     : "Search",
                            labelStyle: TextStyle(
                                color: ColorParser().hexToColor("#9E9E9E")),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
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
                              fontWeight: FontWeight.w500,
                              color: Resources.colors.hfText),
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
                              fontWeight: FontWeight.w500,
                              color: Resources.colors.hfText),
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
                Text(
                  "Type",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Resources.colors.hfText),
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
                          widget.params!.functionType = functionType.name;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                          color: functionType == FilterFunctionType.Website
                              ? Resources.colors.buttonColorlight
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        "QR Code",
                        style: TextStyle(
                            color: functionType == FilterFunctionType.Website
                                ? Resources.colors.buttonColorlight
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
                          widget.params!.functionType = functionType.name;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                          color: functionType != FilterFunctionType.Mobile
                              ? Colors.grey
                              : Resources.colors.buttonColorlight,
                        ),
                      ),
                      child: Text(
                        "App",
                        style: TextStyle(
                            color: functionType != FilterFunctionType.Mobile
                                ? Colors.grey
                                : Resources.colors.buttonColorlight),
                      ),
                    )
                  ],
                ),
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

                      if (functionType != FilterFunctionType.None) {
                        widget.params!.functionType = functionType.name;
                      } else {
                        widget.params!.functionType = null;
                      }

                      widget.params!.status = status.name;
                      widget.params!.type = type.name;
                      widget.params!.frm_keyword = keywordController.text;
                      widget.params!.main_park_id = selectedParkId;
                      widget.params!.assignedTo = selectedAssignedTo;
                      widget.params!.popupDatepickerToDateSearch =
                          "${selectedEndDate.year}-${selectedEndDate.month}-${selectedEndDate.day}";
                      widget.params!.popupDatepickerFromDateSearch =
                          "${selectedStartDate.year}-${selectedStartDate.month}-${selectedStartDate.day}";

                      widget.filterData!(widget.params);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Resources.colors.buttonColorDark,
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
