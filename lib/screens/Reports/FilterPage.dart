import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../resources/resources.dart';

List<String> fieldOptions = ['Item 1','Item 2','Item 3',"Item 4"];
class FilterpageWidget extends StatefulWidget{


  gotoFilterPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (_) => FilterpageWidget()));
  }

  @override
  State<FilterpageWidget> createState() => _FilterpageWidgetState();

}

class _FilterpageWidgetState extends State<FilterpageWidget>{
  bool isSelected = true;
  bool isStatusSelected = true;
  bool isQrSelected = true;
  String? dropdownValueSelected = fieldOptions.first;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();


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

                      value: dropdownValueSelected,
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
                          dropdownValueSelected = value!;
                          // ListOfFeedbackDetails.first.value = value;
                          log("after ${dropdownValueSelected}");
                        });
                      }),
                ),
              ),
        
              SizedBox(height: 20,),
        
              /** Status **/
              Text("Status",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
        
              SizedBox(height: 5,),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        isStatusSelected = !isStatusSelected;
                      });
        
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isStatusSelected ? Resources.colors.buttonColorlight : Colors.grey,
                      ),
                    ),
                    child: Text("Completed",style: TextStyle(color: isStatusSelected ? Resources.colors.buttonColorlight : Colors.grey),),
                  ),
        
                  SizedBox(width: 20,),
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        isStatusSelected = !isStatusSelected;
                      });
        
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:isStatusSelected ?  Colors.grey : Resources.colors.buttonColorlight ,
                      ),
                    ),
                    child: Text("Pending",style: TextStyle(color:isStatusSelected ?  Colors.grey : Resources.colors.buttonColorlight ),),
                  )
                ],
              ),
        
              SizedBox(height: 20,),
              /** Keyword **/
        
              Text("Keyword",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
              SizedBox(height: 5,),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 50,
                      width: 400,
                      child: TextField(
                          onChanged: (value) {
                            // filterSearchResults(value);
                          },
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            prefixIcon: InkWell(
                                onTap: () {
                                  // FilterpageWidget().gotoFilterPage(
                                  //     context);
                                  // Navigator.of(context).push(_createRoute());
                                },
                                child: SvgPicture.asset(
                                    "assets/images/comments/Search.svg")),
                            prefixIconConstraints: BoxConstraints(
                                minHeight: 30, minWidth: 60),
                            prefixIconColor: ColorParser()
                                .hexToColor("#1A7C52"),
                            labelText: ' Search',
                            // labelText: widget.selectedLanguage == "1"
                            //     ? "Search".language(context)
                            //     : "Search",
                            labelStyle: TextStyle(
                                color: ColorParser().hexToColor(
                                    "#9E9E9E")),
        
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
        
                                ),
                                borderRadius: BorderRadius.circular(
                                    10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.grey,),
                                borderRadius: BorderRadius.circular(
                                    10)
                            ),
                          )),
                    ),
                  ),
        
                ],
              ),
              SizedBox(height: 20,),
        
              /** Date Picker **/
                SizedBox(height: 5,),
        
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
              /** Type **/
              Text("Type",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Resources.colors.hfText),),
        
              SizedBox(height: 5,),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        isQrSelected = !isQrSelected;
                      });
        
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isQrSelected ? Resources.colors.buttonColorlight : Colors.grey,
                      ),
                    ),
                    child: Text("QR Code",style: TextStyle(color: isQrSelected ? Resources.colors.buttonColorlight : Colors.grey),),
                  ),
        
                  SizedBox(width: 20,),
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        isQrSelected = !isQrSelected;
                      });
        
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:isQrSelected ?  Colors.grey : Resources.colors.buttonColorlight ,
                      ),
                    ),
                    child: Text("App",style: TextStyle(color:isQrSelected ?  Colors.grey : Resources.colors.buttonColorlight ),),
                  )
                ],
              ),
        
              SizedBox(height: 20,),
              /** submit button **/
        
              SizedBox(
                height: 40,
                width: 120,
                child: ElevatedButton(
        
                  onPressed: () {
                    // AddLocation().gotoAddLocation(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Resources.colors.buttonColorDark,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
        
                ),
              ),
        
        
            ],
          ),
        ),
      ),
    );
  }
}