-- ==================================================
-- TASKORA VERİ TABANI PROJESİ
-- Geliştirici: Yiğit Kaan Bilir
-- ==================================================
-- Microsoft SQL Server / T-SQL. Yeni bir TaskoraDB üzerinde bir kez çalıştırın.

-- BÖLÜM 1: VERİ TABANI OLUŞTURMA
USE master;
GO

-- Türkçe karakterleri VARCHAR alanlarında korumak için Türkçe harmanlama kullanılır.
CREATE DATABASE TaskoraDB COLLATE Turkish_100_CI_AS;
GO

USE TaskoraDB;
GO

-- BÖLÜM 2: TABLOLARIN OLUŞTURULMASI
-- Önce bağımsız tablolar, sonra foreign key kullanan tablolar oluşturulur.
CREATE TABLE dbo.Users (
    UserID INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Role VARCHAR(30) NOT NULL,
    CONSTRAINT UQ_Users_Email UNIQUE (Email)
);

CREATE TABLE dbo.Projects (
    ProjectID INT IDENTITY(1,1) CONSTRAINT PK_Projects PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Description VARCHAR(500) NULL,
    StartDate DATETIME NOT NULL CONSTRAINT DF_Projects_StartDate DEFAULT GETDATE(),
    Status VARCHAR(30) NOT NULL
);

CREATE TABLE dbo.Tasks (
    TaskID INT IDENTITY(1,1) CONSTRAINT PK_Tasks PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    Description VARCHAR(500) NULL,
    Status VARCHAR(30) NOT NULL,
    Priority VARCHAR(20) NOT NULL,
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_Tasks_CreatedAt DEFAULT GETDATE(),
    DueDate DATETIME NULL,
    ProjectID INT NOT NULL,
    AssigneeID INT NOT NULL,
    CONSTRAINT FK_Tasks_Projects FOREIGN KEY (ProjectID) REFERENCES dbo.Projects(ProjectID),
    CONSTRAINT FK_Tasks_Users FOREIGN KEY (AssigneeID) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_Tasks_Status CHECK (Status IN ('pending', 'in_progress', 'completed')),
    CONSTRAINT CK_Tasks_Priority CHECK (Priority IN ('low', 'medium', 'high'))
);

CREATE TABLE dbo.TaskComments (
    CommentID INT IDENTITY(1,1) CONSTRAINT PK_TaskComments PRIMARY KEY,
    TaskID INT NOT NULL,
    UserID INT NOT NULL,
    CommentText VARCHAR(500) NOT NULL,
    CreatedAt DATETIME NOT NULL CONSTRAINT DF_TaskComments_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_TaskComments_Tasks FOREIGN KEY (TaskID) REFERENCES dbo.Tasks(TaskID),
    CONSTRAINT FK_TaskComments_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
);

CREATE TABLE dbo.ProjectMembers (
    ProjectMemberID INT IDENTITY(1,1) CONSTRAINT PK_ProjectMembers PRIMARY KEY,
    ProjectID INT NOT NULL,
    UserID INT NOT NULL,
    JoinedAt DATETIME NOT NULL CONSTRAINT DF_ProjectMembers_JoinedAt DEFAULT GETDATE(),
    CONSTRAINT FK_ProjectMembers_Projects FOREIGN KEY (ProjectID) REFERENCES dbo.Projects(ProjectID),
    CONSTRAINT FK_ProjectMembers_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT UQ_ProjectMembers_Project_User UNIQUE (ProjectID, UserID)
);
GO

-- BÖLÜM 3: ÖRNEK VERİLER
-- IDENTITY değerleri yeni veritabanında ekleme sırasıyla 1'den başlar.
INSERT INTO dbo.Users (FullName, Email, Role) VALUES
(N'Yiğit Kaan Bilir', 'yigit.bilir@taskora.example', 'Developer'),
(N'Ayşe Demir', 'ayse.demir@taskora.example', 'Developer'),
(N'Mert Yılmaz', 'mert.yilmaz@taskora.example', 'Developer'),
(N'Elif Kaya', 'elif.kaya@taskora.example', 'Designer'),
(N'Can Arslan', 'can.arslan@taskora.example', 'Developer'),
(N'Zeynep Çelik', 'zeynep.celik@taskora.example', 'Tester');

INSERT INTO dbo.Projects (ProjectName, Description, StartDate, Status) VALUES
(N'Taskora Backend API', N'Görev yönetimi REST API geliştirmesi.', DATEADD(DAY, -45, GETDATE()), 'active'),
(N'Taskora Web Uygulaması', N'React ile görev paneli geliştirmesi.', DATEADD(DAY, -35, GETDATE()), 'active'),
(N'Taskora Mobil Uygulama', N'Flutter ile mobil görev ekranları.', DATEADD(DAY, -20, GETDATE()), 'planning'),
(N'Veritabanı Entegrasyonu', N'SQL Server veri modeli ve sorguları.', DATEADD(DAY, -15, GETDATE()), 'active'),
(N'Test ve Dokümantasyon', N'İleride yürütülecek test ve dokümantasyon çalışmaları.', DATEADD(DAY, -5, GETDATE()), 'planning');

