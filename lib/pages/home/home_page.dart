import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/bloc/contacts_states.dart';
import 'package:contacts_app/data/cloud/dio_helper.dart';
import 'package:contacts_app/data/cloud/tokens.dart';
import 'package:contacts_app/extensions/contact_model_list_extension.dart';
import 'package:contacts_app/extensions/string_extension.dart';
import 'package:contacts_app/extensions/string_list_extension.dart';
import 'package:contacts_app/models/call_model.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/models/dial_number_model.dart';
import 'package:contacts_app/models/nav_bar_screen_model.dart';
import 'package:contacts_app/pages/home/sub_pages/contacts_page.dart';
import 'package:contacts_app/pages/home/sub_pages/recents_page.dart';
import 'package:contacts_app/pages/home/sub_pages/sim_board_page.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:contacts_app/shared/caller_number.dart';
import 'package:contacts_app/utilities/call_types.dart';
import 'package:contacts_app/utilities/filter_types.dart';
import 'package:contacts_app/utilities/sim_number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final _randomGenerator = Random();
  late ContactsCubit _contactsCubit;
  final _phoneNumberController =
      TextEditingController(text: ContactsCubit.dialNumber);
  final GlobalKey<PopupMenuButtonState<String>> filterPopupKey = GlobalKey();
  final GlobalKey<PopupMenuButtonState<String>> callTypesKey = GlobalKey();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late Size screenSize;
  final List<NavBarScreenModel> navBarItems = [
    NavBarScreenModel(label: 'Recents', icon: Icons.access_time_rounded),
    NavBarScreenModel(label: 'Contacts', icon: Icons.person_outline),
    NavBarScreenModel(label: 'SIMBoard', icon: Icons.sim_card_outlined),
  ];
  final List<Widget> navBarPages = [
    const RecentsPage(),
    const ContactsPage(),
    const SimBoardPage()
  ];
  final List<DialNumberModel> dialNumbers = [
    DialNumberModel(number: '1', letters: [String.fromCharCode(8734)]),
    DialNumberModel(number: '2', letters: ['A', 'B', 'C']),
    DialNumberModel(number: '3', letters: ['D', 'E', 'F']),
    DialNumberModel(number: '4', letters: ['G', 'H', 'I']),
    DialNumberModel(number: '5', letters: ['J', 'K', 'L']),
    DialNumberModel(number: '6', letters: ['M', 'N', 'O']),
    DialNumberModel(number: '7', letters: ['P', 'Q', 'R', 'S']),
    DialNumberModel(number: '8', letters: ['T', 'U', 'V']),
    DialNumberModel(number: '9', letters: ['W', 'X', 'Y', 'Z']),
    DialNumberModel(number: '*', letters: []),
    DialNumberModel(number: '0', letters: ['+']),
    DialNumberModel(number: '#', letters: []),
  ];
  final List<String> filters = ['All', 'Missed Calls'];
  final List<String> callTypes = ['Add 2-sec pause', 'Add wait'];

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  void initState() {
    initPlatformState();
    setSystemNavBarStyle();
    _phoneNumberController.addListener(() {
      _contactsCubit.changeDialNumber(_phoneNumberController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build home');
    screenSize = MediaQuery.of(context).size;
    _contactsCubit = ContactsCubit.getInstance(context);
    DioHelper.getContacts(url: getContactsToken).then((value) {
      _contactsCubit.contacts=value;
    });
    return BlocConsumer<ContactsCubit, ContactsState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black,
              appBar: _buildAppBar(),
              body: _buildBody(),
              bottomNavigationBar: _buildBottomNavBar(),
              bottomSheet:
                  ContactsCubit.isDialShow ? _buildDialKeyboard() : null,
            ));
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (currentIndex == 0)
            PopupMenuButton<String>(
              color: Colors.grey.shade800,
              offset: Offset(screenSize.width * 0.07, 0),
              constraints: BoxConstraints(
                  minWidth: screenSize.width * 0.5,
                  minHeight: screenSize.height * 0.15),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.filter_alt_outlined),
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              itemBuilder: (_) {
                return filters
                    .map<PopupMenuEntry<String>>((item) => PopupMenuItem(
                          value: item,
                          padding: const EdgeInsets.only(right: 30, left: 10),
                          child: Text(
                            item,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            if (item == filters[0]) {
                              _contactsCubit.filter(FilterTypes.ALL);
                            } else {
                              _contactsCubit.filter(FilterTypes.MISSED_CALLS);
                            }
                          },
                        ))
                    .toList();
              },
            ),
          const SizedBox(
            width: 5,
          ),
          if (currentIndex != navBarPages.length - 1)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.searchPageRoute);
                },
                icon: const Icon(Icons.search)),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              onPressed: () {
                AppSettings.openAppSettings();
              },
              icon: const Icon(Icons.hexagon)),
        ],
      );

  Widget _buildBody() => navBarPages[currentIndex];

  BottomNavigationBar _buildBottomNavBar() => BottomNavigationBar(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      selectedFontSize: screenSize.width * 0.035,
      unselectedFontSize: screenSize.width * 0.035,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
          if (index != 0) {
            _contactsCubit.changeDialShowState(false);
          }
        });
      },
      unselectedItemColor: Colors.white54,
      selectedItemColor: CupertinoColors.activeGreen,
      items: navBarItems
          .map((screenItem) => BottomNavigationBarItem(
              icon: Icon(screenItem.icon), label: screenItem.label))
          .toList());

  Widget _buildDialKeyboard() {
    return Container(
      color: CupertinoColors.darkBackgroundGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ContactsCubit.dialNumber.isNotEmpty)
            SizedBox(
              height: screenSize.height * 0.08,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: PopupMenuButton<String>(
                      color: Colors.grey.shade800,
                      offset: Offset(screenSize.width * 0.07, 0),
                      constraints: BoxConstraints(
                          minWidth: screenSize.width * 0.5,
                          minHeight: screenSize.height * 0.15),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_vert_sharp,
                        color: Colors.white,
                      ),
                      position: PopupMenuPosition.under,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (_) {
                        return callTypes
                            .map<PopupMenuEntry<String>>((item) =>
                                PopupMenuItem(
                                  onTap: () {
                                    if (item == 'Add 2-sec pause') {
                                      _phoneNumberController.text += ',';
                                    } else if (item == 'Add wait') {
                                      if (_phoneNumberController.text.last !=
                                          ';') {
                                        _phoneNumberController.text += ';';
                                      }
                                    }
                                  },
                                  value: item,
                                  padding: const EdgeInsets.only(
                                      right: 30, left: 10),
                                  child: Text(
                                    item,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ))
                            .toList();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.none,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            _phoneNumberController.text =
                                _phoneNumberController.text.clearLastChar();
                          },
                          icon: const Icon(
                            CupertinoIcons.delete_left_fill,
                            color: Colors.white,
                          )))
                ],
              ),
            ),
          SizedBox(
            height: screenSize.height * 0.37,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.025),
              shrinkWrap: false,
              childAspectRatio: screenSize.aspectRatio * 4,
              crossAxisCount: 3,
              children: dialNumbers
                  .map((dialNum) => Material(
                        color: Colors.transparent,
                        type: MaterialType.circle,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            _phoneNumberController.text += dialNum.number;
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dialNum.number,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                              ),
                              Text(dialNum.letters.parse(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white38))
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.09,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              childAspectRatio: screenSize.aspectRatio * 4,
              crossAxisCount: 3,
              children: [
                Container(),
                FloatingActionButton(
                  backgroundColor: Colors.green.shade500,
                  onPressed: ContactsCubit.dialNumber.isNotEmpty
                      ? () async {
                          ContactModel? contact = _contactsCubit.contacts
                              .searchByNumber(_phoneNumberController.text);
                          CallModel call = CallModel(
                              callType: CallTypes.values[_randomGenerator.nextInt(CallTypes.values.length)],
                              callNumber: _phoneNumberController.text,
                              time: '${_randomGenerator.nextInt(50)} min ago',
                              isHD: true,
                              simNumber: SimNumber.values[_randomGenerator.nextInt(SimNumber.values.length)],
                              callerName: contact?.name,
                              period: '${_randomGenerator.nextInt(10)} min');
                          await _contactsCubit.addCall(call);
                          CallerNumber.call(_phoneNumberController.text);
                        }
                      : null,
                  child: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
                Material(
                    color: Colors.transparent,
                    type: MaterialType.circle,
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      onPressed: () {
                        _contactsCubit.changeDialShowState(false);
                      },
                      icon: const Icon(Icons.dialpad),
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future setSystemNavBarStyle() async {
    const style = SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: CupertinoColors.darkBackgroundGray,
      systemNavigationBarColor: CupertinoColors.darkBackgroundGray,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
