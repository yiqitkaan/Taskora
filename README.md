# Taskora

Taskora, görev ve ekip yönetimi için geliştirilen bütünleşik bir yazılım projesidir. Software Persona Yazılım / Kariyer Merkezi / 18. Dönem kapsamında Yiğit Kaan Bilir tarafından geliştirilmektedir.

## Proje Modülleri

### Taskora Backend

[`taskora-backend/`](taskora-backend/) klasöründe Node.js ve Express.js tabanlı REST API bulunur. Şu anda görevleri yerel JSON dosyasında saklar.

### Taskora Web

[`taskora-web/`](taskora-web/) klasöründe React, JavaScript ve Tailwind CSS tabanlı web arayüzü bulunur. Şu anda görevleri tarayıcının LocalStorage alanında saklar.

### Taskora Database

Microsoft SQL Server tabanlı merkezi veri katmanı olarak planlanmıştır. Henüz geliştirilmemiştir.

### Taskora Mobile

[`taskora-mobile/`](taskora-mobile/) klasöründe Flutter ve Dart tabanlı mobil görev takip uygulaması bulunur. Yerel ve kalıcı JSON verisiyle giriş/kayıt, GridView kartları, liste görünümü, görev ekleme/düzenleme, arama, filtreleme, detay ve durum güncelleme akışı sunar.

## Planlanan Mimari

```text
Taskora Web ────┐
                ├──> Taskora Backend ──> TaskoraDB
Taskora Mobile ─┘
```

Mevcut eğitim sürümlerinde Web LocalStorage, Backend ise JSON kullanır. REST API ve SQL Server bütünleşmesi sonraki geliştirme aşamasıdır.

## Yerel Çalıştırma

Backend ve Web bağımsız olarak çalışır. Kurulum ve kullanım adımları ilgili modüllerin README dosyalarındadır:

- [Backend kurulumu](taskora-backend/README.md)
- [Web kurulumu](taskora-web/README.md)

Web arayüzü bu aşamada Backend API'sine istek göndermez.
