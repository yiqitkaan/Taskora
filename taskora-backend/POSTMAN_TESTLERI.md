# Taskora Backend — Postman Test ve Ekran Görüntüsü Rehberi

Bu rehber, Taskora Backend'in beş temel CRUD isteğini doğru sırayla çalıştırmak ve sonuçları doğrulamak için hazırlanmıştır.

## Test Sonunda Oluşacak Dosyalar

```text
taskora-backend/screenshots/
├── 01-post-task.png
├── 02-get-tasks.png
├── 03-get-task-detail.png
├── 04-put-task.png
└── 05-delete-task.png
```

İsterseniz silme kontrolünü güçlendiren `06-deleted-task-404.png` ekranını da ekleyebilirsiniz.

## A. Teste Hazırlık

### 1. Terminali açın ve backend klasörüne geçin

```bash
cd Taskora/taskora-backend
```

### 2. Başlangıç verisini yedekleyin

```bash
cp src/data/tasks.json /tmp/taskora-tasks-before-postman.json
```

### 3. Bağımlılıkları kurun

```bash
npm ci
```

### 4. Sunucuyu başlatın

```bash
npm start
```

Terminalde şu mesaj görünmelidir:

```text
Taskora API http://localhost:3000 adresinde çalışıyor.
```

Bu terminali açık bırakın. İstekler çalıştıkça logger satırları burada görünecektir.

### 5. Postman'i açın

İki yöntemden birini kullanabilirsiniz:

1. **Hazır koleksiyon:** Postman'de **Import** düğmesine basıp `taskora-backend/postman/Taskora_Backend.postman_collection.json` dosyasını seçin.
2. **Elle:** Aşağıdaki her isteği yeni HTTP Request ekranında oluşturun.

Hazır koleksiyon kullanıldığında POST cevabındaki yeni görev ID'si otomatik olarak `taskId` değişkenine kaydedilir ve sonraki istekler bu ID'yi kullanır.

## Ekran Görüntüsü İçin Genel Kural

Her ekran görüntüsünde aşağıdakiler aynı karede okunmalıdır:

- Koleksiyondaki test adı
- HTTP methodu
- İstek URL'si
- Sağ üstteki HTTP status kodu
- Response Body içindeki JSON cevap
- `POST` ve `PUT` ekranlarında gönderilen JSON gövdesi

Postman'de istek ve cevap alanları aynı kareye sığmıyorsa panel sınırını sürükleyerek response alanını büyütün veya pencereyi tam ekran yapın. Görüntüyü kırpmadan önce method, URL, status ve JSON cevabının görünür kaldığını kontrol edin.

## TEST 1 — Yeni Görev Oluşturma

### Postman ayarları

1. Koleksiyondan **01 - Görev Oluştur** isteğini açın.
2. Elle oluşturuyorsanız methodu `POST` seçin.
3. URL alanına `http://localhost:3000/tasks` yazın.
4. **Body → raw → JSON** seçin.
5. Aşağıdaki gövdeyi yapıştırın:

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

6. **Send** düğmesine basın.

### Kontrol edilecek sonuç

- Status: `201 Created`
- Cevapta `id`, `createdAt` ve `updatedAt` bulunmalı.
- Temiz başlangıç verisiyle yeni `id` değeri `4` olur.
- Farklı bir ID dönerse sonraki elle oluşturulan URL'lerde bu ID'yi kullanın.

Beklenen cevap biçimi:

```json
{
  "id": 4,
  "title": "Postman API testi",
  "description": "CRUD isteklerini kontrol et",
  "status": "pending",
  "priority": "high",
  "assignee": "Yiğit Kaan Bilir",
  "projectId": 1,
  "createdAt": "<istek-zamanı>",
  "updatedAt": "<istek-zamanı>"
}
```

### Alınacak ekran görüntüsü

Method, URL, request JSON, `201 Created` ve response JSON görünürken ekran görüntüsü alın.

**Dosya adı:** `taskora-backend/screenshots/01-post-task.png`

## TEST 2 — Bütün Görevleri Listeleme

### Postman ayarları

1. **02 - Görevleri Listele** isteğini açın.
2. Method: `GET`
3. URL: `http://localhost:3000/tasks`
4. Body göndermeyin.
5. **Send** düğmesine basın.

### Kontrol edilecek sonuç

- Status: `200 OK`
- Response bir JSON dizisi olmalı.
- Başlangıçtaki üç görev ile TEST 1'de oluşturulan `Postman API testi` görevi görünmeli.

### Alınacak ekran görüntüsü

Method, URL, `200 OK` ve JSON listesindeki `Postman API testi` kaydı görünürken ekran görüntüsü alın.

**Dosya adı:** `taskora-backend/screenshots/02-get-tasks.png`

## TEST 3 — Görev Detayını Görüntüleme

### Postman ayarları

