import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/model/FilterMap.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

import '../../resources/resources.dart';

List<String> fieldOptions = ['Item 1', 'Item 2', 'Item 3', "Item 4"];

class CommentsFilterpageWidget extends StatefulWidget {
  CommentsFilterpageWidget({super.key, this.params, this.filterData});

  FilterMap? params;
  Function? filterData;

  gotoFilterPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => CommentsFilterpageWidget()));
  }

  @override
  State<CommentsFilterpageWidget> createState() =>
      _CommentsFilterpageWidgetState();
}

enum FilterType { Trail, Park }

enum FilterStatus { Completed, Pending }

enum FilterFunctionType { QR, App, None }

class _CommentsFilterpageWidgetState extends State<CommentsFilterpageWidget> {
  FilterType type = FilterType.Park;
  FilterStatus status = FilterStatus.Completed;
  FilterFunctionType functionType = FilterFunctionType.None;
  String? dropdownValueSelected = fieldOptions.first;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  TextEditingController keywordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    if (widget.params == null) {
      widget.params = FilterMap();
    } else {
      type = FilterType.values.byName(widget.params!.type!);
      status = FilterStatus.values.byName(widget.params!.status!);
      if (widget.params!.functionType != null) {
        functionType =
            FilterFunctionType.values.byName(widget.params!.functionType!);
      }
      selectedStartDate = DateFormat("yyyy-MM-dd")
          .parse(widget.params!.popupDatepickerFromDateSearch!);
      selectedEndDate = DateFormat("yyyy-MM-dd")
          .parse(widget.params!.popupDatepickerToDateSearch!);
      keywordController.text = widget.params!.frm_keyword!;
    }

    super.initState();
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
                  child: DropdownButtonFormField(
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      value: dropdownValueSelected,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 30,
                      items:
                          fieldOptions.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Resources.colors.hfText)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          log("before ${value}");
                          dropdownValueSelected = value!;
                          // ListOfFeedbackDetails.first.value = value;
                          log("after ${dropdownValueSelected}");
                        });
                      }),
                ),
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
                          functionType = FilterFunctionType.QR;
                          widget.params!.functionType = functionType.name;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                          color: functionType == FilterFunctionType.QR
                              ? Resources.colors.buttonColorlight
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        "QR Code",
                        style: TextStyle(
                            color: functionType == FilterFunctionType.QR
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
                          functionType = FilterFunctionType.App;
                          widget.params!.functionType = functionType.name;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(
                          color: functionType != FilterFunctionType.App
                              ? Colors.grey
                              : Resources.colors.buttonColorlight,
                        ),
                      ),
                      child: Text(
                        "App",
                        style: TextStyle(
                            color: functionType != FilterFunctionType.App
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
                      widget.params!.main_park_id = "";
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
