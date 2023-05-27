import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grad_login/providers/userProvider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/date_selector.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile-screen';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};
  Color containerFillColor = Colors.grey.shade200;
  Color labelColor = Colors.grey;
  String? name,
      gender,
      phoneNumber,
      countryCode,
      email,
      selectedItem,
      _age,
      _bloodGroup;
  FocusNode countryFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  DateTime? selectdate;
  File? imageFile;

  void openUserFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      imageFile = File(file.path!);
      log(imageFile.toString());
      Future.delayed(Duration.zero).then((value) =>
          Provider.of<UserProvider>(context, listen: false)
              .addUserImage(imageFile!));
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      userData = Provider.of<UserProvider>(context, listen: false).jwtUserData;
      setState(() {
        firstNameController.text = userData['first_name'];
        lastNameController.text = userData['last_name'];
        emailController.text = userData['email'];
      });
    });
    super.initState();
  }

  void _presentDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectdate) {
      setState(() {
        selectdate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    userData = Provider.of<UserProvider>(context, listen: false).jwtUserData;
    String countryName = appLocalization.countryName;
    log('$userData');

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: mediaQuery.height * 0.18,
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back),
                          ),
                          const Spacer(),
                          Text(
                            'Edit Profiles',
                            style: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle!
                                .copyWith(
                                    fontSize: mediaQuery.width * 0.06,
                                    letterSpacing: 0),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 35,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    height: 70,
                                    width: 70,
                                    imageUrl: userProvider.userImage,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${userData['first_name']} ${userData['last_name']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${userData['email']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(thickness: 4)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Personal Information'.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      fillColor: containerFillColor,
                                      filled: true,
                                      labelText: "First name",
                                      labelStyle: TextStyle(color: labelColor),
                                      suffixIcon: const IconButton(
                                        onPressed: null,
                                        icon: Icon(Icons.person_outlined),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: labelColor),
                                      ),
                                    ),
                                    cursorColor: labelColor,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field cannot be empty";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      name = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      fillColor: containerFillColor,
                                      filled: true,
                                      labelText: "Last name",
                                      labelStyle: TextStyle(color: labelColor),
                                      suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.person_outlined,
                                            color: labelColor),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: labelColor),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field cannot be empty";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      name = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                fillColor: containerFillColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabled: false,
                                labelText: "Gender",
                                labelStyle: TextStyle(color: labelColor),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              value: gender,
                              items: const [
                                DropdownMenuItem(
                                  value: "male",
                                  child: Text("Male"),
                                ),
                                DropdownMenuItem(
                                  value: "female",
                                  child: Text("Female"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Choose your gender";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            // DateSelector(
                            //   context: context,
                            // ),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: containerFillColor,
                                border: Border.all(
                                  color: Colors.black54,
                                  // width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    focusNode: countryFocus,
                                    onPressed: () => showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        country.flagEmoji;
                                        countryController.text =
                                            '+${country.phoneCode}';
                                        countryName =
                                            '${country.flagEmoji}  ${country.name}';
                                        setState(() {});
                                      },
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                    ),
                                  ),
                                  countryController.text.isEmpty
                                      ? const Text('---')
                                      : TextFormField(
                                          controller: countryController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          enabled: false,
                                        ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: mobileController,
                                      // focusNode: phoneFocus,
                                      // onEditingComplete: () {
                                      //   if (passwordFocus != null) {
                                      //     FocusScope.of(context)
                                      //         .requestFocus(passwordFocus);
                                      //   }
                                      // },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.phone,
                                      cursorColor: labelColor,

                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 5, 5, 5),
                                        labelText: appLocalization.phoneNumber,
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: labelColor,
                              decoration: InputDecoration(
                                fillColor: containerFillColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: "Email address",
                                labelStyle: TextStyle(color: labelColor),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.email),
                                    onPressed: () {}),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  print(value);
                                }
                              },
                            ),
                            const Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const Text(
                                  'Health Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: containerFillColor,
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: TextFormField(
                                              cursorColor: labelColor,
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Age: 22",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 16),
                                                  focusedBorder:
                                                      InputBorder.none),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Age :";
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                setState(() {
                                                  _age = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: containerFillColor,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                hintText: 'Blood group',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                focusedBorder: InputBorder.none,
                                                border: InputBorder.none,
                                              ),
                                              value: _bloodGroup,
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'A+',
                                                  child: Text('A+'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'A-',
                                                  child: Text('A-'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'B+',
                                                  child: Text('B+'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'B-',
                                                  child: Text('B-'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'O+',
                                                  child: Text('O+'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'O-',
                                                  child: Text('O-'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'AB+',
                                                  child: Text('AB+'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'AB-',
                                                  child: Text('AB-'),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _bloodGroup = value;
                                                });
                                              },
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select your blood group';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                setState(() {
                                                  _bloodGroup = value;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    openUserFiles();
                                    await userProvider.getUserData();
                                  },
                                  child: const Text('Update Profile'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
