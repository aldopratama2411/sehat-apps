import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/name_routes.dart';
import '../services/fooddrink.dart';

class MinumanKaloriPage extends StatefulWidget {
  const MinumanKaloriPage({super.key});

  @override
  State<MinumanKaloriPage> createState() => _MinumanKaloriPageState();
}

class _MinumanKaloriPageState extends State<MinumanKaloriPage> {
  List<Map<String, dynamic>> minuman = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMinuman();
  }

  Future<void> fetchMinuman() async {
    final service = ServicesFoodDrink();
    final data = await service.getMinuman(); // ambil dari Supabase
    setState(() {
      minuman = data;
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
        title: const Text("Minuman & Kalori"),
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
                      itemCount: minuman.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = minuman[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.pushNamed(
                            NameRoutes.detailMakananDanMinuman,
                            extra: item,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50, // soft blue
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Colors.blueAccent.shade200, // avatar blue
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
        backgroundColor: Colors.blueAccent.shade700,
        child: const Icon(Icons.fastfood),
      ),
    );
  }
}
