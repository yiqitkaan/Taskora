-- =============================================================
-- NOVASTORE E-TİCARET VERİ YÖNETİM SİSTEMİ
-- Geliştirici: Yiğit Kaan Bilir
-- Veritabanı: Microsoft SQL Server / T-SQL
-- =============================================================

-- BÖLÜM 1: VERİ TABANI OLUŞTURMA
USE master;
GO

CREATE DATABASE NovaStoreDB COLLATE Turkish_100_CI_AS;
GO

USE NovaStoreDB;
GO

-- BÖLÜM 2: TABLOLARIN OLUŞTURULMASI (DDL)
-- Foreign Key bağımlılıkları nedeniyle önce ana, sonra bağımlı tablolar oluşturulur.

-- GÖREV 1: Categories (Kategoriler)
CREATE TABLE dbo.Categories (
    CategoryID INT IDENTITY(1,1) CONSTRAINT PK_Categories PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

-- GÖREV 2: Products (Ürünler)
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL CONSTRAINT DF_Products_Stock DEFAULT (0),
    CategoryID INT NOT NULL,
    CONSTRAINT CK_Products_Price CHECK (Price >= 0),
    CONSTRAINT CK_Products_Stock CHECK (Stock >= 0),
    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID)
);

-- GÖREV 3: Customers (Müşteriler)
CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) CONSTRAINT PK_Customers PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    City VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);

-- GÖREV 4: Orders (Siparişler)
CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL CONSTRAINT DF_Orders_OrderDate DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL CONSTRAINT DF_Orders_TotalAmount DEFAULT (0),
    CONSTRAINT CK_Orders_TotalAmount CHECK (TotalAmount >= 0),
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

-- GÖREV 5: OrderDetails (Sipariş Detayları / Ara Tablo)
CREATE TABLE dbo.OrderDetails (
    DetailID INT IDENTITY(1,1) CONSTRAINT PK_OrderDetails PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT CK_OrderDetails_Quantity CHECK (Quantity > 0),
    CONSTRAINT UQ_OrderDetails_Order_Product UNIQUE (OrderID, ProductID),
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO

-- BÖLÜM 3: ÖRNEK VERİ GİRİŞİ (DML / INSERT)

-- GÖREV 1: Beş kategori eklenmesi
INSERT INTO dbo.Categories (CategoryName) VALUES
(N'Elektronik'),
(N'Giyim'),
(N'Kitap'),
(N'Kozmetik'),
(N'Ev ve Yaşam');

-- GÖREV 2: Kategorilere bağlı on iki ürün eklenmesi
INSERT INTO dbo.Products (ProductName, Price, Stock, CategoryID) VALUES
(N'Kablosuz Kulaklık',       1299.90,  8, 1),
(N'Mekanik Klavye',          1899.50, 17, 1),
(N'USB-C Şarj Adaptörü',      749.00, 34, 1),
(N'Kapüşonlu Sweatshirt',     899.90, 25, 2),
(N'Keten Gömlek',             679.50, 12, 2),
(N'Bilim Kurgu Romanı',       249.90, 48, 3),
(N'Veri Tabanı Tasarımı',     389.00, 15, 3),
(N'Nemlendirici Krem',        329.90, 22, 4),
(N'Doğal Şampuan',            219.50,  9, 4),
(N'Masa Lambası',             549.90, 19, 5),
(N'Bambu Düzenleyici',        299.00, 31, 5),
(N'Pamuklu Nevresim Takımı', 1199.00, 14, 5);

-- GÖREV 3: Altı müşteri kaydı oluşturulması
INSERT INTO dbo.Customers (FullName, City, Email) VALUES
(N'Ahmet Yılmaz',  N'İstanbul', N'ahmet.yilmaz@novastore.example'),
(N'Ayşe Demir',    N'Ankara',   N'ayse.demir@novastore.example'),
(N'Mert Kaya',     N'İzmir',    N'mert.kaya@novastore.example'),
(N'Elif Arslan',   N'Bursa',    N'elif.arslan@novastore.example'),
(N'Can Çelik',     N'Antalya',  N'can.celik@novastore.example'),
(N'Zeynep Şahin',  N'Eskişehir',N'zeynep.sahin@novastore.example');

-- GÖREV 4: Farklı tarihlerde on sipariş oluşturulması
-- TotalAmount değerleri, sipariş detayları eklendikten sonra ürün fiyatlarından hesaplanır.
INSERT INTO dbo.Orders (CustomerID, OrderDate) VALUES
(1, DATEADD(DAY, -42, GETDATE())),
(2, DATEADD(DAY, -35, GETDATE())),
(1, DATEADD(DAY, -28, GETDATE())),
(3, DATEADD(DAY, -21, GETDATE())),
(4, DATEADD(DAY, -17, GETDATE())),
(5, DATEADD(DAY, -12, GETDATE())),
(2, DATEADD(DAY,  -9, GETDATE())),
(6, DATEADD(DAY,  -6, GETDATE())),
(3, DATEADD(DAY,  -3, GETDATE())),
(1, DATEADD(DAY,  -1, GETDATE()));

-- Her siparişe ait ürün ve miktar bilgilerinin eklenmesi
INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity) VALUES
(1,  1, 1), (1,  6, 2),
(2,  4, 1), (2,  8, 2),
(3,  2, 1), (3,  7, 1), (3, 11, 2),
(4,  3, 2), (4, 10, 1),
(5,  5, 2), (5,  9, 1),
(6, 12, 1), (6,  8, 1),
(7,  6, 3), (7, 11, 1),
(8,  4, 2), (8, 10, 2),
(9,  1, 1), (9,  9, 2),
(10, 3, 1), (10, 5, 1), (10, 12, 1);

