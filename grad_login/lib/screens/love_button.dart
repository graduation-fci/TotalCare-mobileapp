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
    final mediaQuery = MediaQuery.of(context).size;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: mediaQuery.height * 0.04,
        width: mediaQuery.height * 0.04,
        decoration: const BoxDecoration(color: Colors.red),
        child: IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: _isFavorite
                      ? const Text('Added to Favorites!')
                      : const Text('Removed from Favorites!'),
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
