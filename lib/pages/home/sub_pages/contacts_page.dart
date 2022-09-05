import 'dart:math';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/data/cloud/dio_helper.dart';
import 'package:contacts_app/data/cloud/tokens.dart';
import 'package:contacts_app/extensions/call_model_list_extension.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/route_manager/app_routes.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _randomGenerator = Random();
  late ContactsCubit _contactsCubit;
  late Size _screenSize;
  List<Color> colors = [
    Colors.cyanAccent,
    Colors.orangeAccent,
    Colors.blueGrey,
    Colors.lightGreen
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _contactsCubit = ContactsCubit.getInstance(context);
    return _buildPage();
  }

  Widget _buildPage() => SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contacts',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<ContactModel>>(
                    future: DioHelper.getContacts(url: getContactsToken),
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.green,)));
                      }
                      return Expanded(
                      child: snapshot.data!.isEmpty? Center(child: Text('No Contacts',style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white70
                      ),)) : AlphabetScrollView(
                        list: snapshot.data!
                            .map((contact) => AlphaModel(contact.name))
                            .toList(),
                        itemExtent: _screenSize.width * 0.3,
                        itemBuilder: (_, k, id) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _screenSize.height * 0.02),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.callerDetailsPageRoute,
                                    arguments: _contactsCubit.calls.getCall(
                                        _contactsCubit.contacts[k].number));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colors[
                                    _randomGenerator.nextInt(colors.length)],
                                    radius: _screenSize.width * 0.06,
                                    child: Text(
                                      id[0].toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    id,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        selectedTextStyle: const TextStyle(color: Colors.green),
                        unselectedTextStyle: const TextStyle(color: Colors.grey),
                        isAlphabetsFiltered: false,
                      ),
                    );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.createContactPageRoute);
                },
                backgroundColor: Colors.green,
                child: Text(
                  '+',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ),
            )
          ],
        ),
      );
}
