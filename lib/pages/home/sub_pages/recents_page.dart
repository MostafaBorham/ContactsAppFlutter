import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/bloc/contacts_states.dart';
import 'package:contacts_app/data/local/database_helper.dart';
import 'package:contacts_app/models/call_model.dart';
import 'package:contacts_app/models/record_model.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:contacts_app/shared/custom_alert_dialog.dart';
import 'package:contacts_app/shared/custom_toast.dart';
import 'package:contacts_app/shared/sms_sender.dart';
import 'package:contacts_app/utilities/call_types.dart';
import 'package:contacts_app/shared/caller_number.dart';
import 'package:contacts_app/utilities/sim_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({Key? key}) : super(key: key);

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  late Size screenSize;
  late ContactsCubit _contactsCubit;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    _contactsCubit = ContactsCubit.getInstance(context);
    return BlocConsumer<ContactsCubit, ContactsState>(
      builder: (context, state) => _buildPage(state),
      listener: (context, state) {},
    );
  }

  Widget _buildPage(ContactsState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recents',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<CallModel>>(
                  future: DatabaseHelper.instance.getCalls(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        color: Colors.green,
                      )));
                    } else {
                      List<CallModel> tmp = snapshot.data!;
                      if (state is FilterContactsState) {
                        tmp = state.calls;
                      } else {
                        _contactsCubit.calls = snapshot.data!;
                        _contactsCubit.filter(ContactsCubit.currentFilter);
                      }
                      return Expanded(
                          child: snapshot.data!.isEmpty
                              ? Center(
                                  child: Text(
                                  'No Recents Calls',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: Colors.white70),
                                ))
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      _buildCallItem(tmp[index]),
                                  itemCount: tmp.length));
                    }
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: FloatingActionButton(
                onPressed: () {
                  _contactsCubit.changeDialShowState(true);
                },
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.apps_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallItem(CallModel call) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          alignment: AlignmentDirectional.centerEnd,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        child: InkWell(
          highlightColor: Colors.white12,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {});
            _callCurrentContact(call);
          },
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.grey.shade800,
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.9,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                builder: (context) => _buildCallOptionsDialog(call));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (call.callType == CallTypes.MISSED_CALL)
                      const Icon(
                        Icons.phone_missed,
                        color: Colors.red,
                      )
                    else if (call.callType == CallTypes.INCOME_CALL)
                      const Icon(
                        Icons.phone_callback,
                        color: Colors.cyan,
                      )
                    else
                      const Icon(
                        Icons.wifi_calling_rounded,
                        color: Colors.green,
                      ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          call.callerName ?? call.callNumber,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: call.callType == CallTypes.MISSED_CALL
                                      ? Colors.red
                                      : Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            if (call.isHD)
                              const Icon(
                                Icons.hd_outlined,
                                color: Colors.white54,
                              ),
                            const SizedBox(
                              width: 3,
                            ),
                            if (call.simNumber == SimNumber.SIM_ONE)
                              const Icon(
                                Icons.looks_one_outlined,
                                color: Colors.white,
                              )
                            else
                              const Icon(
                                Icons.looks_two_outlined,
                                color: Colors.white,
                              ),
                            Text(
                              'Mobile',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: Colors.white54),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      call.time,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.white54),
                    ),
                    IconButton(
                        onPressed: () async {
                          var number= await Navigator.of(context).pushNamed(
                              AppRoutes.callerDetailsPageRoute,
                              arguments: call);
                          if(number!=null){
                            _contactsCubit.changeDialShowState(true);
                             _contactsCubit
                                 .changeDialNumber(number.toString());
                          }
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Widget _buildCallOptionsDialog(CallModel call) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              call.callerName ?? call.callNumber,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.grey),
            ),
            const SizedBox(
              height: 45,
            ),
            InkWell(
              onTap: () {
                CustomAlertDialog.showAlertDialog(context, 'Call Delete',
                    'Are you sure to delete ${call.callerName ?? call.callNumber} ?',
                    () {
                  setState(() {
                    _contactsCubit.calls.remove(call);
                    Navigator.pop(context);
                  });
                });
              },
              child: Text(
                'Delete call log(s)',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                SmsSender.sendMessage(
                    number: call.callNumber,
                    msg: 'Hello ${call.callerName ?? ''}');
              },
              child: Text(
                'Send SMS',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                CustomAlertDialog.showAlertDialog(context, 'Block Number',
                    'Are you sure to block ${call.callerName ?? call.callNumber} ?',
                    () {
                  setState(() {
                    CustomToast.showToast(
                        msg: 'Number blocked',
                        background: Colors.green,
                        textColor: Colors.white);
                    Navigator.pop(context);
                  });
                });
              },
              child: Text(
                'Block number',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: call.callNumber))
                    .then((value) {
                  CustomToast.showToast(
                      msg: 'Number copied',
                      background: Colors.green,
                      textColor: Colors.white);
                });
              },
              child: Text(
                'Copy number',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                Navigator.popAndPushNamed(
                    context, AppRoutes.callRecordPageRoute,
                    arguments: call.records ?? List<RecordModel>.empty());
              },
              child: Text(
                'Call record',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  _callCurrentContact(CallModel call) {
    CallModel tmp = CallModel(
        callType: CallTypes.OUT_CALL,
        callNumber: call.callNumber,
        time: '0 min ago',
        isHD: true,
        simNumber: SimNumber.SIM_ONE,
        callerName: call.callerName,
        period: '1 min');
    _contactsCubit.addCall(tmp);
    CallerNumber.call(call.callNumber);
  }
}
