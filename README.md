# Funks Kitchen

Funks Kitchen adalah aplikasi mobile yang memungkinkan pengguna untuk melihat menu, detail hidangan, informasi terkait restoran, dan fitur-fitur lainnya. Aplikasi ini dibangun menggunakan Flutter, memastikan tampilan dan performa yang optimal di platform Android dan iOS.

## Fitur Aplikasi

- **Lihat Menu**: Pengguna dapat melihat berbagai macam menu yang ditawarkan oleh Funks Kitchen, termasuk kategori makanan dan minuman.
- **Detail Hidangan**: Menyediakan informasi lengkap tentang hidangan, seperti deskripsi, bahan, harga, dan gambar.
- **Pencarian Cepat**: Fitur pencarian untuk membantu pengguna menemukan hidangan favorit mereka dengan cepat.
- **Sistem Filter**: Filter berdasarkan kategori, harga, popularitas, atau preferensi lainnya.
- **Ulasan Pengguna**: Pengguna dapat melihat ulasan dan rating dari pengunjung lain.
- **Favorit**: Simpan hidangan ke daftar favorit untuk akses cepat di masa depan.
- **Notifikasi Promo**: Mendapatkan notifikasi terkait penawaran spesial dan promo dari Funks Kitchen.

## Teknologi yang Digunakan

- **Flutter**: Framework utama untuk pengembangan aplikasi lintas platform (Android & iOS).
- **Dart**: Bahasa pemrograman yang digunakan dalam Flutter.
- **Firebase**: Untuk otentikasi pengguna, penyimpanan data, dan notifikasi.
- **Provider**: Untuk manajemen state dalam aplikasi.
- **HTTP**: Untuk mengambil data menu dan informasi terkait dari API (jika terintegrasi dengan server).

## Instalasi

1. **Clone Repository**

   ```bash
   git clone https://github.com/username/funks-kitchen.git
   cd funks-kitchen

2. **Install Dependencies**
   Pastikan Flutter sudah terinstal di sistem Anda. Jika belum, ikuti panduan instalasi Flutter.
   Setelah itu, jalankan perintah berikut untuk menginstal dependencies:

   ```bash
   flutter pub get

3. **Menjalankan Aplikasi**
   Hubungkan perangkat Android/iOS atau gunakan emulator, kemudian jalankan aplikasi:

   ```bash
   flutter run

## Struktur Folder

- **lib/:** Berisi kode utama aplikasi.
   - **models/:** Berisi model data seperti menu, user, dll.
   - **pages/:** Halaman-halaman utama aplikasi seperti home, detail menu, dll. - widgets/: Widget-widget khusus yang digunakan di berbagai halaman.
   - **providers/:** Untuk pengaturan state management dengan Provider.
   - **services/:** Berisi file untuk koneksi ke API atau Firebase.

## Kontribusi

1. Fork repository ini.
2. Buat branch baru untuk fitur atau perbaikan.
3. Lakukan commit perubahan Anda.
4. Push branch dan buat Pull Request.

Kami menghargai setiap kontribusi untuk meningkatkan aplikasi Funks Kitchen!

## Lisensi
Proyek ini dilisensikan di bawah MIT License.
   ```bash
   README ini memberikan gambaran lengkap tentang proyek, cara instalasi, serta struktur aplikasi, yang akan memudahkan pengembang lain untuk berkolaborasi dalam pengembangan aplikasi Funks Kitchen.
