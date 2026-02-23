import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onJournalTap;
  final VoidCallback onMoodsTap;
  final VoidCallback onProfileTap;
  final VoidCallback onFabTap;

  const CustomBottomNavbar({
    super.key,
    required this.onHomeTap,
    required this.onJournalTap,
    required this.onMoodsTap,
    required this.onProfileTap,
    required this.  onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [

          /// Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home, "Home", onHomeTap),
                  _navItem(Icons.menu_book, "Journal", onJournalTap),

                  SizedBox(width: 50),

                  _navItem(Icons.calendar_month, "Moods", onMoodsTap),
                  _navItem(Icons.person, "Profile", onProfileTap),
                ],
              ),
            ),
          ),

          /// FAB
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onFabTap,
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Color(0xFF8E75B8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 30),
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
          Icon(icon, color: Colors.grey),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}