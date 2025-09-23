import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EMIApp());
}

class EMIApp extends StatelessWidget {
  const EMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EMI Calculator",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const EMICalculator(),
    );
  }
}

class EMICalculator extends StatefulWidget {
  const EMICalculator({super.key});

  @override
  State<EMICalculator> createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  final TextEditingController loanController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  double? emi;
  double? totalPayment;
  double? totalInterest;

  void calculateEMI() {
    double principal = double.tryParse(loanController.text) ?? 0;
    double annualRate = double.tryParse(rateController.text) ?? 0;
    double months = double.tryParse(tenureController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || months <= 0) {
      setState(() {
        emi = null;
        totalPayment = null;
        totalInterest = null;
      });
      return;
    }

    double monthlyRate = annualRate / (12 * 100);
    double emiCalc = (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    setState(() {
      emi = emiCalc;
      totalPayment = emiCalc * months;
      totalInterest = totalPayment! - principal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // soft yellow background
      appBar: AppBar(
        title: const Text(
          "EMI Calculator",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField(
                controller: loanController,
                label: "Loan Amount",
                icon: Icons.money,
                color: Colors.orangeAccent),
            const SizedBox(height: 20),
            buildTextField(
                controller: rateController,
                label: "Interest Rate (%)",
                icon: Icons.percent,
                color: Colors.greenAccent),
            const SizedBox(height: 20),
            buildTextField(
                controller: tenureController,
                label: "Tenure (Months)",
                icon: Icons.calendar_today,
                color: Colors.lightBlueAccent),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateEMI,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.deepOrangeAccent,
                elevation: 5,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.orangeAccent],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Calculate EMI",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (emi != null)
              Column(
                children: [
                  Text("EMI: ₹${emi!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                  const SizedBox(height: 10),
                  Text("Total Payment: ₹${totalPayment!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, color: Colors.green)),
                  const SizedBox(height: 10),
                  Text("Total Interest: ₹${totalInterest!.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, color: Colors.red)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      required Color color}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: color, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: color, width: 2)),
      ),
    );
  }
}