-- Son proje bilerek görevsiz bırakılmıştır; LEFT JOIN sorgusunu gösterir.
INSERT INTO dbo.ProjectMembers (ProjectID, UserID, JoinedAt) VALUES
(1, 1, DATEADD(DAY, -40, GETDATE())), (1, 2, DATEADD(DAY, -39, GETDATE())),
(1, 3, DATEADD(DAY, -38, GETDATE())), (2, 1, DATEADD(DAY, -32, GETDATE())),
(2, 4, DATEADD(DAY, -31, GETDATE())), (2, 5, DATEADD(DAY, -30, GETDATE())),
(3, 3, DATEADD(DAY, -18, GETDATE())), (3, 4, DATEADD(DAY, -17, GETDATE())),
(3, 2, DATEADD(DAY, -16, GETDATE())), (4, 1, DATEADD(DAY, -12, GETDATE())),
(4, 5, DATEADD(DAY, -11, GETDATE())), (4, 3, DATEADD(DAY, -10, GETDATE())),
(5, 6, DATEADD(DAY, -4, GETDATE()));

-- Altıncı kullanıcı bilerek görevsizdir; kullanıcı analizinde sıfır görünür.
INSERT INTO dbo.Tasks (Title, Description, Status, Priority, CreatedAt, DueDate, ProjectID, AssigneeID) VALUES
(N'Görev API''sini hazırlama', N'Listeleme ve detay endpointleri.', 'completed', 'high', DATEADD(DAY, -30, GETDATE()), DATEADD(DAY, -18, GETDATE()), 1, 1),
(N'JSON veri kaydını geliştirme', N'Dosya okuma ve yazma işlemleri.', 'completed', 'medium', DATEADD(DAY, -28, GETDATE()), DATEADD(DAY, -15, GETDATE()), 1, 2),
(N'Hata yönetimini tamamlama', N'400 ve 404 yanıtlarını kontrol etme.', 'pending', 'high', DATEADD(DAY, -6, GETDATE()), DATEADD(DAY, 4, GETDATE()), 1, 3),
(N'Dashboard tasarımını oluşturma', N'İstatistik ve görev kartları.', 'completed', 'high', DATEADD(DAY, -25, GETDATE()), DATEADD(DAY, -10, GETDATE()), 2, 1),
(N'Görev formunu geliştirme', N'Ekleme ve düzenleme formu.', 'in_progress', 'high', DATEADD(DAY, -12, GETDATE()), DATEADD(DAY, 3, GETDATE()), 2, 4),
(N'Mobil görünümü iyileştirme', N'Dar ekran yerleşimini kontrol etme.', 'pending', 'medium', DATEADD(DAY, -4, GETDATE()), DATEADD(DAY, 8, GETDATE()), 2, 5),
(N'Flutter proje iskeletini kurma', N'Mobil uygulama başlangıcı.', 'pending', 'high', DATEADD(DAY, -8, GETDATE()), DATEADD(DAY, 10, GETDATE()), 3, 3),
(N'Görev detay ekranını tasarlama', N'Mobil görev bilgileri ekranı.', 'in_progress', 'medium', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, 14, GETDATE()), 3, 4),
(N'Bildirim akışını planlama', N'Mobil bildirim senaryoları.', 'pending', 'low', DATEADD(DAY, -2, GETDATE()), NULL, 3, 2),
(N'İlişkisel şemayı hazırlama', N'Tablolar ve ilişkiler.', 'completed', 'high', DATEADD(DAY, -14, GETDATE()), DATEADD(DAY, -2, GETDATE()), 4, 1),
(N'SQL analiz sorgularını yazma', N'JOIN ve aggregate sorguları.', 'in_progress', 'high', DATEADD(DAY, -7, GETDATE()), DATEADD(DAY, 5, GETDATE()), 4, 5),
(N'Yedekleme adımlarını belgeleme', N'Backup komutu ve izinler.', 'pending', 'low', DATEADD(DAY, -1, GETDATE()), NULL, 4, 3);

INSERT INTO dbo.TaskComments (TaskID, UserID, CommentText, CreatedAt) VALUES
(1, 2, N'Endpointler kontrol edildi.', DATEADD(DAY, -20, GETDATE())),
(2, 1, N'JSON dosyası kalıcı olarak güncelleniyor.', DATEADD(DAY, -17, GETDATE())),
(3, 1, N'Geçersiz ID senaryosu eklenmeli.', DATEADD(DAY, -5, GETDATE())),
(4, 4, N'Kart tasarımı hazır.', DATEADD(DAY, -12, GETDATE())),
(5, 1, N'Form doğrulamasını da ekleyelim.', DATEADD(DAY, -8, GETDATE())),
(5, 4, N'Durum ve öncelik alanları eklendi.', DATEADD(DAY, -3, GETDATE())),
(6, 5, N'Tablet görünümü kontrol edilecek.', DATEADD(DAY, -2, GETDATE())),
(7, 3, N'İlk ekran akışı planlandı.', DATEADD(DAY, -4, GETDATE())),
(10, 5, N'Foreign key ilişkileri gözden geçirildi.', DATEADD(DAY, -2, GETDATE())),
(11, 1, N'LEFT JOIN örnekleri eklendi.', DATEADD(DAY, -1, GETDATE()));
GO

