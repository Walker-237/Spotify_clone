import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(top: BorderSide(color: Color(0xFF282828), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, Icons.home_outlined, 'Home', 0),
              _navItem(Icons.search_rounded, Icons.search_outlined, 'Search', 1),
              _libraryNavItem(2),
              _faNavItem(FontAwesomeIcons.spotify, 'Premium', 3),
              _navItem(Icons.add_circle, Icons.add_circle_outline, 'Create', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData active, IconData inactive, String label, int idx) {
    final on = selected == idx;
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          on ? active : inactive,
          color: on ? Colors.white : const Color(0xFFB3B3B3),
          size: 26,
        ),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(
          color: on ? Colors.white : const Color(0xFFB3B3B3),
          fontSize: 10,
          fontWeight: on ? FontWeight.w700 : FontWeight.w400,
        )),
      ]),
    );
  }

  Widget _faNavItem(IconData icon, String label, int idx) {
    final on = selected == idx;
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        FaIcon(icon,
            color: on ? Colors.white : const Color(0xFFB3B3B3), size: 24),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(
          color: on ? Colors.white : const Color(0xFFB3B3B3),
          fontSize: 10,
          fontWeight: on ? FontWeight.w700 : FontWeight.w400,
        )),
      ]),
    );
  }

  Widget _libraryNavItem(int idx) {
    final on = selected == idx;
    final color = on ? Colors.white : const Color(0xFFB3B3B3);
    return GestureDetector(
      onTap: () => onTap(idx),
      behavior: HitTestBehavior.opaque,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 4, height: 14,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 2),
            Container(
              width: 4, height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 2),
            Container(
              width: 4, height: 17,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text('Your Library', style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: on ? FontWeight.w700 : FontWeight.w400,
        )),
      ]),
    );
  }
}