USE QLDT2
GO
-- Lấy thông tin từ bảng KHOA
SELECT * FROM KHOA;

-- Lấy thông tin từ bảng CHUONGTRINHDAOTAO
SELECT * FROM CHUONGTRINHDAOTAO;

-- Lấy thông tin từ bảng LOPCHINHQUY
SELECT * FROM LOPCHINHQUY;

-- Lấy thông tin từ bảng DOITUONG
SELECT * FROM DOITUONG;

-- Lấy thông tin từ bảng SINHVIEN
SELECT * FROM SINHVIEN;

-- Lấy thông tin từ bảng GIANGVIEN
SELECT * FROM GIANGVIEN;

-- Lấy thông tin từ bảng MONHOC
SELECT * FROM MONHOC;

-- Lấy thông tin từ bảng LOPTINCHI
SELECT * FROM LOPTINCHI;

-- Lấy thông tin từ bảng TIETHOC
SELECT * FROM TIETHOC;

-- Lấy thông tin từ bảng HOADON
SELECT * FROM HOADON;

-- Lấy thông tin từ bảng HOCBONG
SELECT * FROM HOCBONG;

-- Lấy thông tin từ bảng DOITUONG_SDT
SELECT * FROM [DOITUONG_SDT];

-- Lấy thông tin từ bảng GIANGVIEN_BANGCAP
SELECT * FROM [GIANGVIEN_BANGCAP];

-- Lấy thông tin từ bảng CHUONGTRINH_MONHOC
SELECT * FROM [CHUONGTRINH_MONHOC];

-- Thêm mới sinh viên
INSERT INTO DOITUONG VALUES ('user51', 'Hà Nội', 'Nữ', '2003-12-6', 'Đào', NULL, 'Trang', 'SV');
INSERT INTO SINHVIEN VALUES ('SV037', '2021-2025', 3.45, 82, 'Chính quy', 'D21CQMR02-B','user51');

-- Sửa thông tin sinh viên
UPDATE SINHVIEN
SET GPA=3.54
WHERE MaSV='SV037';

-- Xóa thông tin sinh viên
DELETE FROM SINHVIEN
WHERE MaSV='SV037';
DELETE FROM DOITUONG
WHERE USER_ID='user51';

-- Thêm dữ liệu giảng viên
INSERT INTO DOITUONG VALUES ('user51','Hải Phòng', 'Nam', '1992-10-10', 'Lê', 'Quang', 'Dũng', 'GV');
INSERT INTO GIANGVIEN VALUES ('GV015', 17000, 'user51');

-- Sửa dữ liệu giảng viên
UPDATE GIANGVIEN
SET Luong=20000
WHERE MaGV='GV015';

-- Xóa dữ liệu giảng viên
DELETE FROM GIANGVIEN
WHERE MaGV='GV015';
DELETE FROM DOITUONG
WHERE USER_ID='user51';

-- Thêm dữ liệu môn học
INSERT INTO MONHOC VALUES ('MH062', 'Toán rời rạc', 3, NULL, 45, 8);

-- Sửa dữ liệu môn học
UPDATE MONHOC
SET SoTC=2,
	SoTietLyThuyet=30,
	SoTietThucHanh=0
WHERE MaMon='MH062';

-- Xóa dữ liệu môn học
DELETE FROM MONHOC
WHERE MaMon='MH062';

-- Thêm dữ liệu hóa đơn
INSERT INTO HOADON VALUES ('BHYT', 'SV001', 885, 'Bảo hiểm ý tế', '2024-11-14');

-- Sửa dữ liệu hóa đơn
UPDATE HOADON
SET SoTien=888
WHERE LoaiHoaDon='BHYT' AND maSV='SV001';

-- Xóa dữ liệu hóa đơn
DELETE FROM HOADON
WHERE LoaiHoaDon='BHYT' AND maSV='SV001';

--Thêm dữ liệu tiết học
INSERT INTO TIETHOC VALUES ('TH038', '2024-11-14 7:00','2024-11-14 8:50', 'LTC017','SV016', 'GV011');

