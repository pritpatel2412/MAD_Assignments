import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Match Image & Word",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orangeAccent,
      ),
      home: const MatchGame(),
    );
  }
}

class MatchGame extends StatefulWidget {
  const MatchGame({super.key});

  @override
  State<MatchGame> createState() => _MatchGameState();
}

class _MatchGameState extends State<MatchGame> {
  final FlutterTts tts = FlutterTts();
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, String>> data = [
    {"word": "Apple", "image": "assets/images/apple.jpg"},
    {"word": "Ball", "image": "assets/images/ball.jpg"},
    {"word": "Cat", "image": "assets/images/cat.webp"},
    {"word": "Dog", "image": "assets/images/dog.webp"},
  ];

  Map<String, String>? current;
  List<String> options = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    nextQuestion();
  }

  Future<void> speak(String text) async {
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  void playSound(String type) async {
    if (type == "correct") {
      await player.play(AssetSource("sounds/correct.mp3"));
    } else {
      await player.play(AssetSource("sounds/wrong.mp3"));
    }
  }

  void nextQuestion() {
    final rand = Random();
    final newCurrent = data[rand.nextInt(data.length)];
    final Set<String> choiceSet = {newCurrent["word"]!};

    while (choiceSet.length < 4) {
      choiceSet.add(data[rand.nextInt(data.length)]["word"]!);
    }

    setState(() {
      current = newCurrent;
      options = choiceSet.toList()..shuffle();
    });

    speak("Find ${newCurrent["word"]}");
  }

  void checkAnswer(String choice) {
    if (choice == current!["word"]) {
      playSound("correct");
      speak("Great! Correct answer");
      setState(() => score++);
    } else {
      playSound("wrong");
      speak("Oops! The correct answer is ${current!["word"]}");
    }

    Future.delayed(const Duration(seconds: 2), nextQuestion);
  }

  @override
  Widget build(BuildContext context) {
    if (current == null) return const SizedBox();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // soft warm background
      appBar: AppBar(
        title: const Text(
          "Match Image & Word",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Score: $score",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.orangeAccent,
                      offset: Offset(3, 3),
                    )
                  ],
                ),
                child: Image.asset(current!["image"]!, width: 200),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: options
                .map((word) => ElevatedButton(
                      onPressed: () => checkAnswer(word),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 28),
                        backgroundColor:
                            Colors.orangeAccent.shade100, // playful button
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        shadowColor: Colors.orange.shade200,
                        elevation: 6,
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
