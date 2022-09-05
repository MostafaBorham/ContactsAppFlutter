import 'package:contacts_app/models/call_model.dart';

extension CallModelExtent on List<CallModel>{
  List<CallModel> search(String key){
    List<CallModel> tmp=[];
    forEach((call) {
      if(call.callNumber==key){
        tmp.add(call);
      }
    });
    return tmp;
  }

  CallModel? getCall(String key){
    CallModel? callResult;
    forEach((call) {
      if(call.callNumber==key){
        callResult=call;
      }
    });
    return callResult;
  }

  List<CallModel> removeAll(CallModel callModel){
    List<CallModel> tmp=[];
    forEach((call) {
      if(call.callNumber!=callModel.callNumber){
        tmp.add(call);
      }
    });
    return tmp;
  }
}