-- BÖLÜM 4: SORGULAMA VE ANALİZ
-- SORGU 1 - Temel listeleme: tamamlanmamış, yüksek öncelikli görevler.
SELECT TaskID, Title, Status, Priority
FROM dbo.Tasks
WHERE Status <> 'completed' AND Priority = 'high'
ORDER BY CASE WHEN DueDate IS NULL THEN 1 ELSE 0 END, DueDate, TaskID;

-- SORGU 2 - INNER JOIN: her görevin projesi ve atanan kullanıcısı.
SELECT t.Title AS TaskTitle, p.ProjectName, u.FullName AS AssigneeName,
       t.Status, t.Priority
FROM dbo.Tasks AS t
INNER JOIN dbo.Projects AS p ON p.ProjectID = t.ProjectID
INNER JOIN dbo.Users AS u ON u.UserID = t.AssigneeID
ORDER BY p.ProjectName, t.TaskID;

-- SORGU 3 - Çoklu JOIN: Yiğit Kaan Bilir'e atanmış görevler.
SELECT t.Title AS TaskTitle, p.ProjectName, t.Status, t.Priority, t.DueDate
FROM dbo.Users AS u
INNER JOIN dbo.Tasks AS t ON t.AssigneeID = u.UserID
INNER JOIN dbo.Projects AS p ON p.ProjectID = t.ProjectID
WHERE u.FullName = N'Yiğit Kaan Bilir'
ORDER BY t.DueDate, t.TaskID;

-- SORGU 4 - LEFT JOIN + GROUP BY + COUNT: görevsiz projeler de görünür.
SELECT p.ProjectName, COUNT(t.TaskID) AS TaskCount
FROM dbo.Projects AS p
LEFT JOIN dbo.Tasks AS t ON t.ProjectID = p.ProjectID
GROUP BY p.ProjectID, p.ProjectName
ORDER BY TaskCount DESC, p.ProjectName;

-- SORGU 5 - Aggregate: görevsiz kullanıcılar dahil toplam ve tamamlanan görev.
SELECT u.FullName, COUNT(t.TaskID) AS TotalTasks,
       SUM(CASE WHEN t.Status = 'completed' THEN 1 ELSE 0 END) AS CompletedTasks
FROM dbo.Users AS u
LEFT JOIN dbo.Tasks AS t ON t.AssigneeID = u.UserID
GROUP BY u.UserID, u.FullName
ORDER BY TotalTasks DESC, u.FullName;

-- SORGU 6 - Zaman analizi: oluşturulmadan bugüne geçen gün sayısı.
SELECT Title AS TaskTitle, CreatedAt,
       DATEDIFF(DAY, CreatedAt, GETDATE()) AS DaysSinceCreated
FROM dbo.Tasks
ORDER BY CreatedAt, TaskID;
GO

-- BÖLÜM 5: SUBQUERY
-- EK SORGU - SUBQUERY
-- Kullanıcı başına ortalama görev sayısından daha fazla görevi olanlar.
-- Alt sorgu görevi olmayan kullanıcıları da ortalamaya dahil eder.
SELECT u.UserID, u.FullName, COUNT(t.TaskID) AS TotalTasks
FROM dbo.Users AS u
LEFT JOIN dbo.Tasks AS t ON t.AssigneeID = u.UserID
GROUP BY u.UserID, u.FullName
HAVING COUNT(t.TaskID) > (
    SELECT AVG(CAST(TaskCount AS DECIMAL(10,2)))
    FROM (
        SELECT COUNT(t2.TaskID) AS TaskCount
        FROM dbo.Users AS u2
        LEFT JOIN dbo.Tasks AS t2 ON t2.AssigneeID = u2.UserID
        GROUP BY u2.UserID
    ) AS UserTaskCounts
)
ORDER BY TotalTasks DESC, u.FullName;
GO

-- BÖLÜM 6: VIEW
-- CREATE VIEW ayrı batch içinde ilk komut olmalıdır.
CREATE VIEW dbo.vw_TaskoraGorevOzet AS
SELECT t.TaskID, t.Title AS TaskTitle, p.ProjectName,
       u.FullName AS AssigneeName, t.Status, t.Priority,
       t.CreatedAt, t.DueDate
FROM dbo.Tasks AS t
INNER JOIN dbo.Projects AS p ON p.ProjectID = t.ProjectID
INNER JOIN dbo.Users AS u ON u.UserID = t.AssigneeID;
GO

-- Oluşturulan VIEW'i kullanma örneği.
SELECT * FROM dbo.vw_TaskoraGorevOzet;
GO

-- BÖLÜM 7: BACKUP
-- C:\Yedek klasörü SQL Server'ın çalıştığı makinede bulunmalı; servis hesabı yazabilmelidir.
BACKUP DATABASE TaskoraDB
TO DISK = N'C:\Yedek\TaskoraDB.bak'
WITH INIT, NAME = N'TaskoraDB Full Backup';
GO
