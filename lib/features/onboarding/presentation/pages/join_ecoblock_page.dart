import 'package:ecoblock_mobile/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/controllers/onboarding_controller.dart';

class JoinEcoBlockPage extends ConsumerWidget {
  const JoinEcoBlockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Illustration simple (niveau 1, pas d'animation)
                  Icon(Icons.eco, color: Color(0xFF6E7426), size: 96),
                  const SizedBox(height: 32),
                  Text(
                    "🌍 Bienvenue dans EcoBlock",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E7426),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Crée ton nœud pour rejoindre le réseau et contribuer à la collecte collaborative de données environnementales.",
                    style: TextStyle(fontSize: 18, color: Color(0xFF50551D)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: Text(
                      'Créer mon nœud',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6E7426),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      await controller.associateNode();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const AppShell()),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Color(0xFFEFD5B7),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "Comment ça marche ?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6E7426),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "1. Crée ton nœud local sécurisé",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF50551D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      "+10 XP",
                                      style: TextStyle(
                                        color: Color(0xFF6E7426),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFFFBEFDF),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "2. Découvre et associe des voisins",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF50551D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      "+20 XP",
                                      style: TextStyle(
                                        color: Color(0xFF6E7426),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFFFBEFDF),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "3. Participe à la propagation des blocs et à la collecte de données",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF50551D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      "+30 XP",
                                      style: TextStyle(
                                        color: Color(0xFF6E7426),
                                      ),
                                    ),
                                    backgroundColor: Color(0xFFFBEFDF),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "EcoBlock respecte ta vie privée : toutes les clés sont générées et stockées localement sur ton appareil.",
                    style: TextStyle(fontSize: 14, color: Color(0xFF50551D)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
