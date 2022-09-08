import 'dart:math';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:contacts_app/data/cloud/dio_helper.dart';
import 'package:contacts_app/data/cloud/constants.dart';
import 'package:contacts_app/extensions/contact_model_list_extension.dart';
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
                    future: DioHelper.getContacts(url: ApiConstants.endpoint),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        return Expanded(
                          child: Center(
                              child: Text(
                            'Server Error',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white70),
                          )),
                        );
                      } else if (snapshot.hasData) {
                        return Expanded(
                          child: AlphabetScrollView(
                            list: snapshot.data!
                                .map((contact) => AlphaModel(contact.name))
                                .toList(),
                            itemExtent: _screenSize.width * 0.25,
                            itemBuilder: (_, index, name) {
                              ContactModel? contactModel =
                                  snapshot.data!.searchByName(name);
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.contactDetailPageRoute,
                                      arguments: contactModel);
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: colors[_randomGenerator
                                          .nextInt(colors.length)],
                                      radius: _screenSize.width * 0.07,
                                      child: Text(
                                        contactModel!.id.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          name,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Text(
                                                contactModel.phone,
                                                maxLines: 1,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        color: Colors.white54),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: _screenSize.width * 0.3,
                                                child: Text(
                                                  contactModel.email!,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(
                                                          color:
                                                              Colors.white54),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            selectedTextStyle:
                                const TextStyle(color: Colors.green),
                            unselectedTextStyle:
                                const TextStyle(color: Colors.grey),
                            isAlphabetsFiltered: false,
                          ),
                        );
                      }
                      return const Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        color: Colors.green,
                      )));
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
