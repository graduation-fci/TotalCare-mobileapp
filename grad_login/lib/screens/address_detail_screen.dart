import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';

class AddressDetailScreen extends StatelessWidget {
  const AddressDetailScreen({super.key});
  static const routeName = '/address-detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AddressItem;
    print(args.description);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Text(args.title),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text(args.description),
                Text(args.phone),
              ],
            ),
          )),
    ));
  }
}