-- Sửa dữ liệu tiết học
UPDATE TIETHOC
SET ThoiGianKetThuc='2024-11-14 11:50'
WHERE MaTietHoc='TH038';

-- Xóa dữ liệu tiết học
DELETE FROM TIETHOC
WHERE MaTietHoc='TH038';

-- Truy vấn thông tin sinh viên có gpa cao nhất mỗi khoa
SELECT 
	GR.MaSV,
	DT.Ho+' '+DT.TenDem+' '+DT.Ten AS Họ_tên,
	GR.Nien_khoa AS Niên_khóa,
	K.TenKhoa AS  Tên_khoa,
	LCQ.TenLopChinhQuy AS Tên_lớp,
	GR.GPA
FROM (
		SELECT	
			SV.MaSV,
			SV.USER_ID,
			SV.GPA,
			SV.Nien_khoa,
			SV.MaLopChinhQuy,
			ROW_NUMBER() OVER (PARTITION BY LCH.MaKhoa ORDER BY SV.GPA DESC) AS RowNum
		FROM SINHVIEN SV
		JOIN LOPCHINHQUY LCH ON SV.MaLopChinhQuy=LCH.MaLopChinhQuy
	  ) AS GR
JOIN LOPCHINHQUY LCQ ON GR.MaLopChinhQuy=LCQ.MaLopChinhQuy
JOIN DOITUONG DT ON DT.USER_ID=GR.USER_ID
JOIN KHOA K ON K.MaKhoa=LCQ.MaKhoa
WHERE GR.RowNum=1;

--Truy vấn thông tin giáo viên có bằng tiến sĩ dạy những lớp có 50 sinh viên, sắp xếp theo mã gv tăng dần
SELECT
	GV.MaGV,
	DT.Ho+' '+DT.TenDem+' '+DT.Ten as Họ_tên,
	LTC.MaLop AS Mã_lớp, 
	LTC.DanhSachSV AS Sĩ_số,
	COUNT (DISTINCT GVBC.BangCap) AS Số_bằng_tiến_sĩ
FROM GIANGVIEN GV
JOIN DOITUONG DT ON GV.USER_ID=DT.USER_ID
JOIN GIANGVIEN_BANGCAP GVBC ON GV.MaGV=GVBC.MaGV
JOIN TIETHOC TH ON GV.MaGV=TH.MaGV
JOIN LOPTINCHI LTC ON TH.MaLopHoc=LTC.MaLop
WHERE GVBC.BangCap LIKE N'Tiến sĩ%' AND LTC.DanhSachSV>50
GROUP BY GV.MaGV, DT.Ho, DT.TenDem, DT.Ten,LTC.DanhSachSV, LTC.MaLop
ORDER BY GV.MaGV ASC;

--Tính tổng tiền học bổng của sinh viên theo từng khoa >20000, sắp xếp giảm dần theo số tiền
SELECT 
	K.TenKhoa AS Khoa, 
	SUM(HB.TienHocBong) AS Tổng_số_tiền
FROM HOCBONG HB
JOIN SINHVIEN SV ON HB.MaSV=SV.MaSV
JOIN LOPCHINHQUY LCQ ON SV.MaLopChinhQuy=LCQ.MaLopChinhQuy
JOIN KHOA K ON LCQ.MaKhoa=K.MaKhoa
GROUP BY K.TenKhoa
HAVING SUM(HB.TienHocBong) > 20000
ORDER BY Tổng_số_tiền DESC;

 --Truy vấn sinh viên đủ đủ điều kiện đạt học bổng và học bổng đạt được
SELECT 
	SV.MaSV,
	DT.Ho+' '+ ISNULL(DT.TenDem+' ','')+DT.Ten AS Họ_tên,
	K.TenKhoa AS Khoa,
	SV.GPA,
	SV.DiemRenLuyen AS Điểm_rèn_luyện,
	HB.TenHocBong AS Học_bổng,
	HB.TienHocBong AS Số_tiền
