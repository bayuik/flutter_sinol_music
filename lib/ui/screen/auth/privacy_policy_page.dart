import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const routeName = '/privacy-policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Center(
        child: Container(
          child: Text(
            "Privacy Policy\nKebijakan Privasi\nKami menghargai privasi Anda dan berkomitmen untuk melindungi informasi pribadi yang Anda berikan kepada kami. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan membagikan informasi yang diberikan kepada kami melalui aplikasi ini.\nInformasi yang Kami Kumpulkan\nKami mengumpulkan informasi yang Anda berikan secara sukarela melalui formulir pendaftaran, pesan, atau interaksi lainnya dengan situs web kami. Informasi yang mungkin kami kumpulkan termasuk nama, alamat email, nomor telepon, dan informasi lainnya yang Anda berikan kepada kami.\nBagaimana Kami Menggunakan Informasi yang Dikumpulkan\nKami menggunakan informasi yang dikumpulkan untuk meningkatkan pengalaman penggunaan situs web kami, menyediakan layanan yang Anda minta, mengirimkan informasi yang Anda minta, dan untuk mengirimkan email kepada Anda.\nBagaimana Kami Membagikan Informasi yang Dikumpulkan\nKami tidak akan memberikan informasi pribadi Anda kepada pihak ketiga tanpa persetujuan Anda, kecuali jika diwajibkan oleh hukum.\nCookies\n\nKami menggunakan cookies untuk meningkatkan pengalaman penggunaan situs web kami. Dengan menggunakan situs web kami, Anda setuju dengan penggunaan cookies kami.\n\nPerubahan Kebijakan Privasi\n\nKami dapat memperbarui kebijakan privasi kami dari waktu ke waktu. Perubahan terbaru akan diterapkan setelah diterbitkan di situs web ini. Pastikan Anda selalu memeriksa kembali kebijakan ini untuk perubahan terbaru.\n\nHubungi Kami\n\nJika Anda memiliki pertanyaan tentang kebijakan privasi ini, jangan ragu untuk menghubungi kami.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
