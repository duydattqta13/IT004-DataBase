-- BÀI TẬP THỰC HÀNH CSDL VỀ QUẢN LÝ GIÁO VỤ
-- LÀM TỪ CÂU 5->24 TRONG PHẦN I

CREATE DATABASE QLGV
USE QLGV
-- PHẦN I
DROP DATABASE QLGV
--Câu 1: Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. 
--Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN

--Quan hệ 1
CREATE TABLE KHOA(
	MAKHOA VARCHAR(4),
	TENKHOA NVARCHAR(40),
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4),
	PRIMARY KEY (MAKHOA)
)

--Quan hệ 2
CREATE TABLE MONHOC(
	MAMH VARCHAR(10),
	TENMH NVARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4),
	PRIMARY KEY (MAMH)
)

--Quan hệ 3
CREATE TABLE DIEUKIEN(
	MAMH VARCHAR(10),
	MAMH_TRUOC VARCHAR(10),
	PRIMARY KEY (MAMH, MAMH_TRUOC)
)

--Quan hệ 4
CREATE TABLE GIAOVIEN(
	MAGV CHAR(4),
	HOTEN NVARCHAR(40),
	HOCVI NVARCHAR(10), HOCHAM NVARCHAR(10),
	GIOITINH NVARCHAR(3),
	NGSINH SMALLDATETIME, NGVL SMALLDATETIME,
	HESO NUMERIC(4,2),
	MUCLUONG MONEY,
	MAKHOA VARCHAR(4),
	PRIMARY KEY (MAGV)
)

--Quan hệ 5
CREATE TABLE LOP(
	MALOP CHAR(3),
	TENLOP NVARCHAR(40),
	TRGLOP CHAR(5),
	SISO TINYINT,
	MAGVCN CHAR(4),
	PRIMARY KEY (MALOP)
)

--Quan hệ 6
CREATE TABLE HOCVIEN(
	MAHV CHAR(5),
	HO NVARCHAR(40),
	TEN NVARCHAR(10),
	NGSINH SMALLDATETIME,
	GIOITINH NVARCHAR(3),
	NOISINH NVARCHAR(40),
	MALOP CHAR(3),
	PRIMARY KEY (MAHV)
)

--Quan hệ 7
CREATE TABLE GIANGDAY(
	MALOP CHAR(3),
	MAMH VARCHAR(10),
	MAGV CHAR(4),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME, DENNGAY SMALLDATETIME,
	PRIMARY KEY (MALOP, MAMH)
)

--Quan hệ 8
CREATE TABLE KETQUATHI(
	MAHV CHAR(5),
	MAMH VARCHAR(10),
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4,2),
	KQUA NVARCHAR(10),
	PRIMARY KEY (MAHV, MAMH, LANTHI)
)

-- Ràng buộc khóa chính, khóa ngoại

ALTER TABLE KHOA 
ADD CONSTRAINT FK_KHOA_TRGKHOA FOREIGN KEY(TRGKHOA) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE MONHOC 
ADD CONSTRAINT FK_MONHOC_MAKHOA FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE DIEUKIEN 
ADD CONSTRAINT FK_DK_MAMH FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE DIEUKIEN 
ADD CONSTRAINT FK_DK_MAMH_TRUOC FOREIGN KEY(MAMH_TRUOC) REFERENCES MONHOC(MAMH)

ALTER TABLE GIAOVIEN 
ADD CONSTRAINT FK_GV_KHOA FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE LOP 
ADD CONSTRAINT FK_LOP_TRGLOP FOREIGN KEY(TRGLOP) REFERENCES HOCVIEN(MAHV)

ALTER TABLE LOP 
ADD CONSTRAINT FK_LOP_GVCN FOREIGN KEY(MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE HOCVIEN 
ADD CONSTRAINT FK_HV_MALOP FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)

ALTER TABLE GIANGDAY 
ADD CONSTRAINT FK_GD_MALOP FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)

ALTER TABLE GIANGDAY 
ADD CONSTRAINT FK_GD_MAMH FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE KETQUATHI 
ADD CONSTRAINT FK_KQ_MAHV FOREIGN KEY(MAHV) REFERENCES HOCVIEN(MAHV)

ALTER TABLE KETQUATHI 
ADD CONSTRAINT FK_KQ_MAMH FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

-- Thêm cột GHICHU, DIEMTB, XEPLOAI vào HOCVIEN
ALTER TABLE HOCVIEN 
ADD GHICHU NVARCHAR(50)

ALTER TABLE HOCVIEN 
ADD DIEMTB NUMERIC(4,2)

ALTER TABLE HOCVIEN 
ADD XEPLOAI NVARCHAR(10)

--Câu 2: Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 
-- 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_HV_MAHV CHECK(SUBSTRING(MAHV ,1 ,3) = MALOP  AND ISNUMERIC(SUBSTRING(MAHV, 4, 2)) = 1)

--Câu 3: Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE GIAOVIEN 
ADD CONSTRAINT CHK__GV_GIOITINH CHECK(GIOITINH IN ('Nam', 'Nữ'))

ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_HV_GIOITINH CHECK(GIOITINH IN ('Nam', 'Nữ'))

--Câu 4: Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).

ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_KQ_DIEM CHECK(DIEM >= 0 AND DIEM <= 10)

-- Làm tròn điểm thi đến 2 chữ số sau dấu phẩy và gán lại cột DIEM
UPDATE KETQUATHI 
SET DIEM = ROUND(DIEM, 2)

-------------------------Buổi 2------------------------------------------

-- PHẦN II

SET DATEFORMAT DMY
-- Chèn giá trị cho bảng KHOA (1)
INSERT INTO KHOA(
	MAKHOA,
	TENKHOA,
	NGTLAP
)
VALUES
	('KHMT', N'Khoa học máy tính', '7/6/2005'),
	('HTTT', N'Hệ thống thông tin', '7/6/2005'),
	('CNPM', N'Công nghệ phần mềm', '7/6/2005'),
	('MTT', N'Mạng và truyền thông', '20/10/2005'),
	('KTMT', N'Kĩ thuật máy tính', '20/12/2005');

-- Chèn giá trị cho bảng GIAOVIEN (2)
INSERT INTO GIAOVIEN(
	MAGV,
	HOTEN,
	HOCVI,
	HOCHAM,
	GIOITINH,
	NGSINH,
	NGVL,
	HESO,
	MUCLUONG,
	MAKHOA
)
VALUES
	('GV01',N'Hồ Thanh Sơn','PTS','GS',N'Nam','2/5/1950','11/1/2004',5.00,'2,250,000','KHMT'),
	('GV02',N'Trần Tâm Thanh','TS','PGS',N'Nam','17/12/1965','20/4/2004',4.50,'2,025,000','HTTT'),
	('GV03',N'Đỗ Nghiêm Phụng','TS','GS',N'Nữ','1/8/1950','23/9/2004',4.00,'1,800,000','CNPM'),
	('GV04',N'Trần Nam Sơn','TS','PGS',N'Nam','22/2/1961','12/1/2005 ',4.50,'2,025,000','KTMT'),
	('GV05',N'Mai Thành Danh','ThS','GV',N'Nam','12/3/1958','12/1/2005 ',3.00,'1,350,000','HTTT'),
	('GV06',N'Trần Doãn Hưng','TS','GV',N'Nam','11/3/1953','12/1/2005 ',4.50,'2,025,000','KHMT'),
	('GV07',N'Nguyễn Minh Tiến','ThS','GV',N'Nam','23/11/1971','1/3/2005 ',4.00,'1,800,000','KHMT'),
	('GV08',N'Lê Thị Trân','KS',NULL,N'Nữ','26/3/1974','1/3/2005 ',1.69,'760,000','KHMT'),
	('GV09',N'Nguyễn Tố Lan','ThS','GV',N'Nữ','31/12/1966','1/3/2005 ',4.00,'1,800,000','HTTT'),
	('GV10',N'Lê Trần Ánh Loan','KS',NULL,N'Nữ','17/7/1972','1/3/2005 ',1.86,'837,000','CNPM'),
	('GV11',N'Hồ Thanh Tùng','CN','GV',N'Nam','12/1/1980','15/5/2005 ',2.67,'1,201,500','MTT'),
	('GV12',N'Trần Vân Anh','CN',NULL,N'Nữ','29/3/1981','15/5/2005 ',1.69,'760,500','CNPM'),
	('GV13',N'Nguyễn Linh Đan','CN',NULL,N'Nữ','23/5/1980','15/5/2005 ',1.69,'760,500','KTMT'),
	('GV14',N'Trương Minh Châu','ThS','GV',N'Nữ','30/11/1976','15/5/2005 ',3.00,'1,350,000','MTT'),
	('GV15',N'Lê Hà Thanh','ThS','GV',N'Nam','4/5/1978','15/5/2005 ',3.00,'1,350,000','KHMT');

