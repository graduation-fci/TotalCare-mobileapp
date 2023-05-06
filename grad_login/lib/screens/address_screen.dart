import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';
import 'package:grad_login/screens/add_address_screen.dart';
import 'package:grad_login/screens/address_detail_screen.dart';
import 'package:grad_login/screens/edit_address_screen.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

bool _isLoading = true;

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Address>(context, listen: false).fetchAddress().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addresses = Provider.of<Address>(context).items;
    final String? errorMSG = Provider.of<Address>(context).errorMSG;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Addresses'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            :  Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            print('Deleting');
                            try {
                              Provider.of<Address>(context, listen: false)
                                  .deleteAddress(addresses[index].id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Address Deleted Successfully!'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Deleting Failed',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  AddressDetailScreen.routeName,
                                  arguments: AddressItem(
                                    id: addresses[index].id,
                                    street: addresses[index].street,
                                    city: addresses[index].city,
                                    description: addresses[index].description,
                                    phone: addresses[index].phone,
                                    type: addresses[index].type,
                                    title: addresses[index].title,
                                  ));
                            },
                            child: Ink(
                              height: 100,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 2,
                                      color: Colors.blueGrey,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ListTile(
                                  leading: Icon(
                                    addresses[index].type == 'Home'
                                        ? Icons.home_outlined
                                        : Icons.business,
                                    size: 50,
                                  ),
                                  title: Text(
                                    addresses[index].description,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    '${addresses[index].street}, ${addresses[index].city}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                EditAddressScreen.routeName,
                                                arguments: AddressItem(
                                                  id: addresses[index].id,
                                                  street:
                                                      addresses[index].street,
                                                  city: addresses[index].city,
                                                  description: addresses[index]
                                                      .description,
                                                  phone: addresses[index].phone,
                                                  type: addresses[index].type,
                                                  title: addresses[index].title,
                                                ));
                                          },
                                          icon: const Icon(Icons.edit)),
                                      // IconButton(
                                      //     onPressed: () {
                                      //       print('Deleting');
                                      //       try {
                                      //         Provider.of<Address>(context,
                                      //                 listen: false)
                                      //             .deleteAddress(addresses[index].id);
                                      //         ScaffoldMessenger.of(context)
                                      //             .showSnackBar(
                                      //           const SnackBar(
                                      //             content: Text(
                                      //                 'Address Deleted Successfully!'),
                                      //           ),
                                      //         );
                                      //       } catch (e) {
                                      //         ScaffoldMessenger.of(context)
                                      //             .showSnackBar(
                                      //           const SnackBar(
                                      //             content: Text(
                                      //               'Deleting Failed',
                                      //               textAlign: TextAlign.center,
                                      //             ),
                                      //           ),
                                      //         );
                                      //       }
                                      //     },
                                      //     icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  },
                  itemCount: addresses.length,
                )),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 28),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                Navigator.of(context).pushNamed(AddAddressScreen.routeName);
              },
              label: const Text(
                'Add new address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
