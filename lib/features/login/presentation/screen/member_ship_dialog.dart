import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smart_gawali/features/login/presentation/screen/AnimalArjaFormScreen.dart';

class MembershipDialog extends StatelessWidget {
  const MembershipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '"गाय आणि म्हैस विक्रीसाठी!\nफक्त ₹29 मध्ये सदस्यता घ्या!\nआजच नोंदणी करा!"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'सहज प्राणी अपलोड करा\nखरेदीदारांपर्यंत पोहोचा\nजल्द विक्री आणि सोपी प्रक्रिया',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'एका महिन्यासाठी',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical:12),
                  decoration: const BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '₹२९',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  AnimalArjaFormScreen()),
                  );

                },
                child: const Text(
                  'सुरू ठेवा',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
