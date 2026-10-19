# Taskora Database

## Proje Hakkında

Taskora'nın görev ve ekip yönetimi için hazırlanmış ilişkisel veri katmanıdır. **Microsoft SQL Server / T-SQL** kullanır. Veritabanı adı **TaskoraDB**'dir. Mevcut Taskora Backend yerel JSON dosyası, Taskora Web ise LocalStorage kullanır. Backend'in SQL Server'a bağlanması sonraki geliştirme aşamasıdır.

## Tablolar

| Tablo | Amaç |
| --- | --- |
| `Users` | Kullanıcı adı, benzersiz e-posta ve rol |
| `Projects` | Proje bilgileri, başlangıç tarihi ve durum |
| `Tasks` | Görev, öncelik, durum, teslim tarihi, proje ve sorumlu |
| `TaskComments` | Görev yorumları ve yorum yazarı |
| `ProjectMembers` | Proje üyelikleri; aynı kullanıcı bir projeye bir kez eklenebilir |

## Tablo İlişkileri

```text
Users    1 --- N Tasks          (AssigneeID)
Projects 1 --- N Tasks          (ProjectID)
Tasks    1 --- N TaskComments   (TaskID)
Users    1 --- N TaskComments   (UserID)
Users    N --- N Projects       (ProjectMembers üzerinden)
```

`ProjectMembers` tablosunda `ProjectID` ve `UserID` birlikte benzersizdir. Örnek veride 6 kullanıcı, 5 proje, 12 görev, 10 yorum ve 13 proje üyeliği vardır. Son proje görevsiz, son kullanıcı ise üzerine görev atanmamış şekilde bırakılmıştır; böylece `LEFT JOIN` sonuçlarında sıfır sayıları görülebilir.

## SQL Dosyasını Çalıştırma

1. Bir Microsoft SQL Server örneğine SQL Server Management Studio (SSMS) ile bağlanın. Yeni veritabanı oluşturma izni gereklidir.
2. [YigitKaanBilir_Taskora_Proje.sql](YigitKaanBilir_Taskora_Proje.sql) dosyasını UTF-8 olarak açın. **TaskoraDB zaten varsa** dosyayı tekrar çalıştırmayın; script yeni veritabanı için tek seferliktir.
3. `C:\Yedek` klasörünü **SQL Server'ın çalıştığı makinede** oluşturun ve SQL Server servis hesabına yazma izni verin. Bu mümkün değilse önce 1–6. bölümleri çalıştırın; 7. bölümdeki backup komutunu uygun ortamda ayrıca çalıştırın.
4. Tüm scripti çalıştırın. `GO` batch ayırıcıları özellikle `CREATE DATABASE` ve `CREATE VIEW` için gereklidir.
5. Object Explorer'da `TaskoraDB` altındaki tabloları ve `dbo.vw_TaskoraGorevOzet` görünümünü kontrol edin. Sorgu sonuçlarını gerçek SQL Server ekranından alın.

SQL dosyası Türkçe metinleri `N'...'` Unicode literal olarak ekler ve `VARCHAR` alanlarının Türkçe karakterleri koruması için `Turkish_100_CI_AS` harmanlamasıyla veritabanını oluşturur.

## Sorgular ve VIEW

Dosyada altı temel analiz sorgusu bulunur: tamamlanmamış yüksek öncelikli görevler; görev–proje–kullanıcı JOIN'i; Yiğit Kaan Bilir'e atanan görevler; proje başına görev sayısı; kullanıcı başına toplam ve tamamlanan görev sayısı; görevlerin oluşturulmasından geçen günler. Ek subquery, ortalama görev sayısından fazla görevi olan kullanıcıları listeler.

`dbo.vw_TaskoraGorevOzet` görünümü görev adı, proje, sorumlu, durum, öncelik ve tarihleri tek sorguda sunar. Oluşturulduktan sonra `SELECT * FROM dbo.vw_TaskoraGorevOzet;` ile okunur.

## Backup ve Doğrulama

Son bölüm `TaskoraDB` veritabanını `C:\Yedek\TaskoraDB.bak` konumuna yedekleyen `BACKUP DATABASE` komutudur. Bu yol SQL Server makinesine aittir; klasör ve yazma izni yoksa komut hata verir.

SQL dosyası Microsoft SQL Server 2022 üzerinde temiz bir veritabanında baştan sona çalıştırılmıştır. 6 kullanıcı, 5 proje, 12 görev, 10 yorum, 13 proje üyeliği, 6 Foreign Key ve `dbo.vw_TaskoraGorevOzet` görünümü doğrulanmıştır. Oluşturulan yedek `RESTORE VERIFYONLY` komutuyla geçerli bulunmuştur.

## Geliştirici

Yiğit Kaan Bilir
