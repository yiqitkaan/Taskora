# Taskora Web

## Proje Hakkında

Taskora Web, görevleri tek ekranda yönetmek için hazırlanan React uygulamasıdır. Bu sürüm LocalStorage kullanmaktadır. Taskora Backend REST API entegrasyonu sonraki geliştirme aşaması olarak planlanmıştır.

**Canlı uygulama:** <https://idyllic-belekoy-ce4466.netlify.app>

Bu modül, Software Persona Yazılım / Kariyer Merkezi 18. Dönem programındaki web geliştirme çalışmasının Taskora ürün senaryosuna uyarlanmış sürümüdür.

## Özellikler

- Görev ekleme, listeleme, güncelleme ve silme
- Durum ve önceliğe göre filtreleme
- Başlık ve açıklamada arama
- Görev durumlarına göre canlı istatistikler
- LocalStorage ile tarayıcıda kalıcı kayıt

İlk açılışta dört örnek görev gelir. Sonraki değişiklikler aynı tarayıcıda sayfa yenilendiğinde korunur. Silme işleminde onay istenir.

## Kullanılan Teknolojiler

- React
- JavaScript
- Vite
- Tailwind CSS
- LocalStorage

## Gereksinimler

Node.js 20.19+ ve npm gerekir.

## Kurulum

```bash
cd taskora-web
npm install
npm run dev
```

Vite'ın terminalde gösterdiği yerel adresi açın; varsayılan adres `http://localhost:5173` olur.

## Production Build

```bash
npm run build
```

Derleme çıktısı `dist/` klasöründedir. Yerelde üretim çıktısını görmek için `npm run preview` kullanılabilir.

## Netlify

GitHub'daki **yiqitkaan/Taskora** deposunu Netlify'a bağlayın. Base directory olarak `taskora-web` seçin. `netlify.toml` dosyası build komutunu `npm run build`, yayın klasörünü `dist` ve Node sürümünü `20.19.5` olarak ayarlar. Netlify arayüzünde elle girmeniz gerekirse aynı değerleri kullanın. Uygulama tek sayfalıdır ve ek yönlendirme gerektirmez.

## Ekran Görüntüleri

Gerçek tarayıcıda alınmış Dashboard, yeni görev ve düzenleme ekranları `screenshots/` klasöründedir.

## Proje Yapısı

```text
taskora-web/
├── public/
├── screenshots/
├── src/
│   ├── components/
│   │   ├── Header.jsx
│   │   ├── StatsCards.jsx
│   │   ├── TaskFilters.jsx
│   │   ├── TaskList.jsx
│   │   ├── TaskCard.jsx
│   │   └── TaskForm.jsx
│   ├── pages/Dashboard.jsx
│   ├── utils/storage.js
│   ├── App.jsx
│   ├── main.jsx
│   └── index.css
├── index.html
├── vite.config.js
├── netlify.toml
├── package.json
└── README.md
```

## Geliştirici

Yiğit Kaan Bilir
