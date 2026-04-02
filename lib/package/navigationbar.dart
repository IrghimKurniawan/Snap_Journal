import 'package:flutter/material.dart';
import 'package:snap_journal/services/theme_extension.dart';

class CustomBottomNavbar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onJournalTap;
  final VoidCallback onInsightTap;
  final VoidCallback onProfileTap;
  final VoidCallback onFabTap;

  const CustomBottomNavbar({
    super.key,
    required this.onHomeTap,
    required this.onJournalTap,
    required this.onInsightTap,
    required this.onProfileTap,
    required this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.watchPrimaryColor;
    final bg = context.scaffoldColor;

    return Container(
      height: 90,
      color: bg,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home, "Home", onHomeTap),
                  _navItem(Icons.menu_book, "Journal", onJournalTap),
                  const SizedBox(width: 50),
                  _navItem(Icons.calendar_month, "Insight", onInsightTap),
                  _navItem(Icons.person, "Profile", onProfileTap),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onFabTap,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: bg, width: 5),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueGrey),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
        ],
      ),
    );
  }
}