1. **03 - Görev Detayı** isteğini açın.
2. Method: `GET`
3. Hazır koleksiyonda URL `http://localhost:3000/tasks/{{taskId}}` olur.
4. Elle çalışıyorsanız TEST 1'de dönen ID'yi kullanın: `http://localhost:3000/tasks/4`
5. **Send** düğmesine basın.

### Kontrol edilecek sonuç

- Status: `200 OK`
- Dönen `id`, TEST 1'de oluşturulan ID ile aynı olmalı.
- Başlık `Postman API testi`, durum `pending`, öncelik `high` olmalı.

### Alınacak ekran görüntüsü

Method, ID içeren URL, `200 OK` ve görevin tüm JSON alanları görünürken ekran görüntüsü alın.

**Dosya adı:** `taskora-backend/screenshots/03-get-task-detail.png`

## TEST 4 — Görevi Güncelleme

### Postman ayarları

1. **04 - Görev Güncelle** isteğini açın.
2. Method: `PUT`
3. Hazır koleksiyonda URL `http://localhost:3000/tasks/{{taskId}}` olur.
4. Elle çalışıyorsanız TEST 1'de dönen ID'yi kullanın: `http://localhost:3000/tasks/4`
5. **Body → raw → JSON** seçin.
6. Aşağıdaki gövdeyi yapıştırın:

```json
{
  "status": "in_progress",
  "priority": "medium"
}
```

7. **Send** düğmesine basın.

### Kontrol edilecek sonuç

- Status: `200 OK`
- Cevaptaki `status` değeri `in_progress` olmalı.
- Cevaptaki `priority` değeri `medium` olmalı.
- `updatedAt` alanı güncel istek zamanına değişmeli.
- `createdAt` alanı değişmemeli.

### Alınacak ekran görüntüsü

Method, URL, request JSON, `200 OK` ve güncellenmiş response JSON aynı karede görünürken ekran görüntüsü alın.

**Dosya adı:** `taskora-backend/screenshots/04-put-task.png`

## TEST 5 — Görevi Silme

### Postman ayarları

1. **05 - Görev Sil** isteğini açın.
2. Method: `DELETE`
3. Hazır koleksiyonda URL `http://localhost:3000/tasks/{{taskId}}` olur.
4. Elle çalışıyorsanız TEST 1'de dönen ID'yi kullanın: `http://localhost:3000/tasks/4`
5. Body göndermeyin.
6. **Send** düğmesine basın.

### Kontrol edilecek sonuç

- Status: `200 OK`
- Cevap aşağıdaki gibi olmalı:

```json
{
  "message": "Görev başarıyla silindi."
}
```

### Alınacak ekran görüntüsü

Method, URL, `200 OK` ve başarı mesajı görünürken ekran görüntüsü alın.

**Dosya adı:** `taskora-backend/screenshots/05-delete-task.png`

## İsteğe Bağlı Güçlü Kanıt — Silinen Görevin 404 Dönmesi

1. **03 - Görev Detayı** isteğini tekrar çalıştırın.
2. Status `404 Not Found` olmalı.
3. Response şu şekilde olmalı:

```json
{
  "error": "Görev bulunamadı."
}
```

İsterseniz bunu `taskora-backend/screenshots/06-deleted-task-404.png` olarak kaydedin.

## Logger Kanıtı

Postman testlerinden sonra `npm start` çalışan terminalde aşağıdakine benzer satırlar görünür:

```text
[2026-10-18 20:33:18] POST /tasks
[2026-10-18 20:33:19] GET /tasks
[2026-10-18 20:33:20] GET /tasks/4
[2026-10-18 20:33:21] PUT /tasks/4
[2026-10-18 20:33:22] DELETE /tasks/4
```

Bu ekran ana Postman görüntülerine ek olarak `07-logger-terminal.png` adıyla kaydedilebilir.

## Test Sonunda Başlangıç Verisini Geri Yükleme

1. Sunucunun çalıştığı terminalde `Ctrl+C` tuşlarına basın.
2. Aşağıdaki komutu çalıştırın:

```bash
cd Taskora/taskora-backend
cp /tmp/taskora-tasks-before-postman.json src/data/tasks.json
```

3. Dosyanın tekrar üç başlangıç görevi içerdiğini kontrol edin:

```bash
cat src/data/tasks.json
```

## Son Kontrol

- [ ] Beş ekran görüntüsünün tamamı `screenshots/` klasöründe
- [ ] Her görüntüde method ve URL okunuyor
- [ ] Her görüntüde HTTP status kodu okunuyor
- [ ] Her görüntüde response JSON okunuyor
- [ ] POST ve PUT görüntülerinde request JSON görünüyor
- [ ] Görüntüler gerçek Postman arayüzünden alınmış
- [ ] Test verisi silinip başlangıç `tasks.json` dosyası geri yüklenmiş
- [ ] İstenirse logger ve silme sonrası `404` ekranı eklenmiş
