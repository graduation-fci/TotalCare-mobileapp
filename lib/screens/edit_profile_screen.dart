import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';

import '../providers/userProvider.dart';
import '../models/user.dart';
import '../widgets/show_custom_dialog.dart';
import '../widgets/blood_type_field.dart';
import '../widgets/date_selector.dart';
import '../app_state.dart';

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
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  Color containerFillColor = Colors.grey.shade200;
  Color labelColor = Colors.grey;
  String? gender, _age;
  FocusNode countryFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  String? selectedDate;
  File? imageFile;
  User? _userData;
  Map<String, dynamic> userProfileData = {};
  Map<String, dynamic> patientData = {};

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      loadData();
    });
    super.initState();
  }

  void loadData() {
    final arguements =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    userProfileData = arguements['user_data'];
    patientData = arguements['patient_data'];

    countryController.text =
        patientData['phone'] == null || patientData['phone'] == ''
            ? '---'
            : patientData['phone'].substring(0, 3);
    mobileController.text =
        patientData['phone'] == null || patientData['phone'] == ''
            ? ''
            : patientData['phone'].substring(3);
    bloodTypeController.text = patientData['bloodType'] ?? '';
    gender = patientData['gender'];
    birthDateController.text = patientData['birth_date'] ?? '';

    firstNameController.text = userProfileData['first_name'];
    lastNameController.text = userProfileData['last_name'];
    emailController.text = userProfileData['email'];
    setState(() {});
  }

  void removeProfileImage(userProvider, {oldImageId}) async {
    oldImageId == null
        ? userProvider.imageId == null
            ? null
            : userProvider.deleteUserImage(userProvider.imageId!)
        : userProvider.deleteUserImage(oldImageId);

    Navigator.of(context).pop();
  }

  Future<void> openUserFiles(userProvider) async {
    final existingImageId = userProvider.imageId;
    if (existingImageId == null) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        imageFile = File(file.path!);
        Future.delayed(Duration.zero)
            .then(
              (_) => Provider.of<UserProvider>(context, listen: false)
                  .uploadProfileImage(imageFile!),
            )
            .then((value) => userProvider.imageId == null
                ? null
                : Provider.of<UserProvider>(context, listen: false)
                    .addUserImage(userProvider.imageId!));
      }
    } else {
      final oldImageId = existingImageId;
      int? newImageId;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        imageFile = File(file.path!);

        Future.delayed(Duration.zero)
            .then((_) async {
              await Provider.of<UserProvider>(context, listen: false)
                  .uploadProfileImage(imageFile!);
              newImageId = userProvider.imageId;
              // log(newImageId.toString());
            })
            .then(
                (_) => removeProfileImage(userProvider, oldImageId: oldImageId))
            .then((_) {
              userProvider.imageId == null
                  ? null
                  : Provider.of<UserProvider>(context, listen: false)
                      .addUserImage(newImageId!);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final appLocalization = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    final patientData = userProvider.userPatientData;
    final userData = userProvider.userProfileData;

    if (userProvider.appState == AppState.done) {
      _userData = User(
        username: '',
        first_name: userData['first_name'],
        last_name: userData['last_name'],
        email: userData['email'],
        phoneNumber: patientData['phone'].toString(),
        bloodType: patientData['bloodType'],
        gender: patientData['gender'],
        birthDate: patientData['birth_date'],
        password: '',
        profileType: 'PAT',
      );
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: userProvider.appState == AppState.loading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.shade200,
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.grey.shade600,
                    ),
                  ),
                ),
              )
            : GestureDetector(
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
                                    GestureDetector(
                                      onTap: () {
                                        showCustomDialog(
                                          context,
                                          Column(
                                            children: [
                                              DialogSelection(
                                                () async {
                                                  await openUserFiles(
                                                      userProvider);
                                                },
                                                'Update profile photo',
                                              ),
                                              DialogSelection(
                                                () {
                                                  removeProfileImage(
                                                      userProvider);
                                                },
                                                'Remove photo',
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              radius: 35,
                                              child: ClipOval(
                                                child: userProvider.userImage ==
                                                        ''
                                                    ? const Icon(
                                                        Icons.person,
                                                        color: Colors.grey,
                                                        size: 50,
                                                      )
                                                    : SizedBox(
                                                        height: 70,
                                                        width: 70,
                                                        child: Image.network(
                                                          userProvider
                                                              .userImage,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              width: 26,
                                              height: 26,
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.black45,
                                                size: 18,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_userData?.first_name} ${_userData?.last_name}',
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
                                            '${_userData?.email}',
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
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Personal Information'.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            const SizedBox(height: 10),
                            Form(
                              key: _formKey,
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
                                            labelStyle:
                                                TextStyle(color: labelColor),
                                            suffixIcon: const IconButton(
                                              onPressed: null,
                                              icon: Icon(Icons.person_outlined),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide:
                                                  BorderSide(color: labelColor),
                                            ),
                                          ),
                                          cursorColor: labelColor,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field cannot be empty";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _userData!.first_name = value!;
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
                                            labelStyle:
                                                TextStyle(color: labelColor),
                                            suffixIcon: IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.person_outlined,
                                                  color: labelColor),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide:
                                                  BorderSide(color: labelColor),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field cannot be empty";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _userData!.last_name = value!;
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide:
                                              BorderSide(color: labelColor),
                                        ),
                                        enabled: false,
                                        labelText: "Gender",
                                        labelStyle:
                                            TextStyle(color: labelColor),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      value: gender,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'M',
                                          child: Text('Male'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'F',
                                          child: Text('Female'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                      onSaved: (value) {
                                        if (value != null) {
                                          _userData!.gender = value;
                                        }
                                      }),
                                  SizedBox(
                                    height: mediaQuery.height * 0.02,
                                  ),
                                  DateSelector(
                                    backColor: containerFillColor,
                                    validator: (value) {
                                      if (value != null) {
                                        _userData!.birthDate = value;
                                      }
                                    },
                                    context: context,
                                    selectdate: selectedDate,
                                    dateController: birthDateController,
                                    userData: _userData!,
                                  ),
                                  SizedBox(
                                    height: mediaQuery.height * 0.02,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.35),
                                          offset: const Offset(0, 10),
                                          blurRadius: 25,
                                        ),
                                      ],
                                      color: containerFillColor,
                                      border: Border.all(
                                        color: Colors.grey,
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
                                              setState(() {});
                                            },
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: TextFormField(
                                            controller: countryController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            enabled: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: mobileController,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.phone,
                                            cursorColor: labelColor,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 5, 5, 5),
                                              labelText:
                                                  appLocalization.phoneNumber,
                                              labelStyle:
                                                  TextStyle(color: labelColor),
                                              border: InputBorder.none,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value == '') {
                                                setState(() {
                                                  countryController.text =
                                                      '---';
                                                  mobileController.text = '';
                                                  _userData!.phoneNumber = '';
                                                });
                                              }
                                              return;
                                            },
                                            onSaved: (value) {
                                              if (value != '' &&
                                                  value != null) {
                                                _userData!.phoneNumber =
                                                    countryController.text +
                                                        value;
                                              }
                                            },
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
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.email),
                                          onPressed: () {}),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field cannot be empty";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      if (value != null) {
                                        _userData!.email = value;
                                      }
                                    },
                                  ),
                                  const Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextFormField(
                                                    cursorColor: labelColor,
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText: "Age",
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    // validator: (value) {
                                                    //   if (value!.isEmpty) {
                                                    //     return "Age:";
                                                    //   }
                                                    //   return null;
                                                    // },
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
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: BloodTypeInput(
                                                backColor: containerFillColor,
                                                bloodTypeController:
                                                    bloodTypeController,
                                                bloodTypes: bloodTypes,
                                                user: _userData,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () =>
                                            onPressed(_userData!, userProvider),
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

  void onPressed(User userData, UserProvider userProvider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await userProvider.editUserData(userData).then((_) {
        if (userData.birthDate != null ||
            userData.gender != null ||
            userData.bloodType != null ||
            !userData.phoneNumber!.startsWith('---')) {
          userProvider.editPatientData(userData);
        }
      });
    }
  }
}

class DialogSelection extends StatelessWidget {
  VoidCallback function;
  String text;
  DialogSelection(
    this.function,
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
