-- Schema Database Presensi Siswa
CREATE DATABASE IF NOT EXISTS presensi_db;
USE presensi_db;

-- Tabel Kelas
CREATE TABLE IF NOT EXISTS kelas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_kelas VARCHAR(50) NOT NULL,
  wali_kelas VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Siswa
CREATE TABLE IF NOT EXISTS siswa (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nis VARCHAR(20) UNIQUE NOT NULL,
  nama VARCHAR(100) NOT NULL,
  kelas_id INT,
  jenis_kelamin ENUM('L', 'P') NOT NULL,
  foto_profil_s3_key VARCHAR(255),
  foto_profil_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (kelas_id) REFERENCES kelas(id)
);

-- Tabel Presensi
CREATE TABLE IF NOT EXISTS presensi (
  id INT AUTO_INCREMENT PRIMARY KEY,
  siswa_id INT NOT NULL,
  tanggal DATE NOT NULL,
  waktu_checkin TIME,
  status ENUM('Hadir', 'Sakit', 'Izin', 'Alpha') NOT NULL DEFAULT 'Hadir',
  foto_presensi_path VARCHAR(500),
  keterangan TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (siswa_id) REFERENCES siswa(id),
  UNIQUE KEY unique_presensi (siswa_id, tanggal)
);

-- Data Sample Kelas
INSERT INTO kelas (nama_kelas, wali_kelas) VALUES
('X-A', 'Budi Santoso, S.Pd'),
('X-B', 'Siti Rahayu, S.Pd'),
('XI-A', 'Ahmad Fauzi, S.Pd'),
('XI-B', 'Dewi Kusuma, S.Pd'),
('XII-A', 'Hendra Wijaya, S.Pd');

-- Data Sample Siswa
INSERT INTO siswa (nis, nama, kelas_id, jenis_kelamin) VALUES
('2024001', 'Andi Pratama', 1, 'L'),
('2024002', 'Budi Setiawan', 1, 'L'),
('2024003', 'Citra Dewi', 1, 'P'),
('2024004', 'Dina Marlina', 2, 'P'),
('2024005', 'Eko Prasetyo', 2, 'L');
