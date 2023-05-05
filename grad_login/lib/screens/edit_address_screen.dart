import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';
import 'package:provider/provider.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-address-screen';

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

enum AddressType { Home, Business }

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  AddressType _addressType = AddressType.Home;
  final _titleController = TextEditingController();

  var id;
  var _editedProduct = AddressItem(
      id: 0,
      street: '',
      city: '',
      description: '',
      phone: '',
      title: '',
      type: '');

  String countryName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as AddressItem;
      _editedProduct.id = args.id;
      _streetController.text = args.street;
      _cityController.text = args.city;
      _descController.text = args.description;
      _phoneController.text = args.phone;
      args.type == 'Home'
          ? _addressType = AddressType.Home
          : _addressType = AddressType.Business;
      _titleController.text = args.title;
    });
  }
  // @override
  // void initState() {
  //   final args = ModalRoute.of(context)!.settings.arguments as int;
  //   _editedProduct = Provider.of<Address>(context).findByID(args);
  //   _initvalues = {
  //     'street': _editedProduct.street,
  //     'city': _editedProduct.city,
  //     'description': _editedProduct.description,
  //   };
  //   _streetController.text = _initvalues['street'].toString();
  //   _cityController.text = _initvalues['city'].toString();
  //   _descriptionController.text = _initvalues['description'].toString();

  //   super.initState();
  // }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${_titleController.text}'),
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
                      onSaved: (newValue) {
                        _editedProduct = AddressItem(
                          id: _editedProduct.id,
                          street: newValue.toString(),
                          city: _editedProduct.city,
                          description: _editedProduct.description,
                          phone: _editedProduct.phone,
                          title: '',
                          type: '',
                        );
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
                      onSaved: (newValue) {
                        _editedProduct = AddressItem(
                            id: _editedProduct.id,
                            street: _editedProduct.street,
                            city: newValue.toString(),
                            description: _editedProduct.description,
                            phone: _editedProduct.phone,
                            type: _editedProduct.type,
                            title: _editedProduct.title);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = AddressItem(
                            id: _editedProduct.id,
                            street: _editedProduct.street,
                            city: _editedProduct.city,
                            description: newValue.toString(),
                            phone: _editedProduct.phone,
                            type: _editedProduct.type,
                            title: _editedProduct.title);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid Title';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = AddressItem(
                            id: _editedProduct.id,
                            street: _editedProduct.street,
                            city: _editedProduct.city,
                            description: _editedProduct.description,
                            phone: _editedProduct.phone,
                            type: _editedProduct.type,
                            title: newValue.toString());
                      },
                    ),
                    const SizedBox(height: 16.0),
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
                              onSaved: (newValue) {
                                _editedProduct = AddressItem(
                                  id: _editedProduct.id,
                                  street: _editedProduct.street,
                                  city: _editedProduct.city,
                                  description: _editedProduct.description,
                                  phone: newValue.toString(),
                                  type: _editedProduct.type,
                                  title: _editedProduct.title,
                                );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone Number cannot be empty';
                                }
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                                labelText: 'Phone Number ',

                                // focusedBorder: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _formKey.currentState!.save();
      await Provider.of<Address>(context, listen: false)
          .updateAddress(_editedProduct.id, _editedProduct, _addressType.name);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address updated Successfully!')));
      setState(() {});
      // print(_streetController.text);
    }
  }
}
