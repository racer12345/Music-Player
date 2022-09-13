// ignore_for_file: file_names, unnecessary_new

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/data/MusicList.dart';
import 'package:flutter_application_4/data/Play.dart';
import 'package:flutter_application_4/provider/songprovi.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainB extends StatefulWidget {
  const MainB({super.key});

  @override
  State<MainB> createState() => _MainBState();
}

class _MainBState extends State<MainB> {
  bool isPlay = false;
  final OnAudioQuery _audioquery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  double value = 30;
  List<SongModel> allsongs = [];

  playSong(uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      _audioPlayer.play();
    } catch (e) {
      log("ERROR");
    }
  }

  @override
  void initState() {
    super.initState();
    request();
  }

  void request() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioquery.permissionsStatus();
      if (!permissionStatus) {
        await _audioquery.permissionsRequest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff45abff),
        body: Stack(children: [
          FutureBuilder<List<SongModel>>(
            future: _audioquery.querySongs(
              sortType: null,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
            ),
            builder: (context, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(child: Text("No songs found"));
              }
              //this widget is help to show your song in app
              return Stack(children: [
                ListView.builder(
                  itemCount: item.data!.length,
                  itemBuilder: (context, index) {
                    allsongs.addAll(item.data!);
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<SongModelProvider>()
                            .setId(item.data![index].id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Play(
                                    songModelList: [item.data![index]],
                                    audioplayer: _audioPlayer)));
                      },
                      child: MusicTile(
                        songModel: item.data![index],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 600, left: 200),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: const Color(0xfff2f2f2),
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
                          gradient: LinearGradient(
                              colors: [Color(0xfff2f2f2), Color(0xffc89feb)])),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Play(
                                        songModelList: allsongs,
                                        audioplayer: _audioPlayer)));
                          },
                          icon: Icon(
                            isPlay ? Icons.play_arrow : Icons.pause,
                          )),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ]));
  }
}
