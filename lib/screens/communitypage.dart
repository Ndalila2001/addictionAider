import 'package:addiction_aider/consts/colors.dart';
import 'package:addiction_aider/screens/communitypagemore.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCD9EC),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Community',
            style: TextStyle(
              fontSize: 50,
              fontFamily: "Fatone",
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildCommunityCard(
                  context: context,
                  username: "her_excellency",
                  type: "STORY",
                  content:
                      "I was lost in my addiction, every day felt like a battle I couldn't win. It controlled my life, took everything from me everything from my family and all that I loved. I was a slave to my addiction, and I didn't know how to break free.",
                ),
                _buildCommunityCard(
                  context: context,
                  username: "Sara_Jones",
                  type: "ARTICLE",
                  content:
                      "I knew I had to stop, but I just couldn't! I knew I had to stop when I woke up naked in the street...",
                ),
                _buildCommunityCard(
                  context: context,
                  username: "CatMania",
                  type: "ARTICLE",
                  content:
                      "He woke up every morning craving the escape, drowning in a haze of temporary relief. Friends turned away...",
                ),
                _buildCommunityCard(
                  context: context,
                  username: "John Angula",
                  type: "STORY",
                  content:
                      "I remember the first time I encountered pornography! I was just a teenager, unsure of my own identity...",
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          // Add navigation or action for creating new post
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF28E07E),
        ),
      ),
        child: const Icon(
          LucideIcons.plus,
          color: Colors.black,
          size: 28,
        ),
    )
    );
  }

  Widget _buildCommunityCard({
    required BuildContext context,
    required String username,
    required String type,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF28E07E), width: 2),
        ),
        color: const Color(0xFFDCD9EC),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Baloo",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: type == "STORY" ? Colors.green[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontFamily: "Fatone",
                        fontSize: 12,
                        color: type == "STORY" ? Colors.green[800] : Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14, 
                  height: 1.4,
                  fontFamily: "Baloo",
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Communitypagemore(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFF28E07E)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: const Text(
                    "READ MORE",
                    style: TextStyle(
                      fontFamily: "Fatone",
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}