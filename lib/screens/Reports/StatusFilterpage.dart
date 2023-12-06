import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/resources.dart';
import '../../utils/ColorParser.dart';

List<String> fieldOptions = ['Item 1','Item 2','Item 3',"Item 4"];
class ButtonLabelAndFunction {
  String label;
  Function function;
  ButtonLabelAndFunction({required this.label, required this.function});
}
class StatusFilterpageWidget extends StatefulWidget{

  gotoStatusFilterPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => StatusFilterpageWidget() ));
  }

  @override
  State<StatusFilterpageWidget> createState() => _StatusFilterpageWidgetState();
  
}

class _StatusFilterpageWidgetState extends State<StatusFilterpageWidget>{
  List<ButtonLabelAndFunction> btnLbelsAndFunctions = [
    ButtonLabelAndFunction(
        label: "Unassigned",
        function: () {
          // your function for filtering by age
        }),
    ButtonLabelAndFunction(
        label: "Resolved",
        function: () {
          // your function for filtering by gender
        }),
    ButtonLabelAndFunction(
        label: "Pending",
        function: () {
          // your function for filtering by location
        }),
  ];
  int activeBtnIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      if(picked.isAfter(endDate)){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Start date must be before end date")));
      }else{
        setState(() {
          startDate = picked;
        });
      }

    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      if(picked.isBefore(startDate)){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("End date must be after start date")));
      }else{
        setState(() {
          endDate = picked;
        });
      }

    }
  }


  bool isSelected = true;
  bool isStatusSelected = true;
  bool isQrSelected = true;
  String? mainLocationDropdownValue = fieldOptions.first;
  String? assignedToDropdownValue = fieldOptions.first;
  String? assignedByDropdownValue = fieldOptions.first;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(

                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Resources.colors.buttonColorlight,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                      child: Row(


                        children: [
                          SvgPicture.asset("assets/images/comments/close.svg"),
                          SizedBox(width: 10,),
                          Text("Close",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                        ],
                      ),

                    ),
                  ),
                ],
              ),
              /** Trail **/
              Text("Type",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),

              SizedBox(height: 5,),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        isSelected = !isSelected;
                      });

                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isSelected ? Resources.colors.buttonColorlight : Colors.grey,
                      ),
                    ),
                    child: Text("Trail",style: TextStyle(color: isSelected ? Resources.colors.buttonColorlight : Colors.grey),),
                  ),

                  SizedBox(width: 20,),
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        isSelected = !isSelected;
                      });

                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:isSelected ?  Colors.grey : Resources.colors.buttonColorlight ,
                      ),
                    ),
                    child: Text("Park",style: TextStyle(color:isSelected ?  Colors.grey : Resources.colors.buttonColorlight ),),
                  )
                ],
              ),
              SizedBox(height: 20,),

              /** Main location **/
              Text("Main Location",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
              const SizedBox(height: 5,),
              Container(
                child: SizedBox(
                  height: 60,
                  child: DropdownButtonFormField(
                      dropdownColor: Colors.white,

                      // isDense: true,
                      //   isExpanded: true,
                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius: BorderRadius.all(Radius.circular(15)),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),

                      value: mainLocationDropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 30,


                      items: fieldOptions.map<DropdownMenuItem<String>>((value) {

                        return DropdownMenuItem<String>(

                          value: value,
                          child: Text(value,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          log("before ${value}");
                          mainLocationDropdownValue = value!;
                          // ListOfFeedbackDetails.first.value = value;
                          log("after ${mainLocationDropdownValue}");
                        });
                      }),
                ),
              ),

              SizedBox(height: 20,),


              /** Assigned To **/
              Text("Assigned To",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
              const SizedBox(height: 5,),
              Container(
                child: SizedBox(
                  height: 60,
                  child: DropdownButtonFormField(
                      dropdownColor: Colors.white,

                      // isDense: true,
                      //   isExpanded: true,
                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius: BorderRadius.all(Radius.circular(15)),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),

                      value: assignedToDropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 30,


                      items: fieldOptions.map<DropdownMenuItem<String>>((value) {

                        return DropdownMenuItem<String>(

                          value: value,
                          child: Text(value,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          log("before ${value}");
                          assignedToDropdownValue = value!;
                          // ListOfFeedbackDetails.first.value = value;
                          log("after ${assignedToDropdownValue}");
                        });
                      }),
                ),
              ),

              SizedBox(height: 20,),

              /** Assigned By **/
              Text("Assigned By",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
              const SizedBox(height: 5,),
              Container(
                child: SizedBox(
                  height: 60,
                  child: DropdownButtonFormField(
                      dropdownColor: Colors.white,

                      // isDense: true,
                      //   isExpanded: true,
                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius: BorderRadius.all(Radius.circular(15)),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorParser().hexToColor("#D7D7D7")),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),

                      value: assignedByDropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 30,


                      items: fieldOptions.map<DropdownMenuItem<String>>((value) {

                        return DropdownMenuItem<String>(

                          value: value,
                          child: Text(value,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          log("before ${value}");
                          assignedByDropdownValue = value!;
                          // ListOfFeedbackDetails.first.value = value;
                          log("after ${assignedByDropdownValue}");
                        });
                      }),
                ),
              ),

              SizedBox(height: 20,),
              /** Date Picker **/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      _selectStartDate(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Start Date",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
                        const SizedBox(height: 5,),
                        Container(
                          height: 40,
                          width: 155,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorParser().hexToColor("#9E9E9E"),),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("${startDate.day}-${startDate.month}-${startDate.year}".split(' ')[0],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                              SvgPicture.asset("assets/images/comments/datepicker.svg"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("End Date",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
                      const SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          _selectEndDate(context);
                        },
                        child: Container(
                          height: 40,
                          width: 155,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorParser().hexToColor("#9E9E9E"),),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("${endDate.day}-${endDate.month}-${endDate.year}".split(' ')[0],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText)),
                              SvgPicture.asset("assets/images/comments/datepicker.svg"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20,),
              /** Status **/
              Text("Status",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
              const SizedBox(height: 5,),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                    itemCount: btnLbelsAndFunctions.length,
                    itemBuilder: (context, index){
                      return OutlinedButton(
                        onPressed: (){
                          setState(() {
                            activeBtnIndex = index;

                          });

                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: activeBtnIndex == index ? Resources.colors.buttonColorlight : Colors.grey ,
                          ),
                        ),
                        child: Text(btnLbelsAndFunctions.elementAt(index).label,style: TextStyle(color:activeBtnIndex == index ? Resources.colors.buttonColorlight :  Colors.grey ),),
                      );
                    }, separatorBuilder: (BuildContext context, int index) { return SizedBox(width: 10); },),
              ),





            ],
          ),
        ),
      ),
    );
  }
}

