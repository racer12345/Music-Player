// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../provider/songprovi.dart';

class Play extends StatefulWidget {
  const Play({Key? key, required this.songModelList, required this.audioplayer})
      : super(key: key);

  // song we create in MainBpage
  final List<SongModel> songModelList;
  // Audioplayer to play a song
  final AudioPlayer audioplayer;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  //duration of the song
  Duration duration = const Duration();
  //position of the song
  Duration position = const Duration();
  //to play a song is
  bool isplay = false;

  List<AudioSource> songList = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // duration position function
    songs();
  }

  void seektoSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioplayer.seek(duration);
  }

  void songs() {
    //we can use try function to try the code
    try {
      for (var element in widget.songModelList) {
        songList.add(
          AudioSource.uri(
            Uri.parse(element.uri!),
            tag: MediaItem(
              id: element.id.toString(),
              album: element.album ?? "No Album",
              title: element.displayNameWOExt,
              artUri: Uri.parse(element.id.toString()),
            ),
          ),
        );
      }

      widget.audioplayer.setAudioSource(
        ConcatenatingAudioSource(children: songList),
      );
      widget.audioplayer.play();
      isplay = true;

      //func duration
      widget.audioplayer.durationStream.listen((d) {
        setState(() {
          duration = d!;
        });
      });
      //func position
      widget.audioplayer.positionStream.listen((p) {
        setState(() {
          position = p;
        });
      });
      listenToEvent();
      listenToSongIndex();
    } catch (e) {
      log("ERROR");
    }
  }

  void listenToEvent() {
    widget.audioplayer.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          isplay = true;
        });
      } else {
        setState(() {
          isplay = false;
        });
      }
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          isplay = false;
        });
      }
    });
  }

  void listenToSongIndex() {
    widget.audioplayer.currentIndexStream.listen(
      (event) {
        setState(
          () {
            if (event != null) {
              currentIndex = event;
            }
            context
                .read<SongModelProvider>()
                .setId(widget.songModelList[currentIndex].id);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: const Color(0xff45abff),
        //we can use stack its easy to position any widget
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 400),
            child: Center(
              child: ArtworkWidget(widget: widget),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 125),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xffc89feb),
                child: Container(
                  height: 70,
                  width: 70,
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
                  //we can use if else function for play and pause icon change
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (isplay) {
                            widget.audioplayer.pause();
                          } else {
                            if (position >= duration) {
                              seektoSeconds(0);
                            } else {
                              widget.audioplayer.play();
                            }
                          }
                          isplay = !isplay;
                        });
                      },
                      icon: Icon(
                        isplay ? Icons.pause : Icons.play_arrow,
                        size: 35,
                        color: const Color(0xff45abff),
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 590, left: 45, right: 0),
            child: Container(
              height: width * 0.200,
              width: width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(5, 10), spreadRadius: 3, blurRadius: 10),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -4),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ],
                  color: const Color(0xfff2f2f2)),
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(position.toString().split('.')[0],
                        style: const TextStyle(
                          color: Color(0xffc89feb),
                        )),
                    Slider(
                      value: position.inSeconds.toDouble(),
                      min: const Duration(microseconds: 0).inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) => setState(() {
                        seektoSeconds(value.toInt());
                        value = value;
                      }),
                      activeColor: const Color(0xffc89feb),
                      inactiveColor: const Color(0xffc89feb),
                    ),
                    Text(duration.toString().split('.')[0],
                        style: const TextStyle(
                          color: Color(0xffc89feb),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xfff2f2f2),
                child: Container(
                  height: 40,
                  width: 40,
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
                      onPressed: () {},
                      icon: const Icon(
                        Icons.loop,
                        size: 25,
                        color: Color(0xff45abff),
                      )),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xfff2f2f2),
                child: Container(
                  height: 50,
                  width: 50,
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
                        if (widget.audioplayer.hasPrevious) {
                          widget.audioplayer.seekToPrevious();
                        }
                      },
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 25,
                        color: Color(0xff45abff),
                      )),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xfff2f2f2),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
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
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xfff2f2f2), Color(0xffc89feb)])),
                  child: IconButton(
                      onPressed: () {
                        if (widget.audioplayer.hasNext) {
                          widget.audioplayer.seekToNext();
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 25,
                        color: Color(0xff45abff),
                      )),
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xfff2f2f2),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
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
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xfff2f2f2), Color(0xffc89feb)])),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shuffle,
                        size: 25,
                        color: Color(0xff45abff),
                      )),
                ),
              ),
            ],
          ),
        ]));
  }
}

class ArtworkWidget extends StatelessWidget {
  const ArtworkWidget({
    Key? key,
    required Play widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: context.watch<SongModelProvider>().id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: const Icon(Icons.music_note),
      artworkFit: BoxFit.fill,
      artworkHeight: 200,
      artworkWidth: 200,
    );
  }
}
