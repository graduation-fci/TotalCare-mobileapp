import 'package:flutter/material.dart';

Container orderItem() {
  return Container(
    height: 120,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.black.withOpacity(0.4),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Total price: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.green,
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.inner,
                    blurRadius: 3,
                    color: Colors.green,
                  ),
                ],
              ),
            )
          ],
        ),
        Text(
          'Address: ',
          style: customTextStyle(),
        ),
        const Spacer(),
        IntrinsicHeight(
          child: Row(
            children: [
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Placed at: ',
                    style: customTextStyle(),
                  ),
                  TextSpan(
                    text: '5 May 2023',
                    style: customTextStyle(),
                  )
                ],
              )),
              const Spacer(),
              const VerticalDivider(
                width: 30,
                thickness: 0.5,
                color: Colors.black,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Payment method:\n\n',
                        style: customTextStyle(),
                      ),
                      const TextSpan(
                        text: 'Cash',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}

TextStyle customTextStyle() {
  return const TextStyle(
    fontSize: 12,
    color: Colors.black,
  );
}
