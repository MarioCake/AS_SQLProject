BEGIN TRAN


/*
	|---------------|
	|  Aufgabe 1a   |
	|---------------|
*/
GO
CREATE PROCEDURE SchutzmaßnahmenBenötigt 
	@preis MONEY, @artikel CHAR(4) 
AS
BEGIN
	IF @preis < (SELECT listenpreis FROM T_Artikel WHERE p_artikel_nr = @artikel)
		PRINT 'Schutzmaßnahmen'
	ELSE
		PRINT 'Keine Schutzmaßnahmen';
END
GO

/*
	|---------------|
	|  Aufgabe 1b   |
	|---------------|
*/
CREATE PROCEDURE BonusErinnerung
AS
BEGIN
	DECLARE @anzahlBestellungen INT = (SELECT COUNT(*) FROM T_Bestellungen);
	IF @anzahlBestellungen > 1000
		PRINT 'Denk an die Boni Chef!';
	ELSE
		PRINT 'Gönn'' dir mal was Chef!';
END


/*
	|---------------|
	|  Aufgabe 1c   |
	|---------------|
*/
GO
CREATE PROCEDURE AendereStatus
AS
BEGIN
	UPDATE T_Kunden
	SET
		[status] = 'W'
	WHERE 
		letztebestellung < DATEADD(MONTH, -3, GETDATE());
END


/*
	|---------------|
	|  Aufgabe 1d   |
	|---------------|
*/
GO
CREATE PROCEDURE KundenBonusAnbieten @Kunde SMALLINT
AS
BEGIN
	DECLARE @anzahlBestellungen INT = (
		SELECT COUNT(*)
		FROM T_Bestellungen
		WHERE f_kunden_nr = @Kunde
	);
	IF @anzahlBestellungen > 5
		PRINT 'Kunde ' + CONVERT(VARCHAR, @Kunde) + ' Bonus anbieten';
END


/*
	|----------------|
	|  Aufgabe 1e/i  |
	|----------------|
*/
GO
CREATE PROCEDURE GeradeUndUngeradeZahlenBis @Zahl INT
AS BEGIN
	DECLARE @counter INT = 1;
	WHILE @counter <= @Zahl
	BEGIN
		IF @counter % 2 = 0
			PRINT CAST(@counter AS VARCHAR) + ' ist gerade.';
		ELSE
			PRINT CAST(@counter AS VARCHAR) + ' ist ungerade.';
		SET @counter += 1;
	END
END

/*
	|---------------|
	|  Aufgabe 1f   |
	|---------------|
*/
GO
CREATE PROCEDURE AlleKundenAusgeben
AS BEGIN
	DECLARE @msg VARCHAR(MAX) = '';

	SELECT @msg += CAST(p_kunden_nr AS VARCHAR) + ' - ' + vname + ' ' + nname + CHAR(13) + CHAR(10)
	FROM T_Kunden;

	PRINT @msg;
END


/*
	|---------------|
	|  Aufgabe 1g   |
	|---------------|
*/
GO
CREATE PROCEDURE KundenAbteilungen
AS BEGIN
	DECLARE @msg VARCHAR(MAX) = '';

	SELECT @msg += CAST(p_kunden_nr AS VARCHAR) + ' - ' + vname + ' ' + nname + ' ist in Abteilung 1.' + CHAR(13) + CHAR(10)
	FROM T_Kunden
	WHERE 
	(
		nname >= 'a' AND 
		nname < 'l'
	) 
	OR
	(
		nname >= 'A' AND
		nname < 'L'
	);


	SELECT @msg += CAST(p_kunden_nr AS VARCHAR) + ' - ' + vname + ' ' + nname + ' ist in Abteilung 2.' + CHAR(13) + CHAR(10)
	FROM T_Kunden
	WHERE 
	NOT 
	(
		(
			nname >= 'a' AND 
			nname < 'l'
		) 
		OR
		(
			nname >= 'A' AND
			nname < 'L'
		)
	);

	PRINT @msg;
END


/*
	|---------------|
	|  Aufgabe 1h   |
	|---------------|
*/
GO
CREATE PROCEDURE GirokontoZeile @Kontonummer INT
AS BEGIN
	WITH GirokontenMitZeilennummer AS
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY p_f_kunden_nr ASC) as RowNumber,
			*
		FROM T_Girokonten
	)
	SELECT *
	FROM  GirokontenMitZeilennummer
	WHERE kontonummer = @Kontonummer
END
GO


ROLLBACK