import 'package:flutter/material.dart';
import 'package:my_flutter_app/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? 'user@example.com';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final selectedMode = provider.mode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.w,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      _email != null && _email!.isNotEmpty
                          ? _email![0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    _email ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Member since 2024",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                leading: const Icon(Icons.brightness_6),
                title: const Text("Dark Mode"),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AppThemeMode>(
                      value: selectedMode,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (AppThemeMode? newValue) {
                        if (newValue != null) {
                          provider.setTheme(newValue);
                        }
                      },
                      items: AppThemeMode.values.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(
                            mode.name[0].toUpperCase() + mode.name.substring(1),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Edit Profile"),
                      onTap: () {},
                    ),
                    Divider(
                      height: 0.1,
                      color:
                          Theme.of(context).colorScheme.onPrimary.withAlpha(30),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text("Change Password"),
                      onTap: () {},
                    ),
                    Divider(
                      height: 0.1,
                      color:
                          Theme.of(context).colorScheme.onPrimary.withAlpha(30),
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text("Notification Settings"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
