// crypto_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrencyOption {
  final String name;
  final String symbol;
  final String? imageUrl;
  final String? chain;
  final String? svgAsset;

  CurrencyOption({
    required this.name,
    required this.symbol,
    this.imageUrl,
    this.chain,
    this.svgAsset,
  });
}

class CryptoDropdown extends StatelessWidget {
  final List<CurrencyOption> options;
  final CurrencyOption selected;
  final Function(CurrencyOption) onChanged;

  const CryptoDropdown({
    Key? key,
    required this.options,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CurrencyOption>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyIcon(selected),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selected.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (selected.chain != null)
                  Text(
                    selected.chain!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem<CurrencyOption>(
          value: option,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _buildCurrencyIcon(option),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (option.chain != null)
                        Text(
                          option.chain!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onSelected: onChanged,
    );
  }

  Widget _buildCurrencyIcon(CurrencyOption currency) {
    if (currency.svgAsset != null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SvgPicture.asset(
            currency.svgAsset!,
            fit: BoxFit.contain,
            placeholderBuilder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      );
    } else if (currency.imageUrl != null) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(currency.imageUrl!),
      );
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey[200],
      child: Text(
        currency.symbol[0],
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
