import 'package:contacts_app/utilities/call_types.dart';

extension CallTypesExtent on List<CallTypes>{
  CallTypes parse(String callTypeJson){
    CallTypes callType=CallTypes.OUT_CALL;
    for (var element in this) {
      if(element.toString()==callTypeJson){
       callType=element;
      }
    }
    return callType;
  }
}