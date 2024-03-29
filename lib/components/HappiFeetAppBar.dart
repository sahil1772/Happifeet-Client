import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happifeet_client_app/storage/runtime_storage.dart';
import 'package:happifeet_client_app/utils/ColorParser.dart';

class HappiFeetAppBar {
  bool IsDashboard;

  // bool IsThankYou;
  // bool IsCityList;

  bool isCitiyList;
  Function? callback;

  HappiFeetAppBar(
      {required this.IsDashboard, required this.isCitiyList, this.callback});

  getAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      // automaticallyImplyLeading: IsDashboard,
      leadingWidth: IsDashboard ? 77 : 110,

      leading:
          // Padding(
          //    padding: const EdgeInsets.only(left: 16),
          //    // child: SvgPicture.asset("assets/images/appBar/npp-logo.svg"),
          //    child: Image.network(RuntimeStorage.instance.clientTheme!.logo!,
          //        width: 45, height: 45),
          //    // child: Image.asset("assets/images/appBar/city_jpg.jpg"),
          //    // child: Image.network(SharedPref.instance.getCityTheme().logo!)
          //  )
          Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            !IsDashboard
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      // callback!();
                    },
                    child: SvgPicture.asset(
                      "assets/images/appBar/back.svg",
                      colorFilter: ColorFilter.mode(
                          ColorParser().hexToColor(RuntimeStorage.instance
                              .clientTheme!.top_title_background_color!),
                          BlendMode.srcIn),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              width: 10,
            ),
            // SvgPicture.asset("assets/images/appBar/npp-logo.svg"),
            Image.network(RuntimeStorage.instance.clientTheme!.logo!,
                width: 45, height: 45),
          ],
        ),
        // child: Image.asset("assets/images/appBar/city_jpg.jpg"),
        // child: Image.network(SharedPref.instance.getCityTheme().logo!)
      ),

      actions: [
        isCitiyList
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(right: 16),
                // child: Image.asset("assets/images/appBar/logo_jpg.jpg"),
                child: SvgPicture.asset("assets/images/appBar/HFLogo.svg",
                    width: 45, height: 45),
              ),
      ],
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: !isCitiyList
          ? const SizedBox()
          : SvgPicture.asset("assets/images/appBar/HFLogo.svg",
              width: 45, height: 45),
      // title: SvgPicture.asset("assets/images/appBar/HFLogo.svg"),
    );
  }
}
// SvgPicture.asset("assets/images/combineLogo.svg",height:35,width: 35,)

// https://www.keephappifeet.com/images/logo.png

// Image.network("https://www.keephappifeet.com/images/logo.png",height: 60,width: 60,)
