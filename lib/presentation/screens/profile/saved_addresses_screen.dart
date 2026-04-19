import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/models/address_model.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class SavedAddressesScreen extends ConsumerStatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  ConsumerState<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends ConsumerState<SavedAddressesScreen> {
  List<AddressModel> _addresses = [];
  bool _loaded = false;

  void _loadAddresses(dynamic user) {
    if (!_loaded && user != null) {
      _addresses = List.from(user.savedAddresses);
      if (_addresses.isEmpty) {
        // Add sample addresses for testing
        _addresses = [
          AddressModel(
            id: '1',
            title: 'Home',
            type: AddressType.home,
            address: '123 Main Street, Downtown',
            buildingName: 'Sunrise Apartments',
            floor: '5',
            apartment: '502',
            latitude: 24.7136,
            longitude: 46.6753,
            isDefault: true,
          ),
          AddressModel(
            id: '2',
            title: 'Work',
            type: AddressType.work,
            address: '456 Business Avenue, Financial District',
            buildingName: 'Tower One',
            floor: '12',
            latitude: 24.7236,
            longitude: 46.6853,
            isDefault: false,
          ),
        ];
      }
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserDataProvider);

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
          l.savedAddresses,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(null),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addAddress, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: userAsync.when(
        data: (user) {
          _loadAddresses(user);

          if (_addresses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            itemCount: _addresses.length,
            itemBuilder: (context, index) {
              return _buildAddressCard(_addresses[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading addresses')),
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
              Icons.location_off_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.noSavedAddresses,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.addFrequentlyVisitedPlaces,
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

  Widget _buildAddressCard(AddressModel address) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showAddEditDialog(address),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(address.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(address.type),
                    color: _getTypeColor(address.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.fullAddress,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Actions
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: AppColors.textHint, size: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddEditDialog(address);
                    } else if (value == 'default') {
                      _setDefault(address);
                    } else if (value == 'delete') {
                      _showDeleteDialog(address);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_rounded, size: 18),
                          const SizedBox(width: 10),
                          Text(l.edit),
                        ],
                      ),
                    ),
                    if (!address.isDefault)
                      PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 18),
                            const SizedBox(width: 10),
                            Text(l.setAsDefault),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                          const SizedBox(width: 10),
                          Text(l.delete, style: const TextStyle(color: AppColors.error)),
                        ],
                      ),
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

  Future<void> _persistAddresses() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateSavedAddresses(user.uid, _addresses);
  }

  void _setDefault(AddressModel address) {
    setState(() {
      _addresses = _addresses.map((a) {
        return a.copyWith(isDefault: a.id == address.id);
      }).toList();
    });
    _persistAddresses();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${address.title} set as default'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeleteDialog(AddressModel address) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l.deleteAddress),
          content: Text('Are you sure you want to delete "${address.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _addresses.removeWhere((a) => a.id == address.id);
                });
                _persistAddresses();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.addressDeleted),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Text(l.delete, style: const TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  void _showAddEditDialog(AddressModel? address) {
    final isEditing = address != null;
    final titleController = TextEditingController(text: address?.title ?? '');
    final addressController = TextEditingController(text: address?.address ?? '');
    final buildingController = TextEditingController(text: address?.buildingName ?? '');
    final floorController = TextEditingController(text: address?.floor ?? '');
    final apartmentController = TextEditingController(text: address?.apartment ?? '');
    final landmarkController = TextEditingController(text: address?.landmark ?? '');
    AddressType selectedType = address?.type ?? AddressType.home;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle
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
                    isEditing ? l.editAddress : l.addNewAddress,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type selector
                          Text(
                            l.addressType,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: AddressType.values.map((type) {
                              final isSelected = type == selectedType;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setSheetState(() => selectedType = type);
                                    if (titleController.text.isEmpty ||
                                        AddressType.values.any(
                                            (t) => t.localizedName(l) == titleController.text)) {
                                      titleController.text = type.localizedName(l);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(alpha: 0.1)
                                          : AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.divider,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          _getTypeIcon(type),
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textHint,
                                          size: 22,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          type.localizedName(l),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),
                          _buildSheetField(titleController, l.label, Icons.label_rounded),
                          const SizedBox(height: 14),
                          _buildSheetField(addressController, l.streetAddress, Icons.location_on_rounded),
                          const SizedBox(height: 14),
                          _buildSheetField(buildingController, l.buildingName, Icons.apartment_rounded),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSheetField(floorController, l.floor, Icons.layers_rounded),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSheetField(apartmentController, l.aptUnit, Icons.door_front_door_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildSheetField(landmarkController, l.landmark, Icons.place_rounded),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // Save button
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(ctx).padding.bottom + 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty ||
                              addressController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l.labelAndAddressRequired),
                                backgroundColor: AppColors.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            return;
                          }

                          final newAddress = AddressModel(
                            id: address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleController.text.trim(),
                            type: selectedType,
                            address: addressController.text.trim(),
                            buildingName: buildingController.text.trim().isEmpty
                                ? null : buildingController.text.trim(),
                            floor: floorController.text.trim().isEmpty
                                ? null : floorController.text.trim(),
                            apartment: apartmentController.text.trim().isEmpty
                                ? null : apartmentController.text.trim(),
                            landmark: landmarkController.text.trim().isEmpty
                                ? null : landmarkController.text.trim(),
                            latitude: address?.latitude ?? 24.7136,
                            longitude: address?.longitude ?? 46.6753,
                            isDefault: address?.isDefault ?? _addresses.isEmpty,
                          );

                          setState(() {
                            if (isEditing) {
                              final index = _addresses.indexWhere((a) => a.id == address.id);
                              if (index != -1) _addresses[index] = newAddress;
                            } else {
                              _addresses.add(newAddress);
                            }
                          });
                          _persistAddresses();

                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(isEditing ? l.addressUpdated : l.addressAdded),
                              backgroundColor: AppColors.secondary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isEditing ? l.updateAddress : l.saveAddress,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
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

  IconData _getTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Icons.home_rounded;
      case AddressType.work:
        return Icons.work_rounded;
      case AddressType.school:
        return Icons.school_rounded;
      case AddressType.other:
        return Icons.location_on_rounded;
    }
  }

  Color _getTypeColor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return AppColors.primary;
      case AddressType.work:
        return AppColors.secondary;
      case AddressType.school:
        return AppColors.warning;
      case AddressType.other:
        return AppColors.textSecondary;
    }
  }
}
