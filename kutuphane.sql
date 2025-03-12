--Derslere katılamadığım için yapay zeka ve youtubetan yardım aldım. Kendim için notlar ekledim.

-- Veritabanı oluşturma
CREATE DATABASE Library; --Bir kez database oluşturulurken çalıştırılır.
USE Library; --Library adlı veritabanını aktif hale getirir.

-- Adresler tablosu
CREATE TABLE Adresler (
    adresNo INT NOT NULL IDENTITY(1,1) PRIMARY KEY, --Birincil anahtarı oluşturur ve numarasını 1 den başlatıp her değerde +1 artırır.
    sehir NVARCHAR(100),
    cadde NVARCHAR(100),
    mahalle NVARCHAR(100),
    binaNo INT,
    postaKodu NVARCHAR(10),
    ulke NVARCHAR(100)
);

-- Üyeler tablosu
CREATE TABLE Uyeler (
    uyeNo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    uyeAdi NVARCHAR(50) NOT NULL, --Boş geçilemez kuralını ekler.
    uyeSoyadi NVARCHAR(50) NOT NULL,
    eposta NVARCHAR(100) UNIQUE, --Aynı e-postadan birden fazla girilmesini engeller.
    telefon NVARCHAR(20),
    cinsiyet CHAR(1) CHECK (cinsiyet IN ('E', 'K')), --Cinsiyetin sadece 'E' ve 'K' girilmesini sağlar.
    adresNo INT FOREIGN KEY REFERENCES Adresler(adresNo) ON DELETE SET NULL --Üye silindiğinde ona bağlı kayıtlara ne olacağını belirtir. Burada bağlı adres Null olarak güncellenir
);

-- Kütüphane tablosu
CREATE TABLE Kutuphane (
    kutuphaneNo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    kutuphaneIsmi NVARCHAR(100) NOT NULL,
    aciklama NVARCHAR(150),
    adresNo INT FOREIGN KEY REFERENCES Adresler(adresNo) ON DELETE SET NULL
);

-- Kitaplar tablosu
CREATE TABLE Kitaplar (
    ISBN BIGINT NOT NULL PRIMARY KEY,
    kitapAdi NVARCHAR(100) NOT NULL,
    sayfaSayisi INT CHECK (sayfaSayisi > 0), --Sayfa sayısı negatif olamayacağından bunu kontrol eden kural eklendi.
    yayinTarihi DATE
);

-- Yazarlar tablosu
CREATE TABLE Yazarlar (
    yazarNo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    yazarAdi NVARCHAR(100) NOT NULL,
    yazarSoyadi NVARCHAR(100) NOT NULL
);

-- Kitap - Yazar ilişki tablosu (n-m ilişki)
CREATE TABLE KitapYazar (
    ISBN BIGINT NOT NULL,
    yazarNo INT NOT NULL,
    PRIMARY KEY (ISBN, yazarNo),
    FOREIGN KEY (ISBN) REFERENCES Kitaplar(ISBN) ON DELETE CASCADE, --Cascade bağlı olan diğer elamanı da tamamen siler.
    FOREIGN KEY (yazarNo) REFERENCES Yazarlar(yazarNo) ON DELETE CASCADE
);

-- Kategoriler tablosu
CREATE TABLE Kategoriler (
    kategoriNo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    kategoriAdi NVARCHAR(100) NOT NULL
);

-- Kitap - Kategori ilişki tablosu (n-m ilişki)
CREATE TABLE KitapKategori (
    ISBN BIGINT NOT NULL,
    kategoriNo INT NOT NULL,
    PRIMARY KEY (ISBN, kategoriNo),
    FOREIGN KEY (ISBN) REFERENCES Kitaplar(ISBN) ON DELETE CASCADE,
    FOREIGN KEY (kategoriNo) REFERENCES Kategoriler(kategoriNo) ON DELETE CASCADE
);

-- Kütüphane - Kitap ilişki tablosu (m-n ilişki)
CREATE TABLE KutuphaneKitap (
    kutuphaneNo INT NOT NULL,
    ISBN BIGINT NOT NULL,
    miktar INT CHECK (miktar >= 0), -- Kitap adedi negatif olamaz
    PRIMARY KEY (kutuphaneNo, ISBN),
    FOREIGN KEY (kutuphaneNo) REFERENCES Kutuphane(kutuphaneNo) ON DELETE CASCADE,
    FOREIGN KEY (ISBN) REFERENCES Kitaplar(ISBN) ON DELETE CASCADE
);

-- Emanet (Ödünç) tablosu
CREATE TABLE Emanet (
    emanetNo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    emanetTarihi DATE NOT NULL,
    teslimTarihi DATE,
    uyeNo INT FOREIGN KEY REFERENCES Uyeler(uyeNo) ON DELETE NO ACTION, --Eğer üyenin emaneti varsa silme işlemi hata verecek ve iptal olacak.
    kutuphaneNo INT FOREIGN KEY REFERENCES Kutuphane(kutuphaneNo) ON DELETE CASCADE,
    ISBN BIGINT FOREIGN KEY REFERENCES Kitaplar(ISBN) ON DELETE CASCADE
);
