import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_app/keys.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: SplashScreenclass(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class SplashScreenclass extends StatefulWidget {
  @override
  SplashScreen createState() => SplashScreen();
}
class SplashScreen extends State<SplashScreenclass> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), 
    () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen2()))
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Image.asset('assets/image.png'),
    );
  }
}

class Screen2 extends StatelessWidget {
  static String label = '';
  static var res = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("TuberZone"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              "Want to Search as..",
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white,
                  fontFamily: 'KiwiMaru'
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text(
                  'Name',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                  ),
                ),
                onPressed: () {
                  label = 'Enter the name of the song';
                  res = 25;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Screen3()));
                }
              ),
              ElevatedButton(
                  child: Text(
                    'Link',
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    label = 'Enter the link of the song';
                    res = 1;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen3()));
                  }
              ),
            ],
          ),
          ElevatedButton(
            child: Text(
              'Listen Online Music',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Screen8()));
            },
          ),
        ],
      ),
      );
  }
}
class Screen3 extends StatelessWidget {
  static String value = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("TuberZone"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(
                  fontSize: 26.0,
                  color: Colors.white,
                  fontFamily: 'KiwiMaru',
                  fontWeight: FontWeight.bold,
                ),
                  decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  labelText: Screen2.label,
                  labelStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0
                  ),
                  fillColor: Colors.grey[700],
                  filled: true,
                ),
                onChanged: (text) {
                  value = text;
                },
               ),
            ),
              ElevatedButton(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen4()));
                  }
              ),
        ],
      ),
    );
  }
}
class Screen4 extends StatefulWidget {
  @override
  Showvideolist createState() => Showvideolist();
}

class Showvideolist extends State<Screen4> {
  var unescape = HtmlUnescape();
  static String variable = '';
  static String videoId = '';
  static String tit = '';
  static var ind = '';
  static var yt = YoutubeExplode();
  static var list2 = [];
  static var audio_ind = 0;
  static String channel = '';

  YoutubeAPI ytApi = YoutubeAPI(key, maxResults: Screen2.res);
  static List<YT_API> ytResult = [];

