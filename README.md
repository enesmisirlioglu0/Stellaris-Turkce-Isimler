# Stellaris Türkler

**Türkler**, Stellaris 4.6 için Türk toplulukları, devletleri ve şehirlerinden esinlenen bir isim listesidir. Bu bir arayüz çevirisi değildir; imparatorluk, gemi, filo, gezegen, ordu ve karakter adlarını sağlar.

Steam Workshop: [Türkler](https://steamcommunity.com/sharedfiles/filedetails/?id=3845647864)

Geliştirme hedefi kurulu **Stellaris 4.6.0 (Corona Borealis)** sürümüdür. Paket yalnızca yerleşik isim listesi biçimini ve genel geri dönüş havuzlarını kullandığından yeni gemi sınıflarında da çalışmaya devam eder; yine de her büyük oyun güncellemesinde karşılaştırma betiğini çalıştır.

## Proje düzeni

- `mod/`: Steam/Paradox Launcher'a verilecek mod paketi.
- `scripts/validate-mod.zsh`: yayımlamadan önce sözdizimi ve meta veri kontrolleri.
- `scripts/compare-vanilla-ship-keys.zsh`: kurulu oyunun isim listesi anahtarlarını paketle karşılaştırır.
- `scripts/install-local.zsh`: modun bağımsız, yerel test kopyasını oluşturur.

## Hızlı yerel test

1. `scripts/validate-mod.zsh` komutunu çalıştır.
2. `scripts/install-local.zsh` komutunu çalıştır. Bu, `~/Documents/Paradox Interactive/Stellaris/mod/stellaris_turkce_isimler_4x` altında yeni bir kopya ve Launcher için ayrı descriptor oluşturur. Mevcut bir klasörün üstüne yazmaz.
3. Paradox Launcher'da yeni bir Playset oluştur, **Türkler** modunu ekle ve eski `Türkçe İsimler v3.0.3` modunu aynı Playset'e ekleme.
4. Yeni imparatorluk oluşturma ekranında **Türkler** listesini seç. Oyuna girip başlangıç gemisi, filo ve lider isimlerini doğrula.
5. Oyunun `logs/error.log` dosyasında bu modla ilgili parse hatası bulunmadığını kontrol et.

## Güncelleme kuralı

Her Stellaris ana sürümünde önce `scripts/compare-vanilla-ship-keys.zsh`, sonra `scripts/validate-mod.zsh` çalıştır. Yeni bir vanilla sınıfı eklenmişse, `mod/common/name_lists/turkish_tr.txt` içindeki `generic` havuz zaten geri dönüş sağlar; yalnızca daha tematik ayrı bir havuz istersen sınıfa özel blok ekle.

## Yayın öncesi

Bu proje eski bir Workshop içeriğinden türetilmiştir. Yayın hakkı ve atıf koşulları için [UPSTREAM-NOTICE.md](UPSTREAM-NOTICE.md) dosyasını tamamlamadan GitHub veya Steam Workshop'a gönderme.
