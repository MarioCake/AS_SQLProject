BEGIN TRAN

--|-------------------|
--|   CREATE TABLES   |
--|-------------------|

CREATE TABLE T_Kunden
(
 p_kunden_nr SMALLINT NOT NULL, 
 status CHAR NOT NULL,
 zahlung CHAR NOT NULL,
 vname VARCHAR (30) NOT NULL,
 nname VARCHAR (30) NOT NULL,
 strasse VARCHAR (30) NOT NULL,
 plz VARCHAR (10) NOT NULL,
 ort VARCHAR (30) NOT NULL,
 letztebestellung DATETIME, 
 letztewerbeaktion DATETIME
);

CREATE TABLE T_Girokonten
(
 p_f_kunden_nr SMALLINT NOT NULL,
 inhaber VARCHAR(30) NOT NULL,
 blz INT NOT NULL,
 kontonummer INT NOT NULL
);

CREATE TABLE T_Bestellungen
(
 p_bestell_nr INT NOT NULL,
 f_kunden_nr SMALLINT NOT NULL,
 bestelldatum DATETIME NOT NULL,
 lieferdatum DATETIME
);

CREATE TABLE T_MwstSaetze
(
 p_mwst_nr TINYINT NOT NULL,
 prozent DECIMAL (4,2) NOT NULL,
 beschreibung VARCHAR (20) NOT NULL
);

CREATE TABLE T_Artikel
(
 p_artikel_nr CHAR (4) NOT NULL,
 f_mwst_nr TINYINT NOT NULL,
 bezeichnung VARCHAR (100) NOT NULL,
 listenpreis DECIMAL(8,2) NOT NULL,
 bestand SMALLINT NOT NULL,
 mindestbestand SMALLINT NOT NULL,
 verpackung VARCHAR (30),
 lagerplatz TINYINT NOT NULL
);

CREATE TABLE T_Artikel_Bestellungen
(
 p_f_bestell_nr INT NOT NULL,
 p_f_artikel_nr CHAR(4) NOT NULL,
 bestellmenge SMALLINT NOT NULL,
 liefermenge SMALLINT,
 mwstprozent DECIMAL(4,2),
 kaufpreis DECIMAL(8,2)
);

--|------------------|
--|   PRIMARY KEYS   |
--|------------------|

/* T_Kunden */
ALTER TABLE T_Kunden ADD CONSTRAINT pk_T_Kunden PRIMARY KEY (p_kunden_nr);

/* T_Girokonten */
ALTER TABLE T_Girokonten ADD CONSTRAINT pk_T_Girokonten PRIMARY KEY (p_f_kunden_nr);

/* T_Bestellungen*/
ALTER TABLE T_Bestellungen ADD CONSTRAINT pk_T_Bestellungen PRIMARY KEY (p_bestell_nr);

/* T_MwstSaetze  */
ALTER TABLE T_MwstSaetze ADD CONSTRAINT pk_T_MwstSaetze PRIMARY KEY (p_mwst_nr);

/* T_Artikel */
ALTER TABLE T_Artikel ADD CONSTRAINT pk_T_Artikel PRIMARY KEY (p_artikel_nr);

/* T_Artikel_Bestellungen */
ALTER TABLE T_Artikel_Bestellungen ADD CONSTRAINT pk_T_Artikel_Bestellungen PRIMARY KEY (p_f_bestell_nr, p_f_artikel_nr);


--|------------------|
--|   FOREIGN KEYS   |
--|------------------|
/* T_Girokonten */
ALTER TABLE T_Girokonten ADD CONSTRAINT fk_T_Girokonten FOREIGN KEY (p_f_kunden_nr) REFERENCES T_Kunden (p_kunden_nr) ON UPDATE CASCADE ON DELETE CASCADE;

/* T_Bestellungen*/
ALTER TABLE T_Bestellungen ADD CONSTRAINT fk_T_Bestellungen FOREIGN KEY (f_kunden_nr) REFERENCES T_Kunden (p_kunden_nr) ON UPDATE CASCADE ON DELETE NO ACTION;

/* T_Artikel */
ALTER TABLE T_Artikel ADD CONSTRAINT fk_T_Artikel FOREIGN KEY (f_mwst_nr) REFERENCES T_MwstSaetze (p_mwst_nr) ON UPDATE CASCADE ON DELETE NO ACTION;

/* T_Artikel_Bestellungen */
ALTER TABLE T_Artikel_Bestellungen ADD CONSTRAINT fk_T_Artikel_Bestellungen_1 FOREIGN KEY (p_f_bestell_nr) REFERENCES T_Bestellungen (p_bestell_nr) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE T_Artikel_Bestellungen ADD CONSTRAINT fk_T_Artikel_Bestellungen_2 FOREIGN KEY (p_f_artikel_nr) REFERENCES T_Artikel (p_artikel_nr) ON UPDATE CASCADE ON DELETE NO ACTION;


--|------------------|
--|      CHECKS      |
--|------------------|
/* T_Kunden */
ALTER TABLE T_Kunden ADD CONSTRAINT ck_T_Kunden_status CHECK (status IN ('S','W','G'));
ALTER TABLE T_Kunden ADD CONSTRAINT ck_T_Kunden_zahlung CHECK (zahlung IN ('N','B','R','V','K'));


--|-----------------|
--|     INSERTS     |
--|-----------------|

SET LANGUAGE DEUTSCH;

INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (100, 'S', 'Hans', 'Voss', 'Kuhdamm 12', '23863', 'Nienwohld', NULL, '1.12.1995', 'N');
INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (101, 'S', 'Peter', 'Stein', 'Moordamm 34', '23863', 'Kayhude', '28.4.1996', '1.12.1995', 'B');
INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (102, 'W', 'Uwe', 'Berger', 'Allee 12 b', '25813', 'Husum', NULL, '1.12.1995', 'N');
INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (103, 'S', 'Nis', 'Randers', 'Am Seeufer 12', '23845', 'Oering', '15.5.1996', '14.1.1997', 'B');
INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (104, 'G', 'Ute', 'Andresen', 'Am Abhang', '24558', 'Ulzburg', NULL, NULL, 'B');
INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (105, 'S', 'Werner', 'Stuff', 'Tarper Weg', '24853', 'Eggebek', '12.5.1996', NULL, 'R');
INSERT INTO T_Kunden 
(p_kunden_nr, status, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion, zahlung )
VALUES (106, 'W', 'Hannes', 'Staack', 'An der Alster 1', '23863', 'Kayhude', NULL, '1.12.1995', 'N');

INSERT INTO T_Girokonten
(p_f_kunden_nr, inhaber, blz, kontonummer)
VALUES (101, 'Dagmar Stein', 23410022, 12346789);
INSERT INTO T_Girokonten
(p_f_kunden_nr, inhaber, blz, kontonummer)
VALUES (103, 'Tetsche Wind', 23410112, 20001234);

INSERT INTO T_MwstSaetze
(p_mwst_nr, prozent, beschreibung)
VALUES (0, 0, 'ohne');
INSERT INTO T_MwstSaetze
(p_mwst_nr, prozent, beschreibung)
VALUES (1, 7, 'erm‰ﬂigt');
INSERT INTO T_MwstSaetze
(p_mwst_nr, prozent, beschreibung)
VALUES (2, 19, 'volle');

INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('G001', 2, 'Whisky', 38.50, 397, 50, '0,7 l', 7);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('G002', 2, 'Portwein', 12.45, 473, 100, '0,5 l', 7);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('G003', 2, 'Bier', 5.20, 1250, 250, '6-er Pack', 7);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('K001', 2, 'Schuhe', 98.50, 120, 25, 'Karton', 2);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('K002', 2, 'Hose', 112.80, 62, 25, NULL, 2);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('K003', 2, 'Damenhut', 65.70, 12, 20, 'Karton', 2);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('K004', 1, 'Sonnenbrille', 76.00, 50, 20, 'Karton', 2);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('L001', 1, 'Ceylon Tee', 6.35, 356, 100, '125 g', 5);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('L002', 1, 'China Tee', 8.35, 42, 50, '125 g', 5);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('L003', 1, 'Naturreis', 1.78, 345, 0, '1 kg', 4);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('L004', 2, 'Schokolade', 0.98, 2101, 1000, 'Tafel', 2);
INSERT INTO T_Artikel
(p_artikel_nr, f_mwst_nr, bezeichnung, listenpreis, bestand, mindestbestand, verpackung, lagerplatz)
 VALUES ('L005', 2, 'Butterkekse', 1.72, 234, 250, '250 g', 2);

INSERT INTO T_Bestellungen
(p_bestell_nr, f_kunden_nr, bestelldatum, lieferdatum)
VALUES (960151, 101, '28.4.1996', '2.5.1996');
INSERT INTO T_Bestellungen
(p_bestell_nr, f_kunden_nr, bestelldatum, lieferdatum)
VALUES (960152, 103, '30.4.1996', '2.5.1996');
INSERT INTO T_Bestellungen
(p_bestell_nr, f_kunden_nr, bestelldatum, lieferdatum)
VALUES (960153, 105, '12.5.1996', NULL);
INSERT INTO T_Bestellungen
(p_bestell_nr, f_kunden_nr, bestelldatum, lieferdatum)
VALUES (960154, 103, '15.5.1996', NULL);

INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960151, 'G002', 4, 4, 15.00, 12.45);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960151, 'G003', 3, 3, 15.00, 5.20);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960151, 'K002', 3, 0, 15.00, 112.80);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960151, 'K003', 1, 1, 15.00, 65.70);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960151, 'L002', 10, 5, 7.00, 8.35);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960152, 'K001', 10, 10, 15.00, 98.50);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960152, 'K003', 2, 2, 15.00, 65.70);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960152, 'K004', 12, 12, 7.00, 76.00);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960153, 'G001', 2, NULL, NULL, NULL);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960153, 'L002', 6, NULL, NULL, NULL);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960153, 'L003', 25, NULL, NULL, NULL);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960153, 'L004', 5, NULL, NULL, NULL);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960154, 'G001', 4, NULL, NULL, NULL);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960154, 'G002', 12, NULL, NULL, NULL);
INSERT INTO T_Artikel_Bestellungen
(p_f_bestell_nr, p_f_artikel_nr, bestellmenge, liefermenge, mwstprozent, kaufpreis )
VALUES (960154, 'G003', 1, NULL, NULL, NULL);

COMMIT