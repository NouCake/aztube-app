import 'package:aztube/api/downloaddata.dart';

class DownloadCache{

  List<DownloadData> queue = [];
  List<DownloadData> downloaded = [];

  DownloadCache();

  List<DownloadData> getAll(){
    List<DownloadData> all = [];

    all.addAll(queue);
    all.addAll(downloaded);

    return all;
  }

  static DownloadCache fromJson(Map<String, dynamic> json){
      DownloadCache cache = DownloadCache();
      cache.queue = convertBack(json['queue']);
      cache.downloaded = convertBack(json['downloaded']);
      return cache;
  }

  Map<String, dynamic> toJson() => {
    'queue': convertTo(queue),
    'downloaded': convertTo(downloaded)
  };

  List<dynamic> convertTo(List<DownloadData> list){
    List<dynamic> response = [];
    for (var element in list) {
      response.add(element.toJson());
    }
    return response;
  }

  static List<DownloadData> convertBack(List<dynamic> list){
    List<DownloadData> response = [];
    for (var element in list) {
      response.add(DownloadData.fromJson(element));
    }
    return response;
  }

}