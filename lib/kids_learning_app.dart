import 'dart:async';
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
      title: 'Fun ABC & 123',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4CAF50), // fresh green seed
      ),
      home: const LearningScreen(),
    );
  }
}

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final FlutterTts tts = FlutterTts();
  final AudioPlayer player = AudioPlayer();
  final letters = List.generate(26, (i) => String.fromCharCode(65 + i));
  final numbers = List.generate(10, (i) => (i + 1).toString());

  String category = "letters";
  String mode = "learn";
  int currentIndex = 0;
  Timer? autoplayTimer;

  // quiz
  String? quizCorrect;
  List<String> quizChoices = [];
  int score = 0;
  int attempts = 0;

  @override
  void dispose() {
    autoplayTimer?.cancel();
    super.dispose();
  }

  List<String> get items => category == "letters" ? letters : numbers;

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.setPitch(1.1);
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  Future<void> playItem(int i) async {
    setState(() => currentIndex = i);
    await speak(items[i]);
  }

  void startAutoplay() {
    stopAutoplay();
    int i = 0;

    Future<void> playNext() async {
      if (i >= items.length) i = 0;
      await playItem(i);
      i++;
      Future.delayed(const Duration(seconds: 2), playNext);
    }

    playNext();
  }

  void stopAutoplay() {
    autoplayTimer?.cancel();
    autoplayTimer = null;
  }

  void makeQuizQuestion() {
    final rand = Random();
    final correct = items[rand.nextInt(items.length)];
    final Set<String> choices = {correct};
    while (choices.length < 4) {
      choices.add(items[rand.nextInt(items.length)]);
    }
    setState(() {
      quizCorrect = correct;
      quizChoices = choices.toList()..shuffle();
    });
    speak(correct);
  }

  void chooseAnswer(String choice) {
    setState(() => attempts++);
    if (choice == quizCorrect) {
      setState(() => score++);
      speak("Correct");
    } else {
      speak("No, it is $quizCorrect");
    }
    Future.delayed(const Duration(seconds: 1), makeQuizQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient background updated
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFC8E6C9)], // light blue to light green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text("Fun ABC & 123"),
                backgroundColor: const Color(0xFF81C784), // soft green
                actions: [
                  DropdownButton<String>(
                    value: category,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "letters", child: Text("Letters")),
                      DropdownMenuItem(value: "numbers", child: Text("Numbers")),
                    ],
                    onChanged: (v) => setState(() => category = v!),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: mode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "learn", child: Text("Learn")),
                      DropdownMenuItem(value: "play", child: Text("Play")),
                      DropdownMenuItem(value: "quiz", child: Text("Quiz")),
                    ],
                    onChanged: (v) {
                      setState(() => mode = v!);
                      stopAutoplay();
                      if (mode == "quiz") {
                        score = 0;
                        attempts = 0;
                        makeQuizQuestion();
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: mode == "quiz" ? buildQuiz() : buildCards(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: mode == "play"
          ? (autoplayTimer == null
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.green, // play button green
                  foregroundColor: Colors.white,
                  onPressed: startAutoplay,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Play"),
                )
              : FloatingActionButton.extended(
                  backgroundColor: Colors.red, // stop button red
                  foregroundColor: Colors.white,
                  onPressed: stopAutoplay,
                  icon: const Icon(Icons.stop),
                  label: const Text("Stop"),
                ))
          : null,
    );
  }

  Widget buildCards() {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        final isActive = i == currentIndex;
        return GestureDetector(
          onTap: () => playItem(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFB2DFDB) : Colors.white, // teal shade active
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF388E3C).withOpacity(0.2), // soft green shadow
                  blurRadius: 6,
                  offset: const Offset(2, 3),
                )
              ],
            ),
            child: Center(
              child: Text(
                items[i],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.teal.shade900 : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildQuiz() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "What is this?",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.teal),
        ),
        const SizedBox(height: 10),
        Text(
          quizCorrect ?? "",
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent, // big quiz text blue
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quizChoices
              .map((c) => ElevatedButton(
                    onPressed: () => chooseAnswer(c),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100, // soft green buttons
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      c,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ))
              .toList(),
        ),
        const Spacer(),
        Text(
          "Score: $score / Attempts: $attempts",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
