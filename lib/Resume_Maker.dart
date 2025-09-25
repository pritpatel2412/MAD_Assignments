// main.dart
// Resume Maker (Flutter) - Fixed Version
// Place this file in lib/main.dart of a new Flutter project.
//
// Features:
// - Fill personal details, multiple education & experience entries
// - Add skills and certifications
// - Live preview of a simple resume template
// - Export resume to PDF using `pdf` and `printing` packages
// - Fixed overflow issues and improved UI
//
// Dependencies (add to pubspec.yaml):
//   flutter:
//     sdk: flutter
//   cupertino_icons: ^1.0.2
//   pdf: ^3.10.1
//   printing: ^5.10.0
//
// Usage:
// 1. Add dependencies and run `flutter pub get`.
// 2. Replace lib/main.dart with this file.
// 3. Run: `flutter run`.

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(ResumeMakerApp());
}

class ResumeMakerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Maker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ResumeHomePage(),
    );
  }
}

// Models
class Education {
  String institute;
  String degree;
  String startYear;
  String endYear;

  Education({this.institute = '', this.degree = '', this.startYear = '', this.endYear = ''});
}

class Experience {
  String company;
  String role;
  String start;
  String end;
  String description;

  Experience({this.company = '', this.role = '', this.start = '', this.end = '', this.description = ''});
}

class ResumeData {
  String fullName = '';
  String title = '';
  String email = '';
  String phone = '';
  String linkedin = '';
  String summary = '';
  List<Education> education = [];
  List<Experience> experience = [];
  List<String> skills = [];
  List<String> certifications = [];
}

class ResumeHomePage extends StatefulWidget {
  @override
  _ResumeHomePageState createState() => _ResumeHomePageState();
}

