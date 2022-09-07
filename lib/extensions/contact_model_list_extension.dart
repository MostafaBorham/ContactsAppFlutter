import 'package:contacts_app/models/contact_model.dart';

extension ContactModelExtent on List<ContactModel>{
  List<ContactModel> search(String key){
    List<ContactModel> tmp=[];
    forEach((contact) {
      if(contact.name.startsWith(key) || contact.phone.startsWith(key)){
        tmp.add(contact);
      }
    });
    return tmp;
  }
  ContactModel? searchByNumber(String number){
    ContactModel? tmpContact;
    forEach((contact) {
      if(contact.phone==number){
        tmpContact=contact;
      }
    });
    return tmpContact;
  }
  ContactModel? searchByName(String name){
    ContactModel? tmpContact;
    forEach((contact) {
      if(contact.name==name){
        tmpContact=contact;
      }
    });
    return tmpContact;
  }
}