UPDATE KHOA SET TRGKHOA = 'GV01' WHERE MAKHOA = 'KHMT' 
UPDATE KHOA SET TRGKHOA = 'GV02' WHERE MAKHOA = 'HTTT'
UPDATE KHOA SET TRGKHOA = 'GV04' WHERE MAKHOA = 'CNPM'
UPDATE KHOA SET TRGKHOA = 'GV03' WHERE MAKHOA = 'MTT' 

-- Chèn giá trị cho bảng LOP (3)
INSERT INTO LOP(
	MALOP,
	TENLOP,
	SISO,
	MAGVCN
)
VALUES
	('K11',N'Lớp 1 khóa 1',11,'GV07'),
	('K12',N'Lớp 2 khóa 1',12,'GV09'),
	('K13',N'Lớp 3 khóa 1',12,'GV14');

-- Chèn giá trị cho bảng HOCVIEN (4)
INSERT INTO HOCVIEN(
	MAHV,
	HO,
	TEN,
	NGSINH,
	GIOITINH,
	NOISINH,
	MALOP
)
VALUES
	('K1101',N'Nguyễn Văn',N'A','27/1/1986',N'Nam',N'TpHCM','K11'),
	('K1102',N'Trần Ngọc',N'Hân','14/3/1986',N'Nữ',N'Kiên Giang','K11'),
	('K1103',N'Hà Duy',N'Lập','18/4/1986',N'Nam',N'Nghệ An','K11'),
	('K1104',N'Trần Ngọc',N'Linh','30/3/1986',N'Nữ',N'Tây Ninh','K11'),
	('K1105',N'Trần Minh',N'Long','27/2/1986',N'Nam',N'TpHCM','K11'),
	('K1106',N'Lê Nhật',N'Minh','24/1/1986',N'Nam',N'TpHCM','K11'),
	('K1107',N'Nguyễn Như',N'Nhựt','27/1/1986',N'Nam',N'Hà Nội','K11'),
	('K1108',N'Nguyễn Mạnh',N'Tâm','27/2/1986',N'Nam',N'Kiên Giang','K11'),
	('K1109',N'Phan Thị Thanh',N'Tâm','27/1/1986',N'Nữ',N'Vĩnh Long','K11'),
	('K1110',N'Lê Hoài',N'Thương','5/2/1986',N'Nữ',N'Cần Thơ','K11'),
	('K1111',N'Lê Hà',N'Vinh','25/12/1986',N'Nam',N'Vĩnh Long','K11'),
	('K1201',N'Nguyễn Văn',N'B','11/2/1986',N'Nam',N'TpHCM','K12'),
	('K1202',N'Nguyễn Thị Kim',N'Duyên','18/1/1986',N'Nữ',N'TpHCM','K12'),
	('K1203',N'Trần Thị Kim',N'Duyên','17/9/1986',N'Nữ',N'TpHCM','K12'),
	('K1204',N'Trương Mỹ',N'Hạnh','19/5/1986',N'Nữ',N'Đồng Nai','K12'),
	('K1205',N'Nguyễn Thành',N'Nam','17/4/1986',N'Nam',N'TpHCM','K12'),
	('K1206',N'Nguyễn Thị Trúc',N'Thanh','4/3/1986',N'Nữ',N'Kiên Giang','K12'),
	('K1207',N'Trần Thị Bích',N'Thủy','8/2/1986',N'Nữ',N'Nghệ An','K12'),
	('K1208',N'Huỳnh Thị Kim',N'Triệu','8/4/1986',N'Nữ',N'Tây Ninh','K12'),
	('K1209',N'Phạm Thanh',N'Triệu','23/2/1986',N'Nam',N'TpHCM','K12'),
	('K1210',N'Ngô Thanh',N'Tuấn','14/2/1986',N'Nam',N'TpHCM','K12'),
	('K1211',N'Đỗ Thị',N'Xuân','9/3/1986',N'Nữ',N'Hà Nội','K12'),
	('K1212',N'Lê Thị Phi',N'Yến','12/3/1986',N'Nữ',N'TpHCM','K12'),
	('K1301',N'Nguyễn Thị Kim',N'Cúc','9/6/1986',N'Nữ',N'Kiên Giang','K13'),
	('K1302',N'Trương Thị Mỹ',N'Hiền','18/3/1986',N'Nữ',N'Nghệ An','K13'),
	('K1303',N'Lê Đức',N'Hiền','21/3/1986',N'Nam',N'Tây Ninh','K13'),
	('K1304',N'Lê Quang',N'Hiền','18/4/1986',N'Nam',N'TpHCM','K13'),
	('K1305',N'Lê Thị',N'Hương','27/3/1986',N'Nữ',N'TpHCM','K13'),
	('K1306',N'Nguyễn Thái',N'Hữu','30/3/1986',N'Nam',N'Hà Nội','K13'),
	('K1307',N'Trần Minh',N'Mẫn','28/5/1986',N'Nam',N'TpHCM','K13'),
	('K1308',N'Nguyễn Hiếu',N'Nghĩa','8/4/1986',N'Nam',N'Kiên Giang','K13'),
	('K1309',N'Nguyễn Trung',N'Nghĩa','18/1/1987',N'Nam',N'Nghệ An','K13'),
	('K1310',N'Trần Thị Hồng',N'Thắm','22/4/1986',N'Nữ',N'Tây Ninh','K13'),
	('K1311',N'Trần Minh',N'Thức','4/4/1986',N'Nam',N'TpHCM','K13'),
	('K1312',N'Nguyễn Thị Kim',N'Yến','7/9/1986',N'Nữ',N'TpHCM','K13');

UPDATE LOP SET TRGLOP = 'K1108' WHERE MALOP = 'K11'
UPDATE LOP SET TRGLOP = 'K1205' WHERE MALOP = 'K12' 
UPDATE LOP SET TRGLOP = 'K1305' WHERE MALOP = 'K13' 

-- Chèn giá trị cho bảng MONHOC (5)
INSERT INTO MONHOC(
	MAMH,
	TENMH,
	TCLT,
	TCTH,
	MAKHOA
)
VALUES
	('THDC',N'Tin học đại cương',4,1,'KHMT'),
	('CTRR',N'Cấu trúc rời rạc',5,0,'KHMT'),
	('CSDL',N'Cơ sở dữ liệu',3,1,'HTTT'),
	('CTDLGT',N'Cấu trúc dữ liệu và giải thuật',3,1,'KHMT'),
	('PTTKTT',N'Phân tích thiết kế thuật toán',3,0,'KHMT'),
	('DHMT',N'Đồ họa máy tính',3,1,'KHMT'),
	('KTMT',N'Kiến trúc máy tính',3,0,'KTMT'),
	('TKCSDL',N'Thiết kế cơ sở dữ liệu',3,1,'HTTT'),
	('PTTKHTTT',N'Phân tích thiết kế hệ thống thông tin',4,1,'HTTT'),
	('HDH',N'Hệ điều hành',4,0,'KTMT'),
	('NMCNPM',N'Nhập môn công nghệ phần mềm',3,0,'CNPM'),
	('LTCFW',N'Lập trình C for win',3,1,'CNPM'),
	('LTHDT',N'Lập trình hướng đối tượng',3,1,'CNPM');