-- Sipariş toplamlarının sipariş detaylarından hesaplanması
UPDATE o
SET TotalAmount = totals.CalculatedTotal
FROM dbo.Orders AS o
INNER JOIN (
    SELECT od.OrderID, SUM(p.Price * od.Quantity) AS CalculatedTotal
    FROM dbo.OrderDetails AS od
    INNER JOIN dbo.Products AS p ON p.ProductID = od.ProductID
    GROUP BY od.OrderID
) AS totals ON totals.OrderID = o.OrderID;
GO

-- BÖLÜM 4: SORGULAMA VE ANALİZ (DQL)

-- SORGU 1 - TEMEL LİSTELEME
-- Stok miktarı 20'den az olan ürünleri stok miktarına göre azalan sıralar.
SELECT ProductName, Stock
FROM dbo.Products
WHERE Stock < 20
ORDER BY Stock DESC;

-- SORGU 2 - VERİ BİRLEŞTİRME (INNER JOIN)
-- Hangi müşterinin hangi tarihte sipariş verdiğini ve sipariş tutarını gösterir.
SELECT c.FullName AS CustomerName,
       c.City,
       o.OrderDate,
       o.TotalAmount
FROM dbo.Customers AS c
INNER JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC;

-- SORGU 3 - ÇOKLU JOIN VE DETAY RAPORU
-- Ahmet Yılmaz'ın aldığı ürünleri, fiyatlarını ve kategorilerini listeler.
SELECT c.FullName AS CustomerName,
       o.OrderDate,
       p.ProductName,
       p.Price,
       od.Quantity,
       cat.CategoryName
FROM dbo.Customers AS c
INNER JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
INNER JOIN dbo.OrderDetails AS od ON od.OrderID = o.OrderID
INNER JOIN dbo.Products AS p ON p.ProductID = od.ProductID
INNER JOIN dbo.Categories AS cat ON cat.CategoryID = p.CategoryID
WHERE c.FullName = N'Ahmet Yılmaz'
ORDER BY o.OrderDate, p.ProductName;

-- SORGU 4 - GRUPLAMA VE AGGREGATE
-- Her kategorideki toplam ürün çeşidi sayısını gösterir.
SELECT cat.CategoryName,
       COUNT(p.ProductID) AS ProductCount
FROM dbo.Categories AS cat
LEFT JOIN dbo.Products AS p ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY ProductCount DESC, cat.CategoryName;

-- SORGU 5 - CİRO ANALİZİ
-- Her müşterinin şirkete kazandırdığı toplam ciroyu büyükten küçüğe sıralar.
SELECT c.FullName AS CustomerName,
       COALESCE(SUM(o.TotalAmount), 0) AS TotalRevenue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalRevenue DESC, c.FullName;

-- SORGU 6 - ZAMAN ANALİZİ
-- Her siparişin üzerinden bugüne kadar kaç gün geçtiğini hesaplar.
SELECT o.OrderID,
       c.FullName AS CustomerName,
       o.OrderDate,
       DATEDIFF(DAY, o.OrderDate, GETDATE()) AS DaysSinceOrder
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC;
GO

-- BÖLÜM 5: İLERİ SEVİYE VERİ TABANI NESNELERİ

-- GÖREV 1 - VIEW OLUŞTURMA
-- Müşteri, sipariş, ürün ve adet bilgilerini tek görünümde birleştirir.
CREATE VIEW dbo.vw_SiparisOzet AS
SELECT c.FullName AS CustomerName,
       o.OrderDate,
       p.ProductName,
       od.Quantity
FROM dbo.Customers AS c
INNER JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
INNER JOIN dbo.OrderDetails AS od ON od.OrderID = o.OrderID
INNER JOIN dbo.Products AS p ON p.ProductID = od.ProductID;
GO

-- Oluşturulan VIEW'in çalışmasını doğrular.
SELECT *
FROM dbo.vw_SiparisOzet
ORDER BY OrderDate DESC, CustomerName, ProductName;
GO

-- GÖREV 2 - VERİ TABANI YEDEĞİ
-- SQL Server servis hesabının C:\Yedek klasörüne yazma izni olmalıdır.
BACKUP DATABASE NovaStoreDB
TO DISK = N'C:\Yedek\NovaStoreDB.bak'
WITH INIT, NAME = N'NovaStoreDB Tam Yedek';
GO
