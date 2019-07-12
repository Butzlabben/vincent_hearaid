import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioProvider {
  static final AudioProvider _instance = AudioProvider._();

  AudioProvider._() {
    cache.prefix = 'audios/';
    cache.fixedPlayer = AudioPlayer();
  }

  factory AudioProvider() => _instance;

  final AudioCache cache = AudioCache();

  VoidCallback callback;

  List<Audio> audios = [
    // Sopran 1 Hoch
    Audio('Einsatz 1/3', 'SOP 1 HOCH 1st.wav', 'Sopran 1 HOCH'),
    Audio('Einsatz 2/3', 'SOP 1 HOCH 2nd.wav', 'Sopran 1 HOCH'),
    Audio('Einsatz 3/3', 'SOP 1 HOCH 3rd.wav', 'Sopran 1 HOCH'),

    // Sopran 1 TIEF
    Audio('Einsatz 1/3', 'SOP 1 TIEF 1st.wav', 'Sopran 1 TIEF'),
    Audio('Einsatz 2/3', 'SOP 1 TIEF 2nd.wav', 'Sopran 1 TIEF'),
    Audio('Einsatz 3/3', 'SOP 1 TIEF 3rd.wav', 'Sopran 1 TIEF'),

    // Sopran 2
    Audio('Einsatz 1/3', 'SOP 2 1st.wav', 'Sopran 2'),
    Audio('Einsatz 2/3', 'SOP 2 2nd.wav', 'Sopran 2'),
    Audio('Einsatz 3/3', 'SOP 2 3rd.wav', 'Sopran 2'),

    // Alt
    Audio('Einsatz 1/3', 'ALT 1st.wav', 'Alt'),
    Audio('Einsatz 2/3', 'ALT 2nd.wav', 'Alt'),
    Audio('Einsatz 3/3', 'ALT 3rd.wav', 'Alt'),

    // Tenor 1
    Audio('Einsatz 1/3', 'TENOR 1 1st.wav', 'Tenor 1'),
    Audio('Einsatz 2/3', 'TENOR 1 2nd.wav', 'Tenor 1'),
    Audio('Einsatz 3/3', 'TENOR 1 3rd.wav', 'Tenor 1'),

    // Tenor 2
    Audio('Einsatz 1/3', 'TENOR 2 1st.wav', 'Tenor 2'),
    Audio('Einsatz 2/3', 'TENOR 2 2nd.wav', 'Tenor 2'),
    Audio('Einsatz 3/3', 'TENOR 2 3rd.wav', 'Tenor 2'),

    //Bass
    Audio('Einsatz 1/3', 'BASS 1st.wav', 'Bass'),
    Audio('Einsatz 2/3', 'BASS 2nd.wav', 'Bass'),
    Audio('Einsatz 3/3', 'BASS 3rd.wav', 'Bass'),
  ];
}

class Audio {
  final String title, path, author;

  Audio(this.title, this.path, this.author);

  Audio.fromJson(Map<String, dynamic> map)
      : this(map['title'], map['path'], map['author']);
}

class AudioTile extends StatefulWidget {
  final String title, path, author;
  final AudioCache cache;

  final double size;

  AudioTile(
      {Key key, this.title, this.path, this.author, this.cache, this.size})
      : super(key: key);

  AudioTile.fromObject({Key key, Audio audio, AudioCache cache, double size})
      : this(
            key: key,
            title: audio.title,
            path: audio.path,
            author: audio.author,
            cache: cache,
            size: size);

  @override
  _AudioTileState createState() => _AudioTileState();
}

class _AudioTileState extends State<AudioTile> {
  bool playing = false;
  StreamSubscription _sub;

  @override
  void initState() {
    _sub = widget.cache.fixedPlayer.onPlayerStateChanged.listen((state) {
      if (state != AudioPlayerState.PLAYING)
        setState(() {
          playing = false;
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: widget.size,
        width: widget.size,
        child: Card(
          color: Colors.yellowAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: onPressed,
                child: Icon(
                  !playing ? Icons.play_arrow : Icons.pause,
                  size: 60,
                ),
              ),
              Text(
                widget.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (widget.author != null)
                Text(
                  widget.author,
                  style: TextStyle(fontSize: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  onPressed() {
    if (!playing) {
      if(widget.cache.fixedPlayer.state == AudioPlayerState.PLAYING)
        widget.cache.fixedPlayer.stop();
      widget.cache.play(widget.path);
    } else
      widget.cache.fixedPlayer.stop();
    setState(() {
      playing = !playing;
    });
  }
}
