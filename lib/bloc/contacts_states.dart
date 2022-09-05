import 'package:contacts_app/models/call_model.dart';

abstract class ContactsState{}

class InitContactsState extends ContactsState{}
class NoSearchHistoryContactsState extends ContactsState{}
class NoSearchResultsContactsState extends ContactsState{}
class AllSuggestionsContactsState extends ContactsState{}
class AddCallState extends ContactsState{}
class ChangeDialNumberState extends ContactsState{}
class ChangeDialShowState extends ContactsState{}
class DeleteCallState extends ContactsState{}
class AllContactsResultContactsState extends ContactsState{}
class FilterContactsState extends ContactsState{
  List<CallModel> calls;

  FilterContactsState({required this.calls});
}