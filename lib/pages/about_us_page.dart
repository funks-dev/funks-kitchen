import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/sidebar.dart';
import '../components/footer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600, // Semibold weight
                    fontFamily: 'Inter', // Inter font
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: 390,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset('assets/images/about_us.png', fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Selamat datang di Funks Kitchen tempat di mana seni kuliner bertemu dengan imajinasi, dan setiap sajian menjadi sebuah karya seni yang menggugah indera! Kami adalah restoran modern yang menggabungkan hidangan lezat dengan atmosfer yang penuh warna, funky, dan menyenangkan. Misi kami adalah memberikan lebih dari sekadar hidangan yang memuaskan; kami ingin menciptakan momen-momen berkesan yang tak terlupakan bagi setiap tamu.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400, // Semibold weight
                        fontFamily: 'Inter', // Inter font
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Dipimpin oleh beberapa Chef ternama, seorang maestro kuliner dengan lebih dari 10 tahun pengalaman di dapur internasional, Funks Kitchen menyajikan menu yang beragam dan terus berkembang. Setiap hidangan di sini diciptakan dengan memadukan bahan-bahan segar pilihan dan teknik inovatif untuk menghasilkan kombinasi rasa yang menakjubkan. Tidak hanya soal rasa, penyajian makanan di Funks Kitchen dirancang agar memanjakan mata sebelum memuaskan lidah.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Menu kami dirancang untuk memenuhi selera berbagai kalangan, dengan pilihan yang mencakup daging berkualitas premium, pasta yang dibuat dengan resep otentik, dan beragam hidangan vegetarian serta vegan yang kaya rasa dan nutrisi. Dari bahan-bahan segar hingga sentuhan inovatif dalam setiap bumbu dan saus, kami memastikan bahwa setiap hidangan membawa kejutan dan kepuasan.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Suasana Funks Kitchen: Lebih dari Sekadar Restoran Masuki dunia Funks Kitchen dan rasakan atmosfer yang penuh dengan energi positif. Desain interior kami mengusung tema modern yang berpadu dengan warna-warna cerah dan elemen funky yang menciptakan suasana hangat dan ceria. Restoran kami adalah tempat yang ideal untuk berkumpul bersama keluarga, teman, atau kolega dalam suasana santai namun tetap penuh gaya.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Tidak peduli apakah Anda datang untuk makan siang cepat, makan malam romantis, atau sekadar nongkrong dengan teman, Funks Kitchen selalu memberikan ruang untuk pengalaman yang penuh kebahagiaan. Pelayanan ramah dan profesional menjadi prioritas kami, memastikan setiap tamu merasa dihargai dan nyaman dari saat masuk hingga keluar pintu.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Misi Kami: Menghadirkan Pengalaman Kuliner yang Unik Kami percaya bahwa setiap gigitan bisa menjadi petualangan. Oleh karena itu, kami selalu berinovasi dengan menu kami, memperkenalkan kombinasi rasa baru, serta teknik penyajian yang unik. Tidak hanya sekadar menyajikan makanan, kami juga ingin memberi Anda pengalaman kuliner yang menginspirasi dan membuat Anda ingin kembali lagi.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Kami di Funks Kitchen berkomitmen untuk menjadikan setiap kunjungan Anda sebagai momen yang berharga, di mana Anda bisa bersenang-senang, menikmati makanan lezat, dan berbagi tawa dengan orang-orang tercinta.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Terima Kasih dari Kami Terima kasih telah memilih Funks Kitchen, tempat di mana kreativitas dan rasa bersatu untuk menciptakan pengalaman kuliner yang luar biasa. Kami sangat menghargai kepercayaan Anda dan berharap bisa terus menjadi bagian dari momen-momen spesial Anda.",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Funks Kitchen: di mana setiap gigitan adalah petualangan dan setiap kunjungan adalah kenangan yang manis!",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Footer outside the Padding for full-width alignment
            const Footer(),
          ],
        ),
      ),
    );
  }
}
