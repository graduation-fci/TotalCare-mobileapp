import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';
import 'package:grad_login/screens/add_address_screen.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Address>(context, listen: false).fetchAddress();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addresses = Provider.of<Address>(context).items;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Your Address')),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Ink(
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
                          leading: const Icon(
                            Icons.home_outlined,
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
                          trailing: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
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