-- Chèn giá trị cho bảng GIANGDAY (6)
INSERT INTO GIANGDAY(
	MALOP,
	MAMH,
	MAGV,
	HOCKY,
	NAM,
	TUNGAY,
	DENNGAY
)
VALUES
	('K11','THDC','GV07',1,2006,'2/1/2006','12/5/2006'),
	('K12','THDC','GV06',1,2006,'2/1/2006','12/5/2006'),
	('K13','THDC','GV15',1,2006,'2/1/2006','12/5/2006'),
	('K11','CTRR','GV02',1,2006,'9/1/2006','17/5/2006'),
	('K12','CTRR','GV02',1,2006,'9/1/2006','17/5/2006'),
	('K13','CTRR','GV08',1,2006,'9/1/2006','17/5/2006'),
	('K11','CSDL','GV05',2,2006,'1/6/2006','15/7/2006'),
	('K12','CSDL','GV09',2,2006,'1/6/2006','15/7/2006'),
	('K13','CTDLGT','GV15',2,2006,'1/6/2006','15/7/2006'),
	('K13','CSDL','GV05',3,2006,'1/8/2006','15/12/2006'),
	('K13','DHMT','GV07',3,2006,'1/8/2006','15/12/2006'),
	('K11','CTDLGT','GV15',3,2006,'1/6/2006','15/7/2006'),
	('K12','CTDLGT','GV15',3,2006,'1/6/2006','15/7/2006'),
	('K11','HDH','GV04',1,2007,'2/1/2007','18/2/2007'),
	('K12','HDH','GV04',1,2007,'2/1/2006','20/3/2007'),
	('K11','DHMT','GV07',1,2007,'18/2/2006','20/3/2007');


-- Chèn giá trị cho bảng DIEUKIEN (7)
INSERT INTO DIEUKIEN(
	MAMH,
	MAMH_TRUOC
)
VALUES
	('CSDL','CTRR'),
	('CSDL','CTDLGT'),
	('CTDLGT','THDC'),
	('PTTKTT','THDC'),
	('PTTKTT','CTDLGT'),
	('DHMT','CTDLGT'),
	('LTHDT','CTDLGT'),
	('PTTKHTTT','CSDL');

-- Chèn giá trị cho bảng KETQUATHI (8)
INSERT INTO KETQUATHI(
	MAHV,
	MAMH,
	LANTHI,
	NGTHI,
	DIEM
)
VALUES
	('K1101','CSDL',1,'20/7/2006',10.00),
	('K1101','CTDLGT',1,'28/12/2006',9.00),
	('K1101','THDC',1,'20/5/2006',9.00),
	('K1101','CTRR',1,'13/5/2006',9.50),
	('K1102','CSDL',1,'20/7/2006',4.00),
	('K1102','CSDL',2,'27/7/2006',4.25),
	('K1102','CSDL',3,'10/8/2006',4.50),
	('K1102','CTDLGT',1,'28/12/2006',4.50),
	('K1102','CTDLGT',2,'5/1/2007',4.00),
	('K1102','CTDLGT',3,'15/1/2007',6.00),
	('K1102','THDC',1,'20/5/2006',5.00),
	('K1102','CTRR',1,'13/5/2006',7.00),
	('K1103','CSDL',1,'20/7/2006',3.50),
	('K1103','CSDL',2,'27/7/2006',8.25),
	('K1103','CTDLGT',1,'28/12/2006',7.00),
	('K1103','THDC',1,'20/5/2006',8.00),
	('K1103','CTRR',1,'13/5/2006',6.50),
	('K1104','CSDL',1,'20/7/2006',3.75),
	('K1104','CTDLGT',1,'28/12/2006',4.00),
	('K1104','THDC',1,'20/5/2006',4.00),
	('K1104','CTRR',1,'13/5/2006',4.00),
	('K1104','CTRR',2,'20/5/2006',3.50),
	('K1104','CTRR',3,'30/6/2006',4.00),
	('K1201','CSDL',1,'20/7/2006',6.00),
	('K1201','CTDLGT',1,'28/12/2006',5.00),
	('K1201','THDC',1,'20/5/2006',8.50),
	('K1201','CTRR',1,'13/5/2006',9.00),
	('K1202','CSDL',1,'20/7/2006',8.00),
	('K1202','CTDLGT',1,'28/12/2006',4.00),
	('K1202','CTDLGT',2,'5/1/2007',5.00),
	('K1202','THDC',1,'20/5/2006',4.00),
	('K1202','THDC',2,'27/5/2006',4.00),
	('K1202','CTRR',1,'13/5/2006',3.00),
-----------------------------------------------------------
	('K1202','CTRR',2,'20/5/2006',4.00),
	('K1202','CTRR',3,'30/6/2006',6.25),
	('K1203','CSDL',1,'20/7/2006',9.25),
	('K1203','CTDLGT',1,'28/12/2006',9.50),
	('K1203','THDC',1,'20/5/2006',10.00),
	('K1203','CTRR',1,'13/5/2006',10.00),
	('K1204','CSDL',1,'20/7/2006',8.50),
	('K1204','CTDLGT',1,'28/12/2006',6.75),
	('K1204','THDC',1,'20/5/2006',4.00),
	('K1204','CTRR',1,'13/5/2006',6.00),
	('K1301','CSDL',1,'20/12/2006',4.25),
	('K1301','CTDLGT',1,'25/7/2006',8.00),
	('K1301','THDC',1,'20/5/2006',7.75),
	('K1301','CTRR',1,'13/5/2006',8.00),
	('K1302','CSDL',1,'20/12/2006',6.75),
	('K1302','CTDLGT',1,'25/7/2006',5.00),
	('K1302','THDC',1,'20/5/2006',8.00),
	('K1302','CTRR',1,'13/5/2006',8.50),
	('K1303','CSDL',1,'20/12/2006',4.00),
	('K1303','CTDLGT',1,'25/7/2006',4.50),
	('K1303','CTDLGT',2,'7/8/2006',4.00),
	('K1303','CTDLGT',3,'15/8/2006',4.25),
	('K1303','THDC',1,'20/5/2006',4.50),
	('K1303','CTRR',1,'13/5/2006',3.25),
	('K1303','CTRR',2,'20/5/2006',5.00),
	('K1304','CSDL',1,'20/12/2006',7.75),
	('K1304','CTDLGT',1,'25/7/2006',9.75),
	('K1304','THDC',1,'20/5/2006',5.50),
	('K1304','CTRR',1,'13/5/2006',5.00),
	('K1305','CSDL',1,'20/12/2006',9.25),
	('K1305','CTDLGT',1,'25/7/2006',10.00),
	('K1305','THDC',1,'20/5/2006',8.00),
	('K1305','CTRR',1,'13/5/2006',10.00);

UPDATE KETQUATHI SET KQUA = N'Đạt' WHERE DIEM >= 5
UPDATE KETQUATHI SET KQUA = N'Không Đạt' WHERE DIEM < 5

--- Câu 1: Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN SET HESO = HESO + 0.2 
WHERE MAGV IN (SELECT TRGKHOA 
			   FROM KHOA 
			   WHERE TRGKHOA IS NOT NULL)
--- CÂU 2: Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các 
--- môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HOCVIEN
SET DIEMTB =
   (SELECT AVG(DIEM) FROM KETQUATHI
	WHERE LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE HOCVIEN.MAHV = KETQUATHI.MAHV GROUP BY MAHV)
	GROUP BY MAHV
	HAVING KETQUATHI.MAHV = HOCVIEN.MAHV)

SELECT HOCVIEN.MAHV ,AVG(DIEM) DIEMTB, MAX(LANTHI) LANTHISAUCUNG
FROM KETQUATHI INNER JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV 
GROUP BY HOCVIEN.MAHV, DIEMTB

--- Câu 3: Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có 
--- một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN SET GHICHU = N'Cấm thi'
WHERE EXISTS (SELECT * FROM KETQUATHI WHERE MAHV = HOCVIEN.MAHV AND LANTHI = 3 AND DIEM < 5)

UPDATE HOCVIEN SET GHICHU = N'Cấm thi'
WHERE EXISTS (SELECT MAHV FROM KETQUATHI WHERE MAHV = HOCVIEN.MAHV AND LANTHI = 3 AND DIEM < 5)

---Câu 4: Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--o Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
--o Nếu 8 <= DIEMTB < 9 thì XEPLOAI = “G”
--o Nếu 6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
--o Nếu 5 <= DIEMTB < 6.5 thì XEPLOAI = “TB”
--o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN SET XEPLOAI = 'XS' WHERE DIEMTB >= 9
UPDATE HOCVIEN SET XEPLOAI = 'G' WHERE DIEMTB >= 8 AND DIEMTB < 9
UPDATE HOCVIEN SET XEPLOAI = 'K' WHERE DIEMTB >= 6.5 AND DIEMTB < 8
UPDATE HOCVIEN SET XEPLOAI = 'TB' WHERE DIEMTB >= 5 AND DIEMTB < 6.5
UPDATE HOCVIEN SET XEPLOAI = 'Y' WHERE DIEMTB < 5

