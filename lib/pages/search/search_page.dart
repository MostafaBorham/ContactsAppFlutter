import 'dart:math';

import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/extensions/contact_model_list_extension.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/shared/caller_number.dart';
import 'package:contacts_app/utilities/empty_search_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Size screenSize;
  late ContactsCubit _contactsCubit;
  final String noHistoryMessage = 'No Search History';
  final String noResultsMessage = 'No Search Results';
  bool isTyping = false;
  final _randomGenerator = Random();
  final _searchController = TextEditingController();
  List<ContactModel> contactsResults = [];
  List<Color> colors = [
    Colors.cyanAccent,
    Colors.orangeAccent,
    Colors.blueGrey,
    Colors.lightGreen
  ];
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        isTyping = true;
      } else {
        isTyping = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    _contactsCubit = ContactsCubit.getInstance(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        title: _buildSearchField(),
        titleSpacing: 0,
        elevation: 0,
        leadingWidth: screenSize.width * 0.1,
      );

  Widget _buildSearchField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          controller: _searchController,
          cursorColor: Colors.green,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.white),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              fillColor: CupertinoColors.darkBackgroundGray,
              filled: true,
              prefixIcon: const Icon(
                Icons.search_outlined,
                color: Colors.white54,
              ),
              prefixIconConstraints:
                  BoxConstraints(minWidth: screenSize.width * 0.1),
              suffixIcon: isTyping
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: const Icon(
                        Icons.highlight_remove,
                        color: Colors.white54,
                      ),
                      constraints: const BoxConstraints(),
                      splashColor: Colors.transparent,
                    )
                  : null,
              suffixIconConstraints: isTyping
                  ? BoxConstraints(minWidth: screenSize.width * 0.1)
                  : null,
              hintText: 'Search contacts',
              hintStyle: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white38,
                  )),
        ),
      );

  Widget _buildBody() {
    if (isTyping) {
      List<ContactModel> contactsResults =
          _contactsCubit.contacts.search(_searchController.text);
      if (contactsResults.isEmpty) {
        return _buildNoPageBody(EmptySearchPages.NO_SEARCH_RESULTS);
      } else {
        return _buildSearchResultsBody(contactsResults);
      }
    } else {
      if (_contactsCubit.suggestions.isEmpty) {
        return _buildNoPageBody(EmptySearchPages.NO_SEARCH_HISTORY);
      } else {
        return _buildSuggestionsListBody();
      }
    }
  }

  Widget _buildNoPageBody(EmptySearchPages page) =>
      page == EmptySearchPages.NO_SEARCH_HISTORY
          ? _buildNoHistoryBody()
          : _buildNoResultsBody();
  Widget _buildNoHistoryBody() => SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.3,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sim_card_alert_outlined,
                  color: Colors.white54,
                  size: screenSize.width * 0.2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  noHistoryMessage,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white54),
                )
              ],
            ),
          ),
        ),
      );
  Widget _buildNoResultsBody() => SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.3,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sim_card_alert_outlined,
                  color: Colors.white54,
                  size: screenSize.width * 0.2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  noResultsMessage,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white54),
                )
              ],
            ),
          ),
        ),
      );

  Widget _buildSuggestionsListBody() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Column(
                children: _contactsCubit.suggestions
                    .map((suggestion) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: InkWell(
                            onTap: () {
                              _searchController.text = suggestion;
                            },
                            splashColor: Colors.transparent,
                            highlightColor: CupertinoColors.darkBackgroundGray,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.white38,
                                  size: screenSize.width * 0.05,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  suggestion,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      _contactsCubit.suggestions
                                          .remove(suggestion);
                                      setState(() {});
                                    },
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white38,
                                      size: screenSize.width * 0.05,
                                    ))
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const Divider(
                color: Colors.white24,
                thickness: 0.5,
              ),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    _contactsCubit.suggestions.clear();
                    setState(() {});
                  },
                  splashColor: Colors.transparent,
                  highlightColor: CupertinoColors.darkBackgroundGray,
                  color: Colors.transparent,
                  child: Text(
                    'Clear history',
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: Colors.white38,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildSearchResultsBody(List<ContactModel> resultList) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALL CONTACTS',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white38),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: resultList
                      .map((contact) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: InkWell(
                              onTap: () {
                                CallerNumber.call(contact.number);
                                setState(() {
                                  if (!_contactsCubit.suggestions
                                      .contains(_searchController.text)) {
                                    _contactsCubit.suggestions
                                        .add(_searchController.text);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colors[_randomGenerator
                                        .nextInt(colors.length)],
                                    radius: screenSize.width * 0.06,
                                    child: Text(
                                      contact.name[0].toUpperCase(),
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
                                    children: [
                                      Text(
                                        contact.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${contact.numberType} ${contact.number}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: Colors.white38),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ),
      );
}
