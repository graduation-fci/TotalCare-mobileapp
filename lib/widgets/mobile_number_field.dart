import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class MobileNumberField extends StatefulWidget {
  final TextEditingController countryController;
  final TextEditingController phoneController;
  final String? Function(String?) validator;
  User? user;

  MobileNumberField({
    super.key,
    required this.countryController,
    required this.phoneController,
    required this.validator,
    this.user,
  });

  @override
  State<MobileNumberField> createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<MobileNumberField> {
  final FocusNode countryFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    String countryName = appLocalization.countryName;
    Color containerFillColor = Colors.grey.shade100;
    Color labelColor = Colors.grey;
    widget.countryController.text = '+20';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
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
                  widget.countryController.text = '+${country.phoneCode}';
                  countryName = '${country.flagEmoji}  ${country.name}';
                  setState(() {});
                },
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 30,
              child: TextFormField(
                controller: widget.countryController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                enabled: false,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: widget.phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                cursorColor: labelColor,
                validator: widget.validator,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                  labelText: appLocalization.phoneNumber,
                  labelStyle: TextStyle(color: labelColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
