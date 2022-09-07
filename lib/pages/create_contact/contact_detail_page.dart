import 'package:contacts_app/data/cloud/constants.dart';
import 'package:contacts_app/data/cloud/dio_helper.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:contacts_app/shared/caller_number.dart';
import 'package:contacts_app/shared/custom_alert_dialog.dart';
import 'package:contacts_app/shared/custom_toast.dart';
import 'package:contacts_app/shared/sms_sender.dart';
import 'package:contacts_app/utilities/user_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({Key? key, required this.contact}) : super(key: key);
  final ContactModel contact;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late Size screenSize;
  bool isLoading = false;
  bool isBlocked=false;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                CustomAlertDialog.showAlertDialog(context, isBlocked? 'Unblock Number' : 'Block Number',
                    'Are you sure to ${isBlocked?'unblock' : 'block'} ${widget.contact.name} ?', () {
                  setState(() {
                    isBlocked=!isBlocked;
                    CustomToast.showToast(
                        msg: isBlocked? 'Number unblocked' : 'Number blocked',
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
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.createContactPageRoute,
                    arguments: <dynamic>[UserTypes.OLD_USER, widget.contact]);
              },
              icon: const Icon(
                Icons.edit_note_sharp,
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
                    Clipboard.setData(ClipboardData(text: widget.contact.phone))
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
                    Future.delayed(Duration.zero,() => CustomAlertDialog.showAlertDialog(context, 'Delete Contact',
                        'Are you sure to delete ${widget.contact.name} ?', () {
                      setState(() {
                        isLoading=true;
                      });
                          DioHelper.deleteContact(url: ApiConstants.endpoint, id: widget.contact.id.toString()).then((value) {
                            CustomToast.showToast(
                                msg: value,
                                background: Colors.green,
                                textColor: Colors.white);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }).catchError((_){
                            setState(() {
                              isLoading=false;
                            });
                            CustomToast.showToast(
                                msg: 'Server Error ... Contact not deleted!',
                                background: Colors.red,
                                textColor: Colors.white);
                            Navigator.pop(context);
                          });
                        }));
                  },
                  value: 'Delete contact',
                  padding: const EdgeInsets.only(right: 30, left: 10),
                  child: Text(
                    'Delete contact',
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
          child: Stack(
            children: [
              SizedBox(
                  height: screenSize.height * 0.5,
                  child: Image.asset(
                    isBlocked? 'assets/images/block_circle_background.png' :'assets/images/caller_background.png',
                    fit: BoxFit.cover,
                  )),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: screenSize.height*0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contact.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: screenSize.width * 0.11),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () =>
                              _callCurrentContact(widget.contact.phone),
                          child: Row(
                            children: [
                              Icon(Icons.phone_android,color: Colors.white60,),
                              SizedBox(width: 10,),
                              Text(
                                widget.contact.phone,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white70),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () =>
                                          _callCurrentContact(
                                              widget.contact.phone),
                                      icon: const Icon(
                                        Icons.call,
                                        color: Colors.white70,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        SmsSender.sendMessage(
                                            number: widget.contact.phone,
                                            msg:
                                                'Hello ${widget.contact.name}');
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
                        InkWell(
                          onTap: () {
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.web_stories,color: Colors.white60,),
                              SizedBox(width: 10,),
                              Text(
                                widget.contact.website!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white70),
                              ),
                              SizedBox(width: 5,),
                              Spacer(),
                              TextButton.icon(onPressed:(){},style: TextButton.styleFrom(
                                primary: Colors.white60
                              ), icon: Text('Browse'), label: Icon(Icons.keyboard_arrow_right_sharp))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.location_on_outlined,color: Colors.white60,),
                              SizedBox(width: 10,),
                              Text(
                                widget.contact.address!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white70),
                              ),
                              SizedBox(width: 5,),
                              Spacer(),
                              TextButton.icon(onPressed:(){},style: TextButton.styleFrom(
                                  primary: Colors.white60
                              ), icon: Text('Search'), label: Icon(Icons.keyboard_arrow_right_sharp))
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.email_outlined,color: Colors.white60,),
                              SizedBox(width: 10,),
                              Text(
                                widget.contact.email!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: Colors.white70),
                              ),
                              SizedBox(width: 5,),
                              Spacer(),
                              TextButton.icon(onPressed:(){},style: TextButton.styleFrom(
                                  primary: Colors.white60
                              ), icon: Text('Send'), label: Icon(Icons.keyboard_arrow_right_sharp))
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.business_sharp,color: Colors.white60,),
                            SizedBox(width: 10,),
                            Text(
                              widget.contact.company!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (isLoading)
                const LinearProgressIndicator(
                  color: Colors.green,
                  backgroundColor: Colors.transparent,
                ),
            ],
          ),
        ),
      );

  _callCurrentContact(String phone) {
    CallerNumber.call(phone);
  }
}
