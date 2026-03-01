import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/issue.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  
  bool _emailNotifications = true;
  bool _webPushNotifications = true;
  bool _statusChangeNotifications = true;
  bool _resolvedNotifications = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreService = FirestoreService();

    _nameController.text = authProvider.currentUser?.name ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 32),
          _buildBasicInfo(authProvider),
          SizedBox(height: 24),
          _buildActivitySummary(firestoreService, authProvider),
          SizedBox(height: 24),
          _buildNotificationPreferences(),
          SizedBox(height: 24),
          _buildAccountSettings(authProvider),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Color(0xFF1E293B), Color(0xFF4F46E5)],
      ).createShader(bounds),
      child: Text(
        'My Profile',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.8,
        ),
      ),
    );
  }

  Widget _buildBasicInfo(AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Text(
                      authProvider.currentUser?.name[0].toUpperCase() ?? 'U',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.currentUser?.name ?? 'User',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          authProvider.currentUser?.email ?? '',
                          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Divider(color: Color(0xFFE2E8F0)),
              SizedBox(height: 24),
              _buildInfoField(
                icon: Icons.person_rounded,
                label: 'Full Name',
                controller: _nameController,
              ),
              SizedBox(height: 16),
              _buildInfoField(
                icon: Icons.email_rounded,
                label: 'Email',
                value: authProvider.currentUser?.email ?? '',
                readOnly: true,
              ),
              SizedBox(height: 16),
              _buildInfoField(
                icon: Icons.phone_rounded,
                label: 'Phone Number',
                controller: _phoneController,
                hint: 'Enter phone number (optional)',
              ),
              SizedBox(height: 16),
              _buildInfoField(
                icon: Icons.location_city_rounded,
                label: 'City / Area',
                controller: _cityController,
                hint: 'Enter your city (optional)',
              ),
              SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Member Since',
                value: DateFormat('MMMM dd, yyyy').format(authProvider.currentUser?.createdAt ?? DateTime.now()),
              ),
              SizedBox(height: 24),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySummary(FirestoreService firestoreService, AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Activity Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              StreamBuilder<List<Issue>>(
                stream: firestoreService.getIssuesByUser(authProvider.currentUser!.uid),
                builder: (context, snapshot) {
                  final issues = snapshot.data ?? [];
                  final inProgress = issues.where((i) => i.status == 'In Progress').length;
                  final resolved = issues.where((i) => i.status == 'Resolved').length;
                  final lastReport = issues.isNotEmpty ? issues.first.createdAt : null;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildStatBox('Total Reports', issues.length.toString(), Icons.description_rounded, [Color(0xFF4F46E5), Color(0xFF6366F1)])),
                          SizedBox(width: 16),
                          Expanded(child: _buildStatBox('In Progress', inProgress.toString(), Icons.autorenew_rounded, [Color(0xFF8B5CF6), Color(0xFFA78BFA)])),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildStatBox('Resolved', resolved.toString(), Icons.check_circle_rounded, [Color(0xFF10B981), Color(0xFF34D399)])),
                          SizedBox(width: 16),
                          Expanded(child: _buildStatBox('Last Report', lastReport != null ? DateFormat('MMM dd').format(lastReport) : 'N/A', Icons.schedule_rounded, [Color(0xFFF59E0B), Color(0xFFFBBF24)])),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.notifications_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Notification Preferences',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildToggleOption('Email Notifications', _emailNotifications, (val) => setState(() => _emailNotifications = val)),
              _buildToggleOption('Web Push Notifications', _webPushNotifications, (val) => setState(() => _webPushNotifications = val)),
              _buildToggleOption('Notify on Status Changes', _statusChangeNotifications, (val) => setState(() => _statusChangeNotifications = val)),
              _buildToggleOption('Notify When Issue Resolved', _resolvedNotifications, (val) => setState(() => _resolvedNotifications = val)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSettings(AuthProvider authProvider) {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFF87171)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Account Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildActionButton('Change Password', Icons.lock_rounded, Color(0xFF4F46E5), () {}),
              SizedBox(height: 12),
              _buildActionButton('Update Profile Info', Icons.edit_rounded, Color(0xFF10B981), () {}),
              SizedBox(height: 12),
              _buildActionButton('Logout', Icons.logout_rounded, Color(0xFFF59E0B), () async {
                await authProvider.signOut();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/');
              }),
              SizedBox(height: 12),
              _buildActionButton('Delete Account', Icons.delete_forever_rounded, Color(0xFFEF4444), () => _showDeleteDialog()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required IconData icon,
    required String label,
    TextEditingController? controller,
    String? value,
    String? hint,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Color(0xFF64748B)),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF4F46E5), width: 2),
            ),
            filled: true,
            fillColor: readOnly ? Color(0xFFF1F5F9) : Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.all(14),
          ),
          style: TextStyle(fontSize: 15, color: Color(0xFF1E293B)),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFF64748B)),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        Spacer(),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, List<Color> colors) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors.map((c) => c.withOpacity(0.1)).toList()),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors[0].withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors[0], size: 28),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF4F46E5),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 12),
              Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully! 🎉'), backgroundColor: Color(0xFF10B981)),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF6366F1)]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: Text(
            'Save Changes',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account deletion requested'), backgroundColor: Color(0xFFEF4444)),
              );
            },
            child: Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }
}
