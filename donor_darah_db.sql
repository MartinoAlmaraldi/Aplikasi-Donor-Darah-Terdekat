-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 06 Des 2025 pada 04.09
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `donor_darah_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `blood_banks`
--

CREATE TABLE `blood_banks` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `address` text NOT NULL,
  `phone` varchar(20) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `operating_hours` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `blood_banks`
--

INSERT INTO `blood_banks` (`id`, `name`, `address`, `phone`, `latitude`, `longitude`, `operating_hours`, `created_at`, `updated_at`) VALUES
(1, 'PMI Kota Banjarbaru', 'Jl. Jenderal Sudirman No.1, Loktabat Utara, Banjarbaru', '0511-4774090', -3.45430000, 114.84170000, 'Senin-Jumat: 08:00-16:00, Sabtu: 08:00-12:00', '2025-12-06 03:01:55', '2025-12-06 03:01:55'),
(2, 'RSUD Banjarbaru', 'Jl. Panglima Batur Barat No.4A, Mentaos, Banjarbaru', '0511-4772150', -3.46250000, 114.83720000, '24 Jam (Unit Transfusi Darah)', '2025-12-06 03:01:55', '2025-12-06 03:01:55'),
(3, 'RS Islam Banjarbaru', 'Jl. A. Yani KM 36, Landasan Ulin, Banjarbaru', '0511-4774400', -3.43980000, 114.82340000, 'Senin-Jumat: 08:00-20:00', '2025-12-06 03:01:55', '2025-12-06 03:01:55'),
(4, 'RS Ansyari Saleh Banjarmasin', 'Jl. Brig Jend. H. Hasan Basry, Banjarmasin', '0511-3252180', -3.31890000, 114.58970000, '24 Jam', '2025-12-06 03:01:55', '2025-12-06 03:01:55'),
(5, 'RS Bhayangkara Banjarbaru', 'Jl. Ahmad Yani KM 35, Landasan Ulin, Banjarbaru', '0511-4774455', -3.45070000, 114.82950000, 'Senin-Sabtu: 07:00-19:00', '2025-12-06 03:01:55', '2025-12-06 03:01:55'),
(6, 'Klinik Utama Medika Syariah', 'Jl. Pangeran Suriansyah, Komet, Banjarbaru', '0511-4774300', -3.46890000, 114.84560000, 'Senin-Jumat: 09:00-15:00', '2025-12-06 03:01:55', '2025-12-06 03:01:55'),
(7, 'RS Hidayah Banjarbaru', 'Jl. Gatot Subroto, Guntung Payung, Banjarbaru', '0511-4774200', -3.44210000, 114.85310000, 'Senin-Jumat: 08:00-16:00', '2025-12-06 03:01:55', '2025-12-06 03:01:55');

-- --------------------------------------------------------

--
-- Struktur dari tabel `blood_stock`
--

CREATE TABLE `blood_stock` (
  `id` int(11) NOT NULL,
  `blood_bank_id` int(11) NOT NULL,
  `blood_type` varchar(5) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0 COMMENT 'Jumlah stok dalam ml',
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `blood_stock`
--

INSERT INTO `blood_stock` (`id`, `blood_bank_id`, `blood_type`, `quantity`, `last_updated`) VALUES
(1, 1, 'A+', 5000, '2025-12-06 03:04:38'),
(2, 1, 'A-', 2500, '2025-12-06 03:04:38'),
(3, 1, 'B+', 4000, '2025-12-06 03:04:38'),
(4, 1, 'B-', 1500, '2025-12-06 03:04:38'),
(5, 1, 'AB+', 3000, '2025-12-06 03:04:38'),
(6, 1, 'AB-', 1000, '2025-12-06 03:04:38'),
(7, 1, 'O+', 6000, '2025-12-06 03:04:38'),
(8, 1, 'O-', 2000, '2025-12-06 03:04:38'),
(9, 2, 'A+', 7000, '2025-12-06 03:04:38'),
(10, 2, 'A-', 3000, '2025-12-06 03:04:38'),
(11, 2, 'B+', 5500, '2025-12-06 03:04:38'),
(12, 2, 'B-', 2000, '2025-12-06 03:04:38'),
(13, 2, 'AB+', 4000, '2025-12-06 03:04:38'),
(14, 2, 'AB-', 1500, '2025-12-06 03:04:38'),
(15, 2, 'O+', 8000, '2025-12-06 03:04:38'),
(16, 2, 'O-', 2500, '2025-12-06 03:04:38'),
(17, 3, 'A+', 4500, '2025-12-06 03:04:38'),
(18, 3, 'A-', 2000, '2025-12-06 03:04:38'),
(19, 3, 'B+', 3500, '2025-12-06 03:04:38'),
(20, 3, 'B-', 1200, '2025-12-06 03:04:38'),
(21, 3, 'AB+', 2500, '2025-12-06 03:04:38'),
(22, 3, 'AB-', 800, '2025-12-06 03:04:38'),
(23, 3, 'O+', 5500, '2025-12-06 03:04:38'),
(24, 3, 'O-', 1800, '2025-12-06 03:04:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `donation_history`
--

CREATE TABLE `donation_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `blood_bank_id` int(11) NOT NULL,
  `donation_date` datetime NOT NULL,
  `blood_type` varchar(5) NOT NULL,
  `quantity` int(11) NOT NULL COMMENT 'Jumlah darah dalam ml',
  `status` enum('pending','approved','rejected','completed') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `donation_history`
