# 📦 Stockin - Smart Warehouse Monitoring

Stockin adalah aplikasi mobile berbasis Flutter yang digunakan untuk memonitor dan mengelola persediaan barang di gudang secara real-time. Aplikasi ini terintegrasi dengan Firebase Authentication dan Cloud Firestore untuk pengelolaan data pengguna, barang, serta transaksi stok.

## Fitur Utama

### 🔐 Authentication

* Login pengguna
* Registrasi akun
* Manajemen sesi pengguna menggunakan Firebase Authentication

### 📊 Dashboard

* Ringkasan jumlah barang
* Monitoring stok minimum
* Statistik barang masuk dan keluar
* Analitik transaksi dalam periode:

    * 7 Hari
    * 1 Bulan
    * 3 Bulan

### 📦 Manajemen Barang

* Menampilkan daftar barang
* Menambah barang baru
* Mengubah data barang
* Monitoring stok minimum
* Informasi SKU, satuan, dan deskripsi barang

### 📥 Barang Masuk (Stock In)

* Pencatatan barang masuk
* Penambahan jumlah stok otomatis
* Riwayat transaksi masuk

### 📤 Barang Keluar (Stock Out)

* Pencatatan barang keluar
* Pengurangan stok otomatis
* Validasi ketersediaan stok
* Riwayat transaksi keluar

### 📑 Riwayat Transaksi

* Menampilkan seluruh transaksi
* Filter transaksi:

    * Semua
    * Barang Masuk
    * Barang Keluar

### 👤 Profile

* Menampilkan informasi pengguna
* Logout akun

---

# Arsitektur Project

Project menggunakan pendekatan:

* Feature-Based Architecture
* Provider State Management
* Firebase Backend Services
* Clean Separation antara:

    * Presentation Layer
    * Provider Layer
    * Data Layer

Struktur utama:

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
│
├── core/
│   ├── services/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── items/
│   ├── navigation/
│   ├── profile/
│   └── transactions/
│
├── models/
│
├── firebase_options.dart
└── main.dart
```

---

# 📂 Detail Struktur Folder

## app/

Konfigurasi aplikasi secara global.

| File        | Fungsi                    |
| ----------- | ------------------------- |
| app.dart    | Inisialisasi aplikasi     |
| routes.dart | Routing halaman           |
| theme.dart  | Konfigurasi tema aplikasi |

---

## core/

### services/

Berisi service global yang dapat digunakan di seluruh aplikasi.

### widgets/

Widget reusable seperti:

* LoadingWidget
* EmptyStateWidget
* ErrorStateWidget

---

## features/

### auth/

Manajemen autentikasi pengguna.

```text
auth/
├── data/
├── provider/
└── presentation/
```

Fitur:

* Login
* Register
* Logout

---

### dashboard/

Menampilkan informasi ringkasan gudang.

Fitur:

* Total barang
* Barang stok rendah
* Statistik transaksi
* Grafik analitik

---

### items/

Manajemen data barang.

Fitur:

* Tambah barang
* Edit barang
* Daftar barang

Data yang disimpan:

```json
{
  "name": "Laptop",
  "sku": "LP001",
  "stock": 100,
  "minStock": 10,
  "unit": "Unit",
  "description": "Laptop kantor"
}
```

---

### transactions/

Pengelolaan transaksi stok.

Fitur:

* Barang masuk
* Barang keluar
* Riwayat transaksi

Jenis transaksi:

```text
in  = Barang Masuk
out = Barang Keluar
```

---

### navigation/

Bottom Navigation utama aplikasi.

---

### profile/

Informasi pengguna dan logout.

---

# 🗄️ Database Firestore

## Collection: users

```json
{
  "uid": "user_id",
  "email": "user@email.com",
  "name": "Nama User",
  "role": "staff",
  "createdAt": "timestamp"
}
```

---

## Collection: items

```json
{
  "name": "Barang",
  "sku": "SKU001",
  "stock": 50,
  "minStock": 10,
  "unit": "pcs",
  "description": "Deskripsi barang",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

## Collection: transactions

```json
{
  "itemId": "item_id",
  "itemName": "Nama Barang",
  "type": "in",
  "quantity": 10,
  "description": "Restok",
  "createdBy": "user_id",
  "createdAt": "timestamp"
}
```

---

# Teknologi yang Digunakan

## Frontend

* Flutter
* Dart

## State Management

* Provider

## Backend

* Firebase Authentication
* Cloud Firestore

## Data Visualization

* fl_chart

---

# Dependencies Utama

```yaml
provider: ^6.1.5+1
firebase_core: ^4.6.0
firebase_auth: ^6.3.0
cloud_firestore: ^6.2.0
fl_chart: ^0.68.0
```

---

# ⚙️ Instalasi

## 1. Clone Repository

```bash
git clone https://github.com/Oxwazolsky/software-development-team-tricode.git
cd stockin
```

## 2. Install Dependency

```bash
flutter pub get
```

## 3. Konfigurasi Firebase

Tambahkan konfigurasi Firebase menggunakan FlutterFire:

```bash
flutterfire configure
```

Pastikan file berikut tersedia:

```text
lib/firebase_options.dart
```

## 4. Jalankan Aplikasi

```bash
flutter run
```

---

# 📱 Minimum Requirement

* Flutter SDK >= 3.5
* Dart SDK >= 3.5
* Android Studio Hedgehog atau lebih baru
* Android SDK 24+
* Firebase Project aktif

---

# 👨‍💻 Tim Pengembang

## Team Tricode

| Nama                   | NIM        | Peran              |
| ---------------------- | ---------- | ------------------ |
| Muchammad Aditya Putra | 2313020112 | Project Manager    |
| Ahmad Hamid Zakaria    | 2313020131 | Frontend Developer |
| Fahrizal Adi Kuswara   | 2313020126 | Backend Developer  |

---

# 📄 License

Project ini dibuat untuk keperluan pembelajaran dan pengembangan akademik.
