import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_flutter_app/screens/profile_screen.dart';
import 'package:my_flutter_app/screens/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(Icons.task_alt_rounded,
                color: Theme.of(context).colorScheme.primary, size: 24.sp),
            Text(
              'TaskMaster Pro',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.task,
                    label: "Tasks",
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TasksScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.person,
                    label: "Profile",
                    color: Theme.of(context).colorScheme.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              "Recent Activity",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            _buildDummyList(),
            SizedBox(height: 24.h),
            Text(
              "Your Stats",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            _buildStatsSection(context),
            SizedBox(height: 24.h),
            Text(
              "Tips for Productivity",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8.h),
            _buildTipsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36.sp, color: Colors.white),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummyList() {
    final items = [
      "Completed Task: Buy groceries",
      "Added new task: Finish Flutter app",
      "Marked task 'Workout' as done",
    ];
    return Column(
      children: items
          .map(
            (e) => Card(
              color: Theme.of(context).colorScheme.surfaceContainer,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(e),
                subtitle: const Text("Just now"),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        _buildStatBox(context, "Tasks", "24"),
        SizedBox(width: 12.w),
        _buildStatBox(context, "Completed", "18"),
        SizedBox(width: 12.w),
        _buildStatBox(context, "Pending", "6"),
      ],
    );
  }

  Widget _buildStatBox(BuildContext context, String title, String value) {
    return Expanded(
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            "Plan your day ahead.\n"
            "Focus on one task at a time.\n"
            "Take short breaks for better productivity.",
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
