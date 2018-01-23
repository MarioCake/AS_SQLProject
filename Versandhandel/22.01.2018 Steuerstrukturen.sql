BEGIN TRAN

GO
-- DROP PROCEDURE SchutzmaßnahmenBenötigt
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

-- DROP PROCEDURE BonusErinnerung
CREATE PROCEDURE BonusErinnerung
AS
BEGIN
	DECLARE @anzahlBestellungen INT = (SELECT COUNT(*) FROM T_Bestellungen);
	IF @anzahlBestellungen > 1000
		PRINT 'Denk an die Boni Chef!';
	ELSE
		PRINT 'Gönn'' dir mal was Chef!';
END
GO

-- DROP PROCEDURE AendereStatus
CREATE PROCEDURE AendereStatus
AS
BEGIN
	UPDATE T_Kunden
	SET
		[status] = 'W'
	WHERE 
		letztebestellung < DATEADD(MONTH, -3, GETDATE());
END
GO

-- DROP PROCEDURE KundenBonusAnbieten
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
GO

-- DROP PROCEDURE GeradeUndUngeradeZahlenBis
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
GO

EXEC GeradeUndUngeradeZahlenBis 1000;

GO
CREATE PROCEDURE AlleKundenAusgeben
AS BEGIN
	DECLARE @msg VARCHAR(MAX) = '';

	SELECT @msg += CAST(p_kunden_nr AS VARCHAR) + ' - ' + vname + ' ' + nname + CHAR(13) + CHAR(10)
	FROM T_Kunden;

	PRINT @msg;
END
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
GO

CREATE PROCEDURE GirokontoZeile @Kunde SMALLINT
AS BEGIN
	WITH GirokontenMitZeilennummer AS
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY p_f_kunden_nr ASC) as RowNumber, 
			p_f_kunden_nr
		FROM T_Girokonten
	)
	SELECT RowNumber, T_Girokonten.*
	FROM T_Girokonten
		JOIN GirokontenMitZeilennummer AS [Row]
			ON [Row].p_f_kunden_nr = T_Girokonten.p_f_kunden_nr
	WHERE T_Girokonten.p_f_kunden_nr = @Kunde
END
GO

ROLLBACK