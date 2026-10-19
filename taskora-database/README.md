# NovaStore Database

NovaStore, Microsoft SQL Server ve T-SQL ile hazırlanmış ilişkisel bir e-ticaret veritabanı projesidir. Veritabanı adı `NovaStoreDB`'dir.

## Teslim dosyaları

| Dosya | İçerik |
| --- | --- |
| [YigitKaanBilir_NovaStore_Proje.sql](YigitKaanBilir_NovaStore_Proje.sql) | Veritabanı, tablolar, örnek veriler, altı analiz sorgusu, VIEW ve BACKUP komutu |
| [YigitKaanBilir_NovaStore_Proje.docx](YigitKaanBilir_NovaStore_Proje.docx) | Kod açıklamaları, gerçek sorgu sonuçları, ilişki şeması ve tam SQL eki |
| [YigitKaanBilir_NovaStore_Proje.png](YigitKaanBilir_NovaStore_Proje.png) | Beş tablonun Primary Key ve Foreign Key ilişkilerini gösteren şema |

Form tesliminde bu üç dosya ayrı alanlara yüklenir. `screenshots/` klasörü raporda kullanılan gerçek sonuç görsellerini içerir.

## Veri modeli

| Tablo | Amaç | Temel ilişki |
| --- | --- | --- |
| `Categories` | Ürün kategorileri | Bir kategori, birden fazla ürüne sahiptir |
| `Products` | Ürün, fiyat ve stok bilgileri | Her ürün bir kategoriye bağlıdır |
| `Customers` | Müşteri, şehir ve benzersiz e-posta bilgileri | Bir müşteri, birden fazla sipariş verebilir |
| `Orders` | Sipariş tarihi ve toplam tutar | Her sipariş bir müşteriye bağlıdır |
| `OrderDetails` | Siparişteki ürün ve miktar | Siparişler ile ürünler arasındaki ara tablodur |

Örnek veri setinde 5 kategori, 12 ürün, 6 müşteri, 10 sipariş ve 22 sipariş detayı bulunur.

## İçerik

SQL dosyası aşağıdaki işlemleri tek akışta gerçekleştirir:

1. `NovaStoreDB` veritabanını oluşturur.
2. Beş tabloyu Primary Key, Foreign Key, UNIQUE, CHECK ve DEFAULT kısıtlarıyla kurar.
3. İlişkili örnek kayıtları ekler ve sipariş toplamlarını ürün fiyatlarından hesaplar.
4. Altı zorunlu analiz sorgusunu çalıştırır:
   - Stoku 20'nin altında olan ürünler
   - Müşteri ve sipariş birleştirmesi
   - Ahmet Yılmaz için çoklu JOIN raporu
   - Kategori bazında ürün sayısı
   - Müşteri bazında toplam ciro
   - Siparişlerin üzerinden geçen gün sayısı
5. `dbo.vw_SiparisOzet` görünümünü oluşturur ve sorgular.
6. `NovaStoreDB` için tam yedek alır.

## SQL Server üzerinde çalıştırma

1. SQL Server Management Studio ile yeni veritabanı oluşturma yetkisi bulunan bir sunucuya bağlanın.
2. SQL Server'ın çalıştığı Windows makinede `C:\Yedek` klasörünü oluşturun.
3. SQL Server servis hesabına bu klasör için yazma izni verin.
4. [SQL dosyasını](YigitKaanBilir_NovaStore_Proje.sql) SSMS içinde UTF-8 olarak açın.
5. Dosyanın tamamını çalıştırın.
6. Object Explorer içinde `NovaStoreDB`, beş tablo ve `dbo.vw_SiparisOzet` görünümünü kontrol edin.
7. `C:\Yedek\NovaStoreDB.bak` dosyasının oluştuğunu doğrulayın.

Aynı isimde `NovaStoreDB` zaten varsa scripti çalıştırmadan önce mevcut veritabanını koruyup korumayacağınıza karar verin. Dosya yeni bir kurulum için hazırlanmıştır.

## Doğrulama

Proje Microsoft SQL Server 2022 üzerinde sıfırdan çalıştırılmıştır. Doğrulanan sonuçlar:

- 5 tablo ve 4 Foreign Key
- 5 kategori, 12 ürün, 6 müşteri, 10 sipariş, 22 sipariş detayı
- Altı sorguda geçerli sonuç kümesi
- `dbo.vw_SiparisOzet` görünümü
- Başarılı `BACKUP DATABASE`
- Başarılı `RESTORE VERIFYONLY`

## Geliştirici

Yiğit Kaan Bilir
