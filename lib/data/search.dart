import 'package:flutter/material.dart';
import 'package:flutter_application_4/data/Appbar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: const Color(0xfff2f2f2),
          radius: 25,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                    colors: [Color(0xfff2f2f2), Color(0xffc89feb)])),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const Data())));
              },
              icon: const Icon(Icons.arrow_back),
              iconSize: 30,
            ),
          ),
        ),
        backgroundColor: const Color(0xffc89feb),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(200))),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SizedBox(),
        ),
      ),
    );
  }
}
