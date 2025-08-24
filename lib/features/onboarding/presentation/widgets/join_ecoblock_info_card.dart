import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinEcoBlockInfoCard extends StatelessWidget {
  const JoinEcoBlockInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.35),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Text(
                'ℹ️ Un nœud est un appareil qui rejoint le réseau local BLE. Il collecte et relaye des données écologiques anonymement.',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 15,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
