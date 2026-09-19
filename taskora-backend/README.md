# Taskora Backend

## Proje Hakkında

Taskora, yazılım ekiplerinin görevlerini takip etmesi için hazırlanan bir REST API projesidir. Bu aşamada görevler yerel bir JSON dosyasında saklanır. Veritabanı ve kullanıcı girişi bulunmaz.

## Kullanılan Teknolojiler

- Node.js
- Express.js
- JavaScript
- REST API
- JSON

## Gereksinimler

Node.js 18 veya üzeri ve npm gerekir.

## Kurulum

```bash
git clone <GITHUB_REPOSITORY_URL>
cd taskora-backend
npm install
npm start
```

Depoyu indirmeden bu çalışma klasöründen çalıştırmak için `cd taskora-backend` komutuyla proje klasörüne geçin.

## Çalıştırma

`npm start` sunucuyu varsayılan olarak `http://localhost:3000` adresinde başlatır. Başka bir port için `PORT=4000 npm start` kullanılabilir. Görevler `src/data/tasks.json` dosyasında tutulur; değişiklikler sunucu yeniden başlatıldığında korunur.

## API Endpointleri

| Method | Endpoint | Açıklama |
| --- | --- | --- |
| POST | `/tasks` | Yeni görev oluştur |
| GET | `/tasks` | Tüm görevleri listele |
| GET | `/tasks/:id` | Görev detayını getir |
| PUT | `/tasks/:id` | Görevi güncelle |
| DELETE | `/tasks/:id` | Görevi sil |

`GET /tasks` isteğinde isteğe bağlı `status` ve `priority` sorgu parametreleriyle filtreleme yapılabilir. Durum değerleri `pending`, `in_progress`, `completed`; öncelik değerleri `low`, `medium`, `high` olabilir. Geçersiz ID biçimi ve eksik alanlar için 400, bulunamayan görevler için 404 döner.

## Örnek POST Request

`POST http://localhost:3000/tasks` isteğinde `Content-Type: application/json` başlığını ve şu gövdeyi kullanın:

```json
{
  "title": "API dokümantasyonunu güncelle",
  "description": "Görev endpointlerini README dosyasına ekle",
  "status": "pending",
  "priority": "high",
  "assignee": "Yiğit Kaan Bilir",
  "projectId": 1
}
```

`title`, `status`, `priority` ve `assignee` zorunludur. `description` belirtilmezse boş metin, `projectId` belirtilmezse `null` olur. `PUT` isteğinde yalnızca değiştirilecek alanları göndermek yeterlidir.

## Postman Testleri

Beş CRUD endpointi Postman ile sırayla denenebilir. Ekran görüntüsü için adımlar ve beklenen yanıtlar [POSTMAN_TESTLERI.md](POSTMAN_TESTLERI.md) dosyasındadır. Test istekleri JSON dosyasındaki verileri değiştirir.

## Proje Yapısı

```text
taskora-backend/
├── src/
│   ├── controllers/taskController.js
│   ├── routes/taskRoutes.js
│   ├── middleware/logger.js
│   ├── data/tasks.json
│   └── app.js
├── screenshots/
├── package.json
├── package-lock.json
├── README.md
├── POSTMAN_TESTLERI.md
└── .gitignore
```

## Geliştirici

Yiğit Kaan Bilir

## Proje

Software Persona Yazılım / Kariyer Merkezi / 18. Dönem
