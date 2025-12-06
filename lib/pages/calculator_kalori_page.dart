import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorKaloriPage extends StatefulWidget {
  const CalculatorKaloriPage({super.key});

  @override
  State<CalculatorKaloriPage> createState() => _CalculatorKaloriPageState();
}

class _CalculatorKaloriPageState extends State<CalculatorKaloriPage> {
  final TextEditingController beratC = TextEditingController();
  final TextEditingController tinggiC = TextEditingController();
  final TextEditingController usiaC = TextEditingController();

  String? gender;
  double? hasilKalori;
  String? informasi;

  void hitungKalori() {
    final berat = double.tryParse(beratC.text);
    final tinggi = double.tryParse(tinggiC.text);
    final usia = double.tryParse(usiaC.text);

    if (berat == null || tinggi == null || usia == null || gender == null) {
      setState(() {
        hasilKalori = null;
        informasi =
            "Beberapa data belum terisi. Lengkapi semua kolom untuk melihat hasil.";
      });
      return;
    }

    double bmr = 0;

    if (gender == "Pria") {
      bmr = 10 * berat + 6.25 * tinggi - 5 * usia + 5;
    } else {
      bmr = 10 * berat + 6.25 * tinggi - 5 * usia - 161;
    }

    setState(() {
      hasilKalori = bmr;
      informasi =
          "Nilai ini merupakan perkiraan kebutuhan energi dasar berdasarkan data yang dimasukkan.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
        title: const Text("Kalkulator Kalori"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Container Putih
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
                    // Jenis Kelamin
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: InputDecoration(
                        labelText: "Jenis Kelamin",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "Pria", child: Text("Pria")),
                        DropdownMenuItem(
                            value: "Wanita", child: Text("Wanita")),
                      ],
                      onChanged: (value) {
                        setState(() => gender = value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Berat Badan
                    TextField(
                      controller: beratC,
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

                    // Tinggi Badan
                    TextField(
                      controller: tinggiC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Tinggi Badan (cm)",
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Usia
                    TextField(
                      controller: usiaC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Usia (tahun)",
                        prefixIcon: const Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Button Hitung
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: hitungKalori,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Hitung Kalori",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Hasil
                    if (hasilKalori != null) ...[
                      Text(
                        "Estimasi Kebutuhan Kalori",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${hasilKalori!.toStringAsFixed(0)} kkal / hari",
                        style: GoogleFonts.montserrat(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        informasi ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                        ),
                      ),
                    ],

                    // Pesan jika data belum lengkap
                    if (hasilKalori == null && informasi != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        informasi!,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]
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
