import 'package:flutter/material.dart';
import 'package:happifeet_client_app/utils/FileDownload.dart';

class DownloadProgressDialog extends StatefulWidget {
   DownloadProgressDialog({super.key,required this.filePath});

   String filePath;

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double progress = 0.0;

  @override
  void initState() {
    _startDownload(filePath: widget.filePath);
    super.initState();
  }

  void _startDownload({required String filePath}) {
    String filename = filePath.split("/").last;
    FileDownload().startDownloading(context, (recivedBytes, totalBytes) {
      setState(() {
        progress = recivedBytes / totalBytes;
      });
    },fileName: filename,filePath: filePath);
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();
    return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "Downloading",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
              minHeight: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "$downloadingProgress %",
              ),
            )
          ],
        ));
  }
}