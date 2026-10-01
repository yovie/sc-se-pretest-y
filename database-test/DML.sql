-- ============================================================
-- DML Database perpustakaan (MySQL / MariaDB)
-- Data dummy sesuai ketentuan:
--   5 kategori, 5 member, 10 buku
--   3 peminjaman (user 1 pinjam buku 1,2,3; user 2 pinjam buku
--   4,5,6; user 3 pinjam buku 7,8,9) + 9 detail_peminjaman
--   user 3 terlambat mengembalikan 1 buku (buku 9, telat 5 hari)
--   -> 1 denda (5 x 1000 = 5000)
-- Jalankan setelah DDL.sql
-- ============================================================

USE perpustakaan;

-- Tabel: kategori (5)
INSERT INTO kategori (id, nama, deskripsi) VALUES
  (1, 'Sains', 'Buku-buku bidang sains dan sains alam'),
  (2, 'Teknologi', 'Buku komputer, pemrograman, dan teknologi'),
  (3, 'Sejarah', 'Buku sejarah peradaban dan tokoh'),
  (4, 'Sastra', 'Buku sastra, novel, dan puisi'),
  (5, 'Matematika', 'Buku matematika dan statistika');

-- Tabel: member (5)
INSERT INTO member (id, no_ktp, nama, email, no_telp, alamat, tgl_daftar, status) VALUES
  (1, '3271001101', 'Budi Santoso', 'budi@mail.com', '081234560001', 'Jl. Melati No. 10, Jakarta', '2026-01-15', 'aktif'),
  (2, '3271001102', 'Siti Aminah', 'siti@mail.com', '081234560002', 'Jl. Kenanga No. 20, Bandung', '2026-02-20', 'aktif'),
  (3, '3271001103', 'Rudi Hartono', 'rudi@mail.com', '081234560003', 'Jl. Mawar No. 30, Semarang', '2026-03-10', 'aktif'),
  (4, '3271001104', 'Andi Wijaya', 'andi@mail.com', '081234560004', 'Jl. Anggrek No. 40, Surabaya', '2026-04-05', 'aktif'),
  (5, '3271001105', 'Dewi Lestari', 'dewi@mail.com', '081234560005', 'Jl. Dahlia No. 50, Yogyakarta', '2026-06-20', 'aktif');

-- Tabel: buku (10)
INSERT INTO buku (id, judul, penulis, penerbit, tahun_terbit, isbn, jumlah_stok, kategori_id, deskripsi) VALUES
  (1, 'Fisika Dasar', 'Albert Santoso', 'Penerbit Sains', 2020, '978-601-1-00001-1', 5, 1, 'Pengantar fisika untuk pemula'),
  (2, 'Kimia Organik', 'Maria Curie', 'Penerbit Sains', 2019, '978-601-1-00002-2', 4, 1, 'Dasar-dasar kimia organik'),
  (3, 'Pemrograman Go', 'Robert Griesemer', 'Tech Books', 2022, '978-601-1-00003-3', 6, 2, 'Panduan bahasa Go untuk backend'),
  (4, 'Basis Data Modern', 'Codd Edward', 'Tech Books', 2021, '978-601-1-00004-4', 3, 2, 'Rekayasa basis data relasional'),
  (5, 'Sejarah Nusantara', 'Ranggawarsita', 'Penerbit Sejarah', 2018, '978-601-1-00005-5', 7, 3, 'Sejarah bangsa Indonesia klasik'),
  (6, 'Peradaban Romawi', 'Edward Gibbon', 'Penerbit Sejarah', 2017, '978-601-1-00006-6', 2, 3, 'Kehancuran kekaisaran Romawi'),
  (7, 'Laskar Pelangi', 'Andrea Hirata', 'Penerbit Sastra', 2020, '978-601-1-00007-7', 8, 4, 'Novel inspirasi anak bangsa'),
  (8, 'Sang Pemimpi', 'Andrea Hirata', 'Penerbit Sastra', 2021, '978-601-1-00008-8', 5, 4, 'Kelanjutan kisah Laskar Pelangi'),
  (9, 'Aljabar Linier', 'David C. Lay', 'Penerbit Matematika', 2023, '978-601-1-00009-9', 4, 5, 'Pengantar aljabar linier terapan'),
  (10, 'Statistika Terapan', 'Susanti Dewi', 'Penerbit Matematika', 2024, '978-601-1-00010-0', 6, 5, 'Statistika untuk penelitian');

-- Tabel: peminjaman (3) - 1 transaksi per user
INSERT INTO peminjaman (id, kode_pinjam, member_id, tgl_pinjam, tgl_kembali_rencana, status) VALUES
  (1, 'PIN-0001', 1, '2026-09-20', '2026-09-27', 'dikembalikan'),
  (2, 'PIN-0002', 2, '2026-09-22', '2026-09-29', 'dikembalikan'),
  (3, 'PIN-0003', 3, '2026-09-18', '2026-09-25', 'dikembalikan');

-- Tabel: detail_peminjaman (9)
-- user 1: buku 1,2,3 | user 2: buku 4,5,6 | user 3: buku 7,8,9
-- tgl_kembali_aktual per buku:
--   peminjaman 1 (rencana 09-27): buku 1,2,3 -> 09-27 tepat waktu
--   peminjaman 2 (rencana 09-29): buku 4,5,6 -> 09-29 tepat waktu
--   peminjaman 3 (rencana 09-25): buku 7,8 -> 09-25 tepat waktu
--                                buku 9    -> 09-30 telat 5 hari (status 'terlambat')
INSERT INTO detail_peminjaman (id, peminjaman_id, buku_id, tgl_kembali_aktual, status_pengembalian) VALUES
  (1, 1, 1, '2026-09-27', 'dikembalikan'),
  (2, 1, 2, '2026-09-27', 'dikembalikan'),
  (3, 1, 3, '2026-09-27', 'dikembalikan'),
  (4, 2, 4, '2026-09-29', 'dikembalikan'),
  (5, 2, 5, '2026-09-29', 'dikembalikan'),
  (6, 2, 6, '2026-09-29', 'dikembalikan'),
  (7, 3, 7, '2026-09-25', 'dikembalikan'),
  (8, 3, 8, '2026-09-25', 'dikembalikan'),
  (9, 3, 9, '2026-09-30', 'terlambat');

-- Tabel: denda (1) - peminjaman 3 (member 3), telat 5 hari x 1000
INSERT INTO denda (id, peminjaman_id, hari_terlambat, tarif_per_hari, total_denda, status_bayar, tgl_bayar) VALUES
  (1, 3, 5, 1000, 5000, 'belum', NULL);