UPDATE HOCVIEN
SET XEPLOAI = CASE
		WHEN DIEMTB >= 9 THEN 'XS'
		WHEN DIEMTB >= 8 AND DIEMTB < 9 THEN 'G'
		WHEN DIEMTB >= 6.5 AND DIEMTB < 8 THEN 'K'
		WHEN DIEMTB >= 5 AND DIEMTB < 6.5 THEN 'TB'
		ELSE 'Y'
	END

---------------------------------------------------------------------------------

-- PHẦN III
--Câu 1: In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp
SELECT MAHV, CONCAT(HO, TEN) AS HOTEN, NGSINH, LOP.MALOP
FROM HOCVIEN INNER JOIN LOP ON HOCVIEN.MAHV = LOP.TRGLOP

SELECT MAHV, CONCAT(HO, TEN) AS HOTEN, NGSINH, MALOP
FROM HOCVIEN WHERE MAHV IN (SELECT TRGLOP FROM LOP)

--Câu 2: In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, 
--sắp xếp theo tên, họ học viên.
SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN, LANTHI, DIEM 
FROM KETQUATHI INNER JOIN HOCVIEN 
ON MAMH = 'CTRR' AND MALOP = 'K12' AND KETQUATHI.MAHV = HOCVIEN.MAHV
ORDER BY TEN, HO

SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN, LANTHI, DIEM 
FROM KETQUATHI, HOCVIEN
WHERE
	KETQUATHI.MAHV = HOCVIEN.MAHV
	AND MAMH = 'CTRR'
	AND MALOP = 'K12'
ORDER BY TEN, HO

--Câu 3: In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi 
--lần thứ nhất đã đạt.
SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN, TENMH
FROM ((KETQUATHI 
INNER JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH) 
INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV)
WHERE LANTHI = 1 AND KQUA = N'Đạt'

SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN, TENMH
FROM KETQUATHI, MONHOC, HOCVIEN
WHERE
	KETQUATHI.MAMH = MONHOC.MAMH
	AND KETQUATHI.MAHV = HOCVIEN.MAHV
	AND LANTHI = 1 AND KQUA = N'Đạt'

--Câu 4:In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở 
--lần thi 1).
SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN
FROM HOCVIEN INNER JOIN KETQUATHI
ON HOCVIEN.MAHV = KETQUATHI.MAHV AND MALOP = 'K11' AND MAMH = 'CTRR' 
AND KQUA = N'Không đạt' AND LANTHI = 1 

SELECT HOCVIEN.MAHV, CONCAT(HO,' ',TEN) AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE
	HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MALOP = 'K11'
	AND MAMH = 'CTRR'
	AND KQUA =  N'Không đạt'
	AND LANTHI = 1
------------------------------Buổi 3------------------------------------------

-- PHẦN III

--Câu 5*: * Danh sách học viên (mã học viên, họ tên) của lớp “K” 
--thi môn CTRR không đạt (ở tất cả các lần thi).
--Cách 1:
SELECT MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN 
WHERE SUBSTRING(MALOP, 1, 1) = 'K'
AND MAHV IN(
SELECT DISTINCT MAHV 
FROM KETQUATHI
WHERE MAMH = 'CTRR' AND KQUA = N'Không đạt'
AND MAHV NOT IN(
SELECT DISTINCT MAHV 
FROM KETQUATHI WHERE LANTHI>=2 AND KQUA = N'Đạt'))

--Cách 2:
SELECT DISTINCT HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN INNER JOIN KETQUATHI 
ON HOCVIEN.MAHV = KETQUATHI.MAHV
AND MALOP LIKE 'K%'
AND MAMH = 'CTRR'
AND NOT EXISTS (SELECT *
				FROM KETQUATHI
				WHERE MAHV = HOCVIEN.MAHV
				AND MAMH = 'CTRR'
				AND KQUA = N'Đạt')

-- Câu 6: Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” 
--dạy trong học kỳ 1 năm 2006.
--Cách 1:
SELECT DISTINCT TENMH
FROM GIAOVIEN, MONHOC, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND MONHOC.MAMH = GIANGDAY.MAMH
	AND HOTEN = N'Trần Tâm Thanh' AND HOCKY = 1 AND NAM = 2006

--Cách 2:
SELECT DISTINCT TENMH
FROM MONHOC
WHERE MAMH IN (SELECT MAMH
			   FROM GIANGDAY
			   WHERE HOCKY = 1 AND NAM = 2006
			   AND MAGV IN (SELECT DISTINCT MAGV
							FROM GIAOVIEN
							WHERE HOTEN =  N'Trần Tâm Thanh'))

--Câu 7: Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm
--lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MONHOC.MAMH, TENMH
FROM MONHOC JOIN GIANGDAY ON MONHOC.MAMH = GIANGDAY.MAMH
WHERE HOCKY = 1 AND NAM = 2006 AND MAGV IN (SELECT MAGVCN
											FROM LOP
											WHERE MALOP = 'K11')

--Câu 8: Tìm họ tên lớp trưởng của các lớp mà giáo viên 
--có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.

SELECT DISTINCT TRGLOP, HO, TEN
FROM LOP JOIN HOCVIEN ON TRGLOP = MAHV
WHERE LOP.MALOP IN (SELECT MALOP FROM GIANGDAY JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
				WHERE GIAOVIEN.HOTEN = N'Nguyễn Tố Lan' AND MAMH IN (
																	SELECT MAMH FROM MONHOC
																	WHERE TENMH = N'Cơ sở dữ liệu') ) 				

--Câu 9: In ra danh sách những môn học (mã môn học, tên môn học) 
--phải học liền trước môn “Co So Du Lieu”.

SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN
(
	SELECT MAMH_TRUOC FROM DIEUKIEN JOIN MONHOC ON DIEUKIEN.MAMH = MONHOC.MAMH
	WHERE TENMH = N'Cơ sở dữ liệu'
)

--Câu 10: Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước 
--những môn học (mã môn học, tên môn học) nào.

SELECT TENMH
FROM MONHOC
WHERE MAMH IN
(
	SELECT MAMH FROM DIEUKIEN
	WHERE MAMH_TRUOC = (SELECT MAMH FROM MONHOC WHERE TENMH = N'Cơ sở dữ liệu')
)

SELECT TENMH
FROM MONHOC INNER JOIN DIEUKIEN ON DIEUKIEN.MAMH = MONHOC.MAMH
WHERE MAMH_TRUOC IN (SELECT MAMH FROM MONHOC WHERE TENMH = N'Cơ sở dữ liệu')

--Câu 11: Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp 
-- “K11” và “K12” trong cùng học kỳ 1 năm 2006.

SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN(
				SELECT DISTINCT MAGV FROM GIANGDAY
				WHERE MAMH = 'CTRR' AND NAM = 2006 AND MALOP = 'K11'
				UNION
				SELECT DISTINCT MAGV FROM GIANGDAY
				WHERE MAMH = 'CTRR' AND NAM = 2006 AND MALOP = 'K12'
				)

--Câu 12: Tìm những học viên (mã học viên, họ tên) thi không đạt 
--môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
--Cách 1:
SELECT MAHV, (HO +' '+TEN) HOTEN
FROM HOCVIEN
WHERE MAHV IN (
				SELECT MAHV FROM KETQUATHI
				WHERE LANTHI = 1 AND MAMH = 'CSDL' AND KQUA = N'Không đạt'
				EXCEPT
				SELECT MAHV FROM KETQUATHI
				WHERE LANTHI > 1 AND MAMH = 'CSDL'
				)
--Cách 2:
SELECT HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	  AND MAMH = 'CSDL' AND LANTHI = 1 AND KQUA = N'Không đạt'	
	  AND NOT EXISTS (SELECT * FROM KETQUATHI 
					  WHERE LANTHI > 1 
					  AND MAMH = 'CSDL' 
					  AND KETQUATHI.MAHV = HOCVIEN.MAHV)

