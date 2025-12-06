import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/name_routes.dart';
import '../services/fooddrink.dart';

class MakananKaloriPage extends StatefulWidget {
  const MakananKaloriPage({super.key});

  @override
  State<MakananKaloriPage> createState() => _MakananKaloriPageState();
}

class _MakananKaloriPageState extends State<MakananKaloriPage> {
  List<Map<String, dynamic>> makanan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMakanan();
  }

  Future<void> fetchMakanan() async {
    final service = ServicesFoodDrink();
    final data = await service.getMakanan(); // ambil dari Supabase
    setState(() {
      makanan = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 0,
        title: const Text("Makanan & Kalori"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: ListView.separated(
                      itemCount: makanan.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = makanan[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.pushNamed(
                            NameRoutes.detailMakananDanMinuman,
                            extra: item, // item dari list atau fetch supabase
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50, // soft orange
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Colors.orange.shade400, // avatar orange
                                  child: Icon(
                                    IconData(item['icon_code'],
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${item['calories']} kkal",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(NameRoutes.addMakananDanMinumKalori);
        },
        backgroundColor: Colors.orange.shade700,
        child: const Icon(Icons.fastfood),
      ),
    );
  }
}
