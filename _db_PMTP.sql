/*
DROP  VIEW [vw_PersonelMaaslari_Crosstab]
DROP  VIEW [vw_PersonelYillikMaaslari]
DROP  VIEW [vw_PersonellerListesi]
DROP  VIEW [vw_PersonelIletisim]
DROP  VIEW [vw_PersonelAylikMaaslari]
DROP  VIEW [vw_PersonelPIVOTTablosu]
GO

DROP TABLE [tbl_Kategoriler]
DROP TABLE [tbl_PersonelMaaslari]
DROP TABLE [tbl_Bolumler]
DROP TABLE [tbl_Personeller]

*/


/****** tbl_Bolumler Tablosunu yaratma ****/
CREATE TABLE [dbo].[tbl_Bolumler](
	[Bolum_ID] [int] IDENTITY(1,1) NOT NULL,
	[Bolum_Adi] [nvarchar](50) NOT NULL,
	[Bolum_Tel] [nvarchar](15) NULL,
 CONSTRAINT [PK_tbl_Bolumler_Bolum_ID] PRIMARY KEY CLUSTERED ([Bolum_ID] ASC))
GO

/****** tbl_Bolumler Tablo verisini girme ****/
INSERT INTO tbl_Bolumler (Bolum_Adi, Bolum_Tel)
VALUES ('Bilişim Sistemleri', '3721112222'),
('Pazarlama', '3722223333'),
('Satış', '3723334444'),
('Muhasebe', '3724445555'),
('Finans', '3725556666'),
('Yönetim', '3726667777')
GO

/****** tbl_Personeller Tablosunu yaratma ****/
CREATE TABLE [dbo].[tbl_Personeller](
	[Pers_ID] [int] IDENTITY(1,1) NOT NULL,
	[Pers_Adi] [nvarchar](50) NOT NULL,
	[Pers_Soyadi] [nvarchar](50) NOT NULL,
	[Pers_Isim]  AS (([Pers_Adi]+' ')+[Pers_Soyadi]),
	[Pers_DTarihi] [smalldatetime] NULL,
	[Pers_Ise_Giris_Tarihi] [smalldatetime] NULL,
	[Pers_Isten_Cikis_Tarihi] [smalldatetime] NULL,
	[Pers_Adresi] [nvarchar](100) NULL,
	[Pers_Kenti] [nvarchar](20) NULL,
	[Pers_Ili] [nvarchar](20) NULL,
	[Pers_Il_Kodu] [char](2) NULL,
	[Pers_Tel] [nvarchar](15) NULL,
	[Pers_Cep] [nvarchar](15) NULL,
	[Pers_Email] [nvarchar](100) NULL,
	[Bolum_ID] [int] NOT NULL,
	[Pers_Maas] [money] NULL,
	[Pers_Komisyon_Yuzdesi] [float] NULL,
	[Cinsiyet_ID] [int] NULL,
	[Pers_Unvani] [nvarchar](50) NULL,
	[Pers_SGK_No] [char](10) NULL,
	[Pers_TC_No] [nvarchar](15) NULL,
	[Pers_Aktif_Mi] [bit] NOT NULL,
	[Kayit_ID] [int] NULL,
	[Kayit_Tarihi] [smalldatetime] NULL,
	[Pers_Foto] [image] NULL,
	[Pers_CV] [ntext] NULL,
	[Pers_CV_File] [nvarchar](100) NULL,
	[Pers_CV_Web] [nvarchar](2500) NULL,
 CONSTRAINT [PK_tbl_Personeller_Pers_ID] PRIMARY KEY CLUSTERED ([Pers_ID] ASC))
GO

