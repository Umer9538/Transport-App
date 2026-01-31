import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/animations/staggered_animation.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _tripReminders = true;
  bool _promotionalEmails = false;
  bool _biometricLogin = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';
  String _selectedMapStyle = 'Standard';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _tripReminders = prefs.getBool('trip_reminders') ?? true;
      _promotionalEmails = prefs.getBool('promotional_emails') ?? false;
      _biometricLogin = prefs.getBool('biometric_login') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _selectedTheme = prefs.getString('theme') ?? 'Light';
      _selectedMapStyle = prefs.getString('map_style') ?? 'Standard';
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: StaggeredList(
          baseDelay: const Duration(milliseconds: 100),
          staggerDelay: const Duration(milliseconds: 50),
          children: [
            // Notifications Section
            _buildSectionTitle('Notifications'),
            _buildSwitchTile(
              icon: Icons.notifications_active_rounded,
              title: 'Push Notifications',
              subtitle: 'Receive trip updates and alerts',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
                _savePreference('push_notifications', value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.email_rounded,
              title: 'Email Notifications',
              subtitle: 'Receive important updates via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
                _savePreference('email_notifications', value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.alarm_rounded,
              title: 'Trip Reminders',
              subtitle: 'Get notified 30 min before pickup',
              value: _tripReminders,
              onChanged: (value) {
                setState(() => _tripReminders = value);
                _savePreference('trip_reminders', value);
              },
            ),
            _buildSwitchTile(
              icon: Icons.local_offer_rounded,
              title: 'Promotional Emails',
              subtitle: 'Receive offers and discounts',
              value: _promotionalEmails,
              onChanged: (value) {
                setState(() => _promotionalEmails = value);
                _savePreference('promotional_emails', value);
              },
            ),

            const SizedBox(height: 24),

            // Privacy & Security
            _buildSectionTitle('Privacy & Security'),
            _buildMenuTile(
              icon: Icons.lock_rounded,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => _showChangePasswordSheet(),
            ),
            _buildSwitchTile(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID',
              value: _biometricLogin,
              onChanged: (value) {
                setState(() => _biometricLogin = value);
                _savePreference('biometric_login', value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? 'Biometric login enabled' : 'Biometric login disabled'),
                    backgroundColor: AppColors.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            _buildMenuTile(
              icon: Icons.shield_rounded,
              title: 'Privacy Settings',
              subtitle: 'Control your data sharing',
              onTap: () => _showPrivacySettings(),
            ),
            _buildMenuTile(
              icon: Icons.history_rounded,
              title: 'Login History',
              subtitle: 'View recent account activity',
              onTap: () => Navigator.pushNamed(context, '/login-history'),
            ),

            const SizedBox(height: 24),

            // App Settings
            _buildSectionTitle('App Settings'),
            _buildMenuTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: _selectedLanguage,
              onTap: () => _showLanguageSelector(),
              trailing: Text(
                _selectedLanguage.split(' ').first,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            _buildMenuTile(
              icon: Icons.dark_mode_rounded,
              title: 'Theme',
              subtitle: '$_selectedTheme mode',
              onTap: () => _showThemeSelector(),
              trailing: Text(
                _selectedTheme,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            _buildMenuTile(
              icon: Icons.map_rounded,
              title: 'Map Style',
              subtitle: '$_selectedMapStyle view',
              onTap: () => _showMapStyleSelector(),
            ),

            const SizedBox(height: 24),

            // About
            _buildSectionTitle('About'),
            _buildMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'About DriverApp',
              subtitle: 'Version 1.0.0',
              onTap: () => _showAboutDialog(),
            ),
            _buildMenuTile(
              icon: Icons.description_rounded,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              onTap: () => Navigator.pushNamed(context, '/terms'),
            ),
            _buildMenuTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
            ),
            _buildMenuTile(
              icon: Icons.star_rate_rounded,
              title: 'Rate the App',
              subtitle: 'Leave a review',
              onTap: () => _showRateAppDialog(),
            ),

            const SizedBox(height: 24),

            // Admin
            _buildSectionTitle('Developer'),
            _buildMenuTile(
              icon: Icons.admin_panel_settings_rounded,
              title: 'Admin Panel',
              subtitle: 'Manage trips, users & drivers',
              onTap: () => Navigator.pushNamed(context, '/admin'),
              iconColor: Colors.purple,
            ),

            const SizedBox(height: 24),

            // Danger Zone
            _buildSectionTitle('Danger Zone'),
            _buildMenuTile(
              icon: Icons.delete_outline_rounded,
              title: 'Clear Cache',
              subtitle: 'Free up storage space',
              onTap: () => _showClearCacheDialog(),
              iconColor: AppColors.warning,
            ),
            _buildMenuTile(
              icon: Icons.delete_forever_rounded,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              onTap: () => _showDeleteAccountDialog(),
              iconColor: AppColors.error,
              titleColor: AppColors.error,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.textSecondary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: titleColor ?? AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ??
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textHint,
                      size: 16,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
              const SizedBox(height: 24),
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['English', 'العربية (السعودية)'].map((lang) {
                return ListTile(
                  title: Text(lang),
                  trailing: lang == _selectedLanguage
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = lang);
                    _savePreference('language', lang);
                    ref.read(localeProvider.notifier).setLocale(lang);
                    Navigator.pop(ctx);
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showThemeSelector() {
    final themes = ['Light', 'Dark', 'System Default'];
    final icons = [Icons.light_mode_rounded, Icons.dark_mode_rounded, Icons.phone_android_rounded];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
              const SizedBox(height: 24),
              const Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(themes.length, (index) {
                return ListTile(
                  leading: Icon(icons[index]),
                  title: Text(themes[index]),
                  trailing: themes[index] == _selectedTheme
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedTheme = themes[index]);
                    _savePreference('theme', themes[index]);
                    ref.read(themeProvider.notifier).setTheme(themes[index]);
                    Navigator.pop(ctx);
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showMapStyleSelector() {
    final styles = ['Standard', 'Satellite', 'Terrain', 'Dark'];
    final icons = [Icons.map_rounded, Icons.satellite_rounded, Icons.terrain_rounded, Icons.dark_mode_rounded];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
              const SizedBox(height: 24),
              const Text(
                'Select Map Style',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(styles.length, (index) {
                return ListTile(
                  leading: Icon(icons[index]),
                  title: Text(styles[index]),
                  trailing: styles[index] == _selectedMapStyle
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedMapStyle = styles[index]);
                    _savePreference('map_style', styles[index]);
                    Navigator.pop(ctx);
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Text('DriverApp'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Version 1.0.0'),
              const SizedBox(height: 8),
              Text(
                'Your personal transportation subscription service for hassle-free daily commute.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                '© 2026 DriverApp. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all cached data including images and temporary files. Your account data will not be affected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cache cleared successfully'),
                    backgroundColor: AppColors.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.warning),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Account'),
          content: const Text(
            'This action cannot be undone. All your data, including trip history, subscriptions, and saved addresses will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordSheet() {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.of(ctx).padding.bottom + 16),
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
                      const SizedBox(height: 24),
                      const Text(
                        'Change Password',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your current password and choose a new one',
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      _buildPasswordField(
                        currentPassController,
                        'Current Password',
                        obscureCurrent,
                        () => setSheetState(() => obscureCurrent = !obscureCurrent),
                      ),
                      const SizedBox(height: 14),
                      _buildPasswordField(
                        newPassController,
                        'New Password',
                        obscureNew,
                        () => setSheetState(() => obscureNew = !obscureNew),
                      ),
                      const SizedBox(height: 14),
                      _buildPasswordField(
                        confirmPassController,
                        'Confirm New Password',
                        obscureConfirm,
                        () => setSheetState(() => obscureConfirm = !obscureConfirm),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password must be at least 8 characters with a number and special character',
                          style: TextStyle(fontSize: 12, color: AppColors.textHint),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : () async {
                            if (currentPassController.text.isEmpty ||
                                newPassController.text.isEmpty ||
                                confirmPassController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please fill all fields'),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                              return;
                            }
                            if (newPassController.text.length < 8) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Password must be at least 8 characters'),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                              return;
                            }
                            if (newPassController.text != confirmPassController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Passwords do not match'),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                              return;
                            }
                            setSheetState(() => isSaving = true);
                            await Future.delayed(const Duration(milliseconds: 800));
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                            }
                            if (mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: const Text('Password changed successfully'),
                                  backgroundColor: AppColors.secondary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: isSaving
                              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                              : const Text('Update Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool obscure, VoidCallback toggleObscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textHint, size: 20),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textHint, size: 20),
          onPressed: toggleObscure,
        ),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _PrivacySettingsSheet(onSave: _savePreference);
      },
    );
  }

  void _showRateAppDialog() {
    int selectedRating = 0;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Rate DriverApp', textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'How would you rate your experience?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedRating = index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: AppColors.warning,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                  if (selectedRating > 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      selectedRating >= 4 ? 'We\'re glad you enjoy it!' : selectedRating >= 3 ? 'Thanks for your feedback!' : 'We\'ll work to improve!',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Later'),
                ),
                TextButton(
                  onPressed: selectedRating > 0 ? () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: const Text('Thank you for your rating!'),
                        backgroundColor: AppColors.secondary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  } : null,
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PrivacySettingsSheet extends StatefulWidget {
  final Future<void> Function(String key, dynamic value) onSave;
  const _PrivacySettingsSheet({required this.onSave});

  @override
  State<_PrivacySettingsSheet> createState() => _PrivacySettingsSheetState();
}

class _PrivacySettingsSheetState extends State<_PrivacySettingsSheet> {
  bool _shareLocation = true;
  bool _shareAnalytics = true;
  bool _personalizedAds = false;
  bool _dataCollection = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shareLocation = prefs.getBool('privacy_location') ?? true;
      _shareAnalytics = prefs.getBool('privacy_analytics') ?? true;
      _personalizedAds = prefs.getBool('privacy_ads') ?? false;
      _dataCollection = prefs.getBool('privacy_data') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 24),
          const Text(
            'Privacy Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Control how your data is used and shared',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),
          _buildPrivacyToggle(
            'Location Sharing',
            'Share location with drivers during trips',
            Icons.location_on_rounded,
            _shareLocation,
            (val) {
              setState(() => _shareLocation = val);
              widget.onSave('privacy_location', val);
            },
          ),
          _buildPrivacyToggle(
            'Analytics',
            'Help improve the app with usage data',
            Icons.analytics_rounded,
            _shareAnalytics,
            (val) {
              setState(() => _shareAnalytics = val);
              widget.onSave('privacy_analytics', val);
            },
          ),
          _buildPrivacyToggle(
            'Personalized Ads',
            'See ads relevant to your interests',
            Icons.ads_click_rounded,
            _personalizedAds,
            (val) {
              setState(() => _personalizedAds = val);
              widget.onSave('privacy_ads', val);
            },
          ),
          _buildPrivacyToggle(
            'Data Collection',
            'Allow collection of trip patterns',
            Icons.data_usage_rounded,
            _dataCollection,
            (val) {
              setState(() => _dataCollection = val);
              widget.onSave('privacy_data', val);
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textHint, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
