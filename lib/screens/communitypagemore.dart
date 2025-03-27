import 'package:addiction_aider/consts/colors.dart';
import 'package:flutter/material.dart';

class Communitypagemore extends StatefulWidget {
  const Communitypagemore({super.key});

  @override
  State<Communitypagemore> createState() => _CommunitypagemoreState();
}

class _CommunitypagemoreState extends State<Communitypagemore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secColor,
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Her_Excellency',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: "Baloo",
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}