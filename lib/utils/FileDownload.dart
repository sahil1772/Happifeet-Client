import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDownload {
  Dio dio = Dio();
  bool isSuccess = false;

  void startDownloading(BuildContext context, final Function okCallback,
      {required String fileName, required String filePath}) async {
    String path = await _getFilePath(fileName);

    try {
      await dio.download(
        filePath,
        path,
        onReceiveProgress: (recivedBytes, totalBytes) {
          log("DOWNLOAD PROGRESS ", error: (recivedBytes / totalBytes));
          okCallback(recivedBytes, totalBytes);
        },
        deleteOnError: true,
      ).then((_) {
        isSuccess = true;
      });
    } catch (e) {
      log("Error occurred while downloading file => $e");
    }

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("File downloaded to your Downloads folder")));
      log("DOWNLOAD SUCCESSFUL $filePath -> $path");
      Navigator.pop(context);
    }
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }
}
