import 'package:addiction_aider/screens/chatbot.dart';
import 'package:addiction_aider/screens/chatspage.dart';
import 'package:addiction_aider/screens/homepage.dart';
import 'package:addiction_aider/screens/notespage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'communitypage.dart';

class MainHomeManger extends StatefulWidget {
  const MainHomeManger({super.key});

  @override
  State<MainHomeManger> createState() => _MainHomeMangerState();
}

class _MainHomeMangerState extends State<MainHomeManger> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CommunityPage(),
    const ChatBotApp(),
    const Homepage(),
    const Chatspage(),
    const Notespage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD9EC),
      drawer: const CustomDrawer(), // Attach the drawer here
      appBar: AppBar(
        backgroundColor: const Color(0xFF28E07E),
        elevation: 0,
        leading: Builder(
          
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: const Color(0xFF28E07E),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          child: GNav(
            gap: 8,
            activeColor: Colors.black,
            iconSize: 30,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: const Color(0xFFDCD9EC),
            backgroundColor: Colors.transparent,
            tabs: const [
              GButton(icon: LucideIcons.usersRound, text: 'Community'),
              GButton(icon: LucideIcons.botMessageSquare, text: 'AI ChatBot'),
              GButton(icon: LucideIcons.house, text: 'Home'),
              GButton(icon: LucideIcons.messageCircle, text: 'Chats'),
              GButton(icon: LucideIcons.notebookPen, text: 'Notes'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF28E07E),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                children: [
                  DrawerItem(
                      icon: LucideIcons.userRound,
                      text: "PROFILE",
                      onTap: () {}),
                  DrawerItem(
                      icon: LucideIcons.heartHandshake,
                      text: "DONATIONS",
                      onTap: () {}),
                  DrawerItem(
                      icon: LucideIcons.star,
                      text: "UPGRADE TO PREMIUM",
                      onTap: () {}),
                  DrawerItem(
                      icon: LucideIcons.handshake,
                      text: "ADD MONITORING PARTNER",
                      onTap: () {}),    
                  DrawerItem(
                      icon: LucideIcons.settings,
                      text: "SETTINGS",
                      onTap: () {}),
                  const SizedBox(height: 80),
                  const Text(
                    "APP VERSION 0.1 BETA",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Fatone',
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Drawer Menu Item Widget
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerItem(
      {required this.icon, required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Baloo',
                  fontSize: 18,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
