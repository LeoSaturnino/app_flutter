import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _start = false;
  bool _startdescanco = false;
  int _timer = 0;

  int qtdeAgua = 0;
  int qtdePomodoro = 0;
  int timePomodoro = 25;

  String buttonText = 'START';
  String timerText = '25 : 00';
  bool _active = true;
  bool _activebutton = true;
  bool _showWater = false;

  AudioCache audioPlayer = AudioCache();

  Future _playAudio(String audio) async {
    await audioPlayer.play(audio);
  }

  void _startStopPomodoro() {
    setState(() {
      _showWater = false;
      if (_start) {
        _activebutton = true;
        buttonText = 'START';
        _start = false;
        _startdescanco = false;
      } else {
        _activebutton = true;
        buttonText = 'PAUSE';
        _start = true;
        _startdescanco = false;
        _startPomodoro();
      }
    });
  }

  void _startPomodoro() {
    if (_start) {
      _timerPomodoro();
      setState(() {
        _timer++;
        int _min = timePomodoro - 1 - _timer ~/ 60;
        int _seg = 60 - _timer % 60;
        timerText =
            '${_min.toString().padLeft(2, '0')} : ${_seg.toString().padLeft(2, '0')}';
        if (_timer >= (timePomodoro * 60)) {
          _stopPomodoro();
        }
        // if (_timer % 10 == 0) {
        //   _pauseWater();
        // }
      });
    }
  }

  // void _pauseWater() {
  //   _showWater = true;
  //   _activebutton = true;
  //   buttonText = 'START';
  //   _start = false;
  //   _startdescanco = false;
  // }

  void _timerPomodoro() {
    Timer(const Duration(seconds: 1), _startPomodoro);
  }

  void _stopPomodoro() {
    _active = false;
    _playAudio('audio/alert3.mp3');
    setState(() {
      _start = false;
      qtdePomodoro++;
      timePomodoro = 25;
      _activebutton = true;
      buttonText = 'START';
      _timer = 0;
      timerText = '${timePomodoro.toString().padLeft(2, '0')} : 00';
      _descancoPomodoro();
    });
  }

  void _resetPomodoro() {
    _stopPomodoro();
    _start = false;
    _showWater = false;
    _startdescanco = false;
    _activebutton = true;
    buttonText = 'START';
    qtdePomodoro = 0;
    qtdeAgua = 0;
    timePomodoro = 25;
  }

  void _descancoPomodoro() {
    setState(() {
      _startdescanco = true;
      timePomodoro = 5;
      _activebutton = false;
      if (qtdePomodoro % 4 == 0) {
        timePomodoro = 25;
      }
      _startDescanco();
    });
  }

  void _startDescanco() {
    if (_startdescanco) {
      _timerDescanco();
      setState(() {
        _timer++;
        int _min = timePomodoro - 1 - _timer ~/ 60;
        int _seg = 60 - _timer % 60;
        timerText =
            '${_min.toString().padLeft(2, '0')} : ${_seg.toString().padLeft(2, '0')}';
        if (_timer >= (timePomodoro * 60)) {
          _stopDescanco();
        }
      });
    }
  }

  void _stopDescanco() {
    _active = true;
    _playAudio('audio/alert1.mp3');
    setState(() {
      _startdescanco = false;
      timePomodoro = 25;
      _activebutton = true;
      buttonText = 'START';
      _timer = 0;
      timerText = '${timePomodoro.toString().padLeft(2, '0')} : 00';
      _showWater = true;
    });
  }

  void _timerDescanco() {
    Timer(const Duration(seconds: 1), _startDescanco);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedCrossFade(
          firstChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedCrossFade(
                firstChild: Container(
                  width: 320,
                  height: 200,
                  child: Image.asset('assets/images/programacao.gif'),
                ),
                secondChild: Container(
                  width: 320,
                  height: 200,
                  child: Image.asset('assets/images/descanco.gif'),
                ),
                crossFadeState: _active
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(seconds: 2),
              ),
              const SizedBox(
                height: 25,
              ),
              AnimatedCrossFade(
                firstChild: const Text(
                  'Pomodoro Timer',
                  style: TextStyle(fontSize: 18),
                ),
                secondChild: const Text(
                  'Descanço Timer',
                  style: TextStyle(fontSize: 18),
                ),
                crossFadeState: _active
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(seconds: 2),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                timerText,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(
                height: 50,
              ),
              AnimatedCrossFade(
                firstChild: ElevatedButton(
                  onPressed: _startStopPomodoro,
                  child: Text(
                    buttonText,
                  ),
                ),
                secondChild: const SizedBox(
                  height: 50,
                ),
                crossFadeState: _activebutton
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(seconds: 2),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
          secondChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 320,
                  height: 200,
                  child: Image.asset('assets/images/agua.gif'),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  'Hora de Beber',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Água!',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  onPressed: _startStopPomodoro,
                  child: Text(
                    buttonText,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ]),
          crossFadeState:
              _showWater ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(seconds: 1),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetPomodoro,
        child: Text('$qtdePomodoro'),
      ), 
    );
  }
}