  callAPI() async {
    String query = Screen3.value;
    ytResult = await ytApi.search(query);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  void playMusic() async {
    list2 = [];
    audio_ind = 0;
    var manifest = await yt.videos.streamsClient.getManifest(Showvideolist.videoId);
    var streamInfo = manifest.videoOnly.toList();
    var st = manifest.audioOnly.toList();
    var list = [], list1 = [];
    var i, a = 1, c = -1;
    String b = '';
    for (i = 0; i < streamInfo.length; i++) {
      list.add(streamInfo[i].toString().replaceRange(0, 12, '').split(' '));
      if (b != list[i][2].toString()) {
        c++;
        b = list[i][2].toString();
        a = int.parse(list[i][0]);
        list1.add(b);
        list1.add(a);
        list1.add(i);
        list2.add(list1);
        list1 = [];
      }
      if (int.parse(list[i][0]) < a) {
        a = int.parse(list[i][0]);
        list2[c][1] = a;
        list2[c][2] = i;
      }
    }
    list = [];
    a = 1;
    for (i = 0; i < st.length; i++) {
      list.add(st[i].toString().replaceRange(0, 12, '').split(' '));
      if (int.parse(list[i][0]) > a) {
        a = int.parse(list[i][0]);
        audio_ind = i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("TuberZone"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: ytResult.length,
          itemBuilder: (_, int index) => listItem(index),
        ),
      ),
    );
  }
  Widget listItem(index) {
    var text = unescape.convert(ytResult[index].title);
    return Card(
      color: Colors.black,
      child: Container(
        color: Colors.grey[850],
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                ind = ytResult[index].thumbnail['high']['url'];
                tit = unescape.convert(ytResult[index].title);
                channel = ytResult[index].channelTitle;
                variable = ytResult[index].url;
                videoId = YoutubePlayer.convertUrlToId(variable);
                playMusic();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Screen5()));
      },
              child: Image.network(
                ytResult[index].thumbnail['high']['url'],
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            Text(
              text,
              softWrap: true,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 1.5)),
            Text(
              'Channel : ' + ytResult[index].channelTitle,
              softWrap: true,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 3.0)),
            Text(
              'Duration : ' + ytResult[index].duration,
              softWrap: true,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Screen5 extends StatefulWidget {
  Videoplayer createState() => Videoplayer();
}
class Videoplayer extends State<Screen5> {
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: Showvideolist.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )
      ..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) =>
          Scaffold(
            backgroundColor: Colors.grey[850],
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
              ),
              title: Text('TuberZone'),
              centerTitle: true,
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: ListView(
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _space,
                      _text('Title', Showvideolist.tit),
                      _space,
                      _text('Channel', Showvideolist.channel),
                      _space,
                      _text('Video Id', Showvideolist.variable),
                      _space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _text(
                            'Playback Quality',
                            _controller.value.playbackQuality ?? '',
                          ),
                          const Spacer(),
                          _text(
                            'Playback Rate',
                            '${_controller.value.playbackRate}x  ',
                          ),
                        ],
                      ),
                      _space,
                      FloatingActionButton(
                        onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Screen6()));
                      },
                        elevation: 8,
                        child: Icon(
                          Icons.download_sharp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space =>
      const SizedBox(height: 10);
}
class Screen6 extends StatefulWidget{
  show createState() => show();
}
class show extends State<Screen6> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
  void download_audio() async{
    var manifest = await Showvideolist.yt.videos.streamsClient.getManifest(Showvideolist.videoId);
    var st = manifest.audioOnly.toList();
    var str = Showvideolist.yt.videos.streamsClient.get(st[Showvideolist.audio_ind]);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    bool a = await Directory('/storage/emulated/0/TuberZone/Videos/').exists();
    bool b = await Directory('/storage/emulated/0/TuberZone/Music/').exists();
    bool c = await Directory('/storage/emulated/0/TuberZone/Image/').exists();
    bool d = await Directory('/storage/emulated/0/TuberZone/Final/').exists();
    if(!a)
    {
      await Directory('/storage/emulated/0/TuberZone/Videos/').create(recursive: true);
    }
    if(!b)
    {
      await Directory('/storage/emulated/0/TuberZone/Music/').create(recursive: true);
    }
    if(!c)
      {
        await Directory('/storage/emulated/0/TuberZone/Image/').create(recursive: true);
      }
    if(!d)
      {
        await Directory('/storage/emulated/0/TuberZone/Final/').create(recursive: true);
      }
    _showSnackBar('Downloading Audio...');
    _showSnackBar('We will notify you once downloaded!!');
    var file_a = File('/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp4');
    var fileStream_a = file_a.openWrite();
    await str.pipe(fileStream_a);
    await fileStream_a.flush();
    await fileStream_a.close();
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    _showSnackBar('Finalizing...It will take some time!!');
    var arguments = ["-i", '/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp4', '-c:v', 'copy', '-c:a', 'libmp3lame', '-b:a:0', '320k', '/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3'];
    await _flutterFFmpeg.executeWithArguments(arguments ).then((rc) => print("FFmpeg process exited with rc $rc"));
    file_a.delete();
    await ImageDownloader.downloadImage(Showvideolist.ind,
      destination: AndroidDestinationType.custom(directory: 'TuberZone')..subDirectory('Image/sample.jpg'),);
    var arg = ['-i', '/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3', '-i', 'storage/emulated/0/TuberZone/Image/sample.jpg', '-map', '0:0', '-map', '1:0', '-c', 'copy', '-id3v2_version', '3', '-metadata:s:v', 'title="Album cover"', '-metadata:s:v', 'comment="Cover (front)"', '/storage/emulated/0/TuberZone/Final/'+Showvideolist.tit+'.mp3'];
    await _flutterFFmpeg.executeWithArguments(arg ).then((rc) => print('FFmpeg process exited with rc $rc'));
    await File('/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3').delete();
    await File('/storage/emulated/0/TuberZone/Final/'+Showvideolist.tit+'.mp3').copy('/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3');
    await Directory('/storage/emulated/0/TuberZone/Final/').deleteSync(recursive: true);
    await Directory('/storage/emulated/0/TuberZone/Image/').deleteSync(recursive: true);
    _showSnackBar('Audio Downloaded in Internal Storage->TuberZone/Music!!!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("TuberZone"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              "Download as..",
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white,
                  fontFamily: 'KiwiMaru'
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: Text(
                    'Video',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen7()));
                  }
              ),
              ElevatedButton(
                  child: Text(
                    'Audio',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    download_audio();
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Screen7 extends StatefulWidget {
  select createState() => select();
}
class select extends State<Screen7> {
  static var indexing=0;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void download_audio() async{
    var manifest = await Showvideolist.yt.videos.streamsClient.getManifest(Showvideolist.videoId);
    var st = manifest.audioOnly.toList();
    var str = Showvideolist.yt.videos.streamsClient.get(st[Showvideolist.audio_ind]);
    var file_a = File('/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp4');
    _showSnackBar('Finalizing...It will take some time!!');
    var fileStream_a = file_a.openWrite();
    await str.pipe(fileStream_a);
    await fileStream_a.flush();
    await fileStream_a.close();
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    var arguments = ["-i", '/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp4', '-c:v', 'copy', '-c:a', 'libmp3lame', '-b:a:0', '320k', '/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3'];
    await _flutterFFmpeg.executeWithArguments(arguments ).then((rc) => print("FFmpeg process exited with rc $rc"));
    file_a.delete();
  }
  void download_video() async{
    _showSnackBar('Downloading Video...');
    _showSnackBar('We will notify you once downloaded!!');
    var manifest = await Showvideolist.yt.videos.streamsClient.getManifest(Showvideolist.videoId);
    var streamInfo = manifest.videoOnly.toList();
    var stream = Showvideolist.yt.videos.streamsClient.get(streamInfo[indexing]);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    bool a = await Directory('/storage/emulated/0/TuberZone/Videos/').exists();
    bool b = await Directory('/storage/emulated/0/TuberZone/Music/').exists();
    bool c = await Directory('/storage/emulated/0/TuberZone/Final/').exists();
    if(!a)
      {
        await Directory('/storage/emulated/0/TuberZone/Videos/').create(recursive: true);
      }
    if(!b)
    {
      await Directory('/storage/emulated/0/TuberZone/Music/').create(recursive: true);
    }
    if(!c)
    {
      await Directory('/storage/emulated/0/TuberZone/Final/').create(recursive: true);
    }
    // Open a file for writing.
    var file = File('/storage/emulated/0/TuberZone/Videos/'+Showvideolist.tit+'.mp4');
    var fileStream = file.openWrite();
    // Pipe all the content of the stream into the file.
    await stream.pipe(fileStream);
    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    await download_audio();

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    var argument = ["-i", '/storage/emulated/0/TuberZone/Videos/'+Showvideolist.tit+'.mp4', '-i', '/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3', '-c', 'copy', '/storage/emulated/0/TuberZone/Final/'+Showvideolist.tit+'.mp4'];
    await _flutterFFmpeg.executeWithArguments(argument ).then((rc) => print("FFmpeg process exited with rc $rc"));
    file.delete();
    await File('/storage/emulated/0/TuberZone/Music/'+Showvideolist.tit+'.mp3').delete();
    await File('/storage/emulated/0/TuberZone/Final/'+Showvideolist.tit+'.mp4').copy('/storage/emulated/0/TuberZone/Videos/'+Showvideolist.tit+'.mp4');
    await Directory('/storage/emulated/0/TuberZone/Final/').deleteSync(recursive: true);
    _showSnackBar('Video Downloaded in Internal Storage->TuberZone/Videos!!!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('TuberZone'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(children: _buildButtons()),
    );
  }

  List<Widget> _buildButtons() {
    List<Widget> listButtons = List.generate(Showvideolist.list2.length, (i) {
      return ElevatedButton(
        onPressed: () {
          indexing = Showvideolist.list2[i][2];
          download_video();
        },
        child: Text(
          Showvideolist.list2[i][0]=='144p' ? '144p'
              : Showvideolist.list2[i][0]=='240p' ? '240p'
              : Showvideolist.list2[i][0]=='360p' ? '360p'
              : Showvideolist.list2[i][0]=='480p' ? '480p'
              : Showvideolist.list2[i][0]=='720p' ? '720p'
              : Showvideolist.list2[i][0]=='1080p' ? '1080p'
              : Showvideolist.list2[i][0]=='1440p' ? '1440p' : '',
          style: TextStyle(
            color: Colors.green,
            backgroundColor: Colors.amberAccent,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      );
    });
    return listButtons;
  }
}
class Screen8 extends StatelessWidget {
  static String url = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("TuberZone"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          url = 'https://wynk.in/music';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => website()));
                        },
                        icon: new Image.asset(
                          'assets/icons/wynk.png',
                        ),
                        iconSize: 150.0,
                      ),
                      IconButton(
                        onPressed: () {
                          url = 'https://gaana.com/';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => website()));
                        },
                        icon: new Image.asset(
                          'assets/icons/gaana.png',
                        ),
                        iconSize: 150.0,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          url = 'https://www.jiosaavn.com/';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => website()));
                        },
                        icon: new Image.asset(
                          'assets/icons/jio.png',
                        ),
                        iconSize: 160.0,
                      ),
                      IconButton(
                        onPressed: () {
                          url = 'https://music.youtube.com/';
                          Navigator.push(context, MaterialPageRoute(builder: (context) => website()));
                        },
                        icon: new Image.asset(
                          'assets/icons/youtube_music.png',
                        ),
                        iconSize: 150.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
class website extends StatefulWidget {
  @override
  PageControl createState() => PageControl();
}
class PageControl extends State<website> {
  WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter = Completer<WebViewController>();
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> _onWillPop(context),
      child: new Scaffold(
        body: WebView(
          key: UniqueKey(),
          initialUrl: Screen8.url,
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value)=>_controller = value);
            _controllerCompleter.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}