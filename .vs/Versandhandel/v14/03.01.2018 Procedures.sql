BEGIN TRAN
GO
CREATE PROCEDURE duplikateAutomatisch @KundenId SMALLINT
AS
BEGIN
	DECLARE @NewKundenId SMALLINT = (SELECT MAX([p_kunden_nr]) + 1 FROM [db_ddladmin].[T_Kunden]);

	INSERT INTO [db_ddladmin].[T_Kunden] 
	(p_kunden_nr, status, zahlung, vname, nname, strasse, plz, ort, letztebestellung, letztewerbeaktion)
	SELECT 
		@NewKundenId, 
		status, 
		zahlung, 
		vname, 
		nname, 
		strasse, 
		plz, 
		ort, 
		letztebestellung, 
		letztewerbeaktion
	FROM [db_ddladmin].[T_Kunden]
	WHERE
		p_kunden_nr = @KundenId;
		

END
GO

CREATE PROCEDURE listenpreisKaufpreisUnterschiedlich
AS
BEGIN
	SELECT p_f_artikel_nr, p_f_bestell_nr
	FROM T_Artikel_Bestellungen
		JOIN T_Artikel
		ON p_f_artikel_nr = p_artikel_nr
	WHERE 
		listenpreis <> kaufpreis;
END
GO

CREATE TABLE T_Bestellungen_Ungeloest
(
	p_id INT NOT NULL IDENTITY(1,1),
	f_art_nr CHAR(4) NOT NULL,
	f_bestell_nr INT NOT NULL
);

ALTER TABLE T_Bestellungen_Ungeloest
	ADD CONSTRAINT PK_T_Bestellungen_Ungeloest
		PRIMARY KEY (p_id);

ALTER TABLE T_Bestellungen_Ungeloest
	ADD CONSTRAINT FK_T_Bestellungen_Ungeloest_Artikel
		FOREIGN KEY (f_art_nr)
			REFERENCES T_Artikel (p_artikel_nr)
			ON UPDATE CASCADE
			ON DELETE NO ACTION;

ALTER TABLE T_Bestellungen_Ungeloest
	ADD CONSTRAINT FK_T_Bestellungen_Ungeloest
		FOREIGN KEY (f_bestell_nr)
			REFERENCES T_Bestellungen (p_bestell_nr)
			ON UPDATE CASCADE
			ON DELETE NO ACTION;

GO
ALTER PROCEDURE listenpreisKaufpreisUnterschiedlich
AS
BEGIN
	TRUNCATE TABLE T_Bestellungen_Ungeloest;

	INSERT INTO T_Bestellungen_Ungeloest 
	(f_art_nr, f_bestell_nr)
	SELECT p_f_artikel_nr, p_f_bestell_nr
	FROM T_Artikel_Bestellungen
		JOIN T_Artikel
		ON p_f_artikel_nr = p_artikel_nr
	WHERE 
		listenpreis <> kaufpreis
END
GO		

EXECUTE listenpreisKaufpreisUnterschiedlich;
SELECT * FROM T_Bestellungen_Ungeloest;

ROLLBACK