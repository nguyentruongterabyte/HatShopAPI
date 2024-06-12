-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: databannon
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.27-MariaDB

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
  CONSTRAINT `FK_maSanPham` FOREIGN KEY (`maSanPham`) REFERENCES `sanpham` (`maSanPham`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chitietdonhang`
--

LOCK TABLES `chitietdonhang` WRITE;
/*!40000 ALTER TABLE `chitietdonhang` DISABLE KEYS */;
INSERT INTO `chitietdonhang` VALUES (133,167,1,117000),(133,168,26,38000),(134,167,1,117000),(135,1,3,100000),(136,165,1,500000),(136,168,1,38000),(137,167,3,117000),(138,1,2,100000),(139,167,1,117000),(139,168,26,38000),(140,167,1,117000),(140,168,26,38000),(141,167,1,117000),(142,167,1,117000),(142,168,26,38000),(143,167,1,117000),(143,168,26,38000),(144,174,3,100000),(145,174,3,100000),(146,174,4,100000),(147,147,1,117000),(147,148,1,38000),(147,151,1,120000),(147,154,1,2700000),(147,155,1,2700000),(147,156,1,2700000),(147,160,1,30000),(147,162,1,200000),(147,163,1,200000),(147,165,1,500000),(148,1,1,100000),(148,2,1,120000),(148,3,1,150000),(148,24,1,30000),(148,25,1,299000),(148,27,1,38000),(148,122,1,35000),(148,140,1,500000),(148,141,1,2700000),(148,154,1,2700000),(149,146,1,500000),(149,149,2,299000),(149,152,1,35000),(149,153,1,100000),(149,156,2,2700000),(149,157,2,2700000),(149,158,1,150000),(149,159,1,150000),(150,143,3,150000),(150,160,1,30000),(150,161,2,30000),(150,162,2,200000),(150,163,1,200000),(150,165,1,500000),(150,167,1,117000),(150,168,1,38000),(151,167,2,117000),(151,168,1,38000),(152,167,2,117000),(174,167,3,117000),(175,168,1,38000);
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
  `dungVoiMoTa` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL ,
  `chatLuongSanPham` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL ,
  `nhanXet` text NOT NULL,
  `maDonHang` int(11) NOT NULL,
  `ngayDanhGia` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`maDanhGia`),
  UNIQUE KEY `maDonHang` (`maDonHang`),
  CONSTRAINT `danhgia_ibfk_1` FOREIGN KEY (`maDonHang`) REFERENCES `donhang` (`maDonHang`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhgia`
--

LOCK TABLES `danhgia` WRITE;
/*!40000 ALTER TABLE `danhgia` DISABLE KEYS */;
INSERT INTO `danhgia` VALUES (88,4,'','','',141,'2024-05-29 03:39:02');
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
INSERT INTO `danhmuc` VALUES (1,'Trang chủ','https://firebasestorage.googleapis.com/v0/b/hatshop-75393.appspot.com/o/categories%2Fhome.jpg?alt=media&token=f2d6dd86-a274-46c6-94f4-0e5cb8354b1d'),(2,'Danh sách sản phẩm','https://firebasestorage.googleapis.com/v0/b/hatshop-75393.appspot.com/o/categories%2Fhats-list.jpg?alt=media&token=5a0f82b1-1a9c-45aa-8084-90990c306d15'),(4,'Đơn mua','https://firebasestorage.googleapis.com/v0/b/hatshop-75393.appspot.com/o/categories%2Forder.png?alt=media&token=96e5f8b9-927e-4666-b29b-52f97b25db31'),(5,'Vị trí cửa hàng','https://firebasestorage.googleapis.com/v0/b/hatshop-75393.appspot.com/o/categories%2Fmap.jpg?alt=media&token=d8ecffa1-cf83-4cbc-9dda-717656c0e801'),(6,'Đăng xuất','https://firebasestorage.googleapis.com/v0/b/hatshop-75393.appspot.com/o/categories%2Flogout.jpg?alt=media&token=fe8afed9-cae8-41f7-ba95-83da2833361d');
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
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donhang`
--

LOCK TABLES `donhang` WRITE;
/*!40000 ALTER TABLE `donhang` DISABLE KEYS */;
INSERT INTO `donhang` VALUES (133,24,'Tây Nguyên ',1,'38000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-04-28 08:55:41'),(134,24,'Lã Xuân Oai',1,'117000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-03-28 08:55:41'),(135,24,'Geography ',3,'300000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-02-28 08:55:41'),(136,24,'Bà rịa Vũng tàu',2,'538000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','ACp_hbKERjpsBsUaFrbFHoaQ','2024-05-28 08:55:41'),(137,24,'Man thiện',3,'351000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','','2024-04-28 08:55:41'),(138,24,'Man Thiện ',2,'200000','0948915051','nguyenthaitruong1223@gmail.com','Chờ xác nhận','ACUgPKrdR6N89_TPxu2mEQfw','2024-04-28 08:55:41'),(139,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2023-04-28 08:55:41'),(140,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2024-04-28 08:55:41'),(141,24,'abc',1,'117000','0948915051','nguyenthaitruong1223@gmail.com','Đã giao','','2024-04-28 08:55:41'),(142,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2024-04-28 12:45:08'),(143,24,'101 Man Thiện',27,'1105000','0948915051','example@gmail.com','Chờ xác nhận','','2024-04-28 13:04:13'),(144,24,'Chư Kbô',3,'300000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','ACcBETBE9Z5GyaQvQR0V1-7Q','2024-04-28 13:26:50'),(145,24,'Chư Kbô',3,'300000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-04-28 13:29:04'),(146,24,'Chư Kbô',4,'400000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-04-28 13:29:29'),(147,24,'Ba Ria Vung Tau',10,'9305000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-05-02 10:32:03'),(148,23,'97 Man Thien Tang Nhon Phu A',10,'6672000','0987654321','nguyenthaitruong.entertainment@gmail.com','Chờ xác nhận','','2024-05-02 10:57:47'),(149,23,'97 Man Thien Tang Nhon Phu B',10,'12333000','0987654321','nguyenthaitruong.entertainment@gmail.com','Chờ xác nhận','','2024-05-02 10:59:42'),(150,23,'30 Tan Lap, Chu Kbo, Dak Lak',12,'1795000','0987654321','nguyenthaitruong.entertainment@gmail.com','Chờ xác nhận','','2024-05-02 11:45:41'),(151,23,'Ba Ria Vung Tau',3,'272000','0987654321','nguyenthaitruong.entertainment@gmail.com','Đã hủy','ACeSVAyH5WNjD45L_SNbXAuQ','2024-05-02 13:08:18'),(152,23,'123 Ha Noi',2,'234000','0987654321','nguyenthaitruong.entertainment@gmail.com','Đã giao','abc','2024-05-05 00:29:31'),(174,24,'Thu Duc',3,'351000','0948915051','nguyenthaitruong1223@gmail.com','Đã giao','','2024-05-25 12:22:56'),(175,24,'Xóm Bến',1,'38000','0948915051','nguyenthaitruong1223@gmail.com','Đã hủy','','2024-05-29 15:41:22');
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
  KEY `giohang_ibfk_2` (`userId`),
  CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`maSanPham`) REFERENCES `sanpham` (`maSanPham`),
  CONSTRAINT `giohang_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `giohang`
--

LOCK TABLES `giohang` WRITE;
/*!40000 ALTER TABLE `giohang` DISABLE KEYS */;
INSERT INTO `giohang` VALUES (165,24,2),(167,23,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hinhanhdanhgia`
--

LOCK TABLES `hinhanhdanhgia` WRITE;
/*!40000 ALTER TABLE `hinhanhdanhgia` DISABLE KEYS */;
/*!40000 ALTER TABLE `hinhanhdanhgia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roleName` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'ADMIN'),(2,'CUSTOMER');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
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
  `moTa` text NOT NULL,
  `soLuong` int(11) DEFAULT NULL,
  `gioiTinh` varchar(20) DEFAULT NULL,
  `mauSac` varchar(30) DEFAULT NULL,
  `hinhAnh` text DEFAULT NULL,
  `trangThai` tinyint(1) DEFAULT NULL,
  `giaSanPham` int(11) DEFAULT 0,
  PRIMARY KEY (`maSanPham`)
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sanpham`
--

LOCK TABLES `sanpham` WRITE;
/*!40000 ALTER TABLE `sanpham` DISABLE KEYS */;
INSERT INTO `sanpham` VALUES (1,'Washed Cotton Caps Men Cadet Cap Design Flat Top Hat','Sử dụng chất liệu cotton mềm mại và thoáng khí, giúp bạn luôn cảm thấy thoải mái ngay cả trong những ngày nắng nóng.Với kiểu dáng Flat Top hiện đại và trẻ trung, chiếc mũ này mang lại sự cá nhân hóa và phong cách cho bất kỳ bộ trang phục nào.Cho phép bạn lựa chọn từ một loạt các màu sắc phong phú, dễ dàng phù hợp với phong cách cá nhân của bạn.Với khóa điều chỉnh phía sau, bạn có thể dễ dàng điều chỉnh kích thước của mũ sao cho vừa vặn và thoải mái nhất.',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1184522745/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-americana-v%C3%A0-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eQWSy0ok0umbVrToBbNZ7hbwTD7-75vgee2EaRDLkDk=',0,100000),(2,'Nón Snapback Nón Hiphop Trơn Có Khóa - Đen','Nón Snapback Nón Hiphop Trơn Có Khóa - Đen là một mẫu nón thời trang phổ biến trong cộng đồng yêu thích phong cách hiphop và streetwear. Sản phẩm này được thiết kế với kiểu dáng snapback, có khóa điều chỉnh phía sau giúp tạo sự vừa vặn và thoải mái cho người đội.Nón được làm từ chất liệu vải mềm mại và nhẹ, mang lại cảm giác thoải mái khi đội suốt cả ngày. Màu sắc đen cơ bản nhưng vẫn mang tính thời trang và dễ dàng kết hợp với nhiều trang phục khác nhau.Với phong cách trơn trụi và đơn giản, nón này phản ánh sự cá nhân và phong cách tự tin của người đội, phù hợp cho các hoạt động ngoài trời, các buổi hòa nhạc, hoặc chỉ đơn giản là để thể hiện phong cách riêng của mình.\r\n\r\n\r\n\r\n\r\n\r\n',35,'Nữ','Vàng tươi','https://media.istockphoto.com/id/1453988945/vi/anh/m%C5%A9-x%C3%B4-m%C3%A0u-v%C3%A0ng-c%C3%A1ch-ly-tr%C3%AAn-m%C3%A0u-tr%E1%BA%AFng.jpg?s=1024x1024&w=is&k=20&c=x3MA6las9ZkUwCC4f4uD5vbS4YCyGGtrdIxxsirTn3c=',0,120000),(3,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242','Mũ adidas Aeroready Baseball Cap \"Black\" HD7242 là một lựa chọn hoàn hảo cho những người yêu thích phong cách thể thao và đặc biệt là bóng chày. Với thiết kế đơn giản nhưng hiện đại, sản phẩm này chắc chắn sẽ làm hài lòng các fan của thương hiệu adidas.\r\n\r\nMũ được làm từ chất liệu chất lượng cao, sử dụng công nghệ Aeroready giúp thoát ẩm và thoáng khí, giúp đầu bạn luôn khô ráo và thoải mái trong mọi hoạt động. Màu đen cơ bản nhưng vẫn mang lại sự sang trọng và dễ dàng kết hợp với nhiều trang phục khác nhau.Thiết kế baseball cap truyền thống với viền cong bên ngoài tạo điểm nhấn thú vị và bảo vệ mắt bạn khỏi ánh nắng mặt trời. Logo adidas được đính ở mặt trước mũ, tạo điểm nhấn thương hiệu và thể hiện sự đẳng cấp của người đội.Cho dù bạn đang chơi bóng chày hoặc chỉ đơn giản là đi dạo phố, mũ adidas Aeroready Baseball Cap sẽ là phụ kiện hoàn hảo để tôn lên phong cách thể thao và năng động của bạn.',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(24,'Mũ bóng chày màu đen trống 4 xem trên nền trắng','Mũ bóng chày màu đen trống 4 là một lựa chọn hoàn hảo cho những người yêu thích thể thao và đặc biệt là bóng chày. Với thiết kế đơn giản nhưng hiện đại, sản phẩm này chắc chắn sẽ làm hài lòng các fan của môn thể thao này.\r\n\r\nMũ được làm từ chất liệu vải bền đẹp, đảm bảo sự thoải mái và bền bỉ khi sử dụng. Màu đen truyền thống tạo nên sự đậm chất thể thao và dễ dàng kết hợp với nhiều trang phục khác nhau.Thiết kế trống 4 trên nền mũ màu đen tạo điểm nhấn độc đáo và phong cách, giúp bạn nổi bật trong các hoạt động thể thao và ngoài trời. Đồng thời, mũ bóng chày còn giúp bảo vệ đầu bạn khỏi ánh nắng mặt trời và gió lạnh.Với sự thoải mái và tính ứng dụng cao, mũ bóng chày màu đen trống 4 là phụ kiện không thể thiếu cho mọi người yêu thích thể thao và phong cách năng động.',30,'Nam','Đen trắng','https://media.istockphoto.com/id/1060912434/vi/vec-to/m%C5%A9-tr%E1%BA%AFng-v%C3%A0-%C4%91en-t%E1%BB%AB-c%C3%A1c-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau.jpg?s=612x612&w=0&k=20&c=Jz_E-l29kqJ1I9Es1D-_5oJJRtT5U9NYClk5qnpzPVQ=',0,30000),(25,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.','Mũ rộng vành màu kem với dây đeo bằng vải đen là một phụ kiện thời trang độc đáo và phong cách, phù hợp cho cả nam và nữ. Với thiết kế đơn giản nhưng không kém phần hiện đại, sản phẩm này chắc chắn sẽ làm bạn nổi bật trong bất kỳ hoàn cảnh nào.\r\n\r\nMàu kem truyền thống tạo cảm giác nhẹ nhàng và dễ chịu, phù hợp với nhiều phong cách trang phục khác nhau. Dây đeo bằng vải đen được cách điệu và tạo điểm nhấn tinh tế cho mũ, đồng thời giúp điều chỉnh kích thước cho vừa vặn.Thiết kế rộng vành giúp bảo vệ mắt bạn khỏi ánh nắng mặt trời chói chang và tạo nên phong cách thời trang đường phố đầy cá tính. Sự kết hợp hài hòa giữa màu kem và dây đeo đen tạo nên điểm nhấn độc đáo và sang trọng cho sản phẩm.Với sự thoải mái và tính ứng dụng cao, mũ rộng vành màu kem này là một lựa chọn xuất sắc để thể hiện phong cách cá nhân của bạn mỗi khi bạn ra ngoài.',35,'Nữ','Xanh nước biển','https://media.istockphoto.com/id/1182381130/vi/anh/m%C5%A9-r%E1%BB%99ng-v%C3%A0nh-m%C3%A0u-kem-v%E1%BB%9Bi-d%C3%A2y-%C4%91eo-b%E1%BA%B1ng-v%E1%BA%A3i-%C4%91en-%C4%91%C6%B0%E1%BB%A3c-c%C3%A1ch-ly-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt.jpg?s=612x612&w=0&k=20&c=SlJ7ZATeBYB1MKnTImR6TdRhLo92g1Y3CwQZtzR7178=',0,299000),(26,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',0,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(27,'Mũ ông già Noel đỏ và trắng lễ hội','Mũ Ông già Noel có kiểu dáng truyền thống với phần thân mũ màu đỏ rực rỡ, được làm từ vải mềm mại và dày dặn, kèm theo một dải vải màu trắng ở phía dưới tạo thành phần đuôi của mũ.Mũ thường được trang trí bằng một chiếc nơ hoặc một hình ảnh nhỏ của Ông già Noel, thêm vào vẻ đáng yêu và phù hợp với chủ đề Giáng sinh.\r\nMũ Ông già Noel thường có kích thước phổ thông, phù hợp với cả trẻ em và người lớn. Chất liệu mềm mại và co dãn linh hoạt giúp mũ ôm sát và thoải mái cho mọi người.Màu đỏ và trắng là hai màu chủ đạo của mũ Ông già Noel, tạo nên vẻ rực rỡ và đầy sắc màu cho bất kỳ buổi lễ hội nào.Mũ Ông già Noel không chỉ là một phụ kiện trang trí, mà còn là biểu tượng của sự vui vẻ và hạnh phúc trong mùa lễ hội. Nó thích hợp để mọi người đội trong các bữa tiệc, dạo phố, tham gia các hoạt động vui chơi và chụp hình kỷ niệm trong dịp Giáng sinh.',30,'Unisex','Đỏ trắng','https://media.istockphoto.com/id/1071753308/vi/anh/%C3%B4ng-gi%C3%A0-noel-gi%C3%BAp-thi%E1%BA%BFt-k%E1%BA%BF-m%C5%A9-%C4%91%E1%BB%8F-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-con-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt-cho-trang-tr%C3%AD-thi%E1%BA%BFt.jpg?s=612x612&w=0&k=20&c=ozum2ju40_RRRhkhpyT0oIi-NbwF6lkXQTmBSgHFi2g=',0,38000),(120,'Mũ diễu hành màu xanh lá cây với thắt lưng và khóa','Mũ diễu hành có kiểu dáng truyền thống, thường là một mũ tròn với đỉa rộng và vòm cong, tạo ra vẻ lãng mạn và tinh tế. Thắt lưng và khóa được thêm vào phần thân mũ, tạo điểm nhấn và tăng tính thẩm mỹ cho sản phẩm.Mũ được thiết kế với màu xanh lá cây, một màu sắc tươi sáng và rực rỡ, tạo nên sự nổi bật và sinh động cho người đội.Thường được làm từ vải như len, nỉ hoặc cotton, chất liệu mềm mại và thoáng khí, giúp đầu bạn cảm thấy thoải mái khi đội suốt cả ngày.Thắt lưng và khóa được tích hợp vào mũ, tạo ra một phụ kiện thời trang độc đáo và cá nhân. Khóa có thể là các loại khóa đơn giản hoặc được trang trí hoa văn phức tạp, tùy thuộc vào phong cách thiết kế.Mũ diễu hành màu xanh lá cây với thắt lưng và khóa thích hợp cho các sự kiện và hoạt động ngoài trời như diễu hành, lễ hội, hoặc các buổi tiệc. Đây cũng có thể là một phụ kiện thú vị để thể hiện phong cách cá nhân trong cuộc sống hàng ngày.',30,'Unisex','Xanh lục','https://media.istockphoto.com/id/184957982/vi/anh/m%C5%A9-leprechaun-xanh-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-tr%E1%BA%AFng.jpg?s=612x612&w=0&k=20&c=2VqEQucvOXJMBWiK8LWJFDhzEWLpkcEy4wHEoXqBUkw=',0,117000),(121,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d','Mũ cảnh sát thường có kiểu dáng đặc trưng, bao gồm phần thân mũ tròn với đỉa rộng và vòm cong. Phía trước của mũ có thể có một mũi gai nhọn hoặc phần nổi lên để tạo ra sự nổi bật và chắc chắn.Màu sắc của mũ cảnh sát thường là màu đen hoặc màu xanh navy, tùy thuộc vào quốc gia và tổ chức cụ thể. Màu sắc này thường được chọn để tạo ra sự chuyên nghiệp và quyết đoán.Mũ thường được làm từ các vật liệu bền như nhựa ABS hoặc polycarbonate để đảm bảo sự bền bỉ và bảo vệ tốt cho người đội. Các vật liệu này thường được sơn bóng hoặc sơn mờ để tạo ra sự sang trọng và chuyên nghiệp.Mũ cảnh sát thường đi kèm với các phụ kiện như dây đeo hoặc băng đô để giữ mũ cố định trên đầu trong khi hoạt động. Một số mũ có thể có khóa hoặc nút bấm để điều chỉnh kích thước cho vừa vặn. Một số mũ cảnh sát có thể có logo hoặc biểu tượng của lực lượng cảnh sát được in hoặc dập nổi trên phía trước hoặc phía bên của mũ, tạo ra sự nhận dạng và đồng nhất cho các nhân viên.Minh họa 3D của mũ cảnh sát có thể minh họa chi tiết về cấu trúc và các yếu tố thiết kế từ nhiều góc độ khác nhau, từ phía trước, phía sau đến các chi tiết nhỏ như đường cong, gờ, hoặc logo.\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n',35,'Nam','Xanh đậm','https://media.istockphoto.com/id/488500609/vi/anh/m%C5%A9-c%E1%BA%A3nh-s%C3%A1t-t%E1%BB%AB-nhi%E1%BB%81u-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau-minh-h%E1%BB%8Da-3d.jpg?s=1024x1024&w=is&k=20&c=V__NJkgMYPyAoQZITHnjH-xGT_1ZYNsGMnFgNkvBe-w=',0,200000),(122,'Nón: Mũ rơm','Mũ rơm là một biểu tượng không thể thiếu của cuộc sống nông thôn và mùa hè. Được làm từ các sợi rơm tự nhiên, mũ rơm thường có kiểu dáng tròn, với đỉa rộng và phần thân mũ nhẹ nhàng và thoáng khí. Mũ rơm không chỉ là một món đồ phục vụ cho mục đích bảo vệ đầu khỏi ánh nắng mặt trời mà còn là biểu tượng của phong cách nông thôn và sự thư giãn. Thường được thấy trong các hoạt động ngoại ô như đi chơi cắm trại, đi bộ đường dài, hoặc tham gia các sự kiện ngoài trời, mũ rơm đã trở thành một phần không thể thiếu của thời trang mùa hè và một biểu tượng của cuộc sống gần gũi với thiên nhiên. Cho dù bạn đang dạo phố, tận hưởng bãi biển hay tham gia các hoạt động ngoại ô, một chiếc mũ rơm sẽ làm cho bất kỳ bộ trang phục nào trở nên thêm phần phóng khoáng và gần gũi với tự nhiên.',50,'Unisex','Vàng nâu','https://media.istockphoto.com/id/184397074/vi/anh/m%C5%A9-r%C6%A1m.jpg?s=1024x1024&w=is&k=20&c=G0aV8hUH7KW0JZMfFhZko6vM2Z1vRPcgx97yOTU8eg0=',0,35000),(138,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.','Mũ rộng vành màu kem với dây đeo bằng vải đen là một phụ kiện thời trang hoàn hảo cho mùa hè và các hoạt động ngoài trời. Với kiểu dáng rộng vành, mũ này cung cấp bảo vệ tốt cho khuôn mặt và mắt khỏi ánh nắng mặt trời chói chang.Màu kem nhẹ nhàng và dịu dàng, tạo cảm giác thoải mái và mát mẻ trong những ngày nắng nóng. Dây đeo bằng vải đen được cách ly trên nền trắng tạo điểm nhấn độc đáo và phong cách. Dây đeo có thể điều chỉnh được, giúp bạn dễ dàng điều chỉnh kích thước phù hợp với đầu của mình. Mũ được làm từ chất liệu nhẹ và thoáng khí, giúp cho bạn cảm thấy thoải mái và dễ chịu trong suốt cả ngày dài hoạt động. Đường cắt cẩn thận và chất liệu chất lượng tạo nên sự hoàn thiện và độ bền cho sản phẩm.',35,'Nữ','Xanh nước biển','https://media.istockphoto.com/id/1182381130/vi/anh/m%C5%A9-r%E1%BB%99ng-v%C3%A0nh-m%C3%A0u-kem-v%E1%BB%9Bi-d%C3%A2y-%C4%91eo-b%E1%BA%B1ng-v%E1%BA%A3i-%C4%91en-%C4%91%C6%B0%E1%BB%A3c-c%C3%A1ch-ly-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt.jpg?s=612x612&w=0&k=20&c=SlJ7ZATeBYB1MKnTImR6TdRhLo92g1Y3CwQZtzR7178=',0,299000),(139,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',50,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(140,'Mũ cao bồi da màu nâu','Mũ được làm từ da hoặc các loại vật liệu tổng hợp chất lượng cao, tạo ra sự sang trọng và bền bỉ. Chất liệu da thường được ưa chuộng vì tính linh hoạt và độ bền của nó.\r\n\r\nKiểu dáng: Mũ có đỉa phẳng và vòm cong, tạo ra vẻ lãng mạn và độc đáo. Phần đỉa có thể được uốn cong hoặc phẳng tùy thuộc vào phong cách cá nhân và sở thích.\r\nMàu nâu là lựa chọn phổ biến cho mũ cao bồi, tạo ra vẻ ấm áp và truyền thống. Màu sắc nâu cũng có thể có các biến thể từ nâu đậm đến nâu nhạt, tạo ra sự đa dạng và linh hoạt trong lựa chọn.Mũ cao bồi thường được trang trí với các phụ kiện như dây da, khoá kim loại hoặc nơ trang trí. Những chi tiết này tạo ra điểm nhấn và thêm vào vẻ đẹp của mũ.Mũ cao bồi thường được đội trong các sự kiện western như rodeo, lễ hội hoặc các hoạt động ngoài trời khác. Nó cũng có thể được sử dụng như một phụ kiện thời trang để tạo điểm nhấn cho bộ trang phục hàng ngày.',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1182540276/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-americana-v%C3%A0-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eSzFoljqYfYuAP859_LlBaPDhALhxO3mgDcvz4jF92M=',0,500000),(141,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',50,'Unisex','Đen','https://storage.googleapis.com/hatshop-75393.appspot.com/6645e237acb52.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388728&Signature=XlDryFHyqNicEY4sxBd7Hbfc9guqlv4SXgY6JXQjg1TK2NH%2BpIPbsZnTLcF%2FBA1wDevcRMKZwXmrz75X%2B3b%2F5fDubZDvaosPGxHc%2B4w4vHGPYkzj2hko2ATO5sl8O%2FDLzQv47k4udl6koCv5smjl4LVgSLc%2FBev2ncfrcBdEyGpQMBsgtPy7OQgqB7U%2FDPVnXnGeft2WXkS7D1iopgj1KLtOwVvHmfKwo98PG%2FqAyuA%2FhDvzEK16JKSn4sXgSJLFRscRd3rk6alHQjc7FbZYiPLePb5pnmNDX85DmKhMXEBUqHinPboWb8nOLzVRuo%2BUXVe5cVqro59pqpbS1IYO1Q%3D%3D&generation=1715855928854444',0,2700000),(143,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242','Mũ baseball có kiểu dáng truyền thống với phần đỉa cong và vòm rộng, tạo ra sự bảo vệ hiệu quả khỏi ánh nắng mặt trời.\r\nSản phẩm được làm từ vật liệu chất lượng cao với công nghệ Aeroready giúp thoát ẩm và thoáng khí, giúp đầu bạn luôn khô ráo và thoải mái trong mọi hoạt động.Màu đen cơ bản làm cho mũ dễ dàng kết hợp với nhiều loại trang phục khác nhau và phù hợp với mọi phong cách thời trang.Logo của thương hiệu adidas được đặt ở mặt trước của mũ, tạo nên điểm nhấn thương hiệu và thể hiện sự chất lượng và đẳng cấp.Mũ được thiết kế với khóa điều chỉnh phía sau, giúp bạn có thể điều chỉnh kích thước mũ sao cho vừa vặn và thoải mái.Sản phẩm này phù hợp cho mọi hoạt động ngoài trời như chơi thể thao, đi dạo, hoặc tham gia các sự kiện ngoài trời khác',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(144,'Mũ bóng chày màu đen trống 4 xem trên nền trắng','Mũ bóng chày có kiểu dáng truyền thống với phần thân mũ màu đen và đỉa trống 4, tạo ra vẻ nổi bật và phong cách.Màu đen là một lựa chọn phổ biến và đa dụng, tạo nên vẻ sang trọng và mạnh mẽ cho mũ. Trên nền trắng, màu sắc của mũ đen nổi bật và thu hút sự chú ý.Mũ có các đường cắt sắc nét và chính xác, tạo ra sự hoàn thiện và chất lượng cao cho sản phẩm.Có thể có logo của thương hiệu bóng chày hoặc các hình ảnh liên quan được in hoặc thêu trên phần thân mũ, tạo điểm nhấn thương hiệu và phong cách.Mũ bóng chày màu đen trống 4 thường được đội trong các trận đấu, tập luyện hoặc các hoạt động ngoài trời khác. Đồng thời, nó cũng là một phụ kiện thời trang thể thao phổ biến và phù hợp với nhiều phong cách trang phục khác nhau.',30,'Nam','Đen trắng','https://media.istockphoto.com/id/1060912434/vi/vec-to/m%C5%A9-tr%E1%BA%AFng-v%C3%A0-%C4%91en-t%E1%BB%AB-c%C3%A1c-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau.jpg?s=612x612&w=0&k=20&c=Jz_E-l29kqJ1I9Es1D-_5oJJRtT5U9NYClk5qnpzPVQ=',0,30000),(145,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d','Mũ cảnh sát được hiển thị trong một môi trường 3D, cho phép người xem quan sát từ nhiều góc độ khác nhau. Dưới ánh sáng chiếu sáng chính xác, mũ được hiển thị với mọi chi tiết, từ phần đỉa cong đến phần thân mũ và dây đeo.Từ góc nhìn phía trước, bạn có thể thấy rõ hình dáng tổng thể của mũ, với phần đỉa cong nhẹ và logo hoặc biểu tượng của lực lượng cảnh sát được in hoặc dập nổi trên mặt trước của mũ. Đường viền sắc nét và chi tiết tinh tế tạo nên sự hoàn thiện cho sản phẩm.Khi quan sát từ phía sau, bạn có thể thấy cách mà dây đeo được thiết kế và gắn kết với mũ, cũng như các chi tiết như các lỗ thông hơi để giữ cho đầu người đội mũ luôn thoáng khí.Từ các góc độ khác nhau, như từ trên xuống hoặc từ dưới lên, bạn có thể thấy rõ hình dáng và cấu trúc của mũ cảnh sát, cho phép bạn hiểu được cách mà nó có thể bảo vệ và hỗ trợ người đội mũ trong các nhiệm vụ và hoạt động hàng ngày.',35,'Nam','Xanh đậm','https://media.istockphoto.com/id/488500609/vi/anh/m%C5%A9-c%E1%BA%A3nh-s%C3%A1t-t%E1%BB%AB-nhi%E1%BB%81u-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau-minh-h%E1%BB%8Da-3d.jpg?s=1024x1024&w=is&k=20&c=V__NJkgMYPyAoQZITHnjH-xGT_1ZYNsGMnFgNkvBe-w=',0,200000),(146,'Mũ cao bồi da màu nâu','Mũ được làm từ da hoặc các loại vật liệu tổng hợp chất lượng cao, tạo ra vẻ lịch lãm và đẳng cấp. Chất liệu da tự nhiên thường được ưa chuộng vì tính linh hoạt và độ bền của nó.Mũ có đỉa cong và vòm rộng, tạo ra vẻ lãng mạn và cổ điển. Phần đỉa có thể được uốn cong hoặc phẳng tùy thuộc vào phong cách cá nhân và sở thích.Màu nâu là lựa chọn phổ biến cho mũ cao bồi, tạo ra vẻ ấm áp và truyền thống. Các biến thể màu nâu từ nâu đậm đến nâu nhạt tạo ra sự đa dạng và linh hoạt trong lựa chọn.Mũ cao bồi thường được trang trí với dây da, khoá kim loại hoặc nơ trang trí. Những chi tiết này tạo ra điểm nhấn và thêm vào vẻ đẹp của mũ.Mũ cao bồi da màu nâu thường được đội trong các sự kiện western như rodeo, lễ hội hoặc các hoạt động ngoài trời khác. Nó cũng có thể được sử dụng như một phụ kiện thời trang để tạo điểm nhấn cho bộ trang phục hàng ngày.',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1182540276/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-americana-v%C3%A0-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eSzFoljqYfYuAP859_LlBaPDhALhxO3mgDcvz4jF92M=',0,500000),(147,'Mũ diễu hành màu xanh lá cây với thắt lưng và khóa','Mũ diễu hành thường có kiểu dáng tròn, với đỉa cong và vòm rộng, tạo cảm giác thoải mái và phóng khoáng. Phần thân mũ được thiết kế màu xanh lá cây, tạo ra sự tươi mới và năng động.Sự kết hợp giữa thắt lưng và khóa là điểm đặc biệt của sản phẩm này. Thắt lưng có thể được làm từ vải hoặc da, mang lại vẻ đẹp tự nhiên và tinh tế. Khóa được sử dụng như một chi tiết trang trí, tạo điểm nhấn và thêm phần phong cách cho mũ.Màu xanh lá cây là lựa chọn táo bạo và nổi bật, phản ánh sự trẻ trung và năng động. Màu sắc này thường được ưa chuộng trong mùa xuân và mùa hè, tạo cảm giác sảng khoái và tươi mới.Mũ có thể được làm từ vải như cotton, polyester hoặc vải canvas, mang lại sự thoải mái và thoáng khí cho người đội. Thắt lưng có thể là da hoặc vải, tùy thuộc vào phong cách và ý thích cá nhân.Mũ diễu hành màu xanh lá cây với thắt lưng và khóa thích hợp cho các sự kiện ngoài trời như các buổi hòa nhạc, lễ hội hoặc dã ngoại. Đồng thời, nó cũng có thể được sử dụng như một phụ kiện thời trang trong cuộc sống hàng ngày.',31,'Unisex','Xanh lục','https://media.istockphoto.com/id/184957982/vi/anh/m%C5%A9-leprechaun-xanh-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-tr%E1%BA%AFng.jpg?s=612x612&w=0&k=20&c=2VqEQucvOXJMBWiK8LWJFDhzEWLpkcEy4wHEoXqBUkw=',0,117000),(148,'Mũ ông già Noel đỏ và trắng lễ hội','Mũ Ông già Noel có kiểu dáng truyền thống với phần thân mũ màu đỏ rực rỡ, được làm từ vải mềm mại và dày dặn, kèm theo một dải vải màu trắng ở phía dưới tạo thành phần đuôi của mũ.Mũ thường được trang trí bằng một chiếc nơ hoặc một hình ảnh nhỏ của Ông già Noel, thêm vào vẻ đáng yêu và phù hợp với chủ đề Giáng sinh.\r\nMũ Ông già Noel thường có kích thước phổ thông, phù hợp với cả trẻ em và người lớn. Chất liệu mềm mại và co dãn linh hoạt giúp mũ ôm sát và thoải mái cho mọi người.Màu đỏ và trắng là hai màu chủ đạo của mũ Ông già Noel, tạo nên vẻ rực rỡ và đầy sắc màu cho bất kỳ buổi lễ hội nào.Mũ Ông già Noel không chỉ là một phụ kiện trang trí, mà còn là biểu tượng của sự vui vẻ và hạnh phúc trong mùa lễ hội. Nó thích hợp để mọi người đội trong các bữa tiệc, dạo phố, tham gia các hoạt động vui chơi và chụp hình kỷ niệm trong dịp Giáng sinh.',31,'Unisex','Đỏ trắng','https://media.istockphoto.com/id/1071753308/vi/anh/%C3%B4ng-gi%C3%A0-noel-gi%C3%BAp-thi%E1%BA%BFt-k%E1%BA%BF-m%C5%A9-%C4%91%E1%BB%8F-b%E1%BB%8B-c%C3%B4-l%E1%BA%ADp-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-con-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt-cho-trang-tr%C3%AD-thi%E1%BA%BFt.jpg?s=612x612&w=0&k=20&c=ozum2ju40_RRRhkhpyT0oIi-NbwF6lkXQTmBSgHFi2g=',0,38000),(149,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.',' Mũ có kiểu dáng rộng vành, tạo ra sự bảo vệ hiệu quả khỏi ánh nắng mặt trời và tia UV. Phần đỉa mũ được thiết kế rộng, tạo cảm giác thoải mái và phong cách.Màu kem là một lựa chọn tinh tế và dễ phối hợp, tạo ra vẻ sang trọng và thanh lịch. Trên nền trắng, màu kem tạo nên sự tương phản và thu hút sự chú ý.\r\nDây đeo được làm từ vải đen, tạo ra điểm nhấn và phong cách cho mũ. Dây đeo này có thể được điều chỉnh để phù hợp với kích thước đầu của bạn và giữ cho mũ cố định và thoải mái.Sự kết hợp giữa màu sắc kem và vải đen được cách ly trên nền trắng tạo ra sự tương phản và nổi bật. Đường cắt cẩn thận và chất liệu chất lượng cao tạo nên sự hoàn thiện và độ bền cho sản phẩm.Mũ được làm từ chất liệu nhẹ và thoáng khí như cotton, polyester hoặc vải canvas, giúp đầu bạn luôn thoải mái và thông thoáng trong mọi hoạt động.',35,'Nữ','Xanh nước biển','https://storage.googleapis.com/hatshop-75393.appspot.com/6645e20e8ea1d.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388687&Signature=fPt0pZ9b0tIoaLr6F%2Ba0jswNWb4wB%2F5YYz%2B1j2TF2rVN1EfLNfP0Yuq4%2Fx%2BDi7NOGd4O6ACFlYm9j52o58W5ioIf1M9bL%2BgUSC5cs2U8u8%2BI7cTsOh80f8ML4NlZw3WC%2FolvRACSq%2FPVAN%2FS7ykQtMTNTlJ0wC2WRxBhXDytK8GgNomE084o%2BYEHOTrRQtYxpPMl17F5d6dWWNMBUlWVeUXzp6KkoWKZ2rQk1HJtx289%2B3gfc5TD9dVJ97iTRMeWYMwSvBRRvyn%2FkCHFOOCERGGGEvHjNzrFvsLs2MoDHWJH7bzkPif2jc29kACQPJf4iE7bMzoZKlnzTScmeMOI7g%3D%3D&generation=1715855887549338',0,299000),(150,'Mũ rộng vành màu kem với dây đeo bằng vải đen được cách ly trên nền trắng với đường cắt.',' Mũ có kiểu dáng rộng vành, tạo sự bảo vệ tốt cho khuôn mặt và mắt khỏi ánh nắng mặt trời chói chang. Phần đỉa mũ được thiết kế rộng, tạo cảm giác thoải mái và phóng khoáng.Màu kem tinh tế và dễ phối hợp, tạo ra vẻ sang trọng và thanh lịch. Trên nền trắng, màu kem tạo ra sự tương phản nổi bật và thu hút sự chú ý.Dây đeo được làm từ vải đen, tạo điểm nhấn và phong cách cho mũ. Dây đeo này có thể điều chỉnh được, giúp bạn dễ dàng điều chỉnh kích thước cho vừa vặn và thoải mái.Sự kết hợp giữa màu sắc kem và vải đen được cách ly trên nền trắng tạo ra sự tương phản và nổi bật. Đường cắt cẩn thận và chất liệu chất lượng cao tạo nên sự hoàn thiện và độ bền cho sản phẩm.Mũ được làm từ chất liệu nhẹ và thoáng khí như cotton, polyester hoặc vải canvas, giúp đầu bạn luôn thoải mái và thông thoáng trong mọi hoạt động.',35,'Nữ','Xanh nước biển','https://media.istockphoto.com/id/1182381130/vi/anh/m%C5%A9-r%E1%BB%99ng-v%C3%A0nh-m%C3%A0u-kem-v%E1%BB%9Bi-d%C3%A2y-%C4%91eo-b%E1%BA%B1ng-v%E1%BA%A3i-%C4%91en-%C4%91%C6%B0%E1%BB%A3c-c%C3%A1ch-ly-tr%C3%AAn-n%E1%BB%81n-tr%E1%BA%AFng-v%E1%BB%9Bi-%C4%91%C6%B0%E1%BB%9Dng-c%E1%BA%AFt.jpg?s=612x612&w=0&k=20&c=SlJ7ZATeBYB1MKnTImR6TdRhLo92g1Y3CwQZtzR7178=',0,299000),(151,'Nón Snapback Nón Hiphop Trơn Có Khóa - Đen','Nón Snapback là một loại nón có kiểu dáng thời trang và năng động, phổ biến trong giới trẻ và đặc biệt là trong cộng đồng hip hop. Kiểu dáng Snapback thường có đỉa phẳng và vòm cong, tạo nên sự hiện đại và cá tính.Màu Đen là một lựa chọn phổ biến và dễ phối hợp, tạo ra vẻ sang trọng và mạnh mẽ. Màu sắc Đen cũng thường được ưa chuộng trong thế giới hip hop vì sự bắt mắt và dễ kết hợp với các bộ trang phục khác.Nón được thiết kế trơn, không có họa tiết hoặc trang trí phức tạp, tạo ra vẻ đơn giản và dễ dàng phối hợp. Khóa được sử dụng làm điểm nhấn thêm vào phần sau của nón, tạo thêm sự độc đáo và cá nhân cho sản phẩm.Thường làm từ vải cotton hoặc vải canvas, tạo cảm giác thoải mái và thoáng khí khi đội. Chất liệu này cũng giúp nón giữ được hình dáng và bền bỉ sau thời gian sử dụng.Nón Snapback Hiphop Trơn Có Khóa màu Đen là một lựa chọn phù hợp cho những người yêu thích phong cách hip hop và mong muốn thể hiện cá tính riêng của mình. Nó thích hợp để đội trong các buổi gặp gỡ bạn bè, đi chơi hoặc tham gia các sự kiện ngoài trời.',36,'Nữ','Vàng tươi','https://media.istockphoto.com/id/1453988945/vi/anh/m%C5%A9-x%C3%B4-m%C3%A0u-v%C3%A0ng-c%C3%A1ch-ly-tr%C3%AAn-m%C3%A0u-tr%E1%BA%AFng.jpg?s=1024x1024&w=is&k=20&c=x3MA6las9ZkUwCC4f4uD5vbS4YCyGGtrdIxxsirTn3c=',0,120000),(152,'Nón: Mũ rơm','Mũ rơm có kiểu dáng đơn giản và truyền thống, thường có đỉa phẳng và vòm cong nhẹ. Phần đỉa mũ có thể được uốn cong hoặc giữ phẳng tùy thuộc vào phong cách và sở thích cá nhân.Mũ rơm được làm từ sợi rơm hoặc cây cỏ tự nhiên, tạo ra vẻ tự nhiên và gần gũi với thiên nhiên. Chất liệu này cũng giúp đầu bạn thoáng khí và thoải mái trong thời tiết nắng nóng.Màu của mũ rơm thường là màu tự nhiên của sợi rơm, tạo ra vẻ mộc mạc và gần gũi. Màu sắc này thường là màu nâu nhạt hoặc vàng nhạt, phản ánh sự ấm áp và truyền thống.Mũ rơm thường được đội trong các hoạt động ngoài trời như đi dã ngoại, câu cá, hoặc tham gia các lễ hội truyền thống. Nó cũng là một phụ kiện thời trang phổ biến trong một số nền văn hóa, tạo ra vẻ đẹp và sự gần gũi với tự nhiên.',50,'Unisex','Vàng nâu','https://media.istockphoto.com/id/184397074/vi/anh/m%C5%A9-r%C6%A1m.jpg?s=1024x1024&w=is&k=20&c=G0aV8hUH7KW0JZMfFhZko6vM2Z1vRPcgx97yOTU8eg0=',0,35000),(153,'Washed Cotton Caps Men Cadet Cap Design Flat Top Hat','Sử dụng chất liệu cotton mềm mại và thoáng khí, giúp bạn luôn cảm thấy thoải mái ngay cả trong những ngày nắng nóng.Với kiểu dáng Flat Top hiện đại và trẻ trung, chiếc mũ này mang lại sự cá nhân hóa và phong cách cho bất kỳ bộ trang phục nào.Cho phép bạn lựa chọn từ một loạt các màu sắc phong phú, dễ dàng phù hợp với phong cách cá nhân của bạn.Với khóa điều chỉnh phía sau, bạn có thể dễ dàng điều chỉnh kích thước của mũ sao cho vừa vặn và thoải mái nhất.',30,'Nam','Nâu sẫm','https://media.istockphoto.com/id/1184522745/vi/anh/c%C6%B0%E1%BB%A1i-ng%E1%BB%B1a-rodeo-v%C4%83n-h%C3%B3a-mi%E1%BB%81n-t%C3%A2y-hoang-d%C3%A3-ch%E1%BB%A7-%C4%91%E1%BB%81-kh%C3%A1i-ni%E1%BB%87m-%C3%A2m-nh%E1%BA%A1c-%C4%91%E1%BB%93ng-qu%C3%AA-americana-v%C3%A0-m%E1%BB%B9-v%E1%BB%9Bi.jpg?s=1024x1024&w=is&k=20&c=eQWSy0ok0umbVrToBbNZ7hbwTD7-75vgee2EaRDLkDk=',0,100000),(154,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',51,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(155,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',51,'Unisex','Đen','https://storage.googleapis.com/hatshop-75393.appspot.com/6645e1e565ddc.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388646&Signature=T%2B74SAI9pxHGxnl9garW9lOm1N30v0na%2BUzbT3ZOiwn9K5Qc5NGEdnfh8IGOzQPFnYh6eyMOR4tlVlvVuAX3oGJ25cRb9%2BF93mcus5FcL1MvsJAGUQV7VcYLO1kNYXnHlN5JnWtgts%2FyVoCPyDMaUQBeMYKkUGoqn5fjcrC2R0si5Q7PnbvSh1He4Pjx23UOTb%2F%2Bua1gBIxq%2FnhLifmBHsbDti9B9lcpNiUIIr68Y7oooo1ZXxBOnOeV6UXqdOku9v1dgjflkTj5YA6V3Lnr2bAOuz0NZGsk7KZPFgJoVEiA8qRQpMIm1OiFSRJbHUB5yvUo%2F%2BlaM8QIHXllETW%2Faw%3D%3D&generation=1715855846883834',0,2700000),(156,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',51,'Unisex','Đen','https://media.istockphoto.com/id/1186076393/vi/anh/trang-ph%E1%BB%A5c-th%E1%BB%9Di-trang-th%E1%BB%9Di-trang-nam-c%E1%BB%95-%C4%91i%E1%BB%83n-v%C3%A0-%E1%BA%A3o-thu%E1%BA%ADt-hi%E1%BB%83n-th%E1%BB%8B-%C3%BD-t%C6%B0%E1%BB%9Fng-kh%C3%A1i-ni%E1%BB%87m-v%E1%BB%9Bi-3-4-g%C3%B3c.jpg?s=612x612&w=0&k=20&c=O0vcSFbGIL-gOLW4Vns2eY6sMEOhi5cpIPxR_YOcWh4=',0,2700000),(157,'Moussa 81','Mũ lưỡi trai là một phụ kiện thời trang phổ biến, thường được thiết kế với một mũ có một miếng lưỡi trai hướng về phía trước. Đây là một phong cách cổ điển và đa dụng, phổ biến trong cả thời trang nam và nữ. Dưới đây là một mô tả tổng quan về mũ lưỡi trai.Mũ lưỡi trai thường có kiểu dáng tròn và nắp mũ rộng, phủ một phần đầu và có một miếng lưỡi trai rộng ở phía trước.Chất liệu phổ biến nhất để làm mũ lưỡi trai là vải, nhưng cũng có thể sử dụng da, len, nỉ, hoặc các loại vật liệu khác tùy thuộc vào phong cách và mục đích sử dụng.Mũ lưỡi trai có thể được thiết kế với nhiều màu sắc và hoa văn khác nhau, từ màu đơn giản như đen, trắng, hoặc xám đến những hoa văn in hoặc thêu độc đáo.Ngoài mũ lưỡi trai thông thường, còn có các biến thể như mũ lưỡi trai snapback, mũ lưỡi trai đính nơ, hoặc mũ lưỡi trai có thêm bên trong để tăng tính thoáng khí.Mũ lưỡi trai có thể phù hợp với nhiều phong cách khác nhau, từ thể thao đến hàng ngày, từ ngoài trời đến nội thất. Chúng cũng thích hợp cho cả nam và nữ, và có thể được kết hợp với nhiều trang phục khác nhau.',50,'Unisex','Đen','https://storage.googleapis.com/hatshop-75393.appspot.com/6645e03b2ede7.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388220&Signature=22nAAMhEb0Bkoqo3UAxEv5HgGlhfAofLPL2SclVREWxr101m9PG%2Bii61uB7jLOkb1ujlLpXh8PCdTXF5TLtWos27n4vI9UDOedsjCcOU%2BcTNmvxevG%2Fv7cnT2unEo%2Bp4RmogPlqiCvyplhfgofXUYtJQzq9yKPvMO1oBHuPUSfDPY7rfN%2FLl%2BleQ9vD%2Bk7CTzRjb0%2B%2BRgEppaesgClz6UUmXtwRuH%2FHquhtCCowOWolj8zbRDfiy0s87U0etXZxtH%2BJ%2BrbqhjdFRHuLnEh%2B2arqdhQu6B9nimwmSgxSK0xrux2jITWq9mFdgzXaJA98IKFkmsHPEvk18m6J1%2FOgOyQ%3D%3D&generation=1715855420169409',0,2700000),(158,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242','Mũ baseball có kiểu dáng truyền thống với phần đỉa cong và vòm rộng, tạo ra sự bảo vệ hiệu quả khỏi ánh nắng mặt trời.\r\nSản phẩm được làm từ vật liệu chất lượng cao với công nghệ Aeroready giúp thoát ẩm và thoáng khí, giúp đầu bạn luôn khô ráo và thoải mái trong mọi hoạt động.Màu đen cơ bản làm cho mũ dễ dàng kết hợp với nhiều loại trang phục khác nhau và phù hợp với mọi phong cách thời trang.Logo của thương hiệu adidas được đặt ở mặt trước của mũ, tạo nên điểm nhấn thương hiệu và thể hiện sự chất lượng và đẳng cấp.Mũ được thiết kế với khóa điều chỉnh phía sau, giúp bạn có thể điều chỉnh kích thước mũ sao cho vừa vặn và thoải mái.Sản phẩm này phù hợp cho mọi hoạt động ngoài trời như chơi thể thao, đi dạo, hoặc tham gia các sự kiện ngoài trời khác',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(159,'Mũ adidas Aeroready Baseball Cap \"Black\" HD7242','Mũ baseball có kiểu dáng truyền thống với phần đỉa cong và vòm rộng, tạo ra sự bảo vệ hiệu quả khỏi ánh nắng mặt trời.\r\nSản phẩm được làm từ vật liệu chất lượng cao với công nghệ Aeroready giúp thoát ẩm và thoáng khí, giúp đầu bạn luôn khô ráo và thoải mái trong mọi hoạt động.Màu đen cơ bản làm cho mũ dễ dàng kết hợp với nhiều loại trang phục khác nhau và phù hợp với mọi phong cách thời trang.Logo của thương hiệu adidas được đặt ở mặt trước của mũ, tạo nên điểm nhấn thương hiệu và thể hiện sự chất lượng và đẳng cấp.Mũ được thiết kế với khóa điều chỉnh phía sau, giúp bạn có thể điều chỉnh kích thước mũ sao cho vừa vặn và thoải mái.Sản phẩm này phù hợp cho mọi hoạt động ngoài trời như chơi thể thao, đi dạo, hoặc tham gia các sự kiện ngoài trời khác',50,'Unisex','Xanh viền trắng','https://media.istockphoto.com/id/535518012/vi/anh/ph%E1%BB%A5-n%E1%BB%AF-m%C5%A9-xanh-v%E1%BB%9Bi-m%E1%BA%A1ng-che-m%E1%BA%B7t.jpg?s=1024x1024&w=is&k=20&c=O17EaK8ZGJXvPpYGTKWtCMqLyeRQ9BNjrslYXMqQ2Sk=',0,150000),(160,'Mũ bóng chày màu đen trống 4 xem trên nền trắng','Mũ bóng chày có kiểu dáng truyền thống với phần thân mũ màu đen và đỉa trống 4, tạo ra vẻ nổi bật và phong cách.Màu đen là một lựa chọn phổ biến và đa dụng, tạo nên vẻ sang trọng và mạnh mẽ cho mũ. Trên nền trắng, màu sắc của mũ đen nổi bật và thu hút sự chú ý.Mũ có các đường cắt sắc nét và chính xác, tạo ra sự hoàn thiện và chất lượng cao cho sản phẩm.Có thể có logo của thương hiệu bóng chày hoặc các hình ảnh liên quan được in hoặc thêu trên phần thân mũ, tạo điểm nhấn thương hiệu và phong cách.Mũ bóng chày màu đen trống 4 thường được đội trong các trận đấu, tập luyện hoặc các hoạt động ngoài trời khác. Đồng thời, nó cũng là một phụ kiện thời trang thể thao phổ biến và phù hợp với nhiều phong cách trang phục khác nhau.',31,'Nam','Đen trắng','https://media.istockphoto.com/id/1060912434/vi/vec-to/m%C5%A9-tr%E1%BA%AFng-v%C3%A0-%C4%91en-t%E1%BB%AB-c%C3%A1c-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau.jpg?s=612x612&w=0&k=20&c=Jz_E-l29kqJ1I9Es1D-_5oJJRtT5U9NYClk5qnpzPVQ=',0,30000),(161,'Mũ bóng chày màu đen trống 4 xem trên nền trắng','Mũ bóng chày có kiểu dáng truyền thống với phần thân mũ màu đen và đỉa trống 4, tạo ra vẻ nổi bật và phong cách.Màu đen là một lựa chọn phổ biến và đa dụng, tạo nên vẻ sang trọng và mạnh mẽ cho mũ. Trên nền trắng, màu sắc của mũ đen nổi bật và thu hút sự chú ý.Mũ có các đường cắt sắc nét và chính xác, tạo ra sự hoàn thiện và chất lượng cao cho sản phẩm.Có thể có logo của thương hiệu bóng chày hoặc các hình ảnh liên quan được in hoặc thêu trên phần thân mũ, tạo điểm nhấn thương hiệu và phong cách.Mũ bóng chày màu đen trống 4 thường được đội trong các trận đấu, tập luyện hoặc các hoạt động ngoài trời khác. Đồng thời, nó cũng là một phụ kiện thời trang thể thao phổ biến và phù hợp với nhiều phong cách trang phục khác nhau.',30,'Nam','Đen trắng','https://storage.googleapis.com/hatshop-75393.appspot.com/6645e022f32e5.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388195&Signature=h1o%2FBcLPa%2Fx5SSbY3f%2BFIjTbmrJa%2F6POzXZex6cM1%2FRyY8LFECEmcf4uYKyVzXoDwH5J9nEDvccZS42V%2Bl1VIviF9yM5u9hRb83%2FcHMGNR7%2F8YtST4743CQ8RhBvzFDcW1ZmidR1N9cROxA6Bsk6kOIV9MPeJYxALqjxrrw3RPGqtSkc1W3AWu5m9DCX0Aojv8XOrJriQB6EaxnQ5Uu31kGyz7RgWFpUrKFgUbCJxWeDbj8HQN5iakTkp1MwOQqRWMatkSSBxuoywXHnjXT%2BqziFL%2F20YIGcjRW88ZM449YkwwdcoB4oHNwcHe9GOBRcrzVrFApYvolKFofZjXwpkg%3D%3D&generation=1715855395973775',0,30000),(162,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d','Mũ cảnh sát được hiển thị trong một môi trường 3D, cho phép người xem quan sát từ nhiều góc độ khác nhau. Dưới ánh sáng chiếu sáng chính xác, mũ được hiển thị với mọi chi tiết, từ phần đỉa cong đến phần thân mũ và dây đeo.Từ góc nhìn phía trước, bạn có thể thấy rõ hình dáng tổng thể của mũ, với phần đỉa cong nhẹ và logo hoặc biểu tượng của lực lượng cảnh sát được in hoặc dập nổi trên mặt trước của mũ. Đường viền sắc nét và chi tiết tinh tế tạo nên sự hoàn thiện cho sản phẩm.Khi quan sát từ phía sau, bạn có thể thấy cách mà dây đeo được thiết kế và gắn kết với mũ, cũng như các chi tiết như các lỗ thông hơi để giữ cho đầu người đội mũ luôn thoáng khí.Từ các góc độ khác nhau, như từ trên xuống hoặc từ dưới lên, bạn có thể thấy rõ hình dáng và cấu trúc của mũ cảnh sát, cho phép bạn hiểu được cách mà nó có thể bảo vệ và hỗ trợ người đội mũ trong các nhiệm vụ và hoạt động hàng ngày.',36,'Nam','Xanh đậm','https://storage.googleapis.com/hatshop-75393.appspot.com/6645e009486c5.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388169&Signature=srqZQ5uFIwg0Zi%2F0i5g%2F3A2AolrT69A%2FBLwWlQ1LrjkKi7P32xZ%2FD6N1ndhmE5D7qTwaGokSS9046NJHyzz9FWexvoyKAWNo1KmGVFH8ZdDXpzFskWZTiXXe1gmVjFSvrw1BAbEjM1VBEi9XJBGPRy0Wh31%2Ffc3wVIfV6r%2BRGALQije9fY9ksswXh6ZLBpgxgSaf6qk5cZBtffWyhnYRoGn%2Fg5QyGCaauhF6Tqt0lGKTm24Lw0nyO0WTtHz8ackaq4%2FQcjUCaQNdhFtdQ%2BkLOKYWEnGzs%2Bq9%2Fdnonz2sJZHau74kkcmpsdY8d8RRO%2BROq5K8nOaQI5A1EKWExoPboQ%3D%3D&generation=1715855369974294',0,200000),(163,'Mũ cảnh sát từ nhiều góc độ khác nhau minh họa 3d','Mũ cảnh sát được hiển thị trong một môi trường 3D, cho phép người xem quan sát từ nhiều góc độ khác nhau. Dưới ánh sáng chiếu sáng chính xác, mũ được hiển thị với mọi chi tiết, từ phần đỉa cong đến phần thân mũ và dây đeo.Từ góc nhìn phía trước, bạn có thể thấy rõ hình dáng tổng thể của mũ, với phần đỉa cong nhẹ và logo hoặc biểu tượng của lực lượng cảnh sát được in hoặc dập nổi trên mặt trước của mũ. Đường viền sắc nét và chi tiết tinh tế tạo nên sự hoàn thiện cho sản phẩm.Khi quan sát từ phía sau, bạn có thể thấy cách mà dây đeo được thiết kế và gắn kết với mũ, cũng như các chi tiết như các lỗ thông hơi để giữ cho đầu người đội mũ luôn thoáng khí.Từ các góc độ khác nhau, như từ trên xuống hoặc từ dưới lên, bạn có thể thấy rõ hình dáng và cấu trúc của mũ cảnh sát, cho phép bạn hiểu được cách mà nó có thể bảo vệ và hỗ trợ người đội mũ trong các nhiệm vụ và hoạt động hàng ngày.',36,'Nam','Xanh đậm','https://media.istockphoto.com/id/488500609/vi/anh/m%C5%A9-c%E1%BA%A3nh-s%C3%A1t-t%E1%BB%AB-nhi%E1%BB%81u-g%C3%B3c-%C4%91%E1%BB%99-kh%C3%A1c-nhau-minh-h%E1%BB%8Da-3d.jpg?s=1024x1024&w=is&k=20&c=V__NJkgMYPyAoQZITHnjH-xGT_1ZYNsGMnFgNkvBe-w=',0,200000),(165,'Mũ cao bồi da màu nâu','Mũ được làm từ da hoặc các loại vật liệu tổng hợp chất lượng cao, tạo ra vẻ lịch lãm và đẳng cấp. Chất liệu da tự nhiên thường được ưa chuộng vì tính linh hoạt và độ bền của nó.Mũ có đỉa cong và vòm rộng, tạo ra vẻ lãng mạn và cổ điển. Phần đỉa có thể được uốn cong hoặc phẳng tùy thuộc vào phong cách cá nhân và sở thích.Màu nâu là lựa chọn phổ biến cho mũ cao bồi, tạo ra vẻ ấm áp và truyền thống. Các biến thể màu nâu từ nâu đậm đến nâu nhạt tạo ra sự đa dạng và linh hoạt trong lựa chọn.Mũ cao bồi thường được trang trí với dây da, khoá kim loại hoặc nơ trang trí. Những chi tiết này tạo ra điểm nhấn và thêm vào vẻ đẹp của mũ.Mũ cao bồi da màu nâu thường được đội trong các sự kiện western như rodeo, lễ hội hoặc các hoạt động ngoài trời khác. Nó cũng có thể được sử dụng như một phụ kiện thời trang để tạo điểm nhấn cho bộ trang phục hàng ngày.',31,'Nam','Nâu sẫm','https://storage.googleapis.com/hatshop-75393.appspot.com/6645dfc0294fe.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388096&Signature=DTFjxQLPRAMJ7D99oM%2Fb3Pepk92R7Ghfx%2BU8i9YOu1%2B9wGYcfLyVn6cACWDJfC1cZmtDK9IZ0XB%2BMC3LtaaaA0od5zjCftypnYpmHeSBT9RTEI2%2BEx7%2FJnRxp7SE4pDz1d%2Bv1ZHVPu%2BGZYx4DesPrRe2KbwG3uKeIJbRZs04onW99Bvf0hXA6SipSx5vNM35epirvK4zbGCcTtkUWct25o6KEGkT4GcwPQyBU%2B0pikgkFbVXNUa69YMSSx3LkYEgRJ1mtOq31On%2BqhzQnTrTJv6G5XIVgBlgLb7e0SJmjXtjRWINUEEMTt%2Bfy5ItxtgR2j1F2EpSsOs%2FpwPQoxuCNg%3D%3D&generation=1715855296928366',0,500000),(167,'Mũ diễu hành màu xanh lá cây với thắt lưng và khóa','Mũ diễu hành thường có kiểu dáng tròn, với đỉa cong và vòm rộng, tạo cảm giác thoải mái và phóng khoáng. Phần thân mũ được thiết kế màu xanh lá cây, tạo ra sự tươi mới và năng động.Sự kết hợp giữa thắt lưng và khóa là điểm đặc biệt của sản phẩm này. Thắt lưng có thể được làm từ vải hoặc da, mang lại vẻ đẹp tự nhiên và tinh tế. Khóa được sử dụng như một chi tiết trang trí, tạo điểm nhấn và thêm phần phong cách cho mũ.Màu xanh lá cây là lựa chọn táo bạo và nổi bật, phản ánh sự trẻ trung và năng động. Màu sắc này thường được ưa chuộng trong mùa xuân và mùa hè, tạo cảm giác sảng khoái và tươi mới.Mũ có thể được làm từ vải như cotton, polyester hoặc vải canvas, mang lại sự thoải mái và thoáng khí cho người đội. Thắt lưng có thể là da hoặc vải, tùy thuộc vào phong cách và ý thích cá nhân.Mũ diễu hành màu xanh lá cây với thắt lưng và khóa thích hợp cho các sự kiện ngoài trời như các buổi hòa nhạc, lễ hội hoặc dã ngoại. Đồng thời, nó cũng có thể được sử dụng như một phụ kiện thời trang trong cuộc sống hàng ngày.',2011,'Unisex','Xanh lục','https://storage.googleapis.com/hatshop-75393.appspot.com/6645df9c38918.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388060&Signature=34JGAGH%2F5N82fqXigqyuVhJBiCYl5bwR%2FAlOC%2F07y5QBZnfx0gQvDJ52KIYdAG%2BNsExlEGC7TA%2FWBwAMg%2BMxDRmAT67gOXndwT%2FFZRGSVRjMIa8vC4bkiPGNqZ0PWYryVKT1oYDJSecjrEWVF54IpuTgNpi392WkDnmUIpjbFgpGz%2FKdmuNnBH23wfptCBQI%2BKZfLajjePmHeAgQJ5pOinXevIv3ikcQ01%2Feo9krW2SoSYXdtkwogJuQUxKcfwFCtGaBI8csjPskQdOEOi%2Fdz%2B1O7xqDdmXGcNf43%2BYPA0R0JBB%2Bnpd9HTooZFWQGQ2jxMEp%2BwS0UGFnKr12IoWlgg%3D%3D&generation=1715855260924927',0,117000),(168,'Mũ ông già Noel đỏ và trắng lễ hội','Mũ Ông già Noel có kiểu dáng truyền thống với phần thân mũ màu đỏ rực rỡ, được làm từ vải mềm mại và dày dặn, kèm theo một dải vải màu trắng ở phía dưới tạo thành phần đuôi của mũ.Mũ thường được trang trí bằng một chiếc nơ hoặc một hình ảnh nhỏ của Ông già Noel, thêm vào vẻ đáng yêu và phù hợp với chủ đề Giáng sinh.\r\nMũ Ông già Noel thường có kích thước phổ thông, phù hợp với cả trẻ em và người lớn. Chất liệu mềm mại và co dãn linh hoạt giúp mũ ôm sát và thoải mái cho mọi người.Màu đỏ và trắng là hai màu chủ đạo của mũ Ông già Noel, tạo nên vẻ rực rỡ và đầy sắc màu cho bất kỳ buổi lễ hội nào.Mũ Ông già Noel không chỉ là một phụ kiện trang trí, mà còn là biểu tượng của sự vui vẻ và hạnh phúc trong mùa lễ hội. Nó thích hợp để mọi người đội trong các bữa tiệc, dạo phố, tham gia các hoạt động vui chơi và chụp hình kỷ niệm trong dịp Giáng sinh.',1898,'Unisex','Đỏ trắng','https://storage.googleapis.com/hatshop-75393.appspot.com/6645df6859b2f.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031388009&Signature=rrUgPdHVdw5dCZKvq77yaikgW8LxP9Y8aKz3weC%2Fe8z01UfzyotVY8r2Cnhv9yMG6hXl7yiDxtYStHJXcNMFMZwFBhq6X1WArBTxvAJx8ylQjqRdfQLR3bDNF0GswQq2jQVA%2BqqCzzS158i8xi7mGc7HvdLYULtMdM2TuMMk2dwbRv0vbGPkdIHIAD%2FLAgmKbYqBrJHu2uYITQEVubCmzWegH2UYJwdXpEecGaR50ntpoxLpZrAjP00psmUVcJCeNLiagjPwUB6Gq10aC4ztpiCzkbz5pjHo6n3WIxMWtyc6XADjaBGzMg%2Fz6MJ9mBHJLjcX4B7il5OfEF1iko%2BXpA%3D%3D&generation=1715855209207622',0,38000),(174,'Nón da tai thỏ','Nón da tai thỏ là một mẫu nón thời trang phổ biến, thường được làm từ chất liệu da tổng hợp hoặc da thật, được thiết kế với phần tai thỏ nhỏ xinh ở phía trước. Điểm nhấn của sản phẩm này là phần tai thỏ, tạo điểm nhấn độc đáo và dễ thương cho người đeo. Nón có thể có nhiều kiểu dáng khác nhau như nón snapback, nón lưỡi trai, hoặc nón đội tròn. Thường được sử dụng trong các bộ trang phục cá nhân hàng ngày hoặc trong các bữa tiệc, sự kiện thời trang. Nón da tai thỏ thường là phụ kiện yêu thích của các bạn trẻ yêu thích phong cách nữ tính và dễ thương.',20,'Unisex','Đen','https://storage.googleapis.com/hatshop-75393.appspot.com/6645df3493330.jpg?GoogleAccessId=firebase-adminsdk-fm0dm%40hatshop-75393.iam.gserviceaccount.com&Expires=2031387958&Signature=KbwgutUz4Ba2eEUhi%2FBFgi3WyG1prnMJFUwN1pFZCXDhnq%2BrhRG7MqvRTAQKF6iI6Z2T3wJo2xxaEJzYN4MVCHh5rGV3lFvr0bY6h2ena9V1fQtRHm2tx30sccjmwOInSfFLOyhN0S4SFg0tupsBsFqCd4aFRpqMNFjFaLMZM%2BjD%2FA9Fmn%2FfX3adX5tBVI8%2BO4mwl723DH1tkxgp3X5L2Blm09He2apcemSsQkIuK5mS4fLpz68gwjCQmXOLiOt6E26MqSp3t0zFFRVlnm%2FWcCeVr6q81bLnlvox%2FNFyHu9oAc0RczW5fyWl8wjhTHNp7jAuczI7nqjAuZn5CMZ4TA%3D%3D&generation=1715855158184682',0,100000);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `toado`
--

LOCK TABLES `toado` WRITE;
/*!40000 ALTER TABLE `toado` DISABLE KEYS */;
INSERT INTO `toado` VALUES (1,106.78736,10.84897,'Hat Shop'),(2,106.78736,10.84897,'Hat shop 1'),(3,106.77346933633089,10.852838157696748,'Hat shop'),(4,106.73675425350666,10.788906021119725,'Hat Shop'),(5,106.7249595746398,10.76825443229899,'Hat shop'),(6,106.72515235841274,10.76676270180724,'Hat shop'),(7,106.77510414272547,10.77883236484694,'Hat shop'),(8,106.78736,10.84897,'Hat shop 1'),(9,106.78736,10.84897,'Hat Shop');
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
  `roleId` int(11) NOT NULL DEFAULT 2,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `role_index` (`roleId`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (23,'nguyenthaitruong.entertainment@gmail.com','$2y$10$w7VeCglvw2vH2TIHLFG55ufdBmWB.BF43cnQfjCHIwcm7L9CwtkQq','Trưởng Chiller','0987654321',2),(24,'nguyenthaitruong1223@gmail.com','$2y$10$TWgdtiyCQL694gIY0OQVa.3SXUlzYnBaftoxDDo.3f4SZbtJlyJ42','Nguyễn Thái Trưởng','0948915051',2),(25,'nguyenthaitruong12233@gmail.com','$2y$10$RuJzs68D6FFYDZJIwlM42ekfdnnehd9TgjrsMuYbvhAv.0dB.C5qC','Nguyễn Thái Trưởng','0948915051',2),(26,'phamngocbao2104@gmail.com','$2y$10$Gla1EMMo0zDaEv8/ijgTduoLj7vyD7aQ4SK0bTb1CRhSEDuCTvcTa','Bảo Phạm','0132659475',2),(28,'n20dccn083@student.ptithcm.edu.vn','$2y$10$b66ZUa57k.meWbPP5IiXHuo2idgN31LkiYDhG5zgpC0d.nm4DDVh.','Nguyen Thai Truong','0948915051',2),(29,'nguyenthaitruong.entertainment1@gmail.com','$2y$10$92fEaJmR6C7YtSB.WwopYuJpZYG6EaQCw0gz2Q8trjkZts3zRtH92','Nguyễn Trưởng','0948915051',2);
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
 1 AS `hasToken`,
 1 AS `daDanhGia`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'databannon'
--

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
/*!50003 DROP PROCEDURE IF EXISTS `SP_CREATE_RATING_IMAGES` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CREATE_RATING_IMAGES`(
	in maDanhGia int,
    in mangChiTiet json
)
begin
	declare i int default 0;
    declare n int;
    declare hinhAnhURL text;
    declare exit handler for sqlexception
    begin
		-- Rollback the transaction in case of any error
		rollback;
	end;
    
    -- Start a new transaction
    set n = json_length(mangChiTiet);
    while i < n do
		set hinhAnhURL = json_unquote(json_extract(mangChiTiet, concat('$[', i, '].hinhAnhURL')));
        
        -- Insert into chitietdonhang table
        insert into hinhanhdanhgia(maDanhGia, hinhAnhURL) 
        values (maDanhGia, hinhAnhURL);
        
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
/*!50003 DROP PROCEDURE IF EXISTS `SP_GET_MOST_PRODUCTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_MOST_PRODUCTS`(in `year` int, in amount int)
BEGIN
	select *
    from chitietdonhang ct
	join donhang dh on ct.maDonHang = dh.maDonHang
    join sanpham sp on ct.maSanPham = sp.maSanPham
    where year(dh.ngayTao) = `year`
    group by ct.maSanPham
    order by sum(ct.soLuong) desc
    limit amount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GET_MOST_YEAR_PRODUCTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_MOST_YEAR_PRODUCTS`(in `year` int, in amount int)
BEGIN
	select ct.maSanPham, sp.tenSanPham, sp.soLuong as soLuongTon, sp.hinhAnh, 
    sum(ct.soLuong) as tongSoLuong
    from chitietdonhang ct
	join donhang dh on ct.maDonHang = dh.maDonHang
    join sanpham sp on ct.maSanPham = sp.maSanPham
    where year(dh.ngayTao) = `year`
    group by ct.maSanPham
    order by sum(ct.soLuong) desc
    limit amount;
END ;;
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
/*!50003 DROP PROCEDURE IF EXISTS `SP_GET_PRODUCT_RATING` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_PRODUCT_RATING`(IN productId INT)
BEGIN
	select u.email, u.username, d.*
    from danhgia d
    join chitietdonhang c on d.maDonHang = c.maDonHang
    join donhang dh on c.maDonHang = dh.maDonHang
    join `user` u on u.id = dh.userId
    where c.maSanPham = productId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_YEAR_REVENUE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_YEAR_REVENUE`(in `year` int)
BEGIN
	select months.thang, coalesce(sum(dh.tongTien), 0) as tong
    from 
		(
        select 1 as thang union select 2 union select 3 union 
		select 4 union select 5 union select 6 union 
        select 7 union select 8 union select 9 union
        select 10 union select 11 union select 12
        ) as months 
	left join donhang as dh
    on months.thang = month(dh.ngayTao) and year(dh.ngayTao) = `year`
    group by months.thang
    order by months.thang;
		
END ;;
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
/*!50001 VIEW `v_orders` AS select `dh`.`maDonHang` AS `maDonHang`,`dh`.`userId` AS `userId`,`u`.`username` AS `username`,`dh`.`diaChi` AS `diaChi`,`dh`.`soLuong` AS `soLuong`,`dh`.`tongTien` AS `tongTien`,`dh`.`soDienThoai` AS `soDienThoai`,`dh`.`email` AS `email`,`dh`.`trangThai` AS `trangThai`,`dh`.`ngayTao` AS `ngayTao`,case when `dh`.`token` <> '' then 1 else 0 end AS `hasToken`,case when `dg`.`maDonHang` is not null then 1 else 0 end AS `daDanhGia` from ((`donhang` `dh` join `user` `u` on(`dh`.`userId` = `u`.`id`)) left join `danhgia` `dg` on(`dh`.`maDonHang` = `dg`.`maDonHang`)) order by `dh`.`maDonHang` desc */;
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

-- Dump completed on 2024-06-04 21:22:43
