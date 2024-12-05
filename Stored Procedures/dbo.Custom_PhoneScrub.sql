SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_PhoneScrub]
AS

SET XACT_ABORT ON

BEGIN TRAN

DECLARE @phones TABLE (number int, DebtorID int, Seq int, PhoneType varchar(10), OldPhone varchar(30), NewPhone varchar(30))

INSERT @phones
SELECT m.number, DebtorID, d.Seq, 'Home', d.homephone, dbo.StripNonDigits(d.homephone)
FROM master m INNER JOIN status
	ON status = code INNER JOIN debtors d
	ON m.number = d.number
WHERE (d.homephone IN 
	('0000000000', '1111111111', '2222222222', '3333333333', '4444444444', '5555555555','6666666666', '7777777777',
	'8888888888', '9999999999') 
	OR (d.homephone NOT LIKE REPLICATE('[0-9]', 10) AND LTRIM(d.homephone) <> '') or substring(d.homephone, 1, 3) in ('000', '111', '222', 
	'333', '444', '555', '666', '777', '888', '999'))
	AND statustype = '0 - Active'


INSERT @phones
SELECT m.number, DebtorID, d.Seq, 'Work', 'oldphone' = case when d.workphone is null then '' else d.workphone end , 
	'newphone' = case when dbo.StripNonDigits(d.workphone) is null then '' else dbo.StripNonDigits(d.workphone) end
FROM master m INNER JOIN status
	ON status = code INNER JOIN debtors d
	ON m.number = d.number
WHERE (d.workphone IN
	('0000000000', '1111111111', '2222222222', '3333333333', '4444444444', '5555555555','6666666666', '7777777777',
	'8888888888', '9999999999') 
	OR (d.workphone NOT LIKE REPLICATE('[0-9]', 10) AND LTRIM(d.workphone) <> '') or substring(d.workphone, 1, 3) in ('000', '111', '222', 
	'333', '444', '555', '666', '777', '888', '999'))
	AND statustype = '0 - Active'

/*Get rid of 1 in front of some numbers */
UPDATE @phones
SET NewPhone = RIGHT(NewPhone, 10) 
WHERE LEN(NewPhone) = 11 AND LEFT(NewPhone, 1) = '1'

/*Remove numbers that are too many digits, or are invalid (1111111...etc)*/
UPDATE @phones
SET NewPhone = NULL
WHERE LEN(NewPhone) <> 10 OR NewPhone IN ('0000000000', '1111111111', '2222222222', '3333333333', '4444444444', '5555555555','6666666666', '7777777777',
	'8888888888', '9999999999')  or substring(NewPhone, 1, 3) in ('000', '111', '222', 
	'333', '444', '555', '666', '777', '888', '999')


INSERT INTO [dbo].[notes] ([number], [created], [UtcCreated], [user0], [action], [result], [comment])
SELECT number, GETDATE(), GETUTCDATE(), 'PHONESCRUB', 'PHONE', 'CHNG', CASE 
	WHEN NewPhone IS NULL THEN 'Debtor(' + CONVERT(varchar, Seq) + ') ' + PhoneType + 
		' Phone # Removed.  Old #: ' + OldPhone 
	ELSE 'Debtor(' + CONVERT(varchar, Seq) + ') ' + PhoneType + 
		' Phone # changed from ' + OldPhone + ' to ' + NewPhone 
	END
FROM @phones 

INSERT PhoneHistory(AccountID, DebtorID, DateChanged, UserChanged, Phonetype, OldNumber, NewNumber)
SELECT number, DebtorID, GETDATE(), 'PHONESCRUB', CASE PhoneType WHEN 'Home' THEN 1 ELSE 2 END,
	OldPhone, COALESCE(NewPhone, '')
FROM @phones


--perform the actual update
UPDATE d
SET homephone = NewPhone 
FROM Debtors d INNER JOIN @phones p
	ON d.DebtorID = p.DebtorID
WHERE PhoneType = 'Home'

UPDATE d
SET workphone = NewPhone 
FROM Debtors d INNER JOIN @phones p
	ON d.DebtorID = p.DebtorID
WHERE PhoneType = 'Work'

UPDATE m
SET homephone = NewPhone 
FROM master m INNER JOIN @phones p
	ON m.number = p.number
WHERE PhoneType = 'Home' AND p.Seq = 0

UPDATE m
SET workphone = NewPhone 
FROM master m INNER JOIN @phones p
	ON m.number = p.number
WHERE PhoneType = 'Work' AND p.Seq = 0



COMMIT
GO
