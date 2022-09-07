import 'package:contacts_app/bloc/contacts_states.dart';
import 'package:contacts_app/data/local/database_helper.dart';
import 'package:contacts_app/extensions/call_model_list_extension.dart';
import 'package:contacts_app/models/call_model.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/models/record_model.dart';
import 'package:contacts_app/utilities/call_types.dart';
import 'package:contacts_app/utilities/filter_types.dart';
import 'package:contacts_app/utilities/sim_number.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(InitContactsState());

  static ContactsCubit getInstance(context) => BlocProvider.of(context);

  static String dialNumber = '';
  static bool isDialShow = false;
  static FilterTypes currentFilter=FilterTypes.ALL;
  List<String> suggestions = ['aa', 'bb', 'cc'];

  List<CallModel> calls = [
/*    CallModel(
      callType: CallTypes.INCOME_CALL,
      callNumber: '01018184261',
      callerName: 'Mom',
      time: '1 hr.ago',
      isHD: true,
      records: [
        RecordModel(
            name: '322-323-record',
            url:
                'https://file-examples.com/storage/fe8bd9dfd063066d39cfd5a/2017/11/file_example_MP3_700KB.mp3',
            date: '25-8-2022',
            time: '7:50 pm'),
        RecordModel(
            name: '322-323-record',
            url:
                'https://file-examples.com/storage/fe8bd9dfd063066d39cfd5a/2017/11/file_example_MP3_700KB.mp3',
            date: '25-8-2022',
            time: '7:50 pm')
      ],
      simNumber: SimNumber.SIM_ONE,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.MISSED_CALL,
      callNumber: '23423424323223',
      time: 'yesterday',
      isHD: true,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '2345&&&&4323223',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),
    CallModel(
      callType: CallTypes.OUT_CALL,
      callNumber: '01005267056',
      callerName: 'Mostafa Borham',
      time: '14 july',
      isHD: false,
      simNumber: SimNumber.SIM_TWO,
      period: '1min 45s',
    ),*/
  ];

  List<ContactModel> contacts = [
  ];

  void filter(FilterTypes filterType) {
    currentFilter=filterType;
    switch (filterType) {
      case FilterTypes.ALL:
        {
          emit(FilterContactsState(calls: calls));
          break;
        }
      case FilterTypes.MISSED_CALLS:
        {
          List<CallModel> missedCalls = [];
          for (var call in calls) {
            if (call.callType == CallTypes.MISSED_CALL) {
              missedCalls.add(call);
            }
          }
          emit(FilterContactsState(calls: missedCalls));
          break;
        }
    }
  }

  Future<void> addCall(CallModel call) async {
    await DatabaseHelper.instance.add(call).then((value) {
      emit(AddCallState());
    });
  }

  void deleteCall(CallModel call) {
    calls = calls.removeAll(call);
    emit(DeleteCallState());
  }

  void changeDialNumber(String newDialNumber) {
    dialNumber = newDialNumber;
    emit(ChangeDialNumberState());
  }

  void changeDialShowState(bool showState) {
    isDialShow = showState;
    emit(ChangeDialShowState());
  }
}
