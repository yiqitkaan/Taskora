# Taskora Backend

Taskora Backend, yazılım ekiplerinin görevlerini oluşturup takip edebilmesi için Node.js ve Express.js ile geliştirilmiş bir REST API eğitim projesidir. Görevler bu sürümde `src/data/tasks.json` dosyasında saklanır; SQL Server entegrasyonu bu teslimin kapsamına dahil değildir.

**Geliştirici:** Yiğit Kaan Bilir

**Program:** Software Persona Yazılım / Kariyer Merkezi / 18. Dönem

**Repository:** <https://github.com/yiqitkaan/Taskora>

## Özellikler

- Yeni görev oluşturma
- Bütün görevleri listeleme
- ID ile görev detayı görüntüleme
- Görevin seçilen alanlarını güncelleme
- Görev silme
- Durum ve önceliğe göre filtreleme
- JSON dosyasında kalıcı veri saklama
- Her istekte method, endpoint ve zaman damgası yazan logger middleware
- Görev alanları, ID biçimi ve JSON gövdesi için hata kontrolleri
- Açıklayıcı HTTP durum kodları ve JSON hata cevapları

## Teknolojiler

- Node.js 18 veya üzeri
- Express.js 4
- JavaScript (CommonJS)
- REST API
- JSON dosya sistemi
- Postman

## Kurulum

### 1. Depoyu indirin

```bash
git clone https://github.com/yiqitkaan/Taskora.git
cd Taskora/taskora-backend
```

Proje zaten bilgisayarınızdaysa:

```bash
cd /Users/yiqitkaan/Desktop/Taskora/taskora-backend
```

### 2. Bağımlılıkları kurun

Kilit dosyasındaki sürümleri birebir kurmak için:

```bash
npm ci
```

Geliştirme sırasında kilit dosyasını güncellemek gerekiyorsa `npm install` da kullanılabilir.

### 3. Sunucuyu başlatın

```bash
npm start
```

Başarılı başlangıç mesajı:

```text
Taskora API http://localhost:3000 adresinde çalışıyor.
```

Farklı port kullanmak için:

```bash
PORT=4000 npm start
```

## Veri Modeli

| Alan | Tür | Açıklama |
| --- | --- | --- |
| `id` | number | Sunucu tarafından oluşturulan pozitif görev ID'si |
| `title` | string | Görev başlığı; zorunludur |
| `description` | string | Görev açıklaması; gönderilmezse boş metin olur |
| `status` | string | `pending`, `in_progress` veya `completed`; zorunludur |
| `priority` | string | `low`, `medium` veya `high`; zorunludur |
| `assignee` | string | Göreve atanan kişi; zorunludur |
| `projectId` | number/null | Pozitif proje ID'si; gönderilmezse `null` olur |
| `createdAt` | ISO 8601 string | Sunucu tarafından oluşturulur |
| `updatedAt` | ISO 8601 string | Oluşturma ve güncellemede sunucu tarafından yazılır |

## API Endpointleri

| Method | Endpoint | Başarılı cevap | Açıklama |
| --- | --- | --- | --- |
| `POST` | `/tasks` | `201 Created` | Yeni görev oluşturur |
| `GET` | `/tasks` | `200 OK` | Tüm görevleri listeler |
| `GET` | `/tasks/:id` | `200 OK` | Belirli görevi getirir |
| `PUT` | `/tasks/:id` | `200 OK` | Gönderilen görev alanlarını günceller |
| `DELETE` | `/tasks/:id` | `200 OK` | Görevi siler |

### Görev oluşturma

`POST http://localhost:3000/tasks`

```json
{
  "title": "Postman API testi",
  "description": "CRUD isteklerini kontrol et",
  "status": "pending",
  "priority": "high",
  "assignee": "Yiğit Kaan Bilir",
  "projectId": 1
}
```

Sunucu `id`, `createdAt` ve `updatedAt` alanlarını kendisi ekler.

### Görevleri listeleme ve filtreleme

```http
GET /tasks
GET /tasks?status=completed
GET /tasks?priority=high
GET /tasks?status=in_progress&priority=medium
```