--

INSERT INTO `donation_history` (`id`, `user_id`, `blood_bank_id`, `donation_date`, `blood_type`, `quantity`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2024-09-01 09:30:00', 'A+', 350, 'completed', 'Donor berhasil, kondisi sehat', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(2, 1, 2, '2024-06-15 10:00:00', 'A+', 350, 'completed', 'Donor rutin, tidak ada keluhan', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(3, 1, 1, '2024-11-25 08:45:00', 'A+', 350, 'pending', 'Menunggu konfirmasi jadwal', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(4, 2, 3, '2024-08-20 14:00:00', 'O+', 350, 'completed', 'Donor perdana berhasil', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(5, 2, 1, '2024-11-28 09:00:00', 'O+', 350, 'approved', 'Sudah dikonfirmasi, jadwal besok', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(6, 3, 2, '2024-10-10 11:30:00', 'B+', 350, 'completed', 'Donor berjalan lancar', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(7, 4, 4, '2024-07-05 15:00:00', 'AB+', 350, 'completed', 'Donor di Banjarmasin', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(8, 4, 5, '2024-11-20 10:30:00', 'AB+', 350, 'rejected', 'Hemoglobin kurang, ditolak', '2025-12-06 03:03:23', '2025-12-06 03:03:23'),
(9, 5, 1, '2024-09-15 08:00:00', 'O-', 350, 'completed', 'Donor golongan langka', '2025-12-06 03:03:23', '2025-12-06 03:03:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `blood_type` varchar(5) NOT NULL,
  `address` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `blood_type`, `address`, `created_at`, `updated_at`) VALUES
(1, 'Ahmad Banjarbaru', 'ahmad@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye', '081234567890', 'A+', 'Jl. Pramuka No. 123, Loktabat, Banjarbaru, Kalimantan Selatan', '2025-12-06 03:01:26', '2025-12-06 03:01:26'),
(2, 'Siti Nurhaliza', 'siti@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye', '081234567891', 'O+', 'Jl. Guntung Manggis No. 45, Banjarbaru', '2025-12-06 03:01:26', '2025-12-06 03:01:26'),
(3, 'Budi Santoso', 'budi@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye', '081234567892', 'B+', 'Jl. Loktabat No. 67, Banjarbaru', '2025-12-06 03:01:26', '2025-12-06 03:01:26'),
(4, 'Rina Wati', 'rina@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye', '081234567893', 'AB+', 'Jl. Mentaos No. 89, Banjarbaru', '2025-12-06 03:01:26', '2025-12-06 03:01:26'),
(5, 'Joko Widodo', 'joko@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye', '081234567894', 'O-', 'Jl. Landasan Ulin No. 12, Banjarbaru', '2025-12-06 03:01:26', '2025-12-06 03:01:26');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `blood_banks`
--
ALTER TABLE `blood_banks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coordinates` (`latitude`,`longitude`);

--
-- Indeks untuk tabel `blood_stock`
--
ALTER TABLE `blood_stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_stock` (`blood_bank_id`,`blood_type`),
  ADD KEY `idx_blood_type` (`blood_type`);

--
-- Indeks untuk tabel `donation_history`
--
ALTER TABLE `donation_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_blood_bank_id` (`blood_bank_id`),
  ADD KEY `idx_donation_date` (`donation_date`),
  ADD KEY `idx_status` (`status`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_blood_type` (`blood_type`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `blood_banks`
--
ALTER TABLE `blood_banks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `blood_stock`
--
ALTER TABLE `blood_stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT untuk tabel `donation_history`
--
ALTER TABLE `donation_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `blood_stock`
--
ALTER TABLE `blood_stock`
  ADD CONSTRAINT `blood_stock_ibfk_1` FOREIGN KEY (`blood_bank_id`) REFERENCES `blood_banks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `donation_history`
--
ALTER TABLE `donation_history`
  ADD CONSTRAINT `donation_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `donation_history_ibfk_2` FOREIGN KEY (`blood_bank_id`) REFERENCES `blood_banks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
