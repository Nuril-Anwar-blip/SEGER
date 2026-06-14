# SEGER Exergame

Exergame adaptif untuk Anak Berkebutuhan Khusus (ASD, Cerebral Palsy, Down
Syndrome). Aplikasi menggabungkan deteksi gerakan/wajah berbasis kamera (ML
Kit) dengan antarmuka latihan yang ramah anak.

## Struktur Proyek (setelah penggabungan)

```
lib/
├── main.dart                     # Entry point: init Hive + routing
├── main_shell.dart                # Bottom navigation (Beranda/Latihan/Progres/Pengaturan)
├── core/theme/app_theme.dart      # ThemeData dasar (Material)
├── theme/app_colors.dart          # Palet warna kustom untuk UI baru
├── models/
│   ├── profil_anak.dart           # Model profil anak (Hive)
│   └── profil_anak.g.dart         # Adapter Hive (generated)
├── services/hive_service.dart     # Persistensi profil anak (backend)
└── screens/
    ├── onboarding/
    │   ├── onboarding_screen.dart           # Step 1: nama & umur
    │   └── onboarding_condition_screen.dart # Step 2: pilih kondisi -> simpan ke Hive
    ├── home/home_screen.dart                # Beranda + kartu profil dari Hive
    ├── exercise/exercise_screen.dart        # Kamera + ML Kit pose/face detection
    ├── progress/progress_screen.dart        # Grafik progres latihan
    ├── reward/reward_screen.dart            # Layar reward setelah sesi selesai
    └── settings/settings_screen.dart        # Pengaturan
```

## Apa yang digabungkan

Sebelumnya ada dua struktur project Flutter terpisah:

1. **Root project** (`pubspec.yaml` nama `seger_exergame`) — berisi UI
   frontend yang lebih lengkap (onboarding pemilihan kondisi, beranda dengan
   hero card, layar progres dengan grafik, layar reward, pengaturan, dan
   navigasi bawah `MainShell`). Namun `main.dart` masih mengarah ke
   layar-layar versi lama dan **tidak** terhubung ke Hive/ML Kit.

2. **Folder `SEGER/`** — berisi logika backend & ML: model `ProfilAnak` +
   adapter Hive, `HiveService` untuk menyimpan profil anak, dan
   `exercise_screen.dart` dengan integrasi kamera + `google_mlkit_pose_detection`
   + `google_mlkit_face_detection` untuk mendeteksi gerakan dan fokus anak
   secara real-time.

### Hasil penggabungan

- **`main.dart`** kini menginisialisasi `HiveService` saat startup dan
  menentukan rute awal: jika profil anak sudah tersimpan, langsung ke
  `MainShell` (`/main`); jika belum, mulai dari onboarding (`/`).
- **Onboarding** dipecah jadi 2 langkah (nama/umur → pilih kondisi), dan pada
  langkah terakhir data disimpan via `HiveService.saveProfil()` lalu
  diarahkan ke `MainShell`.
- **`HomeScreen`** kini menampilkan data profil asli dari Hive (nama,
  kondisi, usia) di atas tampilan hero card yang sudah ada.
- **`ExerciseScreen`** menggunakan logika kamera + ML Kit dari `SEGER/`
  (deteksi pose untuk skor gerakan & deteksi wajah untuk skor fokus), dengan
  overlay UI yang sama seperti sebelumnya, dan tombol "Selesai" sekarang
  menavigasi ke `RewardScreen`.
- **`pubspec.yaml`** digabung menjadi satu, memuat seluruh dependency yang
  dibutuhkan kedua sisi: `camera`, `google_mlkit_pose_detection`,
  `google_mlkit_face_detection`, `permission_handler`, `hive`/`hive_flutter`
  + `hive_generator`/`build_runner`, `flutter_riverpod`, `rive`,
  `flutter_tts`, `path_provider`, `uuid`.
- **`RewardScreen`** dan layar lain yang menavigasi ke `/main` kini berfungsi
  karena rute tersebut sudah didaftarkan.
- File `test/widget_test.dart` diperbaiki (sebelumnya mengimpor
  `package:samsung/main.dart` yang tidak sesuai dengan nama paket
  `seger_exergame`, dan menguji widget counter yang tidak ada).

## Langkah selanjutnya (wajib dijalankan di mesin developer)

Folder platform (`android/`, `ios/`, `macos/`, `windows/`, `linux/`, `web/`)
**tidak disertakan** dalam paket ini karena berisi banyak file
generated/binary dan beberapa konfigurasi yang saling bertentangan antara
kedua project asal (nama paket `com.example.samsung` vs
`com.example.seger_exergame`, nama binary `samsung` vs `seger_exergame`,
dll).

Setelah mengekstrak paket ini ke folder project baru, jalankan:

```bash
flutter create . --project-name seger_exergame --org com.example
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

`flutter create .` akan membuat ulang folder platform yang konsisten dengan
`pubspec.yaml` (nama `seger_exergame`, namespace
`com.example.seger_exergame`) tanpa menimpa folder `lib/`, `test/`,
`pubspec.yaml`, atau `analysis_options.yaml` yang sudah ada di paket ini.

Setelah itu, tambahkan secara manual ke `android/app/src/main/AndroidManifest.xml`
permission kamera (untuk fitur deteksi gerakan):

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

dan untuk iOS, tambahkan ke `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>SEGER membutuhkan akses kamera untuk mendeteksi gerakan latihan anak.</string>
```
