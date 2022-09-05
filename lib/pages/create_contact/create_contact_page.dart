import 'dart:convert';
import 'dart:io';

import 'package:contacts_app/bloc/contacts_cubit.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:contacts_app/shared/custom_toast.dart';
import 'package:contacts_app/utilities/user_types.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({Key? key, this.userType, this.contactModel})
      : super(key: key);
  final UserTypes? userType;
  final ContactModel? contactModel;

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  late ContactsCubit _contactsCubit;
  File? _image;
  final _formedKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  final _relationshipController = TextEditingController();
  late Size _screenSize;
  bool isMore = false;
  String selectedPhoneType = '';
  String selectedEmailType = '';
  List<String> phoneTypes = [
    'Mobile',
    'Work',
    'Home',
    'Main',
    'Work Fax',
    'Home Fax',
    'Pager',
    'Other',
    'Custom'
  ];
  List<String> emailTypes = ['Home', 'Work', 'Other', 'Custom'];

  @override
  void initState() {
    super.initState();
    if(widget.contactModel!=null){
      String name=widget.contactModel!.name;
      String firstName=name.contains(' ')?name.substring(0,name.indexOf(' ')) : name.substring(0,name.length);
      String lastName=name.trim().substring(firstName.length,name.trim().length);
      _firstNameController.text=firstName;
      _lastNameController.text=lastName;
      _phoneController.text=widget.contactModel!.number;
      _emailController.text=widget.contactModel!.email??'';
      _companyController.text=widget.contactModel!.company??'';
      _addressController.text=widget.contactModel!.address??'';
      _relationshipController.text=widget.contactModel!.relationship??'';
      selectedPhoneType = widget.contactModel!.numberType??phoneTypes[0];
      selectedEmailType = widget.contactModel!.emailType??emailTypes[0];
    }
    else{
      selectedPhoneType = phoneTypes[0];
      selectedEmailType = emailTypes[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _contactsCubit = ContactsCubit.getInstance(context);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: Text(
          'Create new contact',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white70, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              if (_formedKey.currentState!.validate()) {
                final newContact = ContactModel(
                    name:
                        '${_firstNameController.text} ${_lastNameController.text}',
                    number: _phoneController.text,
                    numberType: selectedPhoneType,
                    address: _addressController.text,
                    company: _companyController.text,
                    email: _emailController.text,
                    emailType: _emailController.text.isEmpty
                        ? null
                        : selectedEmailType,
                    relationship: _relationshipController.text);
                _contactsCubit.contacts.add(newContact);
                CustomToast.showToast(
                    msg: 'Contact Saved',
                    background: Colors.green,
                    textColor: Colors.white);
                Navigator.pop(context);
              }

            },
            style: TextButton.styleFrom(primary: Colors.green),
            child: Text(widget.userType!=null && widget.userType==UserTypes.OLD_USER? 'EDIT' : 'SAVE'),
          )
        ],
      );

  Widget _buildBody() => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Form(
              key: _formedKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () async => await getImage(),
                        child: Container(
                          width: _screenSize.width * 0.2,
                          height: _screenSize.width * 0.2,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : widget.contactModel?.image != null
                                  ? Image.memory(
                                      base64Decode(widget.contactModel!.image!),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: _screenSize.width * 0.1,
                                    ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: _screenSize.height * 0.04,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green.withOpacity(0.15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'SCAN QR CODE',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.sim_card,
                                      color: Colors.white54,
                                    )),
                                const SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  'Saving to\nmostafaborham7@gmail.com',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white54,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              height: 20,
                              width: 20,
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.white54,
                              )),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: _screenSize.width * 0.7,
                            child: TextFormField(
                              cursorColor: Colors.green,
                              controller: _firstNameController,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'please enter contact name!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white38)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2)),
                                  hintText: 'First name',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white38)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: _screenSize.width * 0.7,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                              cursorColor: Colors.green,
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white38)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2)),
                                  hintText: 'Last name',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white38)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              height: 20,
                              width: 20,
                              child: Icon(
                                Icons.call,
                                color: Colors.white54,
                              )),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: _screenSize.width * 0.7,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                              cursorColor: Colors.green,
                              controller: _phoneController,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'please enter contact phone!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white38)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2)),
                                  hintText: 'Phone',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white38)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          DropdownButton(
                            hint: Text(
                              selectedPhoneType,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white38),
                            ),
                            dropdownColor: CupertinoColors.darkBackgroundGray,
                            items: phoneTypes
                                .map((phoneType) => DropdownMenuItem<String>(
                                    value: phoneType, child: Text(phoneType)))
                                .toList(),
                            onChanged: (selected) {
                              setState(() {
                                selectedPhoneType = selected.toString();
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              height: 20,
                              width: 20,
                              child: Icon(
                                Icons.mail_outline_outlined,
                                color: Colors.white54,
                              )),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(
                            width: _screenSize.width * 0.7,
                            child: TextFormField(
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                              cursorColor: Colors.green,
                              controller: _emailController,
                              validator: (input) {
                                if (input!.isNotEmpty) {
                                  if (!EmailValidator.validate(input)) {
                                    return 'please enter formatted mail or not!';
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white38)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2)),
                                  hintText: 'Email',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.white38)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          DropdownButton(
                            hint: Text(
                              selectedEmailType,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white38),
                            ),
                            dropdownColor: CupertinoColors.darkBackgroundGray,
                            items: emailTypes
                                .map((emailType) => DropdownMenuItem<String>(
                                    value: emailType, child: Text(emailType)))
                                .toList(),
                            onChanged: (selected) {
                              setState(() {
                                selectedEmailType = selected.toString();
                              });
                            },
                          )
                        ],
                      ),
                      isMore
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          Icons.business_sharp,
                                          color: Colors.white54,
                                        )),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: _screenSize.width * 0.7,
                                      child: TextFormField(
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                                        cursorColor: Colors.green,
                                        controller: _companyController,
                                        decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white38)),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green,
                                                        width: 2)),
                                            hintText: 'Company',
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Colors.white38)),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white54,
                                        )),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: _screenSize.width * 0.7,
                                      child: TextFormField(
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                                        cursorColor: Colors.green,
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white38)),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green,
                                                        width: 2)),
                                            hintText: 'Address',
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Colors.white38)),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          Icons.family_restroom,
                                          color: Colors.white54,
                                        )),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: _screenSize.width * 0.7,
                                      child: TextFormField(
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Colors.white70
                              ),
                                        cursorColor: Colors.green,
                                        controller: _relationshipController,
                                        decoration: InputDecoration(
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white38)),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green,
                                                        width: 2)),
                                            hintText: 'Relationship',
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Colors.white38)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  isMore = true;
                                });
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: const Text('MORE FIELDS'),
                            )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }
}
