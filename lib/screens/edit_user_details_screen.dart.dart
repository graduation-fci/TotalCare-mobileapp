import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class EditUserDetailsScreen extends StatefulWidget {
  const EditUserDetailsScreen({super.key});

  @override
  State<EditUserDetailsScreen> createState() => _EditUserDetailsScreenState();
}

final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();
final _userNameController = TextEditingController();
final _emailController = TextEditingController();
final _phoneController = TextEditingController();

class _EditUserDetailsScreenState extends State<EditUserDetailsScreen> {
  String countryName = 'Choose Country';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 150,
                    title: const Text('Edit Profile'),
                    centerTitle: true,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: ListTile(
                        textColor: Colors.white,
                        leading: Image.asset(
                          'assets/images/TotalCare.png',
                          fit: BoxFit.cover,
                        ),
                        title: const Text(
                          'Name Here',
                          style: TextStyle(fontSize: 24),
                        ),
                        subtitle: const Text('Email Here'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PERSONAL INFORMATION',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 190,
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person_outline),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(),
                                hintText: 'First Name',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 190,
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person_outline),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(),
                                hintText: 'Last Name',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.person_outline),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        hintText: 'User Name',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.mail_outline),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          TextButton.icon(
                            label: Text(countryName),
                            onPressed: () => showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                country.flagEmoji;
                                _phoneController.text = '+${country.phoneCode}';
                                countryName =
                                    '${country.flagEmoji}  ${country.name}';
                                setState(() {});
                              },
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                // _authData!. = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone Number cannot be empty';
                                }
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.phone),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(),
                                labelText: 'Phone Number ',

                                // focusedBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ), //DropdownButtonFormField(items: [], onChanged: (_){}),
                    const Text(
                      'HEALTH INFORMATION',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 150,
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 5,
                          crossAxisSpacing: 10,
                        ),
                        children: [
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person_outline),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              hintText: 'Age: ',
                            ),
                          ),
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person_outline),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              hintText: 'Blood Group: ',
                            ),
                          ),
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person_outline),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              hintText: 'Height: ',
                            ),
                          ),
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.person_outline),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              hintText: 'Weight: ',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
