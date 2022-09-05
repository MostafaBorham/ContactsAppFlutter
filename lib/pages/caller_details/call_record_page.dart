import 'package:audioplayers/audioplayers.dart';
import 'package:contacts_app/models/record_model.dart';
import 'package:flutter/material.dart';

class CallRecordPage extends StatefulWidget {
  const CallRecordPage({Key? key, required this.records}) : super(key: key);
  final List<RecordModel> records;

  @override
  State<CallRecordPage> createState() => _CallRecordPageState();
}

class _CallRecordPageState extends State<CallRecordPage> {
  final _audioPlayer = AudioPlayer();
  late Size screenSize;
  bool isPlaying = false;
  bool isStarted = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        isStarted=true;
      });
    });
    ///////////////////////
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    /////////////////////
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    /////////////////////
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        isStarted=false;
        position=Duration.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: _buildBody());
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Record File List'),
      );

  Widget _buildBody() => SafeArea(
        child: widget.records.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: widget.records
                        .map((record) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            record.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${record.date} ${record.time}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                  color: Colors.white54,
                                                ),
                                          )
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            if (isPlaying) {
                                              await _audioPlayer.pause();
                                            } else {
                                              await _audioPlayer.play(UrlSource(record.url));
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(isPlaying? Icons.pause_circle : Icons.play_circle),
                                          color: Colors.white60)
                                    ],
                                  ),
                                  if (isStarted)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(position.toString(),style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Colors.white60
                                          ),),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Slider(
                                              min: 0,
                                              max: duration.inSeconds.toDouble(),
                                              value: position.inSeconds.toDouble(),
                                              onChanged: (value) async {}),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text((duration - position).toString(),style: Theme.of(context).textTheme.caption!.copyWith(
                                              color: Colors.white60
                                          ),),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                        ))
                        .toList(),
                  ),
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.hourglass_empty_sharp,
                      color: Colors.white60,
                      size: 50,
                    ),
                    Text(
                      'No recording file',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
      );
}
/*

Slider(
min: 0,
max: duration.inSeconds.toDouble(),
value: position.inSeconds.toDouble(),
onChanged: (value)async{
}),
Row(
children: [
Text(position.toString()),
Text((duration-position).toString()),
],
),
CircleAvatar(
radius: 35,
child: IconButton(onPressed: ()async{
if(isPlaying){
await _audioPlayer.pause();
}
else{
await _audioPlayer.play(UrlSource('https://file-examples.com/storage/fe8bd9dfd063066d39cfd5a/2017/11/file_example_MP3_700KB.mp3'));
}
}, icon: Icon(
isPlaying?Icons.pause:Icons.play_arrow
)),
)*/