--Câu 13: Tìm giáo viên (mã giáo viên, họ tên) không được 
-- phân công giảng dạy bất kỳ môn học nào.
--Cách 1:
SELECT DISTINCT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT DISTINCT MAGV FROM GIANGDAY)
--Cách 2:
SELECT DISTINCT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN(SELECT MAGV FROM GIAOVIEN
			  EXCEPT
			  SELECT DISTINCT MAGV FROM GIANGDAY)

--Câu 14: Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy 
--bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
--Cách 1:
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE NOT EXISTS
(
	SELECT *
	FROM MONHOC
	WHERE MONHOC.MAKHOA = GIAOVIEN.MAKHOA
	AND NOT EXISTS
	(
		SELECT *
		FROM GIANGDAY
		WHERE GIANGDAY.MAMH = MONHOC.MAMH
		AND GIANGDAY.MAGV = GIAOVIEN.MAGV
	)
)
--Cách 2:
SELECT DISTINCT MAGV, HOTEN
FROM GIAOVIEN, MONHOC
WHERE MAGV IN(SELECT MAGV FROM GIAOVIEN
			  EXCEPT
			  SELECT DISTINCT MAGV FROM GIANGDAY)
AND NOT EXISTS (SELECT *
				FROM MONHOC
				WHERE MONHOC.MAKHOA = GIAOVIEN.MAKHOA)
--Câu 15:Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần 
--vẫn “Không đạt” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
--Cách 1:
SELECT DISTINCT (HO +' '+TEN) HOTEN
FROM HOCVIEN
WHERE MALOP = 'K11'
AND MAHV IN (SELECT DISTINCT MAHV FROM KETQUATHI
			   WHERE LANTHI >= 3 AND KQUA = N'Không đạt'
			   UNION
			   SELECT DISTINCT MAHV FROM KETQUATHI
			   WHERE LANTHI = 2 AND MAMH = 'CTRR' AND DIEM = 5)
--Cách 2:
SELECT DISTINCT
	(HO+' '+TEN) HOTEN
FROM
	HOCVIEN, KETQUATHI
WHERE
	HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MALOP = 'K11'
	AND ((LANTHI = 2 AND DIEM = 5 AND MAMH = 'CTRR')
	OR HOCVIEN.MAHV IN
	(
		SELECT DISTINCT MAHV
		FROM KETQUATHI
		WHERE KQUA = N'Không đạt'
		GROUP BY MAHV, MAMH
		HAVING COUNT(*) >= 3	
	))
--Câu 16:Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp
--trong cùng một học kỳ của một năm học.

SELECT HOTEN
FROM GIAOVIEN, GIANGDAY 
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV AND MAMH = 'CTRR'
GROUP BY GIAOVIEN.MAGV, HOTEN, HOCKY
HAVING COUNT(*) >= 2
--Câu 17:Danh sách học viên và điểm thi môn CSDL 
--(chỉ lấy điểm của lần thi sau cùng)

SELECT HOCVIEN.*, DIEM AS 'Điểm thi CSDL sau cùng'
FROM HOCVIEN, KETQUATHI
WHERE
	HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MAMH = 'CSDL'
	AND LANTHI = 
	(
		SELECT MAX(LANTHI) 
		FROM KETQUATHI 
		WHERE MAMH = 'CSDL' AND KETQUATHI.MAHV = HOCVIEN.MAHV 
		GROUP BY MAHV
	)

--Câu 18: Danh sách học viên và điểm thi môn “Cơ sở dữ liệu” 
--(chỉ lấy điểm cao nhất của các lần thi).

SELECT DISTINCT HOCVIEN.*, DIEM AS 'Điểm cao nhất của các lần thi'
FROM HOCVIEN, MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH
	  AND  HOCVIEN.MAHV = KETQUATHI.MAHV
	  AND TENMH = N'Cơ sở dữ liệu'
	  AND DIEM = 
	  (
		SELECT MAX(DIEM)
		FROM KETQUATHI, MONHOC
		WHERE MONHOC.MAMH = KETQUATHI.MAMH
		AND MAHV = HOCVIEN.MAHV
		AND TENMH = N'Cơ sở dữ liệu'
		GROUP BY MAHV
	  )

--------------------------Buổi 4-----------------------------
--- 13/11/2021

--Câu 19: Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
--Cách 1:
SELECT MAKHOA, TENKHOA
FROM KHOA 
WHERE NGTLAP IN (SELECT MIN(NGTLAP) FROM KHOA)
--Cách 2:
SELECT MAKHOA, TENKHOA
FROM KHOA 
WHERE NGTLAP <= ALL(SELECT NGTLAP FROM KHOA)
--Cách 3:
SELECT TOP 1 WITH TIES MAKHOA, TENKHOA
FROM KHOA
ORDER BY NGTLAP ASC

--Câu 20: Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
--Cách 1:
SELECT HOCHAM, COUNT(MAGV) DEM
FROM GIAOVIEN
WHERE HOCHAM = 'GS' OR HOCHAM = 'PGS'
GROUP BY HOCHAM
--Cách 2:
SELECT HOCHAM, COUNT(MAGV) DEM
FROM GIAOVIEN
GROUP BY HOCHAM
HAVING HOCHAM IN ('GS', 'PGS')

--Mở rộng làm thêm: Có bao nhiêu giảng viên chưa là GS, PGS
-- Trả về con số cụ thể 
SELECT HOCHAM, COUNT(MAGV) DEM_GV_CHUA_LA_GS_PGS
FROM GIAOVIEN
GROUP BY HOCHAM
HAVING HOCHAM != 'GS' AND HOCHAM != 'PGS' OR HOCHAM IS NULL

-- Có bao nhiêu GV chưa có học hàm.

SELECT HOCHAM, COUNT(MAGV) DEM_GV_CHUA_CO_HOCHAM
FROM GIAOVIEN
GROUP BY HOCHAM
HAVING HOCHAM IS NULL

--Câu 21:Thống kê có bao nhiêu giáo viên có học vị 
--là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
--Cách 1:
SELECT KHOA.MAKHOA, TENKHOA, HOCVI, COUNT(HOCVI) SOLUONG
FROM GIAOVIEN, KHOA
WHERE HOCVI IN ('CN','KS','Ths','TS','PTS') AND GIAOVIEN.MAKHOA = KHOA.MAKHOA
GROUP BY HOCVI, KHOA.MAKHOA, TENKHOA

-- Làm thêm: 
-- 1.Coi TS và PTS là giống nhau. Thống kê lại
-- Khó, rất khó!
SELECT GIAOVIEN.MAKHOA, TENKHOA, HOCVI, COUNT(*) SLGV
FROM GIAOVIEN INNER JOIN KHOA ON GIAOVIEN.MAKHOA = KHOA.MAKHOA 
WHERE HOCVI IN ('CN','KS','Ths')
GROUP BY HOCVI, GIAOVIEN.MAKHOA, TENKHOA
UNION
SELECT GIAOVIEN.MAKHOA, TENKHOA, 'TS' AS HOCVI, COUNT(*) SLGV --//Có thể thay TS bởi PTS
FROM GIAOVIEN INNER JOIN KHOA ON GIAOVIEN.MAKHOA = KHOA.MAKHOA 
WHERE HOCVI IN ('TS','PTS')
GROUP BY HOCVI, GIAOVIEN.MAKHOA, TENKHOA
ORDER BY MAKHOA, HOCVI

-- 2.Cập nhật TS->TSKH, PTS->TS
-- UPDATE

UPDATE GIAOVIEN SET HOCVI = 'TSKH' WHERE HOCVI = 'TS'
UPDATE GIAOVIEN SET HOCVI = 'TS' WHERE HOCVI = 'PTS'
SELECT *
FROM GIAOVIEN
-- 3.'CN' : 15, 'KS' : 15, 'Ths' : 22, 'TS' : 30, 'TSKH' : 30
--  'PGS' : 40, 'GS': 60
--  Tính chỉ tiêu tuyển sinh?
--  VỀ NHÀ

--Câu 22: Mỗi môn học thống kê số lượng học viên 
-- theo kết quả (đạt và không đạt).

SELECT MONHOC.MAMH, TENMH, KQUA, COUNT(MAHV) SOLUONG
FROM MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH AND KQUA IN (N'Đạt', N'Không đạt')
GROUP BY  MONHOC.MAMH, TENMH, KQUA
ORDER BY MAMH

