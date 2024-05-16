-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: databannon
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chitietdonhang`
--

DROP TABLE IF EXISTS `chitietdonhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chitietdonhang` (
  `maDonHang` int(11) NOT NULL,
  `maSanPham` int(11) NOT NULL,
  `soLuong` int(11) NOT NULL,
  `giaSanPham` int(11) NOT NULL DEFAULT 20000,
  PRIMARY KEY (`maDonHang`,`maSanPham`),
  KEY `FK_maSanPham` (`maSanPham`),
  CONSTRAINT `FK_maDonHang` FOREIGN KEY (`maDonHang`) REFERENCES `donhang` (`maDonHang`) ON DELETE CASCADE,
  CONSTRAINT `FK_maSanPham` FOREIGN KEY (`maSanPham`) REFERENCES `sanpham` (`MaSanPham`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietdonhang`
--

LOCK TABLES `chitietdonhang` WRITE;
/*!40000 ALTER TABLE `chitietdonhang` DISABLE KEYS */;
INSERT INTO `chitietdonhang` VALUES (133,167,1,117000),(133,168,26,38000),(134,167,1,117000),(135,1,3,100000),(136,165,1,500000),(136,168,1,38000),(137,167,3,117000),(138,1,2,100000),(139,167,1,117000),(139,168,26,38000),(140,167,1,117000),(140,168,26,38000),(141,167,1,117000),(142,167,1,117000),(142,168,26,38000),(143,167,1,117000),(143,168,26,38000),(144,174,3,100000),(145,174,3,100000),(146,174,4,100000),(147,147,1,117000),(147,148,1,38000),(147,151,1,120000),(147,154,1,2700000),(147,155,1,2700000),(147,156,1,2700000),(147,160,1,30000),(147,162,1,200000),(147,163,1,200000),(147,165,1,500000),(148,1,1,100000),(148,2,1,120000),(148,3,1,150000),(148,24,1,30000),(148,25,1,299000),(148,27,1,38000),(148,122,1,35000),(148,140,1,500000),(148,141,1,2700000),(148,154,1,2700000),(149,146,1,500000),(149,149,2,299000),(149,152,1,35000),(149,153,1,100000),(149,156,2,2700000),(149,157,2,2700000),(149,158,1,150000),(149,159,1,150000),(150,143,3,150000),(150,160,1,30000),(150,161,2,30000),(150,162,2,200000),(150,163,1,200000),(150,165,1,500000),(150,167,1,117000),(150,168,1,38000),(151,167,2,117000),(151,168,1,38000),(152,167,2,117000);
/*!40000 ALTER TABLE `chitietdonhang` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger before_insert_chitietdonhang
before insert on chitietdonhang
for each row
begin
	declare v_giaSanPham int(11);
    
    -- Retrieve the giaSanPham from the sanpham table
    select giaSanPham into v_giaSanPham
    from sanpham
    where maSanPham = new.maSanPham;
    
    -- Set the giaSanPham in the new row
    set new.giaSanPham = v_giaSanPham;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger after_insert_chitietdonhang
after insert on chitietdonhang
for each row
begin
	-- Update the quantity of sanpham table
    update sanpham 
    set soLuong = sanPham.soLuong - new.soLuong
    where sanPham.maSanPham = new.maSanPham;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger after_delete_chitietdonhang
after delete on `chitietdonhang`
for each row
begin
	-- update the quantity in sanpham table
    update sanpham 
    set sanpham.soLuong = sanpham.soLuong + old.soLuong
    where sanpham.maSanPham = old.maSanPham;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `danhgia`
--

DROP TABLE IF EXISTS `danhgia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhgia` (
  `maDanhGia` int(11) NOT NULL AUTO_INCREMENT,
  `soSao` tinyint(4) NOT NULL,
  `dungVoiMoTa` text NOT NULL DEFAULT 'Tốt',
  `chatLuongSanPham` text NOT NULL DEFAULT 'Tuyệt vời',
  `nhanXet` text NOT NULL,
  `maDonHang` int(11) NOT NULL,
  `ngayDanhGia` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`maDanhGia`),
  UNIQUE KEY `maDonHang` (`maDonHang`),
  CONSTRAINT `danhgia_ibfk_1` FOREIGN KEY (`maDonHang`) REFERENCES `donhang` (`maDonHang`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhgia`
--

LOCK TABLES `danhgia` WRITE;
/*!40000 ALTER TABLE `danhgia` DISABLE KEYS */;
/*!40000 ALTER TABLE `danhgia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhmuc`
--

DROP TABLE IF EXISTS `danhmuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhmuc` (
  `maDanhMuc` int(11) NOT NULL AUTO_INCREMENT,
  `tenDanhMuc` varchar(255) NOT NULL,
  `hinhAnh` text NOT NULL,
  PRIMARY KEY (`maDanhMuc`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhmuc`
--

LOCK TABLES `danhmuc` WRITE;
/*!40000 ALTER TABLE `danhmuc` DISABLE KEYS */;
INSERT INTO `danhmuc` VALUES (1,'Trang chủ','images/categories/home.jpg'),(2,'Danh sách sản phẩm','images/categories/hats-list.jpg'),(4,'Đơn mua','images/categories/order.png'),(5,'Vị trí cửa hàng','images/categories/map.jpg'),(6,'Đăng xuất','images/categories/logout.jpg');
/*!40000 ALTER TABLE `danhmuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhmucquanly`
--

DROP TABLE IF EXISTS `danhmucquanly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhmucquanly` (
  `maDanhMuc` int(11) NOT NULL AUTO_INCREMENT,
  `tenDanhMuc` varchar(255) NOT NULL,
  `hinhAnh` text NOT NULL,
  PRIMARY KEY (`maDanhMuc`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhmucquanly`
--

LOCK TABLES `danhmucquanly` WRITE;
/*!40000 ALTER TABLE `danhmucquanly` DISABLE KEYS */;
INSERT INTO `danhmucquanly` VALUES (1,'Quản lý sản phẩm','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0XmKxlHl76PwixoDGYvVNxb01CfKJYRYAlRAnzRx80FF4Jr8lfBRUp2TtayezNfzNDq4&usqp=CAU');
/*!40000 ALTER TABLE `danhmucquanly` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donhang`
--

DROP TABLE IF EXISTS `donhang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donhang` (
  `maDonHang` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `diaChi` text NOT NULL,
  `soLuong` int(11) NOT NULL,
  `tongTien` varchar(15) NOT NULL,
  `soDienThoai` varchar(15) NOT NULL,
  `email` varchar(254) NOT NULL,
  `trangThai` varchar(100) NOT NULL DEFAULT 'Chờ xác nhận',
  `token` text NOT NULL,
  `ngayTao` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`maDonHang`),
  KEY `FK_userId` (`userId`),
  CONSTRAINT `FK_userId` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donhang`
--

LOCK TABLES `donhang` WRITE;
/*!40000 ALTER TABLE `donhang` DISABLE KEYS */;
INSERT INTO `donhang` VALUES (133,24,'Tây Nguyên ',1,'38000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-04-28 08:55:41'),(134,24,'Lã Xuân Oai',1,'117000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-03-28 08:55:41'),(135,24,'Geography ',3,'300000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-02-28 08:55:41'),(136,24,'Bà rịa Vũng tàu',2,'538000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','ACp_hbKERjpsBsUaFrbFHoaQ','2024-05-28 08:55:41'),(137,24,'Man thiện',3,'351000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-04-28 08:55:41'),(138,24,'Man Thiện ',2,'200000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','ACUgPKrdR6N89_TPxu2mEQfw','2024-04-28 08:55:41'),(139,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2023-04-28 08:55:41'),(140,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2024-04-28 08:55:41'),(141,24,'abc',1,'117000','0948915051','nguyenthaitruong1223@gmail.com','Đã giao','','2024-04-28 08:55:41'),(142,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2024-04-28 12:45:08'),(143,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2024-04-28 13:04:13'),(144,24,'Chư Kbô',3,'300000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','ACcBETBE9Z5GyaQvQR0V1-7Q','2024-04-28 13:26:50'),(145,24,'Chư Kbô',3,'300000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-04-28 13:29:04'),(146,24,'Chư Kbô',4,'400000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-04-28 13:29:29'),(147,24,'Ba Ria Vung Tau',10,'9305000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-05-02 10:32:03'),(148,23,'97 Man Thien Tang Nhon Phu A',10,'6672000','0987654321','nguyenthaitruong.entertainment@gmail.com','Chờ xác nhận','','2024-05-02 10:57:47'),(149,23,'97 Man Thien Tang Nhon Phu B',10,'12333000','0987654321','nguyenthaitruong.entertainment@gmail.com','Chờ xác nhận','','2024-05-02 10:59:42'),(150,23,'30 Tan Lap, Chu Kbo, Dak Lak',12,'1795000','0987654321','nguyenthaitruong.entertainment@gmail.com','Chờ xác nhận','','2024-05-02 11:45:41'),(151,23,'Ba Ria Vung Tau',3,'272000','0987654321','nguyenthaitruong.entertainment@gmail.com','Đã hủy','ACeSVAyH5WNjD45L_SNbXAuQ','2024-05-02 13:08:18'),(152,23,'123 Ha Noi',2,'234000','0987654321','nguyenthaitruong.entertainment@gmail.com','Đã hủy','abc','2024-05-05 00:29:31');
/*!40000 ALTER TABLE `donhang` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger before_delete_donhang
before delete on `donhang`
for each row
begin
	declare done int default false;
    declare v_maSanPham int;
    declare v_soLuong int;
    declare cur cursor for
		select maSanPham, soLuong
        from chitietdonhang
        where maDonHang = old.maDonHang;
	declare continue handler for not found set done = true;
    
    open cur;
    read_loop: loop
		fetch cur into v_maSanPham, v_soLuong;
        if done then
			leave read_loop;
		end if;
        update sanpham
        set soLuong = soLuong + v_soLuong
        where maSanPham = v_maSanPham;
	end loop;
    close cur;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `giohang`
--

DROP TABLE IF EXISTS `giohang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `giohang` (
  `maSanPham` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `soLuong` int(11) NOT NULL,
  PRIMARY KEY (`maSanPham`,`userId`),
  CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`maSanPham`) REFERENCES `sanpham` (`MaSanPham`),
  CONSTRAINT `giohang_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giohang`
--

LOCK TABLES `giohang` WRITE;
/*!40000 ALTER TABLE `giohang` DISABLE KEYS */;
INSERT INTO `giohang` VALUES (161,24,3),(167,23,1),(168,24,12);
/*!40000 ALTER TABLE `giohang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hinhanhdanhgia`
--

DROP TABLE IF EXISTS `hinhanhdanhgia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hinhanhdanhgia` (
  `maHinhAnh` int(11) NOT NULL AUTO_INCREMENT,
  `maDanhGia` int(11) NOT NULL,
  `hinhAnhURL` text NOT NULL,
  PRIMARY KEY (`maHinhAnh`),
  KEY `maDanhGia` (`maDanhGia`),
  CONSTRAINT `hinhanhdanhgia_ibfk_1` FOREIGN KEY (`maDanhGia`) REFERENCES `danhgia` (`maDanhGia`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hinhanhdanhgia`
--

LOCK TABLES `hinhanhdanhgia` WRITE;
/*!40000 ALTER TABLE `hinhanhdanhgia` DISABLE KEYS */;
/*!40000 ALTER TABLE `hinhanhdanhgia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sanpham`
--

DROP TABLE IF EXISTS `sanpham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sanpham` (
  `maSanPham` int(11) NOT NULL AUTO_INCREMENT,
  `tenSanPham` varchar(255) NOT NULL,
  `soLuong` int(11) DEFAULT NULL,
  `gioiTinh` varchar(20) DEFAULT NULL,
  `mauSac` varchar(30) DEFAULT NULL,
  `hinhAnh` text DEFAULT NULL,
  `trangThai` tinyint(1) DEFAULT NULL,
  `giaSanPham` int(11) DEFAULT 0,
  PRIMARY KEY (`maSanPham`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sanpham`
--

LOCK TABLES `sanpham` WRITE;
/*!40000 ALTER TABLE `sanpham` DISABLE KEYS */;
INSERT INTO `sanpham` VALUES (1,'Washed Cotton Caps Men Cadet Cap Design Flat Top Hat',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1184522745/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-americana-v%C3%A0-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eQWSy0ok0umbVrToBbNZ7hbwTD7-75vgee2EaRDLkDk=',0,100000),(2,'Nón Snapback Nón Hiphop Trơn Có Khóa - Đen',35,'Nữ','Vàng tươi','https://media.istockphoto.com/id/1453988945/vi/anh/m%C5%A9-x%C3%B4-m%C3%A0u-v%C3%A0ng-c%C3%A1ch-ly-tr%C3%AAn-m%C3%A0u-tr%E1%BA%AFng.jpg?s=1024x1024&w=is&k=20&c=x3MA6las9ZkUwCC4f4uD5vbS4YCyGGtrdIxxsirTn3c=',0,120000),(3,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(24,'Mũ bóng chày màu đen trống 4 xem trên nền trắng',30,'Nam','Đen trắng','https://media.istockphoto.com/id/1060912434/vi/vec-to/m%C5%A9-tr%E1%BA%AFng-v%C3%A0-%C4%91en-t%E1%BB%AB-c%C3%A1c-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau.jpg?s=612x612&w=0&k=20&c=Jz_E-l29kqJ1I9Es1D-_5oJJRtT5U9NYClk5qnpzPVQ=',0,30000),(25,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.',35,'Nữ','Xanh nước biển','https://media.istockphoto.com/id/1182381130/vi/anh/m%C5%A9-r%E1%BB%99ng-v%C3%A0nh-m%C3%A0u-kem-v%E1%BB%9Bi-d%C3%A2y-%C4%91eo-b%E1%BA%B1ng-v%E1%BA%A3i-%C4%91en-%C4%91%C6%B0%E1%BB%A3c-c%C3%A1ch-ly-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt.jpg?s=612x612&w=0&k=20&c=SlJ7ZATeBYB1MKnTImR6TdRhLo92g1Y3CwQZtzR7178=',0,299000),(26,'Moussa 81',0,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(27,'Mũ ông già Noel đỏ và trắng lễ hội',30,'Unisex','Đỏ trắng','https://media.istockphoto.com/id/1071753308/vi/anh/%C3%B4ng-gi%C3%A0-noel-gi%C3%BAp-thi%E1%BA%BFt-k%E1%BA%BF-m%C5%A9-%C4%91%E1%BB%8F-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-con-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt-cho-trang-tr%C3%AD-thi%E1%BA%BFt.jpg?s=612x612&w=0&k=20&c=ozum2ju40_RRRhkhpyT0oIi-NbwF6lkXQTmBSgHFi2g=',0,38000),(120,'Mũ diễu hành màu xanh lá cây với thắt lưng và khóa',30,'Unisex','Xanh lục','https://media.istockphoto.com/id/184957982/vi/anh/m%C5%A9-leprechaun-xanh-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-tr%E1%BA%AFng.jpg?s=612x612&w=0&k=20&c=2VqEQucvOXJMBWiK8LWJFDhzEWLpkcEy4wHEoXqBUkw=',0,117000),(121,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d',35,'Nam','Xanh đậm','https://media.istockphoto.com/id/488500609/vi/anh/m%C5%A9-c%E1%BA%A3nh-s%C3%A1t-t%E1%BB%AB-nhi%E1%BB%81u-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau-minh-h%E1%BB%8Da-3d.jpg?s=1024x1024&w=is&k=20&c=V__NJkgMYPyAoQZITHnjH-xGT_1ZYNsGMnFgNkvBe-w=',0,200000),(122,'Nón: Mũ rơm',50,'Unisex','Vàng nâu','https://media.istockphoto.com/id/184397074/vi/anh/m%C5%A9-r%C6%A1m.jpg?s=1024x1024&w=is&k=20&c=G0aV8hUH7KW0JZMfFhZko6vM2Z1vRPcgx97yOTU8eg0=',0,35000),(138,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.',35,'Nữ','Xanh nước biển','https://media.istockphoto.com/id/1182381130/vi/anh/m%C5%A9-r%E1%BB%99ng-v%C3%A0nh-m%C3%A0u-kem-v%E1%BB%9Bi-d%C3%A2y-%C4%91eo-b%E1%BA%B1ng-v%E1%BA%A3i-%C4%91en-%C4%91%C6%B0%E1%BB%A3c-c%C3%A1ch-ly-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt.jpg?s=612x612&w=0&k=20&c=SlJ7ZATeBYB1MKnTImR6TdRhLo92g1Y3CwQZtzR7178=',0,299000),(139,'Moussa 81',50,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(140,'Mũ cao bồi da màu nâu',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1182540276/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-americana-v%C3%A0-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eSzFoljqYfYuAP859_LlBaPDhALhxO3mgDcvz4jF92M=',0,500000),(141,'Moussa 81',50,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(143,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(144,'Mũ bóng chày màu đen trống 4 xem trên nền trắng',30,'Nam','Đen trắng','https://media.istockphoto.com/id/1060912434/vi/vec-to/m%C5%A9-tr%E1%BA%AFng-v%C3%A0-%C4%91en-t%E1%BB%AB-c%C3%A1c-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau.jpg?s=612x612&w=0&k=20&c=Jz_E-l29kqJ1I9Es1D-_5oJJRtT5U9NYClk5qnpzPVQ=',0,30000),(145,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d',35,'Nam','Xanh đậm','https://media.istockphoto.com/id/488500609/vi/anh/m%C5%A9-c%E1%BA%A3nh-s%C3%A1t-t%E1%BB%AB-nhi%E1%BB%81u-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau-minh-h%E1%BB%8Da-3d.jpg?s=1024x1024&w=is&k=20&c=V__NJkgMYPyAoQZITHnjH-xGT_1ZYNsGMnFgNkvBe-w=',0,200000),(146,'Mũ cao bồi da màu nâu',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1182540276/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-americana-v%C3%A0-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eSzFoljqYfYuAP859_LlBaPDhALhxO3mgDcvz4jF92M=',0,500000),(147,'Mũ diễu hành màu xanh lá cây với thắt lưng và khóa',31,'Unisex','Xanh lục','https://media.istockphoto.com/id/184957982/vi/anh/m%C5%A9-leprechaun-xanh-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-tr%E1%BA%AFng.jpg?s=612x612&w=0&k=20&c=2VqEQucvOXJMBWiK8LWJFDhzEWLpkcEy4wHEoXqBUkw=',0,117000),(148,'Mũ ông già Noel đỏ và trắng lễ hội',31,'Unisex','Đỏ trắng','https://media.istockphoto.com/id/1071753308/vi/anh/%C3%B4ng-gi%C3%A0-noel-gi%C3%BAp-thi%E1%BA%BFt-k%E1%BA%BF-m%C5%A9-%C4%91%E1%BB%8F-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-con-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt-cho-trang-tr%C3%AD-thi%E1%BA%BFt.jpg?s=612x612&w=0&k=20&c=ozum2ju40_RRRhkhpyT0oIi-NbwF6lkXQTmBSgHFi2g=',0,38000),(149,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.',35,'Nữ','Xanh nước biển','149.jpg',0,299000),(150,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.',35,'Nữ','Xanh nước biển','https://media.istockphoto.com/id/1182381130/vi/anh/m%C5%A9-r%E1%BB%99ng-v%C3%A0nh-m%C3%A0u-kem-v%E1%BB%9Bi-d%C3%A2y-%C4%91eo-b%E1%BA%B1ng-v%E1%BA%A3i-%C4%91en-%C4%91%C6%B0%E1%BB%A3c-c%C3%A1ch-ly-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt.jpg?s=612x612&w=0&k=20&c=SlJ7ZATeBYB1MKnTImR6TdRhLo92g1Y3CwQZtzR7178=',0,299000),(151,'Nón Snapback Nón Hiphop Trơn Có Khóa - Đen',36,'Nữ','Vàng tươi','https://media.istockphoto.com/id/1453988945/vi/anh/m%C5%A9-x%C3%B4-m%C3%A0u-v%C3%A0ng-c%C3%A1ch-ly-tr%C3%AAn-m%C3%A0u-tr%E1%BA%AFng.jpg?s=1024x1024&w=is&k=20&c=x3MA6las9ZkUwCC4f4uD5vbS4YCyGGtrdIxxsirTn3c=',0,120000),(152,'Nón: Mũ rơm',50,'Unisex','Vàng nâu','https://media.istockphoto.com/id/184397074/vi/anh/m%C5%A9-r%C6%A1m.jpg?s=1024x1024&w=is&k=20&c=G0aV8hUH7KW0JZMfFhZko6vM2Z1vRPcgx97yOTU8eg0=',0,35000),(153,'Washed Cotton Caps Men Cadet Cap Design Flat Top Hat',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1184522745/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-americana-v%C3%A0-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eQWSy0ok0umbVrToBbNZ7hbwTD7-75vgee2EaRDLkDk=',0,100000),(154,'Moussa 81',51,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(155,'Moussa 81',51,'Unisex','Đen','155.jpg',0,2700000),(156,'Moussa 81',51,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(157,'Moussa 81',50,'Unisex','Đen','157.jpg',0,2700000),(158,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(159,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(160,'Mũ bóng chày màu đen trống 4 xem trên nền trắng',31,'Nam','Đen trắng','https://media.istockphoto.com/id/1060912434/vi/vec-to/m%C5%A9-tr%E1%BA%AFng-v%C3%A0-%C4%91en-t%E1%BB%AB-c%C3%A1c-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau.jpg?s=612x612&w=0&k=20&c=Jz_E-l29kqJ1I9Es1D-_5oJJRtT5U9NYClk5qnpzPVQ=',0,30000),(161,'Mũ bóng chày màu đen trống 4 xem trên nền trắng',30,'Nam','Đen trắng','161.jpg',0,30000),(162,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d',36,'Nam','Xanh đậm','162.jpg',0,200000),(163,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d',36,'Nam','Xanh đậm','https://media.istockphoto.com/id/488500609/vi/anh/m%C5%A9-c%E1%BA%A3nh-s%C3%A1t-t%E1%BB%AB-nhi%E1%BB%81u-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau-minh-h%E1%BB%8Da-3d.jpg?s=1024x1024&w=is&k=20&c=V__NJkgMYPyAoQZITHnjH-xGT_1ZYNsGMnFgNkvBe-w=',0,200000),(165,'Mũ cao bồi da màu nâu',31,'Nam','Nâu sẫm','165.jpg',0,500000),(167,'Mũ diễu hành màu xanh lá cây với thắt lưng và khóa',2011,'Unisex','Xanh lục','https://storage.googleapis.com/hatshop-75393.appspot.com/6638d966639f8.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2030534503&Signature=Hnox93dhgEVb8%2FwTn3br0m9Q%2FDXf1UcSUquDZZ%2BjGJRxVK%2BumRJuPPlfvzsM%2BsaD0u3QqyEKK9yjIGMtZCYC4xooXZ5h1PLz7EuQjOTred%2B6VVNos4sFZSBV1kv%2BlDiGP1%2F%2FtjicUbKkeNhNLeKAAJZs068%2Fxukk8SAVNOK8aVi7iOrUvJog2I%2BzOLc%2Fp0Irt1CwNJ9i7RChZeEj8J%2Fl0xONHe%2BC%2BFYzgUTU%2FJtEljapvvJo87WnJ2iycDIj%2F5wBeMXzULWq303OGKxY9Q4%2Bkc2Ywe%2BYutsWkQgiatx0LwvVLGowPBZR9ZkcFQGk%2FTkylpa1pO45%2B1BJcqvQzDrIfQ%3D%3D&generation=1715001702527123',0,117000),(168,'Mũ ông già Noel đỏ và trắng lễ hội',1898,'Unisex','Đỏ trắng','168.jpg',0,38000),(174,'Nón da tai thỏ',20,'Unisex','Đen','169.jpg',0,100000);
/*!40000 ALTER TABLE `sanpham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `toado`
--

DROP TABLE IF EXISTS `toado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `toado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kinhDo` double NOT NULL DEFAULT 106.78736,
  `viDo` double NOT NULL DEFAULT 10.84897,
  `tenViTri` varchar(255) NOT NULL DEFAULT 'Hat Shop',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toado`
--

LOCK TABLES `toado` WRITE;
/*!40000 ALTER TABLE `toado` DISABLE KEYS */;
INSERT INTO `toado` VALUES (1,106.78736,10.84897,'Hat Shop'),(2,106.78736,10.84897,'Hat shop 1'),(3,106.77346933633089,10.852838157696748,'Hat shop'),(4,106.73675425350666,10.788906021119725,'Hat Shop'),(5,106.7249595746398,10.76825443229899,'Hat shop'),(6,106.72515235841274,10.76676270180724,'Hat shop'),(7,106.77510414272547,10.77883236484694,'Hat shop'),(8,106.78736,10.84897,'Hat shop 1');
/*!40000 ALTER TABLE `toado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `password` varchar(254) NOT NULL,
  `username` varchar(100) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (23,'nguyenthaitruong.entertainment@gmail.com','$2y$10$w7VeCglvw2vH2TIHLFG55ufdBmWB.BF43cnQfjCHIwcm7L9CwtkQq','Trưởng Chiller','0987654321'),(24,'nguyenthaitruong1223@gmail.com','$2y$10$TWgdtiyCQL694gIY0OQVa.3SXUlzYnBaftoxDDo.3f4SZbtJlyJ42','Nguyễn Thái Trưởng','0948915051'),(25,'nguyenthaitruong12233@gmail.com','$2y$10$RuJzs68D6FFYDZJIwlM42ekfdnnehd9TgjrsMuYbvhAv.0dB.C5qC','Nguyễn Thái Trưởng','0948915051'),(26,'phamngocbao2104@gmail.com','$2y$10$Gla1EMMo0zDaEv8/ijgTduoLj7vyD7aQ4SK0bTb1CRhSEDuCTvcTa','Bảo Phạm','0132659475'),(28,'n20dccn083@student.ptithcm.edu.vn','$2y$10$b66ZUa57k.meWbPP5IiXHuo2idgN31LkiYDhG5zgpC0d.nm4DDVh.','Nguyen Thai Truong','0948915051'),(29,'nguyenthaitruong.entertainment1@gmail.com','$2y$10$92fEaJmR6C7YtSB.WwopYuJpZYG6EaQCw0gz2Q8trjkZts3zRtH92','Nguyễn Trưởng','0948915051');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_orders`
--

DROP TABLE IF EXISTS `v_orders`;
/*!50001 DROP VIEW IF EXISTS `v_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_orders` AS SELECT 
 1 AS `maDonHang`,
 1 AS `userId`,
 1 AS `username`,
 1 AS `diaChi`,
 1 AS `soLuong`,
 1 AS `tongTien`,
 1 AS `soDienThoai`,
 1 AS `email`,
 1 AS `trangThai`,
 1 AS `ngayTao`,
 1 AS `hasToken`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'databannon'
--
/*!50003 DROP PROCEDURE IF EXISTS `SP_CANCEL_ORDER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CANCEL_ORDER`(IN maDonHang INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_maSanPham INT;
    DECLARE v_soLuong INT;
	
    -- Cursor for selecting products and quantities
	DECLARE cur CURSOR FOR 
        SELECT ct.maSanPham, ct.soLuong 
        FROM chitietdonhang ct
        WHERE ct.maDonHang = maDonHang;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    
    BEGIN
        -- Rollback the transaction in case of error
        ROLLBACK;
    END;

    START TRANSACTION;
	
    -- Update order status to 'Đã hủy'
    UPDATE donhang dh
    SET trangThai = 'Đã hủy'
    WHERE dh.maDonHang = maDonHang;
    
    -- Open cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_maSanPham, v_soLuong;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Update product quantities
        UPDATE sanpham
        SET soLuong = soLuong + v_soLuong
        WHERE maSanPham = v_maSanPham;
    END LOOP;

    -- Close cursor
    CLOSE cur;

    -- Commit transaction
	COMMIT;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_CREATE_ORDER_DETAILS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CREATE_ORDER_DETAILS`(
	in maDonHang int,
    in mangChiTiet json
)
begin
	declare i int default 0;
    declare n int;
	declare maSanPham int;
    declare soLuong int;
    declare exit handler for sqlexception
    begin
		-- Rollback the transaction in case of any error
		rollback;
	end;
    
    -- Start a new transaction
    set n = json_length(mangChiTiet);
    while i < n do
		set maSanPham = json_unquote(json_extract(mangChiTiet, concat('$[', i, '].maSanPham')));
        set soLuong = json_unquote(json_extract(mangChiTiet, concat('$[', i, '].soLuong')));
        
        -- Insert into chitietdonhang table
        insert into chitietdonhang(maDonHang, maSanPham, soLuong) 
        values (maDonHang, maSanPham, soLuong);
        
        set i = i + 1;
    end while;
    
    -- Commit the transaction if all operrrtions succeed
    commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GET_FEATURED_PRODUCTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_FEATURED_PRODUCTS`(in amount INT)
begin
	select sp.* 
    from sanpham sp
    left join chitietdonhang ct
    on sp.maSanPham = ct.maSanPham
    where sp.soLuong > 0
    group by sp.maSanPham
    order by sp.maSanPham desc
    limit amount;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GET_PRODUCTS_IN_A_ORDER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_PRODUCTS_IN_A_ORDER`(in maDonHang int)
begin
	select ct.maSanPham, tenSanPham, ct.giaSanPham, ct.soLuong, gioiTinh, mauSac, hinhAnh
    from chitietdonhang ct
    inner join sanpham sp 
    on ct.maSanPham = sp.maSanPham
    where ct.maDonHang = maDonHang;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GET_PRODUCTS_PAGE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_PRODUCTS_PAGE`(
	in page int,
    in amount int
)
begin
	declare pos int;
    set pos = (page - 1) * amount;
    select sp.*, coalesce(SUM(ct.soLuong), 0) as daBan
    from sanpham sp
    left join chitietdonhang ct ON sp.maSanPham = ct.maSanPham
    where sp.soLuong > 0
    group by sp.maSanPham
    order by sp.maSanPham desc
    limit pos, amount;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_orders`
--

/*!50001 DROP VIEW IF EXISTS `v_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_orders` AS select `dh`.`maDonHang` AS `maDonHang`,`dh`.`userId` AS `userId`,`u`.`username` AS `username`,`dh`.`diaChi` AS `diaChi`,`dh`.`soLuong` AS `soLuong`,`dh`.`tongTien` AS `tongTien`,`dh`.`soDienThoai` AS `soDienThoai`,`dh`.`email` AS `email`,`dh`.`trangThai` AS `trangThai`,`dh`.`ngayTao` AS `ngayTao`,case when `dh`.`token` <> '' then 1 else 0 end AS `hasToken` from (`donhang` `dh` join `user` `u`) where `dh`.`userId` = `u`.`id` order by `dh`.`maDonHang` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-16 16:49:05
