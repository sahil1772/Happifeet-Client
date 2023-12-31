import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HappiFeetAppBar {
  bool IsDashboard;
  // bool IsThankYou;
  // bool IsCityList;

  bool isCitiyList;

  HappiFeetAppBar({required this.IsDashboard,  required this.isCitiyList});

  getAppBar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
      // automaticallyImplyLeading: IsDashboard,
      leadingWidth: 77,

      leading: !isCitiyList ?  Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset("assets/images/appBar/npp-logo.svg"),
          // child: Image.asset("assets/images/appBar/city_jpg.jpg"),
          // child: Image.network(SharedPref.instance.getCityTheme().logo!)
      ) : const SizedBox(),


      actions: [

        isCitiyList ?
        const SizedBox() :Padding(
          padding: const EdgeInsets.only(right: 16),
          // child: Image.asset("assets/images/appBar/logo_jpg.jpg"),
          child: SvgPicture.asset("assets/images/appBar/HFLogo.svg",width: 45,height: 45),
        ),


      ],
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: !isCitiyList ? const SizedBox() : SvgPicture.asset("assets/images/appBar/HFLogo.svg",width: 45,height: 45),
      // title: SvgPicture.asset("assets/images/appBar/HFLogo.svg"),
    );
  }
}
// SvgPicture.asset("assets/images/combineLogo.svg",height:35,width: 35,)

// https://www.keephappifeet.com/images/logo.png

// Image.network("https://www.keephappifeet.com/images/logo.png",height: 60,width: 60,)