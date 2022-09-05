import 'package:contacts_app/utilities/call_types.dart';
import 'package:contacts_app/utilities/sim_number.dart';

extension StringExtent on String{
  String clearLastChar(){
    return substring(0,length-1);
  }

  CallTypes callTypeFromString(){
    int index=0;
    for(int i=0;i<CallTypes.values.length;i++){
      if(CallTypes.values[i].toString()==this){
        index=i;
        break;
      }
    }
    return CallTypes.values[index];
  }
  SimNumber simNumberFromString(){
    int index=0;
    for(int i=0;i<SimNumber.values.length;i++){
      if(SimNumber.values[i].toString()==this){
        index=i;
        break;
      }
    }
    return SimNumber.values[index];
  }
  String get last=>isEmpty? this : this[length-1];
}