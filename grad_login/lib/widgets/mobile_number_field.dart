import 'package:country_picker/country_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class MobileNumberField extends StatefulWidget {
  const MobileNumberField({super.key});

  @override
  State<MobileNumberField> createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<MobileNumberField> {
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode countryFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    String countryName = appLocalization.countryName;
    Color containerFillColor = Colors.grey.shade100;
    Color labelColor = Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
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
                  countryController.text = '+${country.phoneCode}';
                  countryName = '${country.flagEmoji}  ${country.name}';
                  setState(() {});
                },
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ),
            countryController.text.isEmpty
                ? const Text(
                    '---',
                    style: TextStyle(color: Colors.grey),
                  )
                : TextFormField(
                    controller: countryController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    enabled: false,
                  ),
            Expanded(
              child: TextFormField(
                controller: phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                cursorColor: labelColor,
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
