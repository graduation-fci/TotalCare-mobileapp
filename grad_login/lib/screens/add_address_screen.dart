import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';
import 'package:provider/provider.dart';

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
  AddressType _addressType = AddressType.Home;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        labelText: 'Street Address',
                        border: OutlineInputBorder(),
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
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a city';
                        }
                        return null;
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
                    // TextFormField(
                    //   controller: _descriptionController,
                    //   maxLines: 3,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Description',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter a description';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Select Location on Map'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],
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
      await Provider.of<Address>(context, listen: false).addAddress(
        _streetController.text,
        _cityController.text,
        '${_addressType.name.toString()} Address',
      );
      setState(() {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address added Successfully!')));
      });
      // print(_streetController.text);
    }
  }
}
