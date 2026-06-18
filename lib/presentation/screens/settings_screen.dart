import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedUnit = 'Celsius (°C)';
  String _selectedTheme = 'Dark';
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // General Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'General',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Unit Setting
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: const Text(
                'Unit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedUnit,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
              onTap: () {
                _showUnitDialog();
              },
            ),
          ),
          const SizedBox(height: 12),
          // Theme Setting
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: const Text(
                'Theme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedTheme,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
              onTap: () {
                _showThemeDialog();
              },
            ),
          ),
          const SizedBox(height: 24),
          // Notifications Section Header
          Text(
            'Notifications',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Notifications Toggle
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // About App Section
          Text(
            'About',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // About App
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              title: const Text(
                'About App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey.shade600,
              ),
              onTap: () {
                _showAboutDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUnitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Select Unit',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUnitOption('Celsius (°C)'),
              _buildUnitOption('Fahrenheit (°F)'),
              _buildUnitOption('Kelvin (K)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitOption(String unit) {
    return ListTile(
      title: Text(
        unit,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Radio<String>(
        value: unit,
        groupValue: _selectedUnit,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedUnit = value;
            });
          }
          Navigator.pop(context);
        },
        activeColor: const Color(0xFF4FC3F7),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Select Theme',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption('Light'),
              _buildThemeOption('Dark'),
              _buildThemeOption('System'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(String theme) {
    return ListTile(
      title: Text(
        theme,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Radio<String>(
        value: theme,
        groupValue: _selectedTheme,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedTheme = value;
            });
          }
          Navigator.pop(context);
        },
        activeColor: const Color(0xFF4FC3F7),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'About App',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A beautiful and intuitive weather application that provides real-time weather information and forecasts.',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 Weather App. All rights reserved.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF4FC3F7)),
            ),
          ),
        ],
      ),
    );
  }
}
