// main.dart
// Put this file in lib/main.dart of a new Flutter project.
// Minimal subject-wise IT Quiz app with in-memory questions.

import 'package:flutter/material.dart';

void main() {
  runApp(ITQuizApp());
}

class ITQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subject-wise IT Quiz',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

// Simple models
class Question {
  final String subject; // e.g. "Networking", "DBMS"
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.subject,
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

// Sample data: add or replace with JSON/remote-backend later
final List<Question> sampleQuestions = [
  // Networking
  Question(subject: 'Networking', text: 'Which protocol is used to send email between mail servers?', options: ['FTP', 'SMTP', 'HTTP', 'SSH'], correctIndex: 1),
  Question(subject: 'Networking', text: 'Which IP protocol version uses 128-bit addresses?', options: ['IPv4', 'IPv6', 'IPX', 'ARP'], correctIndex: 1),
  Question(subject: 'Networking', text: 'Which device operates at the network layer of the OSI model?', options: ['Switch', 'Hub', 'Router', 'Repeater'], correctIndex: 2),
  Question(subject: 'Networking', text: 'Which protocol secures communication on the web?', options: ['HTTP', 'HTTPS', 'FTP', 'SMTP'], correctIndex: 1),
  Question(subject: 'Networking', text: 'Which port does DNS typically use?', options: ['25', '53', '80', '443'], correctIndex: 1),
  Question(subject: 'Networking', text: 'Which topology connects all devices to a central hub?', options: ['Ring', 'Star', 'Bus', 'Mesh'], correctIndex: 1),
  Question(subject: 'Networking', text: 'What does ARP stand for?', options: ['Address Resolution Protocol', 'Automatic Routing Protocol', 'Advanced Routing Process', 'Address Repeater Protocol'], correctIndex: 0),
  Question(subject: 'Networking', text: 'Which device breaks collision domains?', options: ['Hub', 'Switch', 'Repeater', 'Bridge'], correctIndex: 1),
  Question(subject: 'Networking', text: 'Which command shows the route packets take in a network?', options: ['ping', 'ipconfig', 'traceroute', 'netstat'], correctIndex: 2),
  Question(subject: 'Networking', text: 'Which layer of OSI is responsible for end-to-end delivery?', options: ['Transport', 'Session', 'Network', 'Presentation'], correctIndex: 0),

  //DBMS
  Question(subject: 'DBMS', text: 'Which normal form removes partial dependency?', options: ['1NF', '2NF', '3NF', 'BCNF'], correctIndex: 1),
  Question(subject: 'DBMS', text: 'In SQL, which command is used to remove a table and its data?', options: ['DELETE TABLE', 'DROP TABLE', 'REMOVE TABLE', 'TRUNCATE'], correctIndex: 1),
  Question(subject: 'DBMS', text: 'Which key uniquely identifies a record in a table?', options: ['Primary Key', 'Foreign Key', 'Candidate Key', 'Super Key'], correctIndex: 0),
  Question(subject: 'DBMS', text: 'Which SQL command is used to extract data from a table?', options: ['INSERT', 'UPDATE', 'SELECT', 'DELETE'], correctIndex: 2),
  Question(subject: 'DBMS', text: 'Which join returns rows with matching values in both tables?', options: ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL OUTER JOIN'], correctIndex: 0),
  Question(subject: 'DBMS', text: 'Which constraint ensures no duplicate values in a column?', options: ['NOT NULL', 'UNIQUE', 'CHECK', 'DEFAULT'], correctIndex: 1),
  Question(subject: 'DBMS', text: 'Which language is used for defining database schema?', options: ['DML', 'DDL', 'DCL', 'TCL'], correctIndex: 1),
  Question(subject: 'DBMS', text: 'Which indexing method uses a tree structure?', options: ['Hash Indexing', 'B-Tree Indexing', 'Bitmap Indexing', 'Linear Indexing'], correctIndex: 1),
  Question(subject: 'DBMS', text: 'Which SQL function counts rows?', options: ['COUNT()', 'SUM()', 'AVG()', 'MAX()'], correctIndex: 0),
  Question(subject: 'DBMS', text: 'Which is a transaction property in ACID?', options: ['Access', 'Consistency', 'Durability', 'Isolation'], correctIndex: 1),

  // Operating System
  Question(subject: 'Operating Systems', text: 'Which scheduling algorithm gives the highest priority to the shortest job?', options: ['Round Robin', 'Shortest Job First', 'FIFO', 'Priority Scheduling'], correctIndex: 1),
  Question(subject: 'Operating Systems', text: 'Which component loads the OS into memory?', options: ['Compiler', 'Bootloader', 'Linker', 'Scheduler'], correctIndex: 1),
  Question(subject: 'Operating Systems', text: 'Which memory management technique allows non-contiguous allocation?', options: ['Paging', 'Contiguous Allocation', 'Fixed Partitioning', 'Single Partition'], correctIndex: 0),
  Question(subject: 'Operating Systems', text: 'Which system call is used to create a process in UNIX?', options: ['fork()', 'exec()', 'spawn()', 'create()'], correctIndex: 0),
  Question(subject: 'Operating Systems', text: 'Which is not a type of OS?', options: ['Batch', 'Time Sharing', 'Distributed', 'Database'], correctIndex: 3),
  Question(subject: 'Operating Systems', text: 'Which structure stores information about a process?', options: ['PCB', 'TCB', 'FAT', 'Page Table'], correctIndex: 0),
  Question(subject: 'Operating Systems', text: 'Which scheduling algorithm is preemptive?', options: ['First Come First Serve', 'Shortest Job Next', 'Round Robin', 'Non-preemptive Priority'], correctIndex: 2),
  Question(subject: 'Operating Systems', text: 'Which disk scheduling algorithm is also known as elevator algorithm?', options: ['FCFS', 'SCAN', 'C-SCAN', 'LOOK'], correctIndex: 1),
  Question(subject: 'Operating Systems', text: 'Which layer interacts directly with hardware?', options: ['Application', 'Kernel', 'Shell', 'Middleware'], correctIndex: 1),
  Question(subject: 'Operating Systems', text: 'Which memory is volatile?', options: ['ROM', 'Cache', 'RAM', 'Hard Disk'], correctIndex: 2),

  // Programming
  Question(subject: 'Programming', text: 'In Dart, which keyword is used to create a constant variable?', options: ['final', 'var', 'const', 'static'], correctIndex: 2),
  Question(subject: 'Programming', text: 'Which loop executes at least once?', options: ['for', 'while', 'do-while', 'foreach'], correctIndex: 2),
  Question(subject: 'Programming', text: 'Which data structure uses LIFO?', options: ['Queue', 'Stack', 'Array', 'Linked List'], correctIndex: 1),
  Question(subject: 'Programming', text: 'Which operator is used to compare equality in Dart?', options: ['=', '==', '!=', '==='], correctIndex: 1),
  Question(subject: 'Programming', text: 'Which keyword is used to define a class in Dart?', options: ['function', 'class', 'struct', 'object'], correctIndex: 1),
  Question(subject: 'Programming', text: 'Which OOP principle hides implementation details?', options: ['Inheritance', 'Polymorphism', 'Encapsulation', 'Abstraction'], correctIndex: 2),
  Question(subject: 'Programming', text: 'Which function is the entry point of a Dart program?', options: ['init()', 'main()', 'start()', 'run()'], correctIndex: 1),
  Question(subject: 'Programming', text: 'Which collection type in Dart stores unique values?', options: ['List', 'Map', 'Set', 'Array'], correctIndex: 2),
  Question(subject: 'Programming', text: 'Which programming paradigm is Dart mainly?', options: ['Functional', 'Procedural', 'Object-Oriented', 'Logic'], correctIndex: 2),
  Question(subject: 'Programming', text: 'Which symbol is used for string interpolation in Dart?', options: ['%', '#', r'$','&'], correctIndex: 2),
];

class HomePage extends StatelessWidget {
  // Extract unique subjects from sampleQuestions
  List<String> getSubjects() {
    final set = <String>{};
    for (var q in sampleQuestions) set.add(q.subject);
    return set.toList();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = getSubjects();

    return Scaffold(
      appBar: AppBar(
        title: Text('Subject-wise IT Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a subject',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  final count = sampleQuestions.where((q) => q.subject == subject).length;
                  return Card(
                    child: ListTile(
                      title: Text(subject),
                      subtitle: Text('$count questions'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => QuizPage(subject: subject),
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AllSubjectsReviewPage()));
              },
              icon: Icon(Icons.list),
              label: Text('Review all subjects & questions'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String subject;
  QuizPage({required this.subject});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questions;
  int currentIndex = 0;
  int score = 0;
  int? selectedOptionIndex;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    questions = sampleQuestions.where((q) => q.subject == widget.subject).toList();
  }

  void submitAnswer() {
    if (selectedOptionIndex == null) return; // do nothing if no selection

    setState(() {
      showAnswer = true;
      if (selectedOptionIndex == questions[currentIndex].correctIndex) {
        score += 1;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      selectedOptionIndex = null;
      showAnswer = false;
      if (currentIndex < questions.length - 1) {
        currentIndex += 1;
      } else {
        // show result page
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => ResultPage(score: score, total: questions.length, subject: widget.subject),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: (currentIndex + 1) / questions.length),
            SizedBox(height: 12),
            Text(
              'Question ${currentIndex + 1} of ${questions.length}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(q.text, style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            ...List.generate(q.options.length, (i) {
              final option = q.options[i];
              final isCorrect = i == q.correctIndex;
              final isSelected = selectedOptionIndex == i;

              Color? tileColor;
              if (showAnswer) {
                if (isCorrect) tileColor = Colors.green[100];
                else if (isSelected && !isCorrect) tileColor = Colors.red[100];
              }

              return Card(
                color: tileColor,
                child: RadioListTile<int>(
                  value: i,
                  groupValue: selectedOptionIndex,
                  title: Text(option),
                  onChanged: showAnswer
                      ? null
                      : (val) {
                          setState(() {
                            selectedOptionIndex = val;
                          });
                        },
                ),
              );
            }),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: showAnswer ? nextQuestion : submitAnswer,
                    child: Text(showAnswer ? (currentIndex == questions.length - 1 ? 'Finish' : 'Next') : 'Submit'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Score: $score', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final String subject;
  ResultPage({required this.score, required this.total, required this.subject});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: Text('$subject - Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You scored', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text('$score / $total', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('$percent%'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => QuizPage(subject: subject)));
                },
                child: Text('Retake Quiz'),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomePage()), (r) => false);
                },
                child: Text('Back to Subjects'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllSubjectsReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subjects = sampleQuestions
        .map((q) => q.subject)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('All Questions')),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: sampleQuestions.length,
        itemBuilder: (context, idx) {
          final q = sampleQuestions[idx];
          return Card(
            child: ListTile(
              title: Text(q.text),
              subtitle: Text('Subject: ${q.subject}\nOptions: ${q.options.join(', ')}\nAnswer: ${q.options[q.correctIndex]}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

/*
How to use:
1. Create a new Flutter project: `flutter create it_quiz`
2. Replace lib/main.dart with this file.
3. Run: `flutter run`

Possible improvements you may want to add:
- Load questions from JSON asset or remote API
- Add timers per question
- Store high scores with shared_preferences
- Add animations and polish UI
- Add images/media per question
- Add admin UI to add/edit questions
*/