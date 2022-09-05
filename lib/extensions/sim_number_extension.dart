import 'package:contacts_app/utilities/sim_number.dart';

extension SimNumberExtent on List<SimNumber>{
  SimNumber parse(String simNumberJson){
    SimNumber simNumber=SimNumber.SIM_ONE;
    for (var element in this) {
      if(element.toString()==simNumberJson){
       simNumber=element;
      }
    }
    return simNumber;
  }
}