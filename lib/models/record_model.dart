class RecordModel {
  String name;
  String url;
  String date;
  String time;

  RecordModel(
      {required this.name,
      required this.url,
      required this.date,
      required this.time});

  factory RecordModel.fromJson(Map<String, dynamic> json) =>
      RecordModel(name: json['name'], url: json['url'], date: json['date'], time: json['time']);

  Map<String,dynamic> toJson()=>{
  'name':name,
  'url':url,
  'date':date,
  'time':time
  };
}