INSERT INTO tbl_Personeller (Pers_Adi, Pers_Soyadi, Pers_DTarihi, Bolum_ID, Pers_Ise_Giris_Tarihi, Pers_Isten_Cikis_Tarihi, Pers_Adresi, Pers_Kenti, Pers_Ili, Pers_Il_Kodu, Pers_Maas, Pers_Komisyon_Yuzdesi, Pers_Tel, Pers_Cep, 
Pers_Email, Cinsiyet_ID, Pers_Unvani, Pers_SGK_No, Pers_Aktif_Mi)
VALUES ('Mustafa', 'Çoruh', '1.1.1962', 1, '01.06.2016', NULL, 'Uzun Sok. No 1', 'Kdz. Ereğli', 'Zonguldak', '67', 4500, 0, '3721111222','5371111222', 'mcoruh@mustafacoruh.com', 1, 'VTY', '22233344', 1),
('Buğra', 'Diniz', '1.1.1998',3, '01.07.2016', NULL, 'Kısa Sok. No 2', 'Merkez', 'Bartın','74', 2750, 0.10, NULL, '5353333444', 'bdiniz@gmail.com', 1, 'Satış Elemanı', '66677788', 1),
('Burak', 'Oğuz', '1.1.1993', 2, '01.08.2016', NULL, 'Alt Sok. No 3', 'Beylikdüzü', 'İstanbul', '34', 3000, 0.12, NULL, '5371234567', 'boguz@gmail.com', 1, 'Pazarlamacı', '77788899', 1),
('Ayşe', 'Meliha', '1.1.1968', 6, '01.10.2016', NULL, 'Yukarı Sok No 4', 'Sincan', 'Ankara', '06', 3500, 0, NULL, '5361234567', 'ameliha@mustafacoruh.com', 2, 'Ofis Yöneticisi', '33344455', 1)
GO

-- Fotoğrafı güncelle, Resmin klasörünü değiştirebilirsiniz...
UPDATE tbl_Personeller SET Pers_Foto = (SELECT * FROM OpenRowSet (BULK 'D:\Mustafa-Resim.jpg', SINGLE_BLOB) Pers_Resim)
WHERE Pers_ID=1
GO

-- CV File güncelle
UPDATE tbl_Personeller
SET Pers_CV_File = 'D:\CV-MustafaCoruh.pdf'
WHERE Pers_ID=1
GO

-- CV File güncelle
UPDATE tbl_Personeller
SET Pers_CV_Web = 'http://www.mustafacoruh.com/PDFs/MustafaCoruhEdu.pdf'
WHERE Pers_ID=1
GO

/****** tbl_PersonelMaaslari Tablosunu yaratma ****/
CREATE TABLE [dbo].[tbl_PersonelMaaslari](
	[Maas_ID] [int] IDENTITY(1,1) NOT NULL,
	[Pers_ID] [int] NOT NULL,
	[Maas_Odeme_Tarihi] [smalldatetime] NOT NULL,
	[Maas_Tutari] [money] NOT NULL,
	[Maas_Komisyon] [money] NOT NULL,
	[Maas_Toplam]  AS ([Maas_Tutari]+[Maas_Komisyon]),
    [Ay_ID] AS (datepart(month,[Maas_Odeme_Tarihi])),
	[Maas_Yili] AS (datepart(year,[Maas_Odeme_Tarihi])),
 CONSTRAINT [PK_tbl_PersonelMaaslari_Maas_ID] PRIMARY KEY CLUSTERED ([Maas_ID] ASC))
GO

INSERT INTO tbl_PersonelMaaslari (Pers_ID, Maas_Odeme_Tarihi, Maas_Tutari, Maas_Komisyon)
VALUES (1, '07.01.2020', 3540, 0),
(1, '08.01.2020', 3540, 0),
(1, '09.01.2020', 3540, 0),
(1, '10.01.2020', 3540, 0),
(1, '11.01.2020', 3540, 0),
(1, '12.01.2020', 3540, 0),
(2, '11.01.2020', 2500, 1200),
(2, '12.01.2020', 2500, 1000),
(3, '12.01.2020', 3000, 1000),
(4, '12.01.2020', 3500, 0)
GO

-- DROP TABLE [tbl_Kategoriler]
-- tbl_Kategoriler tablosunu oluşturma
CREATE TABLE [dbo] . [tbl_Kategoriler](
[Kategori_ID] [int] IDENTITY(1,1)  NOT NULL,
[Cinsiyet] [nvarchar](50 )  NULL,
[Unvan] [nvarchar](50 )   NULL,
[Kent_Adi] [nvarchar](50 )  NULL,
[Ulke] [nvarchar](50 )   NULL,
[Il_Adi] [nvarchar](50 )   NULL,
[Ay_Adi] [nvarchar](50) NULL, 
CONSTRAINT[PK_tbl_Kategoriler_Kategori_ID] PRIMARY KEY CLUSTERED ([Kategori_ID] ASC ))
GO 