SELECT MAMH, KQUA, COUNT(*) 'Số học viên'
FROM KETQUATHI
GROUP BY MAMH, KQUA
ORDER BY MAMH
-- làm thêm: 1. thống kê SV đạt, không đạt theo từng lớp
SELECT LOP.MALOP, KETQUATHI.MAHV, KQUA
FROM KETQUATHI, LOP, HOCVIEN
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV 
	AND LOP.MALOP = HOCVIEN.MALOP
	AND KQUA IN (N'Đạt', N'Không đạt')
GROUP BY LOP.MALOP, KETQUATHI.MAHV, MAMH, KQUA
ORDER BY LOP.MALOP, MAMH	

		--   2. Mỗi môn học (tên môn), thống kê SV đạt, không đạt theo từng lớp
--KETQUATHI + LOP
SELECT LOP.MALOP, HOCVIEN.MAHV, TENMH, KQUA
FROM KETQUATHI, LOP, HOCVIEN, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV 
AND LOP.MALOP = HOCVIEN.MALOP
AND MONHOC.MAMH = KETQUATHI.MAMH
AND KQUA IN (N'Đạt', N'Không đạt')
GROUP BY LOP.MALOP, HOCVIEN.MAHV, KETQUATHI.MAMH, TENMH, KQUA
ORDER BY LOP.MALOP	


--Câu 23: Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp,
--đồng thời dạy cho  lớp đó ít nhất một môn học.
-- Cách 1:
SELECT MAGVCN, HOTEN
FROM GIAOVIEN, LOP
WHERE GIAOVIEN.MAGV = MAGVCN 
      AND EXISTS (SELECT MAGV
				  FROM GIANGDAY
			   	  WHERE MAGV = GIAOVIEN.MAGV
					AND MALOP = LOP.MALOP)
-- Cách 2:
SELECT DISTINCT MAGVCN, HOTEN
FROM GIAOVIEN, LOP, GIANGDAY
WHERE GIANGDAY.MALOP = LOP.MALOP
  AND GIANGDAY.MAGV = GIAOVIEN.MAGV
  AND GIAOVIEN.MAGV = LOP.MAGVCN

--Câu 24: Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
--Cách 1:
SELECT MAHV, (HO + ' ' + TEN) HOTEN
FROM HOCVIEN 
WHERE MAHV IN (SELECT TRGLOP 
			   FROM LOP
			   WHERE SISO = (SELECT MAX(SISO)
							 FROM LOP))
--Cách 2:
SELECT TOP 1 WITH TIES (HO + ' ' + TEN) HOTENLOPTRUONGCOSISOCAONHAT
FROM HOCVIEN INNER JOIN LOP ON HOCVIEN.MAHV = TRGLOP
GROUP BY TRGLOP, SISO, (HO + ' ' + TEN)
ORDER BY SISO DESC
--Câu 25: * Tìm họ tên những LOPTRG thi không đạt quá 3 môn
--(mỗi môn đều thi không đạt ở tất cả các lần thi).

SELECT (HO +' '+ TEN) HOTEN
FROM HOCVIEN
WHERE MAHV IN (SELECT TRGLOP FROM LOP)
AND MAHV NOT IN (SELECT DISTINCT MAHV FROM KETQUATHI
				 WHERE KQUA = N'Đạt'
				 GROUP BY MAHV)

--Câu 26: Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
--Cách 1:
SELECT TOP 1 WITH TIES HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE DIEM IN (9,10)
GROUP BY HOCVIEN.MAHV, (HO +' '+ TEN)
ORDER BY COUNT(*) DESC

--Cách 2:
SELECT HOCVIEN.MAHV, (HO+ ' '+ TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
  AND DIEM IN (9,10)
GROUP BY HOCVIEN.MAHV, (HO+ ' '+ TEN)
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM KETQUATHI 
					   WHERE DIEM IN (9,10)	
					   GROUP BY MAHV) 

--Câu 27: Trong từng lớp, tìm học viên (mã học viên, họ tên)
--có số môn đạt điểm 9,10 nhiều nhất.
--Cách 1:
SELECT MALOP, HV.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN HV, KETQUATHI
WHERE DIEM IN (9,10) AND HV.MAHV = KETQUATHI.MAHV
GROUP BY MALOP, HV.MAHV, (HO +' '+ TEN)
HAVING COUNT(DIEM) >= ALL (SELECT COUNT(DISTINCT DIEM)
						   FROM HOCVIEN HV2, KETQUATHI
						   WHERE DIEM IN (9,10) 
						   AND HV2.MAHV = KETQUATHI.MAHV
						   AND HV2.MALOP = HV.MALOP
						   GROUP BY MALOP)
--Cách 2:
-- Xếp loại theo MALOP, sắp xếp theo việc đếm điểm (COUNT(*))
SELECT MALOP, MAHV, HOTEN
FROM
(SELECT MALOP, HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN, COUNT(*) SOLUONGDIEM, 
	RANK() OVER (PARTITION BY MALOP ORDER BY COUNT(*) DESC) AS XEPHANG
 FROM HOCVIEN, KETQUATHI
 WHERE HOCVIEN.MAHV = KETQUATHI.MAHV AND DIEM IN (9,10)
 GROUP BY MALOP, HOCVIEN.MAHV, (HO +' '+ TEN)
) AS A
WHERE A.XEPHANG = 1

--Câu 28:Trong từng học kỳ của từng năm, mỗi giáo viên phân công 
-- dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT MAGV, COUNT(DISTINCT MAMH) 'Số môn học', COUNT(DISTINCT MALOP) 'Số lớp', HOCKY, NAM
FROM GIANGDAY
GROUP BY MAGV, HOCKY, NAM
ORDER BY NAM, HOCKY

--Câu 29:Trong từng học kỳ của từng năm, 
-- tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT NAM, HOCKY, MAGV, HOTEN 
FROM
(	
	SELECT NAM, HOCKY, GV.MAGV, HOTEN, COUNT(*) SOLUONG,
	RANK() OVER (PARTITION BY NAM, HOCKY ORDER BY COUNT(*) DESC) AS XEPHANG
	FROM GIAOVIEN GV, GIANGDAY
	WHERE GV.MAGV = GIANGDAY.MAGV
	GROUP BY NAM, HOCKY, GV.MAGV, HOTEN
) AS A
WHERE A.XEPHANG = 1

--Câu 30: Tìm môn học (mã môn học, tên môn học) có nhiều học viên
-- thi không đạt (ở lần thi thứ 1) nhất.
-- Cách 1:
SELECT TOP 1 WITH TIES MONHOC.MAMH, TENMH
FROM MONHOC, KETQUATHI
WHERE KQUA = N'Không đạt' 
	AND LANTHI = 1
	AND MONHOC.MAMH = KETQUATHI.MAMH 
GROUP BY MONHOC.MAMH, TENMH
ORDER BY COUNT(*) DESC

-- Cách 2:
SELECT MONHOC.MAMH, TENMH
FROM MONHOC, KETQUATHI
WHERE KQUA = N'Không đạt' 
	AND LANTHI = 1
	AND MONHOC.MAMH = KETQUATHI.MAMH 
GROUP BY MONHOC.MAMH, TENMH
HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM KETQUATHI 
						WHERE KQUA = N'Không đạt' AND LANTHI = 1
						GROUP BY MAMH)

--Câu 31: Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt 
--(chỉ xét lần thi thứ 1).
SELECT DISTINCT HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
  AND NOT EXISTS
  (	
	SELECT * FROM KETQUATHI
	WHERE LANTHI = 1 AND KQUA = N'Không đạt'
	AND MAHV = HOCVIEN.MAHV
  )
--Câu 32: * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt
-- (chỉ xét lần thi sau cùng).
SELECT DISTINCT HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
  AND NOT EXISTS
  (	
	SELECT * FROM KETQUATHI
	WHERE KQUA = N'Không đạt'
	AND LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI
				  WHERE MAHV = HOCVIEN.MAHV
				  GROUP BY MAHV)
	AND MAHV = HOCVIEN.MAHV
  )
