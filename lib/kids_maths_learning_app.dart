import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Single-file Flutter app: Kids Math Learning (main.dart)
// Dependencies (pubspec.yaml):
//   flutter_tts: ^3.8.3

void main() {
  runApp(const KidsMathApp());
}

class KidsMathApp extends StatelessWidget {
  const KidsMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Math Fun',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      ),
      home: const HomeScreen(),
    );
  }
}

enum Operation { addition, subtraction, multiplication, division }
enum Mode { practice, quiz }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  Operation _operation = Operation.addition;
  Mode _mode = Mode.practice;
  int _level = 1; // 1 = easy, 2 = medium, 3 = hard

  @override
  void initState() {
    super.initState();
    _tts.setSpeechRate(0.5);
    _tts.setPitch(1.1);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _openPractice() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PracticeScreen(
        operation: _operation,
        level: _level,
        tts: _tts,
      ),
    ));
  }

  void _openQuiz() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => QuizScreen(
        operation: _operation,
        level: _level,
        tts: _tts,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kids Math Fun',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: Colors.deepPurpleAccent),
                    onPressed: () async {
                      await _tts.speak(
                          'Welcome! Choose an operation and a mode: Practice or Quiz.');
                    },
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text('Choose operation', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: Operation.values.map((op) {
                  final label = _labelForOp(op);
                  final selected = op == _operation;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(label, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        _iconForOp(op),
                      ],
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _operation = op),
                    selectedColor: Colors.pinkAccent[100],
                    backgroundColor: Colors.tealAccent[100],
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
              const Text('Select difficulty', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _levelButton(1, 'Easy'),
                  const SizedBox(width: 8),
                  _levelButton(2, 'Medium'),
                  const SizedBox(width: 8),
                  _levelButton(3, 'Hard'),
                ],
              ),

              const SizedBox(height: 20),
              const Text('Mode', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _mode = Mode.practice),
                    icon: const Icon(Icons.school),
                    label: const Text('Practice'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _mode == Mode.practice ? Colors.pinkAccent : Colors.grey[300],
                      foregroundColor:
                          _mode == Mode.practice ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _mode = Mode.quiz),
                    icon: const Icon(Icons.quiz_rounded),
                    label: const Text('Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _mode == Mode.quiz ? Colors.deepPurpleAccent : Colors.grey[300],
                      foregroundColor:
                          _mode == Mode.quiz ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),

              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _mode == Mode.practice ? _openPractice() : _openQuiz(),
                  icon: const Icon(Icons.play_arrow),
                  label: Text(_mode == Mode.practice ? 'Start Practice' : 'Start Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelButton(int lvl, String label) {
    final selected = _level == lvl;
    Color bgColor = selected
        ? (lvl == 1 ? Colors.lightGreen : lvl == 2 ? Colors.orangeAccent : Colors.purpleAccent)
        : Colors.grey[200]!;
    return ElevatedButton(
      onPressed: () => setState(() => _level = lvl),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: selected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(label),
      ),
    );
  }

  String _labelForOp(Operation op) {
    switch (op) {
      case Operation.addition:
        return 'Addition';
      case Operation.subtraction:
        return 'Subtraction';
      case Operation.multiplication:
        return 'Multiplication';
      case Operation.division:
        return 'Division';
    }
  }

  Widget _iconForOp(Operation op) {
    switch (op) {
      case Operation.addition:
        return const Icon(Icons.add_circle, color: Colors.orangeAccent);
      case Operation.subtraction:
        return const Icon(Icons.remove_circle, color: Colors.redAccent);
      case Operation.multiplication:
        return const Icon(Icons.clear, color: Colors.lightBlueAccent);
      case Operation.division:
        return const Icon(Icons.percent, color: Colors.purpleAccent);
    }
  }
}

// ---------------- Practice Screen ----------------
class PracticeScreen extends StatefulWidget {
  final Operation operation;
  final int level;
  final FlutterTts tts;

