// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_4/utils/model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicTile extends StatelessWidget {
  final SongModel songModel;

  const MusicTile({
    required this.songModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        songModel.displayNameWOExt,
        style: const TextStyle(fontFamily: 'Lobster', color: Color(0xfff2f2f2)),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        songModel.additionalSongInfo,
        style: const TextStyle(fontFamily: 'Lobster', color: Color(0xfff2f2f2)),
      ),
      trailing: const Icon(Icons.more_horiz),
      leading: QueryArtworkWidget(
        id: songModel.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const Icon(Icons.music_note),
      ),
    );
  }
}
