import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/addressProvider.dart';
import '../widgets/mobile_number_field.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key}) : super(key: key);
  static const routeName = '/add-address-screen';

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

enum AddressType { Home, Business }

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _titleController = TextEditingController();
  AddressType _addressType = AddressType.Home;

  String countryName = 'Choose Country';

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF003745),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Add Address'.toUpperCase(),
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(fontSize: mediaQuery.width * 0.045),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: _streetController,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a street address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    labelText: 'City',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  cursorColor: Colors.grey,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid Title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                MobileNumberField(
                  countryController: _countryController,
                  phoneController: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number cannot be empty';
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address Type',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Radio<AddressType>(
                          value: AddressType.Home,
                          groupValue: _addressType,
                          onChanged: (AddressType? value) {
                            setState(() {
                              _addressType = value!;
                            });
                          },
                        ),
                        const Text('Home'),
                        Radio<AddressType>(
                          value: AddressType.Business,
                          groupValue: _addressType,
                          onChanged: (AddressType? value) {
                            setState(() {
                              _addressType = value!;
                            });
                          },
                        ),
                        const Text('Business'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: Size(
                      mediaQuery.width * 0.85,
                      mediaQuery.height * 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Select Location on Map',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontSize: mediaQuery.width * 0.038),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    fixedSize: Size(
                      mediaQuery.width * 0.85,
                      mediaQuery.height * 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontSize: mediaQuery.width * 0.038),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      await Provider.of<Address>(context, listen: false)
          .addAddress(
              _streetController.text,
              _cityController.text,
              _descController.text,
              _phoneController.text,
              _addressType.name,
              _titleController.text)
          .then((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address added Successfully!')));
      });
      // print(_streetController.text);
    }
  }
}
