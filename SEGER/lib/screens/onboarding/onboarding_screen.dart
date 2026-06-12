import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/profil_anak.dart';
import '../../services/hive_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController(text: "8");

  String _selectedKondisi = "autisme";

  final List<Map<String, String>> kondisiList = [
    {"value": "autisme", "label": "Autisme"},
    {"value": "cerebral_palsy", "label": "Cerebral Palsy"},
    {"value": "down_syndrome", "label": "Down Syndrome"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selamat Datang di SEGER')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil Anak',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Anak',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _usiaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Umur (tahun)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            const Text('Kondisi:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedKondisi,
              isExpanded: true,
              items: kondisiList.map((kondisi) {
                return DropdownMenuItem(
                  value: kondisi['value'],
                  child: Text(kondisi['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedKondisi = value!);
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (_namaController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nama anak tidak boleh kosong')),
                    );
                    return;
                  }

                  final usia = int.tryParse(_usiaController.text) ?? 8;

                  final profil = ProfilAnak(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nama: _namaController.text.trim(),
                    kondisi: _selectedKondisi,
                    usia: usia,
                  );

                  await HiveService.saveProfil(profil);
                  print('✅ Profil disimpan: ${profil.nama}, ${profil.usia} tahun');

                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Mulai Latihan', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}