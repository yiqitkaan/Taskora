# Taskora Postman Testleri

Önce `taskora-backend` klasöründe `npm install` ve `npm start` çalıştırın. Postman'de gövdeli isteklerde **Body → raw → JSON** seçin. Testleri aşağıdaki sırayla yapın. Yeni görevin ID'si başlangıç verileriyle **4** olur; farklıysa POST yanıtındaki ID'yi sonraki isteklerde kullanın. Her isteğin yanıtını ekran görüntüsü olarak kaydedebilirsiniz.

## TEST 1 — Yeni görev oluşturma

- Method: `POST`
- URL: `http://localhost:3000/tasks`
- Beklenen status: `201 Created`
- Body JSON:

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

Beklenen yanıt örneği (`createdAt` ve `updatedAt` istek zamanına göre değişir):

```json
{
  "id": 4,
  "title": "Postman API testi",
  "description": "CRUD isteklerini kontrol et",
  "status": "pending",
  "priority": "high",
  "assignee": "Yiğit Kaan Bilir",
  "projectId": 1,
  "createdAt": "2026-09-19T12:00:00.000Z",
  "updatedAt": "2026-09-19T12:00:00.000Z"
}
```

## TEST 2 — Tüm görevleri listeleme

- Method: `GET`
- URL: `http://localhost:3000/tasks`
- Beklenen status: `200 OK`
- Body: Yok

Beklenen yanıt örneği: İlk üç örnek görev ve TEST 1'de oluşturulan görevden oluşan JSON dizisi. Dizideki son kayıt şöyle görünür:

```json
[
  { "id": 1, "title": "Görev API'sini hazırlama", "description": "Görev listeleme ve detay endpointleri hazırlanacak.", "status": "completed", "priority": "high", "assignee": "Yiğit Kaan Bilir", "projectId": 1, "createdAt": "2026-09-19T10:00:00.000Z", "updatedAt": "2026-09-19T10:00:00.000Z" },
  { "id": 2, "title": "Görev doğrulama kuralları", "description": "Zorunlu alanlar ve hatalı istekler kontrol edilecek.", "status": "in_progress", "priority": "medium", "assignee": "Yiğit Kaan Bilir", "projectId": 1, "createdAt": "2026-09-19T10:15:00.000Z", "updatedAt": "2026-09-19T10:15:00.000Z" },
  { "id": 3, "title": "Postman testlerini yazma", "description": "CRUD istekleri için örnek test adımları hazırlanacak.", "status": "pending", "priority": "low", "assignee": "Yiğit Kaan Bilir", "projectId": 1, "createdAt": "2026-09-19T10:30:00.000Z", "updatedAt": "2026-09-19T10:30:00.000Z" },
  { "id": 4, "title": "Postman API testi", "description": "CRUD isteklerini kontrol et", "status": "pending", "priority": "high", "assignee": "Yiğit Kaan Bilir", "projectId": 1, "createdAt": "2026-09-19T12:00:00.000Z", "updatedAt": "2026-09-19T12:00:00.000Z" }
]
```

## TEST 3 — Tek görev görüntüleme

- Method: `GET`
- URL: `http://localhost:3000/tasks/4`
- Beklenen status: `200 OK`
- Body: Yok

Beklenen yanıt örneği (ID farklıysa URL'yi ve örneği buna göre uyarlayın):

```json
{
  "id": 4,
  "title": "Postman API testi",
  "description": "CRUD isteklerini kontrol et",
  "status": "pending",
  "priority": "high",
  "assignee": "Yiğit Kaan Bilir",
  "projectId": 1,
  "createdAt": "2026-09-19T12:00:00.000Z",
  "updatedAt": "2026-09-19T12:00:00.000Z"
}
```

## TEST 4 — Görev güncelleme

- Method: `PUT`
- URL: `http://localhost:3000/tasks/4`
- Beklenen status: `200 OK`
- Body JSON:

```json
{
  "status": "in_progress",
  "priority": "medium"
}
```

Beklenen yanıt örneği (`updatedAt` güncel zaman olur):

```json
{
  "id": 4,
  "title": "Postman API testi",
  "description": "CRUD isteklerini kontrol et",
  "status": "in_progress",
  "priority": "medium",
  "assignee": "Yiğit Kaan Bilir",
  "projectId": 1,
  "createdAt": "2026-09-19T12:00:00.000Z",
  "updatedAt": "2026-09-19T12:05:00.000Z"
}
```

## TEST 5 — Görev silme

- Method: `DELETE`
- URL: `http://localhost:3000/tasks/4`
- Beklenen status: `200 OK`
- Body: Yok
- Beklenen yanıt:

```json
{
  "message": "Görev başarıyla silindi."
}
```

Silme sonrasında aynı ID için `GET http://localhost:3000/tasks/4` isteği `404 Not Found` döner.
