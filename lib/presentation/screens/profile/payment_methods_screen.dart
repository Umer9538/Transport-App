import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class PaymentMethod {
  final String id;
  final String type; // visa, mastercard, apple_pay, wallet
  final String label;
  final String? lastFour;
  final String? expiryDate;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    this.lastFour,
    this.expiryDate,
    this.isDefault = false,
  });

  PaymentMethod copyWith({bool? isDefault}) {
    return PaymentMethod(
      id: id,
      type: type,
      label: label,
      lastFour: lastFour,
      expiryDate: expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> data) {
    return PaymentMethod(
      id: data['id'] ?? '',
      type: data['type'] ?? 'visa',
      label: data['label'] ?? 'Card',
      lastFour: data['lastFour'],
      expiryDate: data['expiryDate'],
      isDefault: data['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'label': label,
      'lastFour': lastFour,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
    };
  }
}

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  List<PaymentMethod> _methods = [];
  bool _loaded = false;

  Future<void> _loadMethods() async {
    if (_loaded) return;
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final firestoreService = ref.read(firestoreServiceProvider);
    final data = await firestoreService.getPaymentMethods(user.uid);
    if (mounted) {
      setState(() {
        _methods = data.map((d) => PaymentMethod.fromMap(d)).toList();
        _loaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadMethods());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.paymentMethods,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPaymentSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addMethod, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: _methods.isEmpty
          ? _buildEmptyState()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
              children: [
                // Cards section
                ..._methods.where((m) => m.type == 'visa' || m.type == 'mastercard').map(
                  (method) => _buildCardItem(method),
                ),

                // Wallets section
                if (_methods.any((m) => m.type == 'apple_pay' || m.type == 'wallet')) ...[
                  const SizedBox(height: 24),
                  Text(
                    l.digitalWallets,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._methods.where((m) => m.type == 'apple_pay' || m.type == 'wallet').map(
                    (method) => _buildWalletItem(method),
                  ),
                ],

                const SizedBox(height: 32),

                // Security note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security_rounded, color: AppColors.secondary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.paymentInfoEncrypted,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.credit_card_off_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.noPaymentMethods,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.addCardOrWallet,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(PaymentMethod method) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: method.type == 'visa'
              ? [const Color(0xFF1A237E), const Color(0xFF3949AB)]
              : [const Color(0xFF212121), const Color(0xFF424242)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (method.type == 'visa'
                    ? const Color(0xFF1A237E)
                    : const Color(0xFF212121))
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCardOptions(method),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Card type logo
                    Icon(
                      method.type == 'visa'
                          ? Icons.credit_card_rounded
                          : Icons.credit_card_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    if (method.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l.defaultLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  '**** **** **** ${method.lastFour}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.cardType,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.6),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          method.label.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l.expires,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.6),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          method.expiryDate ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletItem(PaymentMethod method) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: method.isDefault
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showCardOptions(method),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    method.type == 'apple_pay'
                        ? Icons.apple_rounded
                        : Icons.account_balance_wallet_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.connected,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (method.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l.defaultLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCardOptions(PaymentMethod method) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                method.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (method.lastFour != null)
                Text(
                  '**** ${method.lastFour}',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              const SizedBox(height: 20),
              if (!method.isDefault)
                ListTile(
                  leading: const Icon(Icons.star_rounded, color: AppColors.primary),
                  title: Text(l.setAsDefault),
                  onTap: () {
                    _setDefault(method);
                    Navigator.pop(ctx);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: AppColors.error),
                title: Text(l.remove, style: const TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showRemoveDialog(method);
                },
              ),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _setDefault(PaymentMethod method) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() {
      _methods = _methods.map((m) {
        return m.copyWith(isDefault: m.id == method.id);
      }).toList();
    });
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.setDefaultPaymentMethod(user.uid, method.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${method.label} set as default'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showRemoveDialog(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l.removePaymentMethod),
          content: Text('Remove ${method.label}${method.lastFour != null ? ' ending in ${method.lastFour}' : ''}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () async {
                final user = ref.read(currentUserProvider);
                setState(() {
                  _methods.removeWhere((m) => m.id == method.id);
                });
                Navigator.pop(ctx);
                if (user != null) {
                  final firestoreService = ref.read(firestoreServiceProvider);
                  await firestoreService.deletePaymentMethod(user.uid, method.id);
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.paymentMethodRemoved),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              child: Text(l.remove, style: const TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  void _showAddPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _AddCardSheet(
          onCardAdded: (method) {
            setState(() {
              _methods.add(method);
            });
            final l = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.paymentMethodAdded),
                backgroundColor: AppColors.secondary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        );
      },
    );
  }
}

class _AddCardSheet extends StatefulWidget {
  final Function(PaymentMethod) onCardAdded;

  const _AddCardSheet({required this.onCardAdded});

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSaving = false;
  String _selectedType = 'card'; // card, apple_pay

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.addPaymentMethod,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildTypeOption('card', l.creditDebitCard, Icons.credit_card_rounded),
                const SizedBox(width: 12),
                _buildTypeOption('apple_pay', l.applePay, Icons.apple_rounded),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _selectedType == 'card' ? _buildCardForm() : _buildApplePayForm(),
            ),
          ),

          // Add button
          Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _addMethod,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : Text(
                        _selectedType == 'card' ? l.addCard : l.connectApplePay,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : AppColors.textHint, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          _cardNumberController,
          l.cardNumber,
          Icons.credit_card_rounded,
          keyboardType: TextInputType.number,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildField(
                _expiryController,
                l.mmyy,
                Icons.date_range_rounded,
                keyboardType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildField(
                _cvvController,
                l.cvv,
                Icons.lock_rounded,
                keyboardType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                obscure: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildField(
          _nameController,
          l.cardholderName,
          Icons.person_rounded,
        ),
      ],
    );
  }

  Widget _buildApplePayForm() {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.apple_rounded, size: 48, color: AppColors.textPrimary),
              const SizedBox(height: 16),
              Text(
                l.connectApplePay,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.useApplePayWallet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Future<void> _addMethod() async {
    final l = AppLocalizations.of(context)!;
    if (_selectedType == 'card') {
      final cardNum = _cardNumberController.text.replaceAll(' ', '');
      if (cardNum.length < 16 || _expiryController.text.length < 5 || _cvvController.text.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.pleaseCheckCardDetails),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    if (!mounted) return;

    final newMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType == 'card'
          ? (_cardNumberController.text.startsWith('4') ? 'visa' : 'mastercard')
          : 'apple_pay',
      label: _selectedType == 'card'
          ? (_cardNumberController.text.startsWith('4') ? 'Visa' : 'Mastercard')
          : 'Apple Pay',
      lastFour: _selectedType == 'card'
          ? _cardNumberController.text.replaceAll(' ', '').substring(
              _cardNumberController.text.replaceAll(' ', '').length - 4)
          : null,
      expiryDate: _selectedType == 'card' ? _expiryController.text : null,
    );

    widget.onCardAdded(newMethod);
    Navigator.pop(context);
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