  const PracticeScreen({super.key, required this.operation, required this.level, required this.tts});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> with SingleTickerProviderStateMixin {
  final Random _rand = Random();
  late int a, b;
  String userAnswer = '';
  String feedback = '';
  Color feedbackColor = Colors.transparent;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _generate();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _generate() {
    final range = _rangeForLevel(widget.level);
    if (widget.operation == Operation.division) {
      b = _rand.nextInt(range) + 1;
      int multiplier = _rand.nextInt(range) + 1;
      a = b * multiplier;
    } else {
      a = _rand.nextInt(range) + 1;
      b = _rand.nextInt(range) + 1;
    }
    userAnswer = '';
    feedback = '';
    feedbackColor = Colors.transparent;
    _speakProblem();
    setState(() {});
  }

  int _rangeForLevel(int level) {
    switch (level) {
      case 1:
        return 10;
      case 2:
        return 20;
      default:
        return 50;
    }
  }

  String _operatorSymbol() {
    switch (widget.operation) {
      case Operation.addition:
        return '+';
      case Operation.subtraction:
        return '-';
      case Operation.multiplication:
        return '×';
      case Operation.division:
        return '÷';
    }
  }

  num _correctAnswer() {
    switch (widget.operation) {
      case Operation.addition:
        return a + b;
      case Operation.subtraction:
        return a - b;
      case Operation.multiplication:
        return a * b;
      case Operation.division:
        return a ~/ b;
    }
  }

  Future<void> _speakProblem() async {
    final text = 'What is $a ${_operatorSymbol()} $b?';
    await widget.tts.speak(text);
  }

  void _submit() {
    if (userAnswer.trim().isEmpty) return;
    final ans = num.tryParse(userAnswer);
    if (ans == null) return;
    final correct = _correctAnswer();
    if (ans == correct) {
      feedback = 'Great! Correct';
      feedbackColor = Colors.greenAccent[400]!;
      widget.tts.speak('Great! Correct');
      Future.delayed(const Duration(milliseconds: 600), _generate);
    } else {
      feedback = 'Try again';
      feedbackColor = Colors.redAccent[200]!;
      widget.tts.speak('No, try again');
      _shakeController.forward(from: 0.0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('Solve', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Text('$a ${_operatorSymbol()} $b', style: const TextStyle(fontSize: 46, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Your answer'),
                            onChanged: (v) => userAnswer = v,
                            onSubmitted: (_) => _submit(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(onPressed: _submit, child: const Text('Check'))
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: feedbackColor, borderRadius: BorderRadius.circular(10)),
                      child: Text(feedback, style: const TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: _generate, icon: const Icon(Icons.refresh), label: const Text('New')),
                ElevatedButton.icon(onPressed: _speakProblem, icon: const Icon(Icons.volume_up), label: const Text('Hear')),
                ElevatedButton.icon(onPressed: () { setState(() { userAnswer = ''; }); }, icon: const Icon(Icons.clear), label: const Text('Clear')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- Quiz Screen ----------------
class QuizScreen extends StatefulWidget {
  final Operation operation;
  final int level;
  final FlutterTts tts;

  const QuizScreen({super.key, required this.operation, required this.level, required this.tts});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Random _rand = Random();
  late int a, b;
  late List<num> choices;
  late num correct;
  int score = 0;
  int questionNo = 0;
  int total = 10;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final range = _rangeForLevel(widget.level);
    if (widget.operation == Operation.division) {
      b = _rand.nextInt(range) + 1;
      int multiplier = _rand.nextInt(range) + 1;
      a = b * multiplier;
    } else {
      a = _rand.nextInt(range) + 1;
      b = _rand.nextInt(range) + 1;
    }
    correct = _computeAnswer();
    final set = <num>{correct};
    while (set.length < 4) {
      final delta = (_rand.nextInt(7) - 3);
      set.add(max(0, correct + delta));
    }
    choices = set.toList()..shuffle();
    questionNo++;
    widget.tts.speak('Question $questionNo: What is $a ${_symbol()} $b?');
    setState(() {});
  }

  int _rangeForLevel(int level) {
    switch (level) {
      case 1:
        return 10;
      case 2:
        return 20;
      default:
        return 50;
    }
  }

  num _computeAnswer() {
    switch (widget.operation) {
      case Operation.addition:
        return a + b;
      case Operation.subtraction:
        return a - b;
      case Operation.multiplication:
        return a * b;
      case Operation.division:
        return a ~/ b;
    }
  }

  String _symbol() {
    switch (widget.operation) {
      case Operation.addition:
        return '+';
      case Operation.subtraction:
        return '-';
      case Operation.multiplication:
        return '×';
      case Operation.division:
        return '÷';
    }
  }

  void _choose(num chosen) {
    if (chosen == correct) {
      score++;
      widget.tts.speak('Correct');
    } else {
      widget.tts.speak('No, the correct answer is $correct');
    }
    if (questionNo >= total) {
      _showResult();
    } else {
      Future.delayed(const Duration(milliseconds: 700), _nextQuestion);
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Complete'),
        content: Text('Your score: $score / $total'),
        actions: [
          TextButton(onPressed: () { Navigator.of(context).pop(); Navigator.of(context).pop(); }, child: const Text('Close')),
          ElevatedButton(onPressed: () { Navigator.of(context).pop(); setState(() { score = 0; questionNo = 0; _nextQuestion(); }); }, child: const Text('Retry'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Question $questionNo / $total', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text('What is', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('$a ${_symbol()} $b', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: choices.map((c) => ElevatedButton(
                        onPressed: () => _choose(c),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[100],
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(c.toString(), style: const TextStyle(fontSize: 20)),
                      )).toList(),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text('Score: $score', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: _nextQuestion, icon: const Icon(Icons.skip_next), label: const Text('Skip'))
          ],
        ),
      ),
    );
  }
}