FROM SINHVIEN SV
JOIN DOITUONG DT ON SV.USER_ID=DT.USER_ID
JOIN LOPCHINHQUY LCQ ON LCQ.MaLopChinhQuy = SV.MaLopChinhQuy
JOIN KHOA K ON LCQ.MaKhoa=K.MaKhoa
JOIN HOCBONG HB ON SV.MaSV=HB.MaSV
WHERE SV.GPA>=3.2 AND SV.DiemRenLuyen>=80
ORDER BY 
	K.TenKhoa ASC,
	HB.TienHocBong DESC

-- Danh sách sinh viên với số môn đang học và tổng số tín chỉ lớn hơn 3, sắp xếp giảm dần

SELECT
	SV.MaSV,
	DT.Ho+' '+DT.TenDem+' '+DT.Ten AS Họ_tên,
	COUNT(LTC.MaMon) as Số_môn_đang_học,
	SUM(MH.SoTC) as Tổng_số_tín_chỉ
FROM SINHVIEN SV
JOIN DOITUONG DT ON SV.USER_ID=DT.USER_ID
JOIN TIETHOC TH ON SV.MaSV=TH.MaSV
JOIN LOPTINCHI LTC ON TH.MaLopHoc=LTC.MaLop
JOIN MONHOC MH ON LTC.MaMon=MH.MaMon
GROUP BY SV.MaSV, DT.Ho, DT.TenDem, DT.Ten
HAVING SUM(MH.SoTC) >3
ORDER BY Tổng_số_tín_chỉ DESC;

--Truy vấn danh sách sinh viên có năm đào tạo là 4.5 và số tín chỉ nhiều hơn 130
 SELECT DISTINCT 
	SV.MaSV,
	DT.Ho+' '+DT.TenDem+' '+DT.Ten AS Họ_tên,
	LCQ.MaLopChinhQuy AS Lớp_Chính_quy,
	K.TenKhoa AS Khoa,
	CTDT.ThoiGianDaoTao AS Thời_gian_đào_tạo,
	CTDT.TongTinChi AS Số_tín
 FROM SINHVIEN SV
 JOIN DOITUONG DT ON SV.USER_ID=DT.USER_ID
 JOIN LOPCHINHQUY LCQ ON LCQ.MaLopChinhQuy = SV.MaLopChinhQuy
 JOIN CHUONGTRINHDAOTAO CTDT ON LCQ.MaKhoa=CTDT.MaKhoa
 JOIN KHOA K ON K.MaKhoa=LCQ.MaKhoa
 WHERE CTDT.ThoiGianDaoTao=4.5 AND CTDT.TongTinChi>130;

 --Thống kê các tiết học được tổ chức bởi các giảng viên và thời gian học

SELECT
	GV.MaGV,
	DT.Ho+' '+DT.TenDem+' '+DT.Ten as Họ_tên,
	TH.MaTietHoc AS Mã_tiết_học,
	TH.ThoiGianBatDau AS Thời_gian_bắt_đầu,
	TH.ThoiGianKetThuc AS  Thời_gian_kết_thúc
FROM GIANGVIEN GV
JOIN DOITUONG DT ON GV.USER_ID=DT.USER_ID
JOIN TIETHOC TH ON GV.MaGV=TH.MaGV
ORDER BY GV.MaGV, TH.ThoiGianBatDau;

--Thống kê thông tin sinh viên và học phí đã đóng
SELECT 
	DT.Ho+' '+DT.TenDem+' '+DT.Ten AS Họ_tên,
	DT.QueQuan AS Hộ_khẩu,
	SV.GPA,
	HD.SoTien AS Học_phí,
	HD.NgayThanhToan AS Ngày_thanh_toán
FROM SINHVIEN SV
JOIN DOITUONG DT ON DT.USER_ID =SV.USER_ID
LEFT JOIN HOADON HD ON SV.MaSV=HD.MaSV AND HD.LoaiHoaDon='HocPhi'