--Câu 33: * Tìm học viên (mã học viên, họ tên) đã thi 
--tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
SELECT DISTINCT HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN, MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH AND HOCVIEN.MAHV = KETQUATHI.MAHV
AND NOT EXISTS
(
		SELECT * FROM KETQUATHI
		WHERE MONHOC.MAMH = KETQUATHI.MAMH
		AND HOCVIEN.MAHV = KETQUATHI.MAHV
		AND KQUA = N'Không đạt' AND LANTHI = 1
) 
--Câu 34: *Tìm học viên (mã học viên, họ tên) đã thi 
-- tất cả các môn đều đạt (chỉ xét lần thi sau cùng).
SELECT DISTINCT HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN
FROM HOCVIEN, MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH AND HOCVIEN.MAHV = KETQUATHI.MAHV
AND NOT EXISTS
  (	
	SELECT * FROM KETQUATHI
	WHERE KQUA = N'Không đạt'
	AND LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI
				  WHERE MAHV = HOCVIEN.MAHV
				  GROUP BY MAHV)
	AND MAHV = HOCVIEN.MAHV 
  )
--Câu 35:**Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất 
-- trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT DISTINCT MAMH, MAHV, HOTEN
FROM 
(
	SELECT MAMH, HOCVIEN.MAHV, (HO +' '+ TEN) HOTEN,
	RANK() OVER (PARTITION BY MAMH ORDER BY MAX(DIEM) DESC) AS XEPHANG
	FROM HOCVIEN, KETQUATHI
	WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI
				  WHERE MAHV = HOCVIEN.MAHV
				  GROUP BY MAHV)
	GROUP BY MAMH, HOCVIEN.MAHV, (HO +' '+ TEN)
) AS A
WHERE A.XEPHANG = 1

--------------------------------------------------------------------------
---------------------------Buổi 5 (27/11/2021)----------------------------
--------------------------------------------------------------------------

---Phần I Câu 5 -> 24

--Câu 5:  Kết quả thi là “Đạt” nếu điểm từ 5 đến 10 
-- và “Không đạt” nếu điểm nhỏ hơn 5.
-- Bảng: KETQUATHI
-- RB: DIEM
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_KQUA CHECK ((DIEM < 5 AND KQUA = N'Không đạt')
	OR (DIEM >=5 AND DIEM <=10 AND KQUA = N'Đạt'))

--Câu 6: Học viên thi một môn tối đa 3 lần
-- Bảng: KETQUATHI
-- RB: LANTHI
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_LANTHI CHECK (LANTHI <= 3)

-- Câu 7: Học kỳ chỉ có giá trị từ 1 đến 3.
-- Bảng: GIANGDAY
-- RB: HOCKY
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHK_HK CHECK(HOCKY IN (1, 2, 3))

-- Câu 8: Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
-- Bảng: GIAOVIEN
-- RB: HOCVI
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_HOCVI CHECK(HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))

-- Câu 9: Lớp trưởng của một lớp phải là học viên của lớp đó.
-- Bảng: HOCVIEN, LOP
-- RB: LOPTRG

CREATE TRIGGER UPDATE_LOPTRG ON LOP
FOR UPDATE
AS
IF (UPDATE(MALOP) OR UPDATE(TRGLOP))
BEGIN
	DECLARE @MAHV VARCHAR(10), @TRGLOP VARCHAR(10), @MALOP VARCHAR(10)

	SELECT @TRGLOP = TRGLOP, @MALOP = MALOP FROM INSERTED
	SELECT @MAHV = MAHV FROM HOCVIEN 
	WHERE MAHV = @TRGLOP AND MALOP = @MALOP

	IF (@MAHV <> @TRGLOP)
		BEGIN
			PRINT 'Lỗi! Lớp trưởng không phải thành viên lớp đó'
			ROLLBACK TRANSACTION
		END
	ELSE
		PRINT 'UPDATE thành công'
END

-- Câu 10: Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”
CREATE TRIGGER INS_TRUONGKHOA ON KHOA
FOR INSERT
AS
BEGIN
	DECLARE @MAGV VARCHAR(7), @TRGKHOA VARCHAR(7), @MAKHOA VARCHAR(7)
	SELECT @TRGKHOA = TRGKHOA, @MAKHOA = MAKHOA FROM INSERTED
	SELECT @MAGV = MAGV FROM GIAOVIEN WHERE MAGV = @TRGKHOA AND HOCVI IN ('TS', 'PTS')

	IF (@MAGV = @TRGKHOA)
		BEGIN
			PRINT N'Nhập thành công'
		END
	ELSE
		BEGIN
			PRINT N'Lỗi! trưởng khoa không là giáo viên thuộc khoa đó hoặc không có học vị TS hoặc PTS'
			ROLLBACK TRANSACTION
		END
END

-- Câu 11: Học viên ít nhất là 18 tuổi
-- Bảng: HOCVIEN
-- RB: NOW - NGSINH >= 18

ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_TUOI CHECK(YEAR(GETDATE()) - YEAR(NGSINH) >= 18) 

-- Câu 12: Giảng dạy một môn học ngày bắt đầu (TUNGAY) 
-- phải nhỏ hơn ngày kết thúc (DENNGAY)
-- Bảng: GIANGDAY
-- RB: TUNGAY < DENNGAY

ALTER TABLE GIANGDAY
ADD CONSTRAINT CHK_NGAY CHECK(TUNGAY < DENNGAY)

-- Câu 13: Giáo viên khi vào làm ít nhất là 22 tuổi.
-- Bảng: GIAOVIEN
-- RB: TUOI
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_TUOIVAOLAM CHECK(YEAR(NGVL) - YEAR(NGSINH) >= 22) 

-- Câu 14: Tất cả các môn học đều có số tín chỉ lý thuyết 
-- và tín chỉ thực hành chênh lệch nhau không quá 3
-- Bảng: MONHOC
-- RB: |TCLT - TCTH| <= 3
-- LƯU Ý: HDH 4LT cần update lại thành 3TCLT và 1TCTH
--		  CTRR 5LT cần update lại thành 3TCLT
UPDATE MONHOC SET TCLT = 3, TCTH = 1 WHERE MAMH = 'HDH'
UPDATE MONHOC SET TCLT = 3  WHERE MAMH = 'CTRR'

ALTER TABLE MONHOC
ADD CONSTRAINT CHK_TINCHI CHECK (ABS(TCLT - TCTH) <= 3)

-- Câu 15: Học viên chỉ được thi một môn học nào đó
-- khi lớp của học viên đã học xong môn học này.
-- Bảng: GIANGDAY, KETQUATHI
-- ý tưởng: xét điều kiện -> ngày thi > ngày kết thúc môn học đó

CREATE TRIGGER UPDATE_HOCVIEN_THI ON GIANGDAY
FOR UPDATE
AS
BEGIN
	DECLARE @MAMH VARCHAR(10), @DENNGAY SMALLDATETIME, @MAMH2 VARCHAR(10)
	SELECT @MAMH = MAMH, @DENNGAY = DENNGAY FROM INSERTED

	SELECT @MAMH2 = MAMH FROM KETQUATHI WHERE MAMH = @MAMH AND NGTHI > @DENNGAY
	IF (@MAMH2 = @MAMH)
		BEGIN
			PRINT N'Học viên được thi môn học học đó!'
		END
	ELSE
		BEGIN
			PRINT N'Lỗi! Học viên không được thi môn đó!'
			ROLLBACK TRANSACTION
		END
END
--Câu 16: Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
-- Bảng: GIANGDAY, LOP

CREATE TRIGGER INS_NAM_LOP_MAX3MON ON MONHOC
FOR INSERT
AS
BEGIN
	DECLARE @MAMH VARCHAR(10), @MAMH2 VARCHAR(10)
	SELECT @MAMH = MAMH FROM INSERTED

	SELECT @MAMH2 = MAMH FROM GIANGDAY WHERE MAMH = @MAMH
	GROUP BY NAM, HOCKY, MAMH
	HAVING COUNT(MAMH) <= 3

	IF (@MAMH2 = @MAMH)
		BEGIN
			PRINT N'hợp lệ!'
		END
	ELSE
		BEGIN
			PRINT N'Lỗi!'
			ROLLBACK TRANSACTION
		END
END

