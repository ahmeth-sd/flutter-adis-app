# ADISAPP FAZ 1 (MVP) Teknik Spesifikasyonları

Bu doküman, ADISAPP projesinin ilk fazı olan MVP (Minimum Uygulanabilir Ürün) geliştirme süreci için gereken tüm fonksiyonel ve teknik detayları içermektedir.

---

## 1. Kullanıcı Tanımlama ve Profilleme (Onboarding)

Uygulama ilk açıldığında, kullanıcının ihtiyaçlarına göre arayüzü şekillendirmek için bir anket sunulmalıdır.

* 
**Temel Bilgiler:** Kullanıcının yaşı, tanısı (varsa), işitme, görme ve bilişsel engel durumu sorgulanmalıdır.


* 
**Otomatik Yapılandırma:** Alınan bilgilere göre buton kontrastları artırılmalı, yazılar kalınlaştırılmalı ve font büyüklüğü otomatik ayarlanmalıdır.


* 
**Bilişsel Düzey Seçimi:** Kullanıcının bilişsel yetkinliğine göre üç farklı kullanım modu sunulmalıdır:


* 
**Temel:** Başlangıç seviyesi iletişim formlarını içerir.


* 
**Orta:** Dil gelişimini desteklemek için klasör yaratma imkanı sunar.


* 
**İleri:** Deneyimli kullanıcılar için bütünsel dil gelişimine odaklanır.





---

## 2. Arayüz ve Grid Yapısı (Dashboard)

Ana ekrandaki buton dizilimi, seçilen düzeyin gerektirdiği karmaşıklığa göre dinamik olarak değişmelidir.

| Düzey | Grid Düzeni | İçerik Özellikleri |
| --- | --- | --- |
| **Temel** | 4x3 Buton 

 | Anne, baba, yiyecek/içecek klasörleri, temel eylemler (ver, al, evet, hayır).

 |
| **Orta** | 5x4 Buton 

 | Temel düzeye ek olarak duygular, sıfatlar, zamirler ve özel klasörler.

 |
| **İleri** | 6x6 Buton 

 | Tamamen kullanıcıya özel, genişletilebilir ve yardıma ihtiyaç duyulmayan düzen.

 |

* 
**Navigasyon:** Sayfalar arası geçişi sağlayan "Önceki" ve "Sonraki" butonları, diğer butonlardan farklı renklerle ayrıştırılmalıdır.



---

## 3. Cümle Oluşturma ve Seslendirme (TTS)

* 
**Cümle Çubuğu:** Ekranın en üstünde, seçilen sembollerin yan yana dizildiği ve görselleştirildiği bir boşluk bulunmalıdır.


* **Seslendirme Mantığı:**
* Her butona basıldığında ilgili kelime anlık olarak seslendirilmelidir.


* Cümle tamamlandığında, tüm kelimeler ardışık olarak birleştirilip seslendirilmelidir.




* 
**Ses Kalitesi:** Robotik olmayan, insan sesine yakın kadın ve erkek sesi seçenekleri sunulmalıdır.


* 
**Kişisel Kayıt:** Kullanıcılar veya aileleri, her sembol için kendi seslerini kaydedebilmelidir.



---

## 4. İçerik Yönetimi ve Kişiselleştirme

Uygulama temel sembollerle yüklense de, kullanıcının hayatına uyum sağlaması için özelleştirilebilir olmalıdır.

* 
**Medya Değişimi:** Kullanıcılar, sembol resimlerini kendi çektikleri fotoğraflarla değiştirebilmelidir.


* 
**Zamir Sembolizasyonu:** Fotoğraf yüklemenin zor olduğu zamir gibi gruplar için sistem en iyi görselleştirmeyi sunmalıdır.


* 
**Kayıtlı Cümleler:** "Ev", "Okul" gibi kategorilere ayrılmış hazır cümle listeleri oluşturulabilmelidir.


* 
**Geçmiş:** Sık kullanılan cümlelere hızlı erişim sağlayan bir geçmiş bölümü bulunmalıdır.



---

## 5. Klavye Modülü

Okuma-yazma yetisi olan ancak konuşma güçlüğü çeken bireyler için özel bir ekran tasarlanmalıdır.

* 
**Yazıdan Sese:** Yazılan metinlerin seslendirilmesi için "Oku" butonu bulunmalıdır.


* 
**Düzenleme Araçları:** Tek tek karakter silme veya tüm metni temizleme fonksiyonları eklenmelidir.


