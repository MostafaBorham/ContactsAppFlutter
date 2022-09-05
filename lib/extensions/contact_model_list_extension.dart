import 'package:contacts_app/models/contact_model.dart';

extension ContactModelExtent on List<ContactModel>{
  List<ContactModel> search(String key){
    List<ContactModel> tmp=[];
    forEach((contact) {
      if(contact.name.startsWith(key) || contact.number.startsWith(key)){
        tmp.add(contact);
      }
    });
    return tmp;
  }
  ContactModel? searchByNumber(String number){
    ContactModel? tmpContact;
    forEach((contact) {
      if(contact.number==number){
        tmpContact=contact;
      }
    });
    return tmpContact;
  }
}