INSERT INTO [dbo] . [tbl_Kategoriler] ([Cinsiyet],[Unvan],[Kent_Adi],[Ulke],[Il_Adi], [Ay_Adi])
VALUES (N'Erkek',N'VT Yöneticisi',N'Merkez',N'Türkiye',N'Adana',N'Ocak'),
(N'Kadın',N'Satış Elemanı',N'Kdz.Ereğli',N'ABD',N'Zonguldak',N'Şubat'),
(NULL,N'Pazarlamacı',N'Alaplı',N'İngiltere',N'İstanbul',N'Mart'),
(NULL,N'Ofis Yöneticisi',N'Beylikdüzü',N'Kanada',N'Düzce',N'Nisan'),
(NULL,N'CIO',N'Kızılay',N'Meksika',N'Amasya',N'Mayıs'),
(NULL,N'CEO',N'Sincan',N'Almanya',N'Ankara',N'Haziran'),
(NULL,N'Müdür',N'Merkez',N'Brezilya',N'Antalya',N'Temmuz'),
(NULL, N'Mühendis',N'Arnavutköy',N'İsveç',N'Artvin',N'Ağustos'),
(NULL,N'İşçi',N'Ümraniye',N'Fransa',N'Aydın',N'Eylül'),
(NULL,N'Memur',N'Maltepe',N'Kolombiya',N'Balıkesir',N'Ekim'),
(NULL,N'Teknik Servis Elemanı',N'Üsküdar',N'İtalya',N'Bilecik',N'Kasım'),
(NULL,N'Asistan',N'Sultanbeyli',N'Polonya',N'Bingöl',N'Aralık'),
(NULL,N'BLG Yöneticisi',N'Şile',N'G.Afrika',N'Bitlis', NULL),
(NULL,N'Elektrikçi',N'Şişli',N'Arjantin',N'Bolu', NULL),
(NULL,N'Polis',N'Sarıgazi',N'Avusturya',N'Burdur', NULL),
(NULL,N'Güvenlik',N'Levent',N'Avustralya',N'Bursa', NULL),
(NULL,N'Bekçi',N'Esenler',N'Belçika',N'Çanakkale', NULL),
(NULL,N'Danışman',N'Bahçelievler',N'İsviçre',N'Çankırı', NULL),
(NULL,N'Sekreter',N'Mecidiyeköy',N'İspanya',N'Çorum', NULL)
GO


-- Tablolar arası ilişkileri oluşturma
ALTER TABLE [dbo].[tbl_Personeller]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Personeller_tbl_Bolumler_Bolum_ID] FOREIGN KEY([Bolum_ID])
REFERENCES [dbo].[tbl_Bolumler] ([Bolum_ID])
GO
ALTER TABLE [dbo].[tbl_Personeller] CHECK CONSTRAINT [FK_tbl_Personeller_tbl_Bolumler_Bolum_ID]
GO

ALTER TABLE [dbo].[tbl_PersonelMaaslari]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PersonelMaaslari_tbl_Personeller_Pers_ID] FOREIGN KEY([Pers_ID])
REFERENCES [dbo].[tbl_Personeller] ([Pers_ID])
GO
ALTER TABLE [dbo].[tbl_PersonelMaaslari] CHECK CONSTRAINT [FK_tbl_PersonelMaaslari_tbl_Personeller_Pers_ID]
GO

-- Tablolarda DEFAULT oluşturma
ALTER TABLE [tbl_Personeller] ADD CONSTRAINT [DF_tbl_Personeller_Pers_Maas]  DEFAULT ((0)) FOR [Pers_Maas]
ALTER TABLE [tbl_Personeller] ADD CONSTRAINT [DF_tbl_Personeller_Pers_Komisyon_Yuzdesi]  DEFAULT ((0)) FOR [Pers_Komisyon_Yuzdesi]
ALTER TABLE [tbl_Personeller] ADD CONSTRAINT [DF_tbl_Personeller_Pers_Aktif_Mi]  DEFAULT ((1)) FOR [Pers_Aktif_Mi]
ALTER TABLE [tbl_Personeller] ADD CONSTRAINT [DF_tbl_Personeller_Pers_Ise_Giris_Tarihi]  DEFAULT (getdate()) FOR [Pers_Ise_Giris_Tarihi]
GO

ALTER TABLE [tbl_PersonelMaaslari] ADD CONSTRAINT [DF_tbl_PersonelMaaslari_Maas_Tutari]  DEFAULT ((0)) FOR [Maas_Tutari]
ALTER TABLE [tbl_PersonelMaaslari] ADD CONSTRAINT [DF_tbl_PersonelMaaslari_Maas_Komisyon]  DEFAULT ((0)) FOR [Maas_Komisyon]
ALTER TABLE [tbl_PersonelMaaslari] ADD CONSTRAINT [DF_tbl_PersonelMaaslari_Maas_Odeme_Tarihi]  DEFAULT (getdate()) FOR [Maas_Odeme_Tarihi]
GO

