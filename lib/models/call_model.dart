import 'dart:convert';
import 'dart:io';

import 'package:contacts_app/extensions/call_types_extension.dart';
import 'package:contacts_app/extensions/sim_number_extension.dart';
import 'package:contacts_app/extensions/string_extension.dart';
import 'package:contacts_app/models/record_model.dart';
import 'package:contacts_app/utilities/sim_number.dart';

import '../utilities/call_types.dart';

class CallModel {
  CallTypes callType;
  String callNumber;
  String? callerName;
  String time;
  String period;
  bool isHD;
  SimNumber simNumber;
  List<RecordModel>? records;

  CallModel(
      {required this.callType,
      required this.callNumber,
      required this.time,
      required this.isHD,
      required this.simNumber,
      required this.period,
      this.callerName,
      this.records});

  factory CallModel.fromJson(Map<String, dynamic> map) {
    return CallModel(
      callNumber: map['callNumber'],
      callerName: map['callerName'],
      callType: CallTypes.values.parse(map['callType']),
      time: map['time'],
      period: map['period'],
      isHD: map['isHD']==0?false : true,
      simNumber: SimNumber.values.parse(map['simNumber']),
      records: json.decode(map['records'])??[]
  );
  }

  Map<String,dynamic> toJson()=>{
  'callNumber' : callNumber,
  'callerName' : callerName,
  'callType' : callType.toString(),
  'time' : time,
  'period' : period,
  'isHD' : isHD?1:0,
  'simNumber' : simNumber.toString(),
  'records' : json.encode(records?.map((e) => e.toJson()).toList())
  };

}

/*
json['records'].map((e) => RecordModel.fromJson(e)).toList()
SimNumber.values.firstWhere((e) => e.toString()=='SimNumber.${json['simNumber']}'),*/
