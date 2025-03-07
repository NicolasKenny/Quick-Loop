import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quick_loop/painter/ball_painter.dart';
import 'widgets/loop.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Quick Loop",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameManager(),
      ),
    );
  }
}

class GameManager extends StatefulWidget {
  const GameManager({Key? key}) : super(key: key);

  @override
  State<GameManager> createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager>
    with SingleTickerProviderStateMixin {
  final _pathWidth = 20.0;
  int score = 0;
  int bestScore = -1;
  double speed = 1.5; // velocidade inicial
  final double maxSpeed = 5.0; //velociade maxima
  double ballAngle = 0;
  double loopLength = 0;
  double loopStartAngle = 0;
  bool isUnderCollision = false;
  bool isPlaying = false;
  bool isGameOvered = false;
  bool isClockwise = true;

  late AnimationController controller;
  late Animation animation;

  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.ease)
      ..addListener(gameLoop);

    controller.repeat();
    randomizeSegmentPosition();
  }

  gameLoop() {
    driveBall();
    checkIfBallIsColliding();
    setState(() {});
  }

  startGame() {
    isPlaying = true;
    isGameOvered = false;
    speed = 1.5; //reinicia a velocidade para o valor inicial
    randomizeSegmentPosition();
  }

  driveBall() {
    if (isClockwise) {
      ballAngle = (ballAngle + speed) % 360; // Sentido horário
    } else {
      ballAngle = (ballAngle - speed) % 360; // Sentido anti-horário
    }
  }

  randomizeSegmentPosition() {
    loopStartAngle = Random().nextInt(270).toDouble();
    loopLength = Random().nextInt(60).clamp(20, 60).toDouble();
  }

  checkIfBallIsColliding() {
    final endAngle = loopStartAngle + loopLength + _pathWidth;

    if (ballAngle < endAngle && ballAngle > loopStartAngle) {
      isUnderCollision = true;
    } else {
      isUnderCollision = false;
    }
  }

  checkForRecordBreak() {
    if (bestScore < score) {
      bestScore = score;
    }
  }

  gameOver() async {
    isGameOvered = true;
    isPlaying = false;
    checkForRecordBreak();
    score = 0;

    await audioPlayer.play(AssetSource("sounds/perdeu.mp3"));
  }

  handleTap() async {
    if (isPlaying) {
      if (isUnderCollision) {
      
        score++;
        if (speed < maxSpeed){
          speed += 0.2;
        }
        randomizeSegmentPosition();

        await audioPlayer.play(AssetSource("sounds/ponto.mp3"));
      } else {
        gameOver();
      }
      isClockwise = !isClockwise;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isPlaying ? handleTap() : startGame(),
      child: Material(
        color: const Color.fromARGB(255, 32, 32, 65),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox.square(
                  dimension: 300,
                  child: GameBoard(
                    ballAngle: ballAngle,
                    loopLength: loopLength,
                    loopStartAngle: loopStartAngle,
                    pathWidth: _pathWidth,
                    child: Center(
                      child: isPlaying
                          ? Text(
                              "$score",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 165, 143, 143),
                              fontSize: 24,
                            ),
                            )
                          : IconButton(
                              onPressed: startGame,
                              icon: const Icon(Icons.play_arrow_rounded),
                              iconSize: 60,
                            ),
                    ),
                  ),
                ),
              ),
              if (isGameOvered)
              
                Padding(
                  
                  padding: const EdgeInsets.all(35.0),
                  
                  child: Text(
                    "Game Over\n Melhor pontuação : $bestScore",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 165, 143, 143),
                              fontSize: 24,
                              
                                      ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  final Widget? child;
  final double loopStartAngle;
  final double loopLength;
  final double ballAngle;
  final double pathWidth;

  const GameBoard({
    Key? key,
    this.child,
    required this.loopStartAngle,
    required this.loopLength,
    required this.ballAngle,
    required this.pathWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loop(
      duration: const Duration(milliseconds: 400),
      stroke: pathWidth,
      startAngle: loopStartAngle,
      angle: loopLength,
      color: const Color.fromARGB(163, 153, 216, 245),
      child: CustomPaint(
        painter: BallPainter(
          color: const Color.fromARGB(255, 216, 230, 142),
          radius: pathWidth / 2,
          angle: ballAngle,
        ),
        child: child,
      ),
    );
  }
}
