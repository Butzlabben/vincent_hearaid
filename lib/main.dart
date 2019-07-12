import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vincent_hearaid/audios.dart';

void main() {
  runApp(UliBoard());
}

class UliBoard extends StatefulWidget {
  @override
  _UliBoardState createState() => _UliBoardState();
}

class _UliBoardState extends State<UliBoard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.yellowAccent,
      theme: ThemeData(
        primaryColor: Colors.yellowAccent,
        accentColor: Colors.pinkAccent,
      ),
      title: 'Vincent is giey',
      routes: {
        '/': (context) => MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final AudioProvider provider = AudioProvider();

  List<AudioTile> getAudios(double size) => provider.audios
      .map((a) => AudioTile.fromObject(
            audio: a,
            cache: provider.cache,
            size: size,
          ))
      .toList();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String filter;

  @override
  void initState() {
    AudioProvider().callback = () {
      setState(() {});
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vincent is giey'),
        actions: <Widget>[_buildPopMenuButton()],
      ),
      body: LayoutBuilder(builder: (context, constrains) {
        double size = constrains.maxWidth / 2 - 16;
        List<AudioTile> audios = widget.getAudios(size);
        if (filter != null && filter != '') {
          audios.retainWhere((tile) {
            return tile.author.toLowerCase().contains(filter) ||
                tile.title.toLowerCase().contains(filter) ||
                tile.path.toLowerCase().contains(filter);
          });
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            if (index.isEven) {
              if (index >= audios.length) return null;
              Widget nextAudio = audios.length <= (index + 1)
                  ? Container(
                      width: size + 8,
                      height: size + 8,
                    )
                  : audios[index + 1];
              return Row(
                  children: <Widget>[audios[index], nextAudio],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly);
            } else {
              return Container();
            }
          },
          itemCount: audios.length,
        );
      }),
    );
  }

  Widget _buildPopMenuButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton(
        child: Icon(Icons.filter_list),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text('Kein Filter'),
            value: '',
          ),
          PopupMenuItem(
            child: Text('Sopran 1 Hoch'),
            value: "sopran 1 hoch",
          ),
          PopupMenuItem(
            child: Text('Sopran 1 TIEF'),
            value: "sopran 1 tief",
          ),
          PopupMenuItem(
            child: Text('Sopran 2'),
            value: "sopran 2",
          ),
          PopupMenuItem(
            child: Text('Alt'),
            value: "alt",
          ),
          PopupMenuItem(
            child: Text('Tenor 1'),
            value: "tenor 1",
          ),
          PopupMenuItem(
            child: Text('Tenor 2'),
            value: "tenor 2",
          ),
          PopupMenuItem(
            child: Text('Bass'),
            value: "bass",
          ),
        ],
        onSelected: (val) {
          setState(() {
            filter = val;
          });
        },
      ),
    );
  }
}