-- Câu 17: Sĩ số của một lớp bằng với số lượng học viên thuộc lớp đó
-- Bảng: LOP, HOCVIEN
CREATE TRIGGER SISOLOP_SOLUONG ON LOP
FOR UPDATE
AS
BEGIN
	DECLARE @MALOP CHAR(3),  @MALOP2 CHAR(3),@SISO TINYINT
	SELECT @MALOP = MALOP, @SISO = SISO FROM INSERTED
	SELECT @MALOP2 = MALOP FROM HOCVIEN WHERE MALOP = @MALOP
	GROUP BY MALOP, MAHV
	HAVING COUNT(MAHV) = @SISO

	IF (@MALOP2 = @MALOP)
		BEGIN
			PRINT N'Hợp lệ! Sĩ số của một lớp bằng với số lượng học viên thuộc lớp'
		END
	ELSE
		BEGIN
			PRINT N'Lỗi!Sĩ số của một lớp không bằng với số lượng học viên thuộc lớp'
			ROLLBACK TRANSACTION
		END
END

-- Câu 18: Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC 
-- trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại 
-- hai bộ (“A”,”B”) và (“B”,”A”).
-- Bảng: DIEUKIEN
CREATE TRIGGER CHK_MAMH_MAMHTRUOC ON DIEUKIEN
FOR INSERT
AS 
BEGIN
	DECLARE @MAMH VARCHAR(10), @MAMH_TRUOC VARCHAR(10)
	DECLARE @MAMH2 VARCHAR(10), @MAMH_TRUOC2 VARCHAR(10)

	SELECT @MAMH = MAMH, @MAMH_TRUOC = MAMH_TRUOC FROM INSERTED

	SELECT @MAMH2 = MAMH, @MAMH_TRUOC2 = MAMH_TRUOC
	FROM DIEUKIEN 
	WHERE @MAMH = @MAMH2 AND @MAMH_TRUOC = @MAMH_TRUOC2
	AND MAMH != MAMH_TRUOC OR (MAMH = @MAMH_TRUOC AND MAMH_TRUOC = @MAMH)

	IF @MAMH != @MAMH_TRUOC OR (@MAMH = @MAMH_TRUOC2 AND @MAMH_TRUOC = @MAMH2)
		BEGIN
			PRINT N'Hợp lệ!'
		END
	ELSE
		BEGIN
			PRINT N'Không hợp lệ'
			ROLLBACK TRANSACTION
		END
END
-- Câu 19: Các giáo viên có cùng học vị, học hàm, hệ số lương 
-- thì mức lương bằng nhau.
-- Bảng: GIAOVIEN
CREATE TRIGGER CHK_GIAOVIEN ON GIAOVIEN
FOR INSERT
AS 
BEGIN
	DECLARE @HOCVI VARCHAR(10), @HOCHAM VARCHAR(10), @HESO NUMERIC(4, 2), @MUCLUONG MONEY
	DECLARE @HOCVI2 VARCHAR(10), @HOCHAM2 VARCHAR(10), @HESO2 NUMERIC(4, 2)
	SELECT @HOCVI = HOCVI, @HOCHAM = HOCHAM FROM INSERTED

	SELECT @HOCVI2 = HOCVI, @HOCHAM2 = HOCHAM, @HESO2 = HESO FROM GIAOVIEN
	WHERE HOCVI = @HOCVI AND HOCHAM = @HOCHAM AND HESO = @HESO
	AND MUCLUONG = @MUCLUONG

	IF (@HOCVI2 = @HOCVI AND @HOCHAM2 = @HOCHAM AND @HESO2 = @HESO)
		BEGIN
			PRINT N'Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.'
		END
	ELSE
		BEGIN
			PRINT N'Các giáo viên không cùng học vị, học hàm, hệ số lương!'
			ROLLBACK TRANSACTION
		END
END

-- Câu 20: Học viên chỉ được thi lại (lần thi > 1) 
-- khi điểm của lần thi trước đó dưới 5.
--Bảng:KETQUATHI
CREATE TRIGGER CHK_THILAI ON KETQUATHI
FOR UPDATE
AS 
BEGIN
	DECLARE @MAHV CHAR(5), @LANTHI TINYINT, @DIEM NUMERIC(4, 2)
	DECLARE @LANTHI2 TINYINT

	SELECT @MAHV = MAHV, @LANTHI = LANTHI, @DIEM = DIEM FROM INSERTED

	SELECT @LANTHI2 = LANTHI FROM KETQUATHI 
	WHERE MAHV = @MAHV AND (LANTHI - @LANTHI > 1) AND @DIEM < 5

	IF (@LANTHI2 - @LANTHI > 1)
		BEGIN
			PRINT N'Học viên được thi lại'
		END 
	ELSE
		BEGIN
			PRINT N'Học viên không được thi lại'
			ROLLBACK TRANSACTION
		END 
END

-- Câu 21: Ngày thi của lần thi sau phải lớn hơn ngày thi 
-- của lần thi trước (cùng học viên, cùng môn học).
-- Bảng: KETQUATHI
CREATE TRIGGER CHK_NGTHI_SAU_LON_TRUOC ON KETQUATHI
FOR INSERT
AS 
BEGIN
	DECLARE @MAHV CHAR(5), @MAMH VARCHAR(10), @NGTHI SMALLDATETIME, @LANTHI TINYINT
	DECLARE @MAHV2 CHAR(5), @MAMH2 VARCHAR(10)

	SELECT @MAHV = MAHV, @MAMH = MAMH, @NGTHI = NGTHI, @LANTHI = LANTHI FROM INSERTED
	
	SELECT @MAHV2 = MAHV, @MAMH2 = MAMH FROM KETQUATHI
	WHERE MAHV = @MAHV AND MAMH = @MAMH
	AND NGTHI > @NGTHI AND LANTHI - @LANTHI > 1

	IF (@MAHV2 = @MAHV AND @MAMH2 = @MAMH)
		BEGIN
			PRINT N'Hợp lệ! Ngày thi của lần thi sau > ngày thi của lần thi trước'
		END
	ELSE
		BEGIN
			PRINT N'Lỗi ! Ngày thi của lần thi sau < ngày thi của lần thi trước'
			ROLLBACK TRANSACTION
		END
END
-- Câu 22: Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong
-- Trùng Câu 15

-- Câu 23: Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau 
-- giữa các môn học (sau khi học xong những môn học phải học trước mới
-- được học những môn liền sau).
-- Bảng: DIEUKIEN, KETQUATHI
CREATE TRIGGER CHK_DK_HOC ON DIEUKIEN
FOR UPDATE
AS
BEGIN
	DECLARE @MAMH_TRUOC VARCHAR(10)
	DECLARE @MAMH2 VARCHAR(10)
	SELECT @MAMH_TRUOC = MAMH_TRUOC FROM INSERTED

	SELECT @MAMH2 = MAMH FROM KETQUATHI
	WHERE MAMH = @MAMH_TRUOC AND KQUA = N'Đạt'

	IF (@MAMH2 = @MAMH_TRUOC)
		BEGIN
			PRINT N'Được học tiếp môn học sau!'
		END
	ELSE
		BEGIN
			PRINT N'Không được học tiếp môn học sau!'
			ROLLBACK TRANSACTION
		END
END

-- Câu 24: Giáo viên chỉ được phân công dạy những môn 
-- thuộc khoa giáo viên đó phụ trách
-- Bảng: GIANGDAY, MONHOC, GIAOVIEN
CREATE TRIGGER CHK_GV_PHANCONGDAY ON GIANGDAY
FOR INSERT
AS 
BEGIN
	DECLARE @MAMH VARCHAR(10), @MAGV CHAR(4)
	DECLARE @MAMH2 VARCHAR(10), @MAGV2 CHAR(4)

	SELECT @MAMH = MAMH, @MAGV = MAGV FROM INSERTED

	SELECT @MAGV2 = MAGV, @MAMH2 = MAMH 
	FROM GIAOVIEN, MONHOC
	WHERE GIAOVIEN.MAKHOA = MONHOC.MAKHOA 
		AND MAGV = @MAGV AND MAMH = @MAMH

	IF (@MAGV2 = @MAGV AND @MAMH2 = @MAMH)
		BEGIN
			PRINT N'Giáo viên được phân công dạy những môn này!'
		END
	ELSE
		BEGIN
			PRINT N'Giáo viên không được phân công dạy'
			ROLLBACK TRANSACTION
		END
END