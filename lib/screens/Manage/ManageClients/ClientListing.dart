import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happifeet_client_app/network/ApiFactory.dart';
import 'package:happifeet_client_app/screens/Manage/ManageClients/AddClient.dart';

import '../../../components/ClientListingCard.dart';
import '../../../components/HappiFeetAppBar.dart';
import '../../../model/ClientUsers/ClientUserData.dart';
import '../../../storage/shared_preferences.dart';
import '../../../utils/ColorParser.dart';

Future? futureClientData;
class ClientListingWidget extends StatefulWidget{


  gotoClientListingPage(BuildContext context,Function? callback) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ClientListingWidget())).then((value) => callback!());



  }

  @override
  State<ClientListingWidget> createState() => _ClientListingWidgetState();

}

class _ClientListingWidgetState extends State<ClientListingWidget>{
  List<ClientUserData>? clientUserData;

  @override
  void initState() {
    // TODO: implement initState
    futureClientData = getClientUserData();
    super.initState();
  }

  Future<void> getClientUserData() async{
    var response = await ApiFactory().getClientService().getClientUserData("list_client_users", await SharedPref.instance.getUserId());
    clientUserData = response;
    log("CLIENT USER DATA ${clientUserData!.first.toJson()}");
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(

                        "List Assigned Client",
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration:  const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color:  Colors.white),
                  // color: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),

                    child: RefreshIndicator(
                      onRefresh: () => getClientUserData() ,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /** Search bar **/
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 26),
                            child: Row(
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
                                          prefixIcon: const Icon(Icons.search),
                                          prefixIconColor: ColorParser().hexToColor("#1A7C52"),
                                          labelText: 'Search',
                                          // labelText: widget.selectedLanguage == "1"
                                          //     ? "Search".language(context)
                                          //     : "Search",
                                          labelStyle: TextStyle(color: ColorParser().hexToColor("#9E9E9E")),

                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 1,

                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color:  Colors.grey,),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                        )),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          /**   listview builder     **/

                          /**  Client user Listing **/

                          FutureBuilder(
                            future: futureClientData,
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if(snapshot.connectionState == ConnectionState.done){
                                return Flexible(
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,

                                    physics: const ScrollPhysics(),
                                    itemCount: clientUserData!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return  ClientListingCard(clientUserData: clientUserData![index]);
                                    }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 8,); },
                                  ),
                                );
                              }else if(snapshot.connectionState == ConnectionState.waiting){
                                return CircularProgressIndicator();
                              }else{
                                return Text("Something Went Wrong");
                              }

                            },

                          ),
                          const SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
      bottomSheet: Container(
        height: 50,
        color: ColorParser().hexToColor("#1A7C52"),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(

                onPressed: () {
                  AddClientWidget().gotoAddClientPage(context,null,false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: ColorParser().hexToColor("#1A7C52"),elevation: 0),
                child: const Text("Add Client",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),

              ),
            ),
          ],
        ),
      ),
    );
  }
}