class _ResumeHomePageState extends State<ResumeHomePage> {
  final ResumeData data = ResumeData();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController certController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // seed with one education and experience by default
    data.education.add(Education());
    data.experience.add(Experience());
  }

  @override
  void dispose() {
    skillController.dispose();
    certController.dispose();
    super.dispose();
  }

  void addEducation() {
    setState(() {
      data.education.add(Education());
    });
  }

  void removeEducation(int index) {
    setState(() {
      if (data.education.length > 1) data.education.removeAt(index);
    });
  }

  void addExperience() {
    setState(() {
      data.experience.add(Experience());
    });
  }

  void removeExperience(int index) {
    setState(() {
      if (data.experience.length > 1) data.experience.removeAt(index);
    });
  }

  void addSkill() {
    final s = skillController.text.trim();
    if (s.isNotEmpty) {
      setState(() {
        data.skills.add(s);
        skillController.clear();
      });
    }
  }

  void addCertification() {
    final s = certController.text.trim();
    if (s.isNotEmpty) {
      setState(() {
        data.certifications.add(s);
        certController.clear();
      });
    }
  }

  Future<void> exportPdf() async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (pw.Context ctx) => [
          pw.Header(level: 0, child: pw.Text(data.fullName, style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold))),
          pw.Text(data.title, style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 8),
          pw.Row(children: [
            pw.Text('Email: ${data.email}   '),
            pw.Text('Phone: ${data.phone}  '),
            pw.Text('LinkedIn: ${data.linkedin}'),
          ]),
          pw.SizedBox(height: 12),
          if (data.summary.isNotEmpty) pw.Column(children: [pw.Text('Professional Summary', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)), pw.SizedBox(height: 6), pw.Text(data.summary)]),
          pw.SizedBox(height: 12),
          if (data.experience.isNotEmpty)
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('Experience', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Column(children: data.experience.map((e) {
                return pw.Container(padding: pw.EdgeInsets.only(bottom: 6), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('${e.role} — ${e.company}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text('${e.start} - ${e.end}')]),
                  if (e.description.isNotEmpty) pw.Text(e.description),
                ]));
              }).toList())
            ]),
          pw.SizedBox(height: 10),
          if (data.education.isNotEmpty)
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('Education', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Column(children: data.education.map((ed) {
                return pw.Container(padding: pw.EdgeInsets.only(bottom: 6), child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text(ed.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(ed.institute)]), pw.Text('${ed.startYear} - ${ed.endYear}')]));
              }).toList())
            ]),
          pw.SizedBox(height: 10),
          if (data.skills.isNotEmpty) pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text('Skills', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)), pw.SizedBox(height: 6), pw.Wrap(spacing: 6, runSpacing: 6, children: data.skills.map((s) => pw.Container(padding: pw.EdgeInsets.all(6), decoration: pw.BoxDecoration(border: pw.Border.all()), child: pw.Text(s))).toList())]),
          pw.SizedBox(height: 10),
          if (data.certifications.isNotEmpty) pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text('Certifications', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)), pw.SizedBox(height: 6), pw.Column(children: data.certifications.map((c) => pw.Bullet(text: c)).toList())]),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await doc.save(), filename: '${data.fullName}_Resume.pdf');
  }

  Widget buildTextField({required String label, required String hint, required Function(String) onChanged, String? initial}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(
          labelText: label, 
          hintText: hint, 
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildEducationCard(int idx) {
    final ed = data.education[idx];
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Education ${idx + 1}', style: TextStyle(fontWeight: FontWeight.bold)), 
                if (data.education.length > 1)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeEducation(idx),
                  ),
              ],
            ),
            buildTextField(label: 'Institute', hint: 'e.g. ABC University', initial: ed.institute, onChanged: (v) => ed.institute = v),
            buildTextField(label: 'Degree', hint: 'e.g. B.Tech Computer Science', initial: ed.degree, onChanged: (v) => ed.degree = v),
            Row(
              children: [
                Expanded(child: buildTextField(label: 'Start Year', hint: 'e.g. 2018', initial: ed.startYear, onChanged: (v) => ed.startYear = v)), 
                SizedBox(width: 8), 
                Expanded(child: buildTextField(label: 'End Year', hint: 'e.g. 2022', initial: ed.endYear, onChanged: (v) => ed.endYear = v))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExperienceCard(int idx) {
    final ex = data.experience[idx];
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Experience ${idx + 1}', style: TextStyle(fontWeight: FontWeight.bold)), 
                if (data.experience.length > 1)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeExperience(idx),
                  ),
              ],
            ),
            buildTextField(label: 'Company', hint: 'e.g. Acme Corp', initial: ex.company, onChanged: (v) => ex.company = v),
            buildTextField(label: 'Role', hint: 'e.g. Software Engineer', initial: ex.role, onChanged: (v) => ex.role = v),
            Row(
              children: [
                Expanded(child: buildTextField(label: 'Start', hint: 'e.g. Jun 2022', initial: ex.start, onChanged: (v) => ex.start = v)), 
                SizedBox(width: 8), 
                Expanded(child: buildTextField(label: 'End', hint: 'e.g. Present', initial: ex.end, onChanged: (v) => ex.end = v))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                initialValue: ex.description,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description', 
                  hintText: 'Briefly describe responsibilities', 
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (v) => ex.description = v,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resumePreview() {
    return Container(
      height: MediaQuery.of(context).size.height - kToolbarHeight - 20,
      child: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  data.fullName.isEmpty ? 'Full Name' : data.fullName, 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  data.title.isEmpty ? 'Professional Title' : data.title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(data.email.isEmpty ? 'email@example.com' : data.email)), 
                    SizedBox(width: 12), 
                    Expanded(child: Text(data.phone.isEmpty ? '+91-XXXXXXXXXX' : data.phone))
                  ],
                ),
                if (data.linkedin.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(data.linkedin, style: TextStyle(color: Colors.blue)),
                ],
                SizedBox(height: 12),
                if (data.summary.isNotEmpty) ...[
                  Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(data.summary),
                  SizedBox(height: 12),
                ],
                if (data.experience.isNotEmpty) ...[
                  Text('Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ...data.experience.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${e.role.isEmpty ? 'Role' : e.role} — ${e.company.isEmpty ? 'Company' : e.company}', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${e.start.isEmpty ? 'Start' : e.start} - ${e.end.isEmpty ? 'End' : e.end}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        if (e.description.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(e.description, style: TextStyle(fontSize: 14)),
                        ],
                      ],
                    ),
                  )).toList(),
                ],
                if (data.education.isNotEmpty) ...[
                  Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ...data.education.map((ed) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ed.degree.isEmpty ? 'Degree' : ed.degree, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(ed.institute.isEmpty ? 'Institute' : ed.institute, style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Text(
                          '${ed.startYear.isEmpty ? 'Start' : ed.startYear} - ${ed.endYear.isEmpty ? 'End' : ed.endYear}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )).toList(),
                  SizedBox(height: 8),
                ],
                if (data.skills.isNotEmpty) ...[
                  Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: data.skills.map((s) => Chip(
                      label: Text(s, style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.teal.shade50,
                    )).toList(),
                  ),
                  SizedBox(height: 12),
                ],
                if (data.certifications.isNotEmpty) ...[
                  Text('Certifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ...data.certifications.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text('• $c'),
                  )).toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Maker'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: exportPdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // Wide layout - two columns
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: buildForm(),
                ),
                Expanded(
                  flex: 2,
                  child: resumePreview(),
                ),
              ],
            );
          }

          // Narrow layout - single column with tabs
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.teal,
                  tabs: [
                    Tab(icon: Icon(Icons.edit), text: 'Edit'),
                    Tab(icon: Icon(Icons.preview), text: 'Preview'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      buildForm(),
                      resumePreview(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Section
            Text('Personal Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            buildTextField(
              label: 'Full Name', 
              hint: 'e.g. John Doe', 
              onChanged: (v) => setState(() => data.fullName = v),
            ),
            buildTextField(
              label: 'Professional Title', 
              hint: 'e.g. Mobile Developer', 
              onChanged: (v) => setState(() => data.title = v),
            ),
            buildTextField(
              label: 'Email', 
              hint: 'e.g. name@example.com', 
              onChanged: (v) => setState(() => data.email = v),
            ),
            buildTextField(
              label: 'Phone', 
              hint: 'e.g. +91-9876543210', 
              onChanged: (v) => setState(() => data.phone = v),
            ),
            buildTextField(
              label: 'LinkedIn / Website', 
              hint: 'Optional', 
              onChanged: (v) => setState(() => data.linkedin = v),
            ),
            
            SizedBox(height: 16),
            Text('Professional Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                initialValue: data.summary,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'A brief professional summary showcasing your expertise and career goals',
                  contentPadding: EdgeInsets.all(12),
                ),
                onChanged: (v) => setState(() => data.summary = v),
              ),
            ),

            // Experience Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Work Experience', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: addExperience,
                  icon: Icon(Icons.add),
                  label: Text('Add Experience'),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...List.generate(data.experience.length, (i) => buildExperienceCard(i)),
            
            SizedBox(height: 16),

            // Education Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Education', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: addEducation,
                  icon: Icon(Icons.add),
                  label: Text('Add Education'),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...List.generate(data.education.length, (i) => buildEducationCard(i)),
            
            SizedBox(height: 16),

            // Skills Section
            Text('Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: skillController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add a skill (e.g. Flutter, Python)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onFieldSubmitted: (_) => addSkill(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addSkill,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (data.skills.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.skills.map((s) => Chip(
                  label: Text(s),
                  onDeleted: () => setState(() => data.skills.remove(s)),
                  deleteIcon: Icon(Icons.close, size: 16),
                )).toList(),
              ),

            SizedBox(height: 16),

            // Certifications Section
            Text('Certifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: certController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add a certification',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onFieldSubmitted: (_) => addCertification(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addCertification,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (data.certifications.isNotEmpty)
              ...data.certifications.map((c) => ListTile(
                dense: true,
                leading: Icon(Icons.verified, color: Colors.teal, size: 16),
                title: Text(c),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => setState(() => data.certifications.remove(c)),
                ),
                contentPadding: EdgeInsets.zero,
              )).toList(),

            SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: exportPdf,
                  icon: Icon(Icons.file_download),
                  label: Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}