-- RestMan: tra cứu hóa đơn bán và thống kê nhà cung cấp theo hàng nhập.
-- MySQL 8.0+. Có thể chạy lại an toàn: không xóa dữ liệu hiện có.
CREATE DATABASE IF NOT EXISTS shopman
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopman;

CREATE TABLE IF NOT EXISTS tblAddress5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  houseNumber VARCHAR(20),
  street VARCHAR(100),
  ward VARCHAR(100),
  city VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblMembers5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  lastName VARCHAR(50),
  middleName VARCHAR(50),
  firstName VARCHAR(50),
  dateOfBirth DATE,
  email VARCHAR(120),
  phoneNumber VARCHAR(20),
  idAddress5 INT,
  CONSTRAINT fk_members_address FOREIGN KEY (idAddress5) REFERENCES tblAddress5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblCustomers5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customerId VARCHAR(50) NOT NULL UNIQUE,
  idMember5 INT NOT NULL UNIQUE,
  CONSTRAINT fk_customers_member FOREIGN KEY (idMember5) REFERENCES tblMembers5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblMemberRegistration5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  registeredDate DATE NOT NULL,
  idCustomer5 INT NOT NULL,
  CONSTRAINT fk_registration_customer FOREIGN KEY (idCustomer5) REFERENCES tblCustomers5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblStaffs5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  `role` VARCHAR(50) NOT NULL,
  staffId VARCHAR(50) NOT NULL UNIQUE,
  idMember5 INT NOT NULL UNIQUE,
  CONSTRAINT fk_staff_member FOREIGN KEY (idMember5) REFERENCES tblMembers5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblManagers5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idStaff5 INT NOT NULL UNIQUE,
  CONSTRAINT fk_manager_staff FOREIGN KEY (idStaff5) REFERENCES tblStaffs5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblSalesStaff5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idStaff5 INT NOT NULL UNIQUE,
  CONSTRAINT fk_sales_staff FOREIGN KEY (idStaff5) REFERENCES tblStaffs5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblSuppliers5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(120),
  phoneNumber VARCHAR(20),
  idAddress5 INT,
  CONSTRAINT fk_supplier_address FOREIGN KEY (idAddress5) REFERENCES tblAddress5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblProducts5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  category VARCHAR(80),
  quantity INT NOT NULL DEFAULT 0,
  CONSTRAINT chk_product_quantity CHECK (quantity >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblImportInvoices5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  totalAmount DECIMAL(14,2) NOT NULL DEFAULT 0,
  totalAmountInWords VARCHAR(255),
  createdDate DATETIME NOT NULL,
  note VARCHAR(255),
  trackingNumber VARCHAR(100),
  idManager5 INT NOT NULL,
  idSupplier5 INT NOT NULL,
  CONSTRAINT fk_import_manager FOREIGN KEY (idManager5) REFERENCES tblManagers5(id),
  CONSTRAINT fk_import_supplier FOREIGN KEY (idSupplier5) REFERENCES tblSuppliers5(id),
  INDEX idx_import_supplier_date (idSupplier5, createdDate)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblImportInvoiceDetails5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  price DECIMAL(12,2) NOT NULL,
  quantity INT NOT NULL,
  idImportInvoice5 INT NOT NULL,
  idProduct5 INT NOT NULL,
  CONSTRAINT chk_import_detail_price CHECK (price >= 0),
  CONSTRAINT chk_import_detail_quantity CHECK (quantity > 0),
  CONSTRAINT fk_import_detail_invoice FOREIGN KEY (idImportInvoice5) REFERENCES tblImportInvoices5(id),
  CONSTRAINT fk_import_detail_product FOREIGN KEY (idProduct5) REFERENCES tblProducts5(id),
  INDEX idx_import_details_invoice (idImportInvoice5)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblSalesInvoices5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  totalAmount DECIMAL(14,2) NOT NULL DEFAULT 0,
  totalAmountInWords VARCHAR(255),
  createdDate DATETIME NOT NULL,
  note VARCHAR(255),
  trackingNumber VARCHAR(100),
  status VARCHAR(40) NOT NULL DEFAULT 'Đang xử lý',
  idCustomer5 INT NOT NULL,
  idSalesStaff5 INT NOT NULL,
  CONSTRAINT fk_sales_invoice_customer FOREIGN KEY (idCustomer5) REFERENCES tblCustomers5(id),
  CONSTRAINT fk_sales_invoice_staff FOREIGN KEY (idSalesStaff5) REFERENCES tblSalesStaff5(id),
  INDEX idx_sales_invoice_customer_date (idCustomer5, createdDate)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblDeliveryStaffs5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(120),
  name VARCHAR(120) NOT NULL,
  phoneNumber VARCHAR(20),
  idSalesInvoice5 INT,
  CONSTRAINT fk_delivery_staff_invoice FOREIGN KEY (idSalesInvoice5) REFERENCES tblSalesInvoices5(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tblSalesInvoiceDetails5 (
  id INT AUTO_INCREMENT PRIMARY KEY,
  price DECIMAL(12,2) NOT NULL,
  quantity INT NOT NULL,
  idSalesInvoice5 INT NOT NULL,
  idProduct5 INT NOT NULL,
  CONSTRAINT chk_sales_detail_price CHECK (price >= 0),
  CONSTRAINT chk_sales_detail_quantity CHECK (quantity > 0),
  CONSTRAINT fk_sales_detail_invoice FOREIGN KEY (idSalesInvoice5) REFERENCES tblSalesInvoices5(id),
  CONSTRAINT fk_sales_detail_product FOREIGN KEY (idProduct5) REFERENCES tblProducts5(id),
  INDEX idx_sales_details_invoice (idSalesInvoice5)
) ENGINE=InnoDB;

-- Nâng cấp schema đã tạo từ bản SQL trước đó mà không xóa dữ liệu.
SET @has_delivery_email = (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name = 'tblDeliveryStaffs5' AND column_name = 'email');
SET @ddl = IF(@has_delivery_email = 0,
  'ALTER TABLE tblDeliveryStaffs5 ADD COLUMN email VARCHAR(120) NULL', 'SELECT 1');
PREPARE schema_update FROM @ddl; EXECUTE schema_update; DEALLOCATE PREPARE schema_update;

-- Xóa quan hệ và bảng đối tác giao hàng khỏi các database đã được tạo trước đây.
SET @has_delivery_partner_fk = (SELECT COUNT(*) FROM information_schema.referential_constraints
  WHERE constraint_schema = DATABASE() AND table_name = 'tblDeliveryStaffs5' AND constraint_name = 'fk_delivery_staff_partner');
SET @ddl = IF(@has_delivery_partner_fk > 0,
  'ALTER TABLE tblDeliveryStaffs5 DROP FOREIGN KEY fk_delivery_staff_partner', 'SELECT 1');
PREPARE schema_update FROM @ddl; EXECUTE schema_update; DEALLOCATE PREPARE schema_update;

SET @has_delivery_partner_column = (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name = 'tblDeliveryStaffs5' AND column_name = 'idDeliveryPartner5');
SET @ddl = IF(@has_delivery_partner_column > 0,
  'ALTER TABLE tblDeliveryStaffs5 DROP COLUMN idDeliveryPartner5', 'SELECT 1');
PREPARE schema_update FROM @ddl; EXECUTE schema_update; DEALLOCATE PREPARE schema_update;

DROP TABLE IF EXISTS tblDeliveryPartners5;

SET @has_delivery_invoice = (SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name = 'tblDeliveryStaffs5' AND column_name = 'idSalesInvoice5');
SET @ddl = IF(@has_delivery_invoice = 0,
  'ALTER TABLE tblDeliveryStaffs5 ADD COLUMN idSalesInvoice5 INT NULL', 'SELECT 1');
PREPARE schema_update FROM @ddl; EXECUTE schema_update; DEALLOCATE PREPARE schema_update;

SET @has_delivery_invoice_fk = (SELECT COUNT(*) FROM information_schema.referential_constraints
  WHERE constraint_schema = DATABASE() AND constraint_name = 'fk_delivery_staff_invoice');
SET @ddl = IF(@has_delivery_invoice_fk = 0,
  'ALTER TABLE tblDeliveryStaffs5 ADD CONSTRAINT fk_delivery_staff_invoice FOREIGN KEY (idSalesInvoice5) REFERENCES tblSalesInvoices5(id)', 'SELECT 1');
PREPARE schema_update FROM @ddl; EXECUTE schema_update; DEALLOCATE PREPARE schema_update;

-- Dữ liệu mẫu tối thiểu cho hai màn hình. Mật khẩu chỉ là dữ liệu demo.
INSERT IGNORE INTO tblAddress5 (id, houseNumber, street, ward, city) VALUES
  (1, '12', 'Nguyễn Trãi', 'Phường 3', 'TP. Hồ Chí Minh'),
  (2, '45', 'Lê Lợi', 'Phường Bến Thành', 'TP. Hồ Chí Minh');
INSERT IGNORE INTO tblMembers5 (id, username, password, lastName, middleName, firstName, email, phoneNumber, idAddress5) VALUES
  (1, 'khach1', 'demo', 'Nguyễn', 'Văn', 'An', 'an@example.com', '0900000001', 1),
  (2, 'quanly1', 'demo', 'Trần', 'Thị', 'Bình', 'binh@example.com', '0900000002', 2),
  (3, 'banhang1', 'demo', 'Phạm', 'Minh', 'Anh', 'anh@example.com', '0900000005', 1);
INSERT IGNORE INTO tblCustomers5 (id, customerId, idMember5) VALUES (1, 'KH0001', 1);
INSERT IGNORE INTO tblMemberRegistration5 (id, registeredDate, idCustomer5) VALUES (1, '2026-01-10', 1);
INSERT IGNORE INTO tblStaffs5 (id, `role`, staffId, idMember5) VALUES
  (1, 'Quản lý', 'NV0001', 2),
  (2, 'Nhân viên bán hàng', 'NV0002', 3);
INSERT IGNORE INTO tblManagers5 (id, idStaff5) VALUES (1, 1);
INSERT INTO tblSalesStaff5 (id, idStaff5) VALUES (1, 2)
  ON DUPLICATE KEY UPDATE idStaff5=VALUES(idStaff5);
INSERT IGNORE INTO tblSuppliers5 (id, name, email, phoneNumber, idAddress5) VALUES (1, 'Nhà cung cấp mẫu', 'supplier@example.com', '0900000003', 2);
INSERT IGNORE INTO tblProducts5 (id, name, category, quantity) VALUES (1, 'Cà phê hạt', 'Nguyên liệu', 50), (2, 'Trà xanh', 'Nguyên liệu', 30);
INSERT IGNORE INTO tblImportInvoices5 (id, totalAmount, totalAmountInWords, createdDate, note, trackingNumber, idManager5, idSupplier5) VALUES
  (1, 2500000, 'Hai triệu năm trăm nghìn đồng', '2026-10-20 09:30:00', 'Nhập hàng mẫu', 'IMP-0001', 1, 1);
INSERT IGNORE INTO tblImportInvoiceDetails5 (id, price, quantity, idImportInvoice5, idProduct5) VALUES (1, 50000, 50, 1, 1);
INSERT IGNORE INTO tblSalesInvoices5 (id, totalAmount, totalAmountInWords, createdDate, note, trackingNumber, status, idCustomer5, idSalesStaff5) VALUES
  (1, 150000, 'Một trăm năm mươi nghìn đồng', '2026-10-21 12:15:00', 'Đơn hàng mẫu', 'SALE-0001', 'Đang giao', 1, 1);
INSERT INTO tblDeliveryStaffs5 (id, name, phoneNumber, email, idSalesInvoice5) VALUES (1, 'Lê Minh', '0900000004', 'minh@example.com', 1)
  ON DUPLICATE KEY UPDATE email=VALUES(email), idSalesInvoice5=VALUES(idSalesInvoice5);
INSERT IGNORE INTO tblSalesInvoiceDetails5 (id, price, quantity, idSalesInvoice5, idProduct5) VALUES (1, 75000, 2, 1, 2);
