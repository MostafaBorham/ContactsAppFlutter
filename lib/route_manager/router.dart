import 'package:contacts_app/models/call_model.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/models/record_model.dart';
import 'package:contacts_app/pages/caller_details/call_record_page.dart';
import 'package:contacts_app/pages/caller_details/caller_details_page.dart';
import 'package:contacts_app/pages/create_contact/create_contact_page.dart';
import 'package:contacts_app/pages/home/home_page.dart';
import 'package:contacts_app/pages/search/search_page.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:contacts_app/utilities/user_types.dart';
import 'package:flutter/cupertino.dart';

Route<dynamic> onGenerate(RouteSettings settings){
  switch(settings.name){
    case AppRoutes.homePageRoute:
      {
        return CupertinoPageRoute(builder: (_)=>const HomePage());
      }
    case AppRoutes.searchPageRoute:
      {
        return CupertinoPageRoute(builder: (_)=>const SearchPage());
      }
    case AppRoutes.createContactPageRoute:
      {
        Widget widget=const CreateContactPage();
        if(settings.arguments!=null){
          final List<dynamic> args=settings.arguments as List<dynamic>;
          final UserTypes user=args[0] as UserTypes;
          final ContactModel contact=args[1] as ContactModel;
          widget=CreateContactPage(userType: user,contactModel: contact);
        }
        return CupertinoPageRoute(builder: (_)=>widget);
      }
    case AppRoutes.callRecordPageRoute:
      {
        final List<RecordModel> records=settings.arguments as List<RecordModel>;
        return CupertinoPageRoute(builder: (_)=>CallRecordPage(records: records,));
      }
    case AppRoutes.callerDetailsPageRoute:{
      final CallModel callModel=settings.arguments as CallModel;
      return CupertinoPageRoute(builder: (_)=> CallerDetailsPage(callerInfo: callModel,));
    }
    default :{
      return CupertinoPageRoute(builder: (_)=>Container());
    }
  }
}