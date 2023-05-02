import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';
import 'package:provider/provider.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-address-screen';

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();

  var id;
  var _editedProduct =
      AddressItem(id: 0, street: '', city: '', description: '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as AddressItem;
      _editedProduct.id = args.id;
      _streetController.text = args.street;
      _cityController.text = args.city;
      _descriptionController.text = args.description;
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
    _descriptionController.dispose();
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
                      onSaved: (newValue) {
                        _editedProduct = AddressItem(
                            id: _editedProduct.id,
                            street: newValue.toString(),
                            city: _editedProduct.city,
                            description: _editedProduct.description);
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
                            description: _editedProduct.description);
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
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
                        print('Newvalue:$newValue');
                        _editedProduct = AddressItem(
                            id: _editedProduct.id,
                            street: _editedProduct.street,
                            city: _editedProduct.city,
                            description: newValue.toString());
                      },
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
          .updateAddress(_editedProduct.id, _editedProduct);
      setState(() {});
      print(_streetController.text);
    }
  }
}
