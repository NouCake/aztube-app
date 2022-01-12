import 'dart:developer';

import 'package:aztube/api/downloaddata.dart';
import 'package:aztube/files/downloadsmodel.dart';
import 'package:aztube/files/filemanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Download extends StatefulWidget {

  const Download({Key? key, required this.name, required this.video, required this.cache}) : super(key: key);

  final DownloadCache cache;
  final DownloadData video;
  final String name;

  @override
  State<StatefulWidget> createState() {
    return DownloadState();
  }

}

class DownloadState extends State<Download> {

  bool downloading = false;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    widget.video.downloading.listen((data) {
      setState(() {
        progress = data;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    Widget trailing = IconButton(
      onPressed: () {
        startDownload();
      },
      icon: Icon(widget.video.downloaded  ? Icons.download_done : Icons.download),
      color: Colors.black,
    );
    if(downloading){
      trailing = CircularProgressIndicator(color: Colors.black, value: progress/100,);
    }
    return Column(children: [
      ListTile(
          title: Text(widget.name),
          trailing: trailing ),
      const Divider()
    ]);
  }

  void startDownload(){
    if(!downloading && !widget.video.downloaded){
      setState(() {
        downloading = true;
      });
      downloadVideo(widget.video);
    }
  }

  void downloadVideo(DownloadData video) async {
    const platform = MethodChannel("de.aztube.aztube_app/youtube");
    Map<String, dynamic> args = {
      "videoId": video.videoID,
      "quality": video.quality
    };

    final bool result = await platform.invokeMethod("downloadVideo", args);
    if(!result){
      setState(() {
        downloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating),
      );
    }else{
      widget.cache.queue.remove(widget.video);
      widget.video.downloaded = true;
      widget.cache.downloaded.add(widget.video);
      FileManager().saveDownloads(widget.cache);
      setState(() {
        downloading = false;
      });
    }
  }

}