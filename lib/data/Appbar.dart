// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_4/MainB.dart';
import 'package:flutter_application_4/search.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff45abff),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              size: 40,
            ),
          ),
          backgroundColor: const Color(0xffc89feb),
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(200))),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(200),
            child: Stack(children: [
              const Padding(
                padding: EdgeInsets.only(right: 250, bottom: 20),
                child: Text('Songs',
                    style: TextStyle(
                        fontFamily: 'Lobster',
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfff2f2f2))),
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 250, bottom: 30, top: 20),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xfff2f2f2),
                      radius: 30,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(5, 10),
                                  spreadRadius: 3,
                                  blurRadius: 10),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-3, -4),
                                  spreadRadius: -2,
                                  blurRadius: 20),
                            ],
                            gradient: LinearGradient(colors: [
                              Color(0xfff2f2f2),
                              Color(0xffc89feb)
                            ])),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Search()));
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Color(0xff45abff),
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
        body: const MainB());
  }
}