* 
**Tahmin ve Öneri (İleri Aşama):** Kelime ve gramer hatalarının tespiti ve düzeltilmesi planlanmalıdır.



---

## 6. Teknik Gereksinimler ve Faz 1 Teslimatları

* 
**Görsel Estetik:** Arayüz, mevcut AAC uygulamalarından (örneğin Otsimo) daha modern ve estetik bir görünüme sahip olmalıdır.


* 
**Erişilebilirlik:** Renk paleti, dikkat dağınıklığı olan kullanıcılar için özel olarak seçilmelidir.


* 
**Eğitim Bölümü:** Uygulamanın nasıl kullanılacağını anlatan eğitici animasyonlar ve yardım menüsü yerleşik olmalıdır.



---





---



## 1. İçerik Stratejisi ve Hedef Kitle

* 
**Amaç:** Konuşma güçlüğü çeken, otizm tanılı veya bilişsel engeli bulunan bireylerin günlük ihtiyaçlarını en hızlı şekilde ifade etmelerini sağlamak.


* **Dil ve Ton:** Net, somut ve doğrudan ifadeler kullanılmalıdır. Karmaşık soyutlamalardan kaçınılmalıdır.
* **Görsel Eşleştirme:** Her öğe için evrensel AAC sembollerine (Sclera, Mulberry veya ARASAAC benzeri) uygun görsel açıklamaları oluşturulmalıdır.

## 2. Kullanım Düzeylerine Göre İçerik Dağılımı

### A. Temel Düzey (4x3 Grid - 12 Buton)

Bu düzeyde sadece "hayatta kalma" ve en temel istekler yer almalıdır:

* 
**Kişiler:** Anne, Baba.


* 
**Temel Gereksinimler:** Acıktım (Yiyecekler Klasörü), Susadım (İçecekler Klasörü).


* 
**Eylemler:** İstiyorum, İstemiyorum, Ver, Al.


* 
**Sosyal/Tepki:** Evet, Hayır, Merhaba, Teşekkür ederim.



### B. Orta Düzey (5x4 Grid - 20 Buton)

Temel düzeye ek olarak dil gelişimini destekleyen yapılar eklenmelidir:

* 
**Duygular:** Mutlu, Üzgün, Kızgın, Korkmuş.


* 
**Zamirler:** Ben, Sen, O, Biz, Siz, Onlar .


* 
**Sıfatlar:** Büyük, Küçük, Sıcak, Soğuk.


* 
**Mekanlar:** Ev, Okul, Park, Hastane.



### C. İleri Düzey (6x6 Grid - 36 Buton)

Bütünsel dil gelişimine odaklanan, spesifik detaylar içeren düzen:

* 
**Detaylı Yiyecekler:** Elma, Muz, Ekmek, Süt, Su, Meyve Suyu.


* **Zaman Kavramları:** Şimdi, Sonra, Sabah, Akşam.
* **Sorular:** Ne? Nerede? Kim? Neden?.


* 
**Gelişmiş Eylemler:** Oynamak istiyorum, Yardım et, Tuvalete gitmek istiyorum.



## 3. Veri Yapısı Gereksinimleri (Data Schema)

Ajan, her bir iletişim öğesini aşağıdaki `JSON` formatına uygun üretmelidir:

```json
{
  "id": "unique_id",
  "label": "Görünen Metin",
  "level": "Temel | Orta | İleri",
  "category": "Kategori İsmi",
  "icon_description": "Üretilecek görselin detaylı betimlemesi",
  "tts_text": "Seslendirilecek metin",
  "color_code": "Erişilebilirlik renk kodu"
}

```

## 4. Antigravity Ajanına Talimatlar

Ajan bu dosyayı okuduğunda aşağıdaki adımları sırasıyla gerçekleştirmelidir:

1. **Hiyerarşi Oluşturma:** Dokümandaki düzeylere göre klasör yapısını (Kategoriler) ve içindeki öğeleri bir `assets/data/initial_content.json` dosyası olarak üret.
2. **Görsel Seçimi:** `icon_description` alanına, Flutter projesinde kullanılacak placeholder sembollerin veya üretilecek görsellerin promptlarını yaz.
3. 
**Erişilebilirlik Kontrolü:** Görme engeli veya dikkat dağınıklığı olan kullanıcılar için buton kontrastlarını dokümandaki verilere göre (Faz 1) ayarla.


4. 
**Seslendirme Hazırlığı:** Her öğe için `flutter_tts` paketine gönderilecek olan net seslendirme metinlerini belirle.



---


