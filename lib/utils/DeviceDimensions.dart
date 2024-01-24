import 'package:flutter/material.dart';
import 'package:happifeet_client_app/components/HappiFeetAppBar.dart';

class DeviceDimensions {
  // static double HEADER_HEIGHT = 4;
  static double BOTTOMSHEET_TOP_MARGIN = 25;

  static Size getDeviceInfo(BuildContext context) {
    // -- Fetch Device Dimensions
    return MediaQuery.of(context).size;
  }

  static double getDeviceHeight(BuildContext context) {
    // -- Fetch Device Height from function --> getDeviceInfo
    return getDeviceInfo(context).height;
  }

  static double getDeviceWidth(BuildContext context) {
    // -- Fetch Device Width from function --> getDeviceInfo
    return getDeviceInfo(context).width;
  }

  static double getHeaderSize(BuildContext context, double HEADER_HEIGHT) {
    // -- Calculate Header Size based Device Height and Area to Cover -> HEADER_HEIGHT = 5
    // (NOTE : HEADER_HEIGHT is used to calculate how much area to cover on screen (1/nth). for eg: 1/5th of the screen)
    return getDeviceHeight(context) / HEADER_HEIGHT;
  }

  static double getBottomSheetHeight(
      BuildContext context, double HEADER_HEIGHT) {
    // -- Calculate Height of bottom sheet by subtracting size of Header from the Device Height
    return getDeviceHeight(context) - getHeaderSize(context, HEADER_HEIGHT);
  }

  static double getBottomSheetMargin(
      BuildContext context, double HEADER_HEIGHT) {
    // -- Calculate top margin of bottom sheet
    return getHeaderSize(context, HEADER_HEIGHT) - BOTTOMSHEET_TOP_MARGIN;
  }

  static EdgeInsets getHeaderEdgeInsets(BuildContext context) {
    // -- Calculate top margin of bottom sheet
    return EdgeInsets.only(
        top: HappiFeetAppBar(isCitiyList: false, IsDashboard: false)
                .getAppBar(context)
                .preferredSize
                .height +
            MediaQuery.of(context).padding.top,
        bottom: DeviceDimensions.BOTTOMSHEET_TOP_MARGIN);
  }
}
