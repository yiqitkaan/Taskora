# Taskora Mobile Gereksinim Kontrolü

**Son kontrol:** 18 Ekim 2026

**Resmî yönerge:** `projeGereksinimDokumantasyon/mobilDokuman/Mobil Uygulama Geliştirme; Android _ iOS Proje Yönergesi.pdf`

**Eğitmen yanıtı:** `projeGereksinimDokumantasyon/mobilDokuman/bilgilendirmeMailimobil.txt`

## Kapsam Kararı

Hüseyin Adıgüzel'in yazılı yanıtına göre değerlendirmede öncelik teknik kıstaslardadır. Mini katalog yapısına uyarlama tavsiye edilmiş, zorunlu tutulmamıştır. Ekran görüntülerinde iOS Simulator veya Android Emulator kullanılabileceği ayrıca doğrulanmıştır.

Taskora Mobile bu onaya dayanarak mini katalogdaki öğrenme hedeflerini görev takip senaryosunda uygular. Ürün kartının karşılığı görev kartı, ürün detayının karşılığı görev detayı, sepet state simülasyonunun karşılığı görev durumu güncellemesidir.

## Teknik Kıstas Matrisi

| Yönerge kıstası | Taskora karşılığı | Kanıt | Durum |
| --- | --- | --- | --- |
| Flutter SDK ve Dart SDK | Flutter 3.47.7, Dart 3.13.5 | `README.md`, `pubspec.yaml` | Tamamlandı |
| `material.dart` | Material 3 arayüzü | `lib/main.dart` | Tamamlandı |
| Ekstra paket kullanılmaması | Yalnızca Flutter SDK; test için Flutter SDK içindeki `flutter_test` | `pubspec.yaml`, `pubspec.lock` | Tamamlandı |
| Stateless ve Stateful widget | Uygulama, rozet, liste ve detay widget'ları | `lib/` | Tamamlandı |
| Dart collection ve null safety | `List<Task>`, filtreleme ve null güvenli model | `lib/` | Tamamlandı |
| Temel yerleşim widget'ları | Text, Container, Row, Column, Padding, Expanded ve Align | `lib/pages/` | Tamamlandı |
| Card ve ListTile | Görev kartları ve detay bilgi satırları | `task_list_page.dart`, `task_detail_page.dart` | Tamamlandı |
| Navigator push/pop | Named route ile detaya geçiş, sonuçla geri dönüş | `task_list_page.dart`, `task_detail_page.dart` | Tamamlandı |
| Route Arguments | Seçilen `Task` nesnesinin detay sayfasına aktarılması | `lib/main.dart`, `task_detail_page.dart` | Tamamlandı |
| JSON ve model sınıfı | Yerel JSON'un `Task` listesine dönüşmesi | `assets/data/tasks.json`, `lib/models/task.dart` | Tamamlandı |
| `fromJson` / `toJson` | İki yönlü model dönüşümü | `lib/models/task.dart` | Tamamlandı |
| `ListView.builder` | Dinamik görev liste görünümü | `task_list_page.dart` | Tamamlandı |
| `GridView` ile kart tasarımı | Varsayılan dinamik görev kart görünümü | `task_list_page.dart` | Tamamlandı |
| `Image.asset` | Yerel Taskora banner görseli | `task_list_page.dart`, `assets/images/` | Tamamlandı |
| Görsel asset tanımı | `taskora_banner.png` dosyasının pubspec kaydı ve uygulamada yüklenmesi | `pubspec.yaml`, widget testi | Tamamlandı |
| Görev detay görselleri | Beş yerel görselin görevlerle eşleştirilmesi ve yeni görevlere rastgele atanması | `assets/images/tasks/`, `task_detail_page.dart` | Tamamlandı |
| Arama ve filtreleme | Başlık/açıklama araması ve durum filtresi | `task_list_page.dart` | Tamamlandı |
| Ana sayfa ve detay ekranı | Görev listesi/kartları ve görev detayı | `lib/pages/` | Tamamlandı |
| Basit state güncellemesi | Detaydan görev durumunu ilerletme ve listeye aktarma | `task_detail_page.dart`, `task_list_page.dart` | Tamamlandı |
| Taskora ek özelliği: kullanıcı girişi | Yerel kullanıcı JSON'u, doğrulamalı giriş ve hatalı giriş mesajı | `users.json`, `auth_page.dart`, widget testi | Tamamlandı |
| Taskora ek özelliği: kullanıcı kaydı | E-posta kontrolü, şifre doğrulaması ve cihazdaki yerel JSON kaydı | `auth_gate.dart`, `auth_page.dart`, widget testi | Tamamlandı |
| Taskora ek özelliği: çıkış | Kullanıcı oturumunu kapatıp giriş ekranına dönme | `auth_gate.dart`, `task_list_page.dart`, widget testi | Tamamlandı |
| Taskora ek özelliği: kalıcı yerel JSON | Kullanıcı ve görev JSON'larını Android SharedPreferences / iOS UserDefaults içinde saklama | `local_json_storage.dart`, Kotlin/Swift kanal kodu, widget testi | Tamamlandı |
| Taskora ek özelliği: görev ekleme | Doğrulamalı form, yeni ID ve uygulama içi liste güncellemesi | `task_form_page.dart`, widget testi | Tamamlandı |
| Taskora ek özelliği: görev düzenleme | Detaydan form açma ve güncel modeli listeye döndürme | `task_detail_page.dart`, widget testi | Tamamlandı |
| Proje klasör yapısı | model, data, pages, widgets ve assets ayrımı | `lib/`, `assets/` | Tamamlandı |
| Asset yönetimi | Görev/kullanıcı JSON'u ve PNG asset tanımları | `pubspec.yaml` | Tamamlandı |
| README | Ad, açıklama, sürüm ve çalıştırma adımları | `README.md` | Tamamlandı |
| Uygulama ekran görüntüleri | Giriş, liste, kart, detay ve state ekranları | `screenshots/` | Tamamlandı |
| Public GitHub repository URL'i | <https://github.com/yiqitkaan/Taskora> public olarak erişilebilir | Mobil klasörünün final push'u bekliyor | Bekliyor |

## Doğrulama Komutları

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
flutter build apk --debug
flutter build ios --simulator --no-codesign
```

18 Ekim 2026 tarihli son kontrolde statik analiz hatasız, 8 widget/model testi başarılı ve Web, Android debug APK ile iOS Simulator derlemeleri başarılı tamamlandı. Gerçek iOS Simulator uçtan uca kontrolünde hatalı giriş, demo girişi, görev ekleme, detay görseli, durum güncelleme, çıkış/yeniden giriş, yeni kullanıcı kaydı ve uygulama yeniden oluşturulduktan sonra kullanıcı ile görev verilerinin korunması doğrulandı.

## Teslim Öncesi Son Kontrol

- Public GitHub görünümünde `taskora-mobile/` klasörünü doğrula.
- README içindeki sürüm ve komutları son kez kontrol et.
- `screenshots/` içinde kart, liste ve detay ekranlarının okunabilir olduğunu doğrula.
- GitHub URL'sini ve seçilen ekran görüntülerini teslim formuna ekle.
