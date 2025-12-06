import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorBMIPage extends StatefulWidget {
  const CalculatorBMIPage({super.key});

  @override
  State<CalculatorBMIPage> createState() => _CalculatorBMIPageState();
}

class _CalculatorBMIPageState extends State<CalculatorBMIPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  double? bmiResult;
  String status = "";
  String infoText =
      "Masukkan tinggi dan berat badan Anda untuk menghitung BMI.";

  void calculateBMI() {
    final weight = double.tryParse(weightController.text);
    final height = double.tryParse(heightController.text);

    // Validasi input
    if (weight == null || height == null) {
      setState(() {
        bmiResult = null;
        status = "";
        infoText = "Pastikan angka yang dimasukkan sudah benar.";
      });
      return;
    }

    // Batasan berat
    if (weight < 20 || weight > 200) {
      setState(() {
        bmiResult = null;
        status = "";
        infoText = "Berat badan harus berada antara 20 – 200 kg.";
      });
      return;
    }

    // Batasan tinggi
    if (height < 100 || height > 220) {
      setState(() {
        bmiResult = null;
        status = "";
        infoText = "Tinggi badan harus berada antara 100 – 220 cm.";
      });
      return;
    }

    // Perhitungan BMI
    final heightMeter = height / 100;
    final bmi = weight / (heightMeter * heightMeter);

    setState(() {
      bmiResult = bmi;

      // Kategori Netral Tanpa Saran
      if (bmi < 18.5) {
        status = "Kurus";
        infoText = "BMI Anda berada dalam kategori Kurus.";
      } else if (bmi < 25) {
        status = "Normal / Ideal";
        infoText = "BMI Anda berada dalam kategori Normal / Ideal.";
      } else if (bmi < 30) {
        status = "Kelebihan Berat Badan";
        infoText = "BMI Anda berada dalam kategori Kelebihan Berat Badan.";
      } else {
        status = "Obesitas";
        infoText = "BMI Anda berada dalam kategori Obesitas.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
        title: const Text("Kalkulator BMI"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // BERAT BADAN
                    TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Berat Badan (kg)",
                        prefixIcon: const Icon(Icons.monitor_weight_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // TINGGI BADAN
                    TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Tinggi Badan (cm)",
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // BUTTON HITUNG
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Hitung BMI",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // INFORMASI AWAL ATAU PESAN
                    if (bmiResult == null) ...[
                      Text(
                        infoText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],

                    // HASIL BMI
                    if (bmiResult != null) ...[
                      Text(
                        "BMI Anda",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        bmiResult!.toStringAsFixed(1),
                        style: GoogleFonts.montserrat(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        status,
                        style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        infoText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(fontSize: 15),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
