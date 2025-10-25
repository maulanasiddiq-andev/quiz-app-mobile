# 📱 Everyday Quiz (Flutter App)

Everyday Quiz adalah aplikasi mobile interaktif untuk membuat dan mengerjakan kuis harian.  
Aplikasi ini dikembangkan menggunakan **Flutter** dengan **Riverpod** untuk state management dan terintegrasi dengan backend **ASP.NET Core**.

---

## 🚀 Fitur Utama

- 🔐 **Autentikasi & OTP**
  - Register & login dengan validasi di Flutter dan backend.
  - OTP dikirim ke email melalui backend (berlaku 15 menit).
  - Login juga mendukung **Google Sign-In**.

- 👤 **Role & Module Access**
  - Fitur yang bisa diakses user ditentukan oleh role & module.
  - Role bisa dikustom oleh admin melalui dashboard backend.

- 🧠 **Kuis Interaktif**
  - Buat kuis: tambah detail, pertanyaan, dan upload gambar.
  - Navigasi antar soal dengan drawer + tombol next/previous.
  - State disimpan menggunakan **Riverpod**, termasuk current index & jawaban user.
  - Upload gambar ke **Google Cloud Storage Bucket** sebelum upload kuis ke server.

- 🕒 **Timer & Auto Submit**
  - Timer kuis dengan efek warna pada 10 detik terakhir (merah berkedip).
  - Konfirmasi sebelum keluar atau submit jawaban.
  - Auto-submit saat waktu habis.

- 📊 **Review Hasil Kuis**
  - User bisa melihat hasil kuis sendiri (nilai, durasi, jawaban benar/salah).
  - Warna hijau untuk jawaban benar, merah untuk jawaban salah.
  - Tidak bisa melihat hasil kuis milik user lain.

- 🌐 **Online & Offline Handling**
  - Deteksi koneksi internet (ada aksi khusus ketika offline).
  - Simpan email login terakhir di **flutter_secure_storage** untuk autofill.

---

## 🧱 Struktur Proyek

lib/
│
├── components/ # Widget reusable
├── constants/ # Konstanta global
├── exceptions/ # Exception handler
├── interceptors/ # Base Dio settings + JWT interceptor
├── models/ # Data models
├── notifiers/ # Riverpod notifiers
├── pages/ # UI pages
├── services/ # API service layer
├── states/ # State definitions
├── themes/ # App themes
└── utils/ # Utility functions


---

## 🧩 Teknologi yang Digunakan

- **Flutter SDK** ≥ 3.x  
- **Dart** ≥ 3.x  
- **Riverpod** untuk state management  
- **Dio** untuk HTTP client  
- **Flutter Secure Storage** untuk JWT dan email history  
- **Google Sign-In** integration  
- **Image Picker + Cropper**  
- **Connectivity Plus** untuk cek koneksi  
- **Material 3 UI**  

---

## ⚙️ Cara Menjalankan

### 1️⃣ Clone Repository
```bash
git clone https://github.com/username/everyday-quiz-flutter.git
cd everyday-quiz-flutter

flutter pub get

flutter run```
