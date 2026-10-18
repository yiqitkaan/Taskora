# Taskora Mobile

## Proje Hakkında

Taskora Mobile, kullanıcıların görevlerini mobil ekranda oluşturması, izlemesi ve güncellemesi için Flutter ile geliştirilmiş bir görev yönetimi uygulamasıdır. Başlangıç kullanıcıları ve görevler yerel JSON asset'lerinden okunur. Kayıtlar ve görev değişiklikleri Android'de SharedPreferences, iOS'ta UserDefaults içinde JSON olarak kalıcı saklanır.

## Özellikler

- `GridView.builder` ile kart tabanlı görev görünümü
- `ListView.builder` ile dinamik görev listesi
- JSON tabanlı demo kullanıcıyla giriş yapma
- Form doğrulamalı yeni kullanıcı kaydı ve çıkış yapma
- Kullanıcı ve görev değişikliklerini cihazda JSON olarak kalıcı saklama
- Kart ve liste görünümü arasında geçiş
- Form doğrulamalı yeni görev ekleme
- Görev detayından alanları düzenleme
- Başlık ve açıklamada arama ve durum filtresi
- Görev detay ekranı
- `Navigator.pushNamed` ve route arguments ile veri aktarımı
- Basit görev durumu güncellemesi
- Task modelinde `fromJson` ve `toJson`
- Yerel JSON ve görsel asset kullanımı
- Görev detaylarında beş görsellik havuzdan atanan kapak görseli

## Kullanılan Teknolojiler

- Flutter 3.47.7
- Dart 3.13.5
- Material Design (`material.dart`)
- Yerel JSON

Ekstra Flutter paketi kullanılmamıştır.

## Repository

Public Taskora repository: <https://github.com/yiqitkaan/Taskora>

Yeni kullanıcılar, eklenen görevler, düzenlemeler ve durum değişiklikleri cihazda kalıcıdır. Çıkış yapıldığında veya uygulama yeniden başlatıldığında kaybolmaz. Uygulama silinirse ya da uygulama verileri temizlenirse başlangıç asset JSON'ları yeniden yüklenir.

## Demo Giriş

```text
E-posta: demo@taskora.app
Şifre:   123456
```

Bu hesap yalnızca yerel demo akışını denemek içindir. Uygulama çevrim dışı çalıştığı için demo kullanıcı verileri yerel JSON içinde tutulur.

## Kurulum ve Çalıştırma

```bash
cd taskora-mobile
flutter pub get
flutter run
```

Bağlı cihazları görmek için `flutter devices`, belirli bir hedefte çalıştırmak için `flutter run -d chrome` kullanılabilir.

iOS Simulator üzerinde çalıştırmak için:

```bash
open -a Simulator
flutter devices
flutter run -d <IOS_CIHAZ_ID>
```

Android Emulator üzerinde çalıştırmak için Android Studio'dan bir sanal cihaz başlatıp aşağıdaki komutları kullanın:

```bash
flutter devices
flutter run -d <ANDROID_CIHAZ_ID>
```

## Kontroller

```bash
flutter analyze
flutter test
flutter build web
flutter build apk --debug
flutter build ios --simulator --no-codesign
```

Android debug çıktısı `build/app/outputs/flutter-apk/app-debug.apk` altında üretilir.

## Proje Yapısı

```text
taskora-mobile/
├── assets/
│   ├── data/
│   │   ├── tasks.json
│   │   └── users.json
│   └── images/
│       ├── taskora_banner.png
│       └── tasks/
│           ├── task-mobile.png
│           ├── task-backend.png
│           ├── task-web.png
│           ├── task-database.png
│           └── task-roadmap.png
├── lib/
│   ├── data/task_data.dart
│   ├── data/local_json_storage.dart
│   ├── data/user_data.dart
│   ├── models/app_user.dart
│   ├── models/task.dart
│   ├── pages/auth_gate.dart
│   ├── pages/auth_page.dart
│   ├── pages/task_list_page.dart
│   ├── pages/task_detail_page.dart
│   ├── pages/task_form_page.dart
│   ├── widgets/task_badge.dart
│   └── main.dart
├── screenshots/
├── test/widget_test.dart
└── pubspec.yaml
```

## Ekran Görüntüleri

`screenshots/` klasöründe iOS Simulator üzerinden alınmış şu uygulama ekranları bulunur:

- `01-ana-sayfa.png`: kart tabanlı görev ana sayfası
- `02-gorev-listesi.png`: dinamik görev liste görünümü
- `03-gorev-detayi.png`: yerel görselli görev detay ekranı
- `04-giris-ekrani.png`: JSON tabanlı kullanıcı giriş ekranı

## Teknik Kapsam

Uygulamada model ve JSON dönüşümü, `ListView.builder`, `GridView.builder`, yerel görseller, arama ve filtreleme, named route ile gezinme, route arguments, detay ekranı ve durum yönetimi birlikte kullanılır. JSON tabanlı giriş, kayıt, çıkış, kalıcı yerel depolama ile form doğrulamalı görev ekleme ve düzenleme akışları görev yönetimi deneyimini tamamlar. Kalıcılık, üçüncü taraf paket kullanılmadan Flutter `MethodChannel` üzerinden Android SharedPreferences ve iOS UserDefaults ile sağlanır.

Özelliklerin kaynak dosyaları ve doğrulama adımları [MOBILE_GEREKSINIM_KONTROLU.md](MOBILE_GEREKSINIM_KONTROLU.md) dosyasında listelenmiştir.

## Geliştirici

Yiğit Kaan Bilir
