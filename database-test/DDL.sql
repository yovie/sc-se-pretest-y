-- ============================================================
-- DDL Database perpustakaan (MySQL / MariaDB)
-- Digenerate dari schema.yaml oleh generate_ddl.py
-- ============================================================

CREATE DATABASE IF NOT EXISTS perpustakaan;
USE perpustakaan;

-- Tabel: kategori
CREATE TABLE kategori (
  id INT NOT NULL AUTO_INCREMENT,
  nama VARCHAR(50) NOT NULL,
  deskripsi TEXT,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel: member
CREATE TABLE member (
  id INT NOT NULL AUTO_INCREMENT,
  no_ktp VARCHAR(20) NOT NULL,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100),
  no_telp VARCHAR(20),
  alamat VARCHAR(255),
  tgl_daftar DATE,
  status VARCHAR(20) DEFAULT 'aktif',
  PRIMARY KEY (id),
  UNIQUE KEY uk_member_no_ktp (no_ktp),
  UNIQUE KEY uk_member_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel: buku
CREATE TABLE buku (
  id INT NOT NULL AUTO_INCREMENT,
  judul VARCHAR(200) NOT NULL,
  penulis VARCHAR(100),
  penerbit VARCHAR(100),
  tahun_terbit SMALLINT,
  isbn VARCHAR(20),
  jumlah_stok INT DEFAULT 0,
  kategori_id INT,
  deskripsi TEXT,
  PRIMARY KEY (id),
  UNIQUE KEY uk_buku_isbn (isbn),
  -- relasi: kategori.id -> buku.kategori_id (1:N)
  CONSTRAINT fk_buku_kategori_id FOREIGN KEY (kategori_id) REFERENCES kategori (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel: peminjaman
CREATE TABLE peminjaman (
  id INT NOT NULL AUTO_INCREMENT,
  kode_pinjam VARCHAR(20),
  member_id INT,
  tgl_pinjam DATE,
  tgl_kembali_rencana DATE,
  status VARCHAR(20) DEFAULT 'dipinjam',
  PRIMARY KEY (id),
  UNIQUE KEY uk_peminjaman_kode_pinjam (kode_pinjam),
  -- relasi: member.id -> peminjaman.member_id (1:N)
  CONSTRAINT fk_peminjaman_member_id FOREIGN KEY (member_id) REFERENCES member (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel: detail_peminjaman
CREATE TABLE detail_peminjaman (
  id INT NOT NULL AUTO_INCREMENT,
  peminjaman_id INT,
  buku_id INT,
  tgl_kembali_aktual DATE,
  status_pengembalian VARCHAR(20),
  PRIMARY KEY (id),
  -- relasi: peminjaman.id -> detail_peminjaman.peminjaman_id (1:N)
  CONSTRAINT fk_detail_peminjaman_peminjaman_id FOREIGN KEY (peminjaman_id) REFERENCES peminjaman (id),
  -- relasi: buku.id -> detail_peminjaman.buku_id (1:N)
  CONSTRAINT fk_detail_peminjaman_buku_id FOREIGN KEY (buku_id) REFERENCES buku (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel: denda
CREATE TABLE denda (
  id INT NOT NULL AUTO_INCREMENT,
  peminjaman_id INT,
  hari_terlambat INT,
  tarif_per_hari INT DEFAULT 1000,
  total_denda INT,
  status_bayar VARCHAR(20) DEFAULT 'belum',
  tgl_bayar DATE,
  PRIMARY KEY (id),
  UNIQUE KEY uk_denda_peminjaman_id (peminjaman_id),
  -- relasi: peminjaman.id -> denda.peminjaman_id (1:1)
  CONSTRAINT fk_denda_peminjaman_id FOREIGN KEY (peminjaman_id) REFERENCES peminjaman (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
