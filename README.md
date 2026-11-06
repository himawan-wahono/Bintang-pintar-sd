# ⭐ Bintang Pintar SD — Petualangan Belajar Interaktif

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%26%20Auth-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Google Gemini AI](https://img.shields.io/badge/AI-Google%20Gemini-8E75C4?logo=google&logoColor=white)](https://ai.google.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20Ready-3DDC84?logo=android&logoColor=white)](https://developer.android.com)
[![Curriculum](https://img.shields.io/badge/Curriculum-Kurikulum%20Merdeka%20SD-brightgreen)](https://kurikulum.kemdikbud.go.id/)

**Bintang Pintar SD** adalah aplikasi pembelajaran dan latihan soal interaktif untuk siswa Sekolah Dasar (Kelas 1–6) berbasis **Kurikulum Merdeka**. Dirancang dengan arsitektur **Hybrid Client-First (Offline-First)** yang memungkinkan ribuan latihan soal dimainkan secara instan tanpa ketergantungan koneksi internet, serta didukung oleh generator soal otomatis berbasis **Google Gemini AI**.

---

## 🚀 Fitur Unggulan & Arsitektur Teknis

### 1. 🎨 Native Vector Rendering Engine (`CustomPainter`)
Tidak bergantung pada file gambar eksternal/CDN yang membebani kuota dan lambat dimuat. Aplikasi menggambar langsung diagram matematika menggunakan vector canvas:
* **Geometri 2D & 3D**: Persegi, Segitiga, Lingkaran, Kubus 3D Isometrik, dan Tabung dengan label dimensi dinamis ($p, l, t, r$).
* **Analisis Data & Statistika**: Diagram Batang (*Dynamic Bar Chart*) dan Diagram Gambar (*Pictogram* berbasis skala emoji).
* **Sudut & Waktu**: Jam analog dengan perputaran jarum jam & menit presisi, serta busur derajat sudut.
* **Pecahan**: Diagram kue pecahan (*Pie Fraction*) dengan arsiran dinamis.

### 2. ⚡ Arsitektur Hybrid Offline-First
* **0-Latency Offline Engine**: Ribuan bank soal terkompresi tertanam langsung di dalam aplikasi (`assets/data/bank_soal_base.json`).
* **Delta Cloud Sync**: Saat terhubung ke internet, aplikasi hanya mengunduh selisih (*delta*) soal baru dari **Cloud Firestore** tanpa membaca ulang database, menjaga biaya database tetap **Rp 0 / 100% Free Tier**.

### 3. 🤖 AI Automated Question Generator (GitHub Actions + Gemini)
* Alur otomatis mingguan menggunakan GitHub Actions CI/CD dan Google Gemini Generative AI SDK.
* Secara sistematis memproduksi soal-soal HOTS & kontekstual untuk 19 topik Matematika dan 18 topik Bahasa Inggris dengan pemeriksaan anti-duplikasi ketat (*Strict Deduplication Check*).

### 4. 🎮 Gamifikasi Pendidikan & Portal Pendampingan
* **Petualangan Peta**: *Math Saga Map* dan *English World Map* dengan sistem level bertingkat.
* **Sistem Reward**: Koin Bintang, Combo Streak, Lencana Penghargaan (*Badges*), dan Avatar interaktif.
* **Mode Santai vs Waktu**: Pilihan batas waktu fleksibel (Mode Santai tanpa batas waktu / Mode Tantangan).
* **Dashboard Orang Tua/Guru**: Dilindungi PIN Keamanan, manajemen soal kustom mandiri, pengaturan penukaran hadiah riil, serta fitur cetak lembar kerja kuis ke **PDF**.

---

## 🛠️ Tech Stack & Libraries

| Kategori | Teknologi / Library |
| :--- | :--- |
| **Framework** | Flutter (Dart 3.x) |
| **State Management** | `provider: ^6.1.2` |
| **Backend & Database** | Google Firebase (Firestore & Firebase Auth) |
| **Local Storage** | `shared_preferences: ^2.2.2` |
| **Export & Printing** | `pdf: ^3.12.0`, `printing: ^5.14.3` |
| **UI & Animations** | `flutter_animate: ^4.5.0`, `google_fonts: ^6.1.0` |
| **AI Integration** | `@google/generative-ai` (Node.js Automation via GitHub Actions) |

---

## 📂 Struktur Proyek

```text
lib/
├── models/         # Model data (Question, UserStats, Profile, Reward)
├── providers/      # State Management (Quiz, User, Stats, Parent)
├── screens/        # Antarmuka Pengguna (Saga Map, Quiz, Review, Dashboard Ortu)
├── services/       # Integrasi Firestore, Auth, PDF Export, Connectivity
├── utils/          # Tema Warna, Storage Helper, Parser
└── widgets/        # Dynamic Vector Painters, Dialogs, Cards
```

---

## 💻 Cara Menjalankan Proyek Secara Lokal

1. **Clone repository ini**:
   ```bash
   git clone https://github.com/USERNAME/bintang-pintar-sd.git
   cd bintang-pintar-sd
   ```

2. **Pasang dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan di emulator atau perangkat fisik**:
   ```bash
   flutter run
   ```

4. **Build APK Release**:
   ```bash
   flutter build apk --release
   ```

---

## 👨‍💻 Author & Personal Branding
* **Developer**: Portofolio Pengembang Aplikasi Edukasi Flutter & AI
* **Lisensi**: Proyek ini dikembangkan untuk tujuan edukasi dan portofolio profesional.
