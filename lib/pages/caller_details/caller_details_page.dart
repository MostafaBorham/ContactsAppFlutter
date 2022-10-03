import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/bloc/contacts_states.dart';
import 'package:contacts_app/extensions/call_model_list_extension.dart';
import 'package:contacts_app/models/call_model.dart';
import 'package:contacts_app/models/record_model.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:contacts_app/shared/caller_number.dart';
import 'package:contacts_app/shared/custom_alert_dialog.dart';
import 'package:contacts_app/shared/custom_toast.dart';
import 'package:contacts_app/shared/sms_sender.dart';
import 'package:contacts_app/utilities/call_types.dart';
import 'package:contacts_app/utilities/sim_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallerDetailsPage extends StatefulWidget {
  const CallerDetailsPage({Key? key, required this.callerInfo})
      : super(key: key);

  final CallModel callerInfo;
  @override
  State<CallerDetailsPage> createState() => _CallerDetailsPageState();
}

class _CallerDetailsPageState extends State<CallerDetailsPage> {
  late Size screenSize;
  late ContactsCubit _contactsCubit;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    _contactsCubit = ContactsCubit.getInstance(context);
    return BlocConsumer<ContactsCubit, ContactsState>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                CustomAlertDialog.showAlertDialog(context, 'Block Number',
                    'Are you sure to block ${widget.callerInfo.callerName ?? widget.callerInfo.callNumber} ?',
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
              icon: const Icon(
                Icons.block,
                color: Colors.white,
              )),
          PopupMenuButton<String>(
            color: Colors.grey.shade800,
            offset: Offset(screenSize.width * 0.07, 0),
            constraints: BoxConstraints(
                minWidth: screenSize.width * 0.5,
                minHeight: screenSize.height * 0.15),
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            position: PopupMenuPosition.under,
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  onTap: () {
                    Clipboard.setData(
                            ClipboardData(text: widget.callerInfo.callNumber))
                        .then((value) {
                      CustomToast.showToast(
                          msg: 'Number copied',
                          background: Colors.green,
                          textColor: Colors.white);
                    });
                  },
                  value: 'Copy number',
                  padding: const EdgeInsets.only(right: 30, left: 10),
                  child: Text(
                    'Copy number',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context).pop(widget.callerInfo.callNumber);
                  },
                  value: 'Edit number before call',
                  padding: const EdgeInsets.only(right: 30, left: 10),
                  child: Text(
                    'Edit number before call',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(
                      Duration.zero,
                      () {
                        CustomAlertDialog.showAlertDialog(
                          context,
                          'Delete History',
                          'Delete the entire call history?',
                          () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            _contactsCubit.deleteCall(widget.callerInfo);
                          },
                        );
                      },
                    );
                  },
                  value: 'Delete recent calls',
                  padding: const EdgeInsets.only(right: 30, left: 10),
                  child: Text(
                    'Delete recent calls',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ),
              ];
            },
          ),
        ],
      );

  Widget _buildBody() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenSize.height * 0.6,
                  child: Stack(
                    children: [
                      SizedBox(
                          height: screenSize.height * 0.5,
                          child: Image.asset(
                            'assets/images/caller_background.png',
                            fit: BoxFit.cover,
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.11),
                            child: Text(
                              widget.callerInfo.callerName ??
                                  widget.callerInfo.callNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenSize.width * 0.11),
                            ),
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () =>
                                    _callCurrentContact(widget.callerInfo),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.callerInfo.callNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: Colors.white70),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () =>
                                                _callCurrentContact(
                                                    widget.callerInfo),
                                            icon: const Icon(
                                              Icons.call,
                                              color: Colors.white70,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              SmsSender.sendMessage(
                                                  number: widget
                                                      .callerInfo.callNumber,
                                                  msg:
                                                      'Hello ${widget.callerInfo.callerName ?? ''}');
                                            },
                                            icon: const Icon(
                                              Icons.sms,
                                              color: Colors.white70,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      AppRoutes.callRecordPageRoute,
                                      arguments: widget.callerInfo.records ??
                                          List<RecordModel>.empty());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Call record',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: Colors.white70),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_sharp,
                                      color: Colors.white38,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.07,
                ),
                Text(
                  'RECENTS',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white38),
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  children: _contactsCubit.calls
                      .search(widget.callerInfo.callNumber)
                      .map((call) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      call.callType.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      children: [
                                        if (call.callType ==
                                            CallTypes.MISSED_CALL)
                                          const Icon(
                                            Icons.phone_missed,
                                            color: Colors.red,
                                          )
                                        else if (call.callType ==
                                            CallTypes.INCOME_CALL)
                                          const Icon(
                                            Icons.phone_callback,
                                            color: Colors.cyan,
                                          )
                                        else
                                          const Icon(
                                            Icons.wifi_calling_rounded,
                                            color: Colors.green,
                                          ),
                                        if (call.isHD)
                                          const Icon(
                                            Icons.hd_outlined,
                                            color: Colors.white54,
                                          ),
                                        Text(
                                          call.time,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.white54),
                                        ),
                                        Text(
                                          ' (${call.period})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.white54),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  call.time,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white54),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
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
