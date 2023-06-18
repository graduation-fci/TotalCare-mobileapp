import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishProvider.dart';

class LoveBtn extends StatefulWidget {
  final int id, drugID;
  LoveBtn(this.id, this.drugID);

  @override
  State<LoveBtn> createState() => _LoveBtnState();
}

class _LoveBtnState extends State<LoveBtn> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: mediaQuery.height * 0.04,
        width: mediaQuery.height * 0.04,
        decoration: const BoxDecoration(color: Colors.red),
        child: IconButton(
            onPressed: () async {
              // log(widget.id.toString());
              // log(widget.drugID.toString());
              _isFavorite
                  ? await Provider.of<Wish>(context, listen: false)
                      .deleteFavWish(widget.id, widget.drugID)
                  : await Provider.of<Wish>(context, listen: false)
                      .addWish(widget.id, widget.drugID);
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: _isFavorite
                      ? const Text('Added to Wish List!')
                      : const Text('Removed from Wish List!'),
                ),
              );
            },
            icon: _isFavorite
                ? Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: mediaQuery.width * 0.05,
                  )
                : Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                    size: mediaQuery.width * 0.05,
                  )),
      ),
    );
  }
}
