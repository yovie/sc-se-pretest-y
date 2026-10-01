USE perpustakaan;

-- daftar buku yang tidak pernah dipinjam di oleh siapapun
SELECT b.judul
FROM buku b
WHERE NOT EXISTS (
  SELECT 1 FROM detail_peminjaman d WHERE d.buku_id = b.id
)
ORDER BY b.id;

-- user yang pernah mengembalikan buku terlambat beserta dendanya
SELECT m.nama, dn.total_denda
FROM denda dn
JOIN peminjaman p ON p.id = dn.peminjaman_id
JOIN member m ON m.id = p.member_id
ORDER BY m.id;

-- user dengan daftar buku yang dipinjam nya
SELECT m.id, m.nama, GROUP_CONCAT(b.judul ORDER BY p.id, d.id SEPARATOR ', ') AS buku
FROM member m
JOIN peminjaman p ON p.member_id = m.id
JOIN detail_peminjaman d ON d.peminjaman_id = p.id
JOIN buku b ON b.id = d.buku_id
GROUP BY m.id, m.nama
ORDER BY m.id;