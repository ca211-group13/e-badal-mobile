import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountType {
  final String name;
  final String imagePath;
  final bool isLocalAccount;
  final String hintText;
  final String? prefix;
  final int maxLength;
  final String validationPattern;

  AccountType(
    this.name,
    this.imagePath, {
    required this.isLocalAccount,
    required this.hintText,
    this.prefix,
    required this.maxLength,
    required this.validationPattern,
  });
}

class AddAccountDialog extends StatefulWidget {
  final Function(AccountType type, String value)? onAccountAdded;

  const AddAccountDialog({Key? key, this.onAccountAdded}) : super(key: key);

  static void show(BuildContext context,
      {Function(AccountType type, String value)? onAccountAdded}) {
    showDialog(
      context: context,
      builder: (context) => AddAccountDialog(onAccountAdded: onAccountAdded),
    );
  }

  @override
  _AddAccountDialogState createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final List<AccountType> accountTypes = [
    AccountType(
      'EVC',
      'assets/images/evc.svg',
      isLocalAccount: true,
      hintText: 'Enter EVC number',
      prefix: '+252 ',
      maxLength: 9,
      validationPattern: r'^[0-9]{9}$',
    ),
    AccountType(
      'USDT (BEP-20)',
      'assets/images/usdtbep20.svg',
      isLocalAccount: false,
      hintText: 'Enter BEP-20 wallet address',
      maxLength: 42,
      validationPattern: r'^0x[a-fA-F0-9]{40}$',
    ),
    AccountType(
      'USDT (TRC-20)',
      'assets/images/USDTTRC20.svg',
      isLocalAccount: false,
      hintText: 'Enter TRC-20 wallet address',
      maxLength: 34,
      validationPattern: r'^T[A-Za-z0-9]{33}$',
    ),
    AccountType(
      'Zaad',
      'assets/images/zaad.svg',
      isLocalAccount: true,
      hintText: 'Enter Zaad number',
      prefix: '+252 ',
      maxLength: 9,
      validationPattern: r'^[0-9]{9}$',
    ),
    AccountType(
      'Sahal',
      'assets/images/sahal.svg',
      isLocalAccount: true,
      hintText: 'Enter Sahal number',
      prefix: '+252 ',
      maxLength: 9,
      validationPattern: r'^[0-9]{9}$',
    ),
  ];
  late AccountType selectedAccountType;
  final TextEditingController accountValueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedAccountType = accountTypes[0];
  }

  String? validateAccountInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter account details';
    }

    String valueToValidate = value;

    if (selectedAccountType.isLocalAccount) {
      // For local accounts, remove prefix and validate 9 digits
      if (selectedAccountType.prefix != null) {
        valueToValidate = value.replaceAll(selectedAccountType.prefix!, '');
      }
      if (!RegExp(r'^\d{9}$').hasMatch(valueToValidate)) {
        return 'Please enter a valid ${selectedAccountType.name} number (9 digits)';
      }
    } else {
      // For USDT accounts
      if (selectedAccountType.name.contains('BEP-20')) {
        // BEP-20 validation: must start with 0x and be 42 chars long
        if (!value.startsWith('0x')) {
          return 'BEP-20 address must start with 0x';
        }
        if (value.length != 42) {
          return 'BEP-20 address must be 42 characters long';
        }
        if (!RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(value)) {
          return 'Invalid BEP-20 address format';
        }
      } else if (selectedAccountType.name.contains('TRC-20')) {
        // TRC-20 validation: must start with T and be 34 chars long
        if (!value.startsWith('T')) {
          return 'TRC-20 address must start with T';
        }
        if (value.length != 34) {
          return 'TRC-20 address must be 34 characters long';
        }
        if (!RegExp(r'^T[a-zA-Z0-9]{33}$').hasMatch(value)) {
          return 'Invalid TRC-20 address format';
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdown for account type
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Select Account Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<AccountType>(
                value: selectedAccountType,
                onChanged: (AccountType? value) {
                  if (value != null) {
                    setState(() {
                      selectedAccountType = value;
                      accountValueController.clear();
                    });
                  }
                },
                items: accountTypes.map((AccountType accountType) {
                  return DropdownMenuItem<AccountType>(
                    value: accountType,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          accountType.imagePath,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(accountType.name),
                      ],
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Input field for account value
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Account Value',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: accountValueController,
                decoration: InputDecoration(
                  hintText: selectedAccountType.hintText,
                  prefixText: selectedAccountType.isLocalAccount
                      ? selectedAccountType.prefix
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: selectedAccountType.isLocalAccount
                      ? 'Enter 9 digits'
                      : selectedAccountType.name.contains('BEP-20')
                          ? 'Enter BEP-20 address (starts with 0x)'
                          : 'Enter TRC-20 address (starts with T)',
                  counterText:
                      '${accountValueController.text.length}/${selectedAccountType.maxLength}',
                ),
                keyboardType: selectedAccountType.isLocalAccount
                    ? TextInputType.phone
                    : TextInputType.text,
                maxLength: selectedAccountType.maxLength,
                validator: validateAccountInput,
                onChanged: (value) {
                  setState(() {}); // Update counter
                },
              ),
              const SizedBox(height: 24),

              // Add Account button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.onAccountAdded != null) {
                        widget.onAccountAdded!(
                          selectedAccountType,
                          accountValueController.text,
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