### Görev detayı

```http
GET /tasks/1
```

### Görev güncelleme

`PUT` isteğinde yalnızca değiştirilecek alanlar gönderilebilir:

```json
{
  "status": "in_progress",
  "priority": "medium"
}
```

`id`, `createdAt` ve `updatedAt` istemci tarafından değiştirilemez. `updatedAt` başarılı güncellemede sunucu tarafından yenilenir.

### Görev silme

```http
DELETE /tasks/4
```

Başarılı cevap:

```json
{
  "message": "Görev başarıyla silindi."
}
```

## Hata Cevapları

| Durum | Örnek neden |
| --- | --- |
| `400 Bad Request` | Geçersiz ID, eksik alan, geçersiz status/priority, boş güncelleme veya bozuk JSON |
| `404 Not Found` | Görev ya da endpoint bulunamadı |
| `500 Internal Server Error` | JSON veri dosyasının okunamaması veya yazılamaması |

Hata cevapları şu biçimdedir:

```json
{
  "error": "Görev bulunamadı."
}
```

## Veri Saklama

Görevler [src/data/tasks.json](src/data/tasks.json) dosyasında tutulur. `POST`, `PUT` ve `DELETE` istekleri bu dosyayı değiştirir ve değişiklikler sunucu yeniden başlatıldığında korunur.

Ekran görüntüsü testinden önce başlangıç verisini yedeklemek için:

```bash
cp src/data/tasks.json /tmp/taskora-tasks-before-postman.json
```

Testten sonra geri yüklemek için önce sunucuyu `Ctrl+C` ile durdurun, ardından:

```bash
cp /tmp/taskora-tasks-before-postman.json src/data/tasks.json
```

## Logger Middleware

Logger bütün API isteklerinde method, orijinal endpoint ve saniye hassasiyetinde zaman damgasını terminale yazar:

```text
[2026-10-18 20:33:18] GET /tasks
[2026-10-18 20:33:19] POST /tasks
```

## Postman Testi ve Ekran Görüntüleri

Teslim için beş zorunlu CRUD isteği Postman üzerinde sırayla çalıştırılmalıdır. Ayrıntılı tıklama adımları, gövdeler, beklenen cevaplar, dosya isimleri ve veri geri yükleme işlemi [POSTMAN_TESTLERI.md](POSTMAN_TESTLERI.md) dosyasındadır.

Hazır koleksiyon dosyası Postman'e aktarılabilir:

```text
postman/Taskora_Backend.postman_collection.json
```

Ekran görüntüleri `screenshots/` klasörüne konulmalıdır.

## Doğrulanan Kontroller

18 Ekim 2026 tarihinde aşağıdaki akış gerçek çalışan sunucu üzerinde doğrulandı:

- `POST` → `201`
- Liste, detay ve filtreleme istekleri → `200`
- `PUT` → `200`
- `DELETE` → `200`
- Silinen ya da bulunamayan görev → `404`
- Eksik alan ve bozuk JSON → `400`
- Logger çıktısında method, endpoint ve zaman damgası
- `npm ci` güvenlik denetimi → 0 açık

## Proje Yapısı

```text
taskora-backend/
├── docs/
│   ├── Taskora_Backend_Proje_Tanitim_Dokumani.html
│   └── Taskora_Backend_Proje_Tanitim_Dokumani.pdf
├── postman/
│   └── Taskora_Backend.postman_collection.json
├── screenshots/
│   └── 01-post-task.png ... 05-delete-task.png
├── src/
│   ├── controllers/taskController.js
│   ├── data/tasks.json
│   ├── middleware/logger.js
│   ├── routes/taskRoutes.js
│   └── app.js
├── .gitignore
├── package.json
├── package-lock.json
├── POSTMAN_TESTLERI.md
└── README.md
```

## Kapsam

Bu eğitim sürümünde authentication, SQL Server bağlantısı, Docker ve production dağıtımı bulunmaz. Web ve Mobile modülleri kendi yerel veri katmanlarını kullanır; Backend API entegrasyonu sonraki geliştirme aşamasıdır.