-- Pivot Tablo oluşturma. SELECT kısmı tek başına, sonrada PIVOT'la birlikte çalıştırınca aradaki fark görülebilir.
CREATE VIEW [dbo].[vw_PersonelPIVOTTablosu] AS
SELECT * FROM (SELECT Pers_Adi, Pers_Ili, COUNT(Pers_ID) AS ElemanSayisi FROM tbl_Personeller
GROUP BY Pers_Adi, Pers_Ili) AS ElemanSayisi
PIVOT
(COUNT(ElemanSayisi) FOR Pers_Ili IN ([Bursa], [Ankara], [İstanbul],[İzmir],[Zonguldak])) AS P
GO
--SELECT * FROM vw_PersonelPIVOTTablosu
GO

CREATE VIEW [dbo].[vw_PersonelAylikMaaslari]
AS
SELECT [Pers_Isim], tbl_Personeller.Pers_Unvani, [Maas_Tutari]+[Maas_Komisyon] AS MaasToplam, tbl_Kategoriler.Ay_Adi, tbl_PersonelMaaslari.Maas_Tutari, tbl_PersonelMaaslari.Maas_Komisyon, tbl_PersonelMaaslari.Maas_Yili
FROM tbl_Kategoriler INNER JOIN ((tbl_Bolumler INNER JOIN tbl_Personeller ON tbl_Bolumler.Bolum_ID = tbl_Personeller.[Bolum_ID]) INNER JOIN tbl_PersonelMaaslari ON tbl_Personeller.Pers_ID = tbl_PersonelMaaslari.[Pers_ID]) ON tbl_Kategoriler.[Kategori_ID] = tbl_PersonelMaaslari.[Ay_ID]
GO

CREATE VIEW [dbo].[vw_PersonelIletisim]
AS
SELECT tbl_Personeller.Pers_ID, [Pers_Isim], tbl_Personeller.Pers_Soyadi, tbl_Personeller.Pers_Tel, tbl_Personeller.Pers_Cep, tbl_Personeller.Pers_Email, tbl_Bolumler.Bolum_Adi AS Bolum
FROM tbl_Bolumler INNER JOIN tbl_Personeller ON tbl_Bolumler.Bolum_ID = tbl_Personeller.Bolum_ID
GO

CREATE VIEW [dbo].[vw_PersonellerListesi]
AS
SELECT tbl_Personeller.Pers_ID, tbl_Personeller.Pers_Adi, tbl_Personeller.Pers_Soyadi, [Pers_Isim], tbl_Personeller.Pers_DTarihi, tbl_Personeller.Pers_Ise_Giris_Tarihi, tbl_Personeller.Pers_Isten_Cikis_Tarihi, tbl_Personeller.Pers_Cep, tbl_Personeller.Pers_Email, tbl_Personeller.Pers_Unvani, tbl_Personeller.Pers_Aktif_Mi, tbl_Bolumler.Bolum_Adi
FROM tbl_Bolumler INNER JOIN tbl_Personeller ON tbl_Bolumler.Bolum_ID = tbl_Personeller.Bolum_ID
GO

CREATE VIEW [dbo].[vw_PersonelYillikMaaslari]
AS
SELECT vw_PersonelAylikMaaslari.Pers_Isim AS Personel, vw_PersonelAylikMaaslari.Maas_Yili AS Yil, Sum(vw_PersonelAylikMaaslari.MaasToplam) AS Toplam
FROM vw_PersonelAylikMaaslari
GROUP BY vw_PersonelAylikMaaslari.Pers_Isim, vw_PersonelAylikMaaslari.Maas_Yili
GO

CREATE VIEW [dbo].[vw_PersonelMaaslari_Crosstab] 	AS 

SELECT vw_PersonelAylikMaaslari.Pers_Isim, vw_PersonelAylikMaaslari.Maas_Yili, Sum(vw_PersonelAylikMaaslari.MaasToplam) AS MaasToplam
FROM vw_PersonelAylikMaaslari
GROUP BY vw_PersonelAylikMaaslari.Pers_Isim, vw_PersonelAylikMaaslari.Maas_Yili
GO
