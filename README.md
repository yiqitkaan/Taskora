# Taskora

Taskora; görev ve ekip yönetimi için backend, web, veritabanı ve mobil bileşenlerini tek depoda birleştiren bir yazılım projesidir.

**Geliştirici:** Yiğit Kaan Bilir

**Repository:** <https://github.com/yiqitkaan/Taskora>

## Modüller

| Sıra | Modül | Teknolojiler | Veri kaynağı | Öne çıkan özellikler |
| --- | --- | --- | --- | --- |
| 1 | Backend | Node.js, Express.js, JavaScript, REST API | Yerel JSON | CRUD, routing, logger ve istek doğrulama |
| 2 | Web | React, JavaScript, Vite, Tailwind CSS | LocalStorage | CRUD, arama, filtreleme ve kalıcılık çalışıyor |
| 3 | Database / SQL | Microsoft SQL Server, T-SQL | TaskoraDB | İlişkisel veri katmanı geliştirme aşamasında |
| 4 | Mobile | Flutter, Dart, Material Design | Cihazda kalıcı yerel JSON | Giriş, kayıt ve çevrim dışı görev yönetimi |

## 1. Taskora Backend

[`taskora-backend/`](taskora-backend/) altında Node.js ve Express.js ile geliştirilen görev yönetimi REST API'si bulunur.

### Özellikler

- Görev oluşturma, listeleme, detay görüntüleme, güncelleme ve silme
- Controller ve router katmanlarının ayrılması
- Method, endpoint ve zaman damgası yazan logger middleware
- JSON dosyasında kalıcı görev verisi
- Durum ve öncelik filtreleri
- Zorunlu alan, enum, ID ve bozuk JSON kontrolleri
- Açıklayıcı `400`, `404` ve `500` hata cevapları

### Çalıştırma

```bash
cd taskora-backend
npm ci
npm start
```

API varsayılan olarak `http://localhost:3000` adresinde çalışır.

| Method | Endpoint | İşlem |
| --- | --- | --- |
| `POST` | `/tasks` | Yeni görev oluşturur |
| `GET` | `/tasks` | Bütün görevleri listeler |
| `GET` | `/tasks/:id` | Belirli görevi getirir |
| `PUT` | `/tasks/:id` | Görevin gönderilen alanlarını günceller |
| `DELETE` | `/tasks/:id` | Görevi siler |

Ayrıntılı kurulum, istek örnekleri ve hata cevapları için [Backend README](taskora-backend/README.md), ekran görüntüsü akışı için [Postman Test Rehberi](taskora-backend/POSTMAN_TESTLERI.md) kullanılmalıdır.

## 2. Taskora Web

[`taskora-web/`](taskora-web/) altında React ve Vite ile geliştirilen tarayıcı tabanlı görev yönetimi arayüzü bulunur.

### Özellikler

- Görev ekleme, listeleme, düzenleme ve silme
- Durum ve öncelik filtreleri
- Başlık ve açıklamada arama
- Görev durumlarına göre canlı istatistikler
- LocalStorage ile tarayıcıda kalıcı kayıt
- Netlify dağıtım yapılandırması

### Çalıştırma

```bash
cd taskora-web
npm ci
npm run dev
```

Production kontrolü:

```bash
npm run build
npm run preview
```

Ayrıntılar için [Web README](taskora-web/README.md) dosyasına bakın.

## 3. Taskora Database / SQL

Microsoft SQL Server ve T-SQL tabanlı `TaskoraDB` veri katmanı geliştirme aşamasındadır. Hedef şema; kullanıcılar, projeler, görevler, yorumlar ve proje üyelikleri arasındaki ilişkileri kapsar.

## 4. Taskora Mobile

[`taskora-mobile/`](taskora-mobile/) altında Flutter ve Dart ile geliştirilen mobil görev yönetimi uygulaması bulunur.

### Özellikler

- JSON tabanlı demo giriş, yeni kullanıcı kaydı ve çıkış
- Görevler için kart ve liste görünümü
- Görev ekleme, düzenleme, arama, filtreleme ve durum güncelleme
- Görev detaylarında yerel görsel asset'leri
- Android SharedPreferences ve iOS UserDefaults içinde JSON kalıcılığı
- Model sınıflarında `fromJson` ve `toJson`
- Navigator ve route arguments ile ekranlar arası veri aktarımı

### Çalıştırma

```bash
cd taskora-mobile
flutter pub get
flutter run
```

Kalite kontrolleri:

```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build ios --simulator --no-codesign
```

Ayrıntılar için [Mobile README](taskora-mobile/README.md) ve [Mobil Gereksinim Kontrolü](taskora-mobile/MOBILE_GEREKSINIM_KONTROLU.md) dosyalarına bakın.

## Mevcut Veri Mimarisi

Modüller bağımsız çalışacak şekilde hazırlanmıştır:

```text
Taskora Backend  ──> src/data/tasks.json
Taskora Web      ──> Browser LocalStorage
Taskora Database ──> Microsoft SQL Server / TaskoraDB (planlanan)
Taskora Mobile   ──> Android SharedPreferences / iOS UserDefaults
```

Hedeflenen sonraki entegrasyon:

```text
Taskora Web ────┐
                ├──> Taskora Backend ──> TaskoraDB
Taskora Mobile ─┘
```

Web ve Mobile uygulamaları şu anda Backend API'ye istek göndermez. Backend de TaskoraDB yerine yerel JSON dosyası kullanır.

## Depo Yapısı

```text
Taskora/
├── taskora-backend/                 # Node.js / Express REST API
├── taskora-web/                     # React / Vite web uygulaması
└── taskora-mobile/                  # Flutter mobil uygulaması
```

## Dokümantasyon

- [Backend proje dokümanı](taskora-backend/docs/Taskora_Backend_Proje_Tanitim_Dokumani.pdf)
- [Backend Postman testleri](taskora-backend/POSTMAN_TESTLERI.md)
- [Web ekran görüntüleri](taskora-web/screenshots/)
- [Mobile ekran görüntüleri](taskora-mobile/screenshots/)

Her modülün çalıştırma ve test ayrıntıları kendi README dosyasında tutulur.
