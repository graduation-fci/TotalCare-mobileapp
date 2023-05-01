import 'package:flutter/material.dart';

class LoveBtn extends StatefulWidget {
  const LoveBtn({super.key});

  @override
  State<LoveBtn> createState() => _LoveBtnState();
}

class _LoveBtnState extends State<LoveBtn> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(color: Colors.red),
        child: IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: _isFavorite
                      ? const Text('Removed from Favorites!')
                      : const Text('Added to Favorites!'),
                ),
              );
            },
            icon: _isFavorite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                  )),
      ),
    );
  }
}
