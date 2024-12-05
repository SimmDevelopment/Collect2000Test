SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_ContactAddresses]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	UPDATE Attunely_ContactAddresses SET
		Address_Line1 = d.Street1,
		Address_Line2 = d.Street2,
		Address_City = d.City,
		Address_State = d.State,
		Address_PostalCode = d.Zipcode,
		Address_Country_Id = 'AddressCountry|us',
		Party_Id = CASE d.Seq WHEN 0 THEN 'ContactParty|debtor' ELSE 'ContactParty|cosigner' END,
		Status_Id = CASE d.mr WHEN 'N' THEN 'ContactStatus|good_delivered' WHEN 'Y' THEN 'ContactStatus|bad_incorrect' ELSE 'ContactStatus|unknown_status' END,
		Source_Id = 'ContactSource|unknown_source',
		RecordTime = GETUTCDATE()	
	FROM Attunely_ContactAddresses a
	INNER JOIN Debtors d 
		ON a.AddressKey = d.DebtorID
	WHERE
		Address_Line1 NOT LIKE d.Street1 OR
		Address_Line2 NOT LIKE d.Street2 OR
		Address_City NOT LIKE d.City OR
		Address_State NOT LIKE d.State OR
		Address_PostalCode NOT LIKE d.Zipcode OR
		Address_Country_Id NOT LIKE 'AddressCountry|us' OR
		Party_Id NOT LIKE CASE d.Seq WHEN 0 THEN 'ContactParty|debtor' ELSE 'ContactParty|cosigner' END OR
		Status_Id NOT LIKE CASE d.mr WHEN 'N' THEN 'ContactStatus|good_delivered' WHEN 'Y' THEN 'ContactStatus|bad_incorrect' ELSE 'ContactStatus|unknown_status' END OR
		Source_Id NOT LIKE 'ContactSource|unknown_source'
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO [dbo].[Attunely_ContactAddresses]
           ([AccountKey]
           ,[AddressKey]
           ,[Address_Line1]
           ,[Address_Line2]
           ,[Address_Line3]
           ,[Address_City]
           ,[Address_State]
           ,[Address_PostalCode]
           ,[Address_Country_Id]
           ,[Party_Id]
           ,[OtherPartyDescription]
           ,[Status_Id]
           ,[Source_Id]
           ,[RecordTime]
           ,[Deleted])
	SELECT DISTINCT
		d.Number,
		d.DebtorID,
		d.Street1,
		d.Street2,
		null,
		d.City,
		d.State,
		d.Zipcode,
		'AddressCountry|us',
		CASE d.Seq WHEN 0 THEN 'ContactParty|debtor' ELSE 'ContactParty|cosigner' END,
		null,
		CASE d.mr WHEN 'N' THEN 'ContactStatus|good_delivered' WHEN 'Y' THEN 'ContactStatus|bad_incorrect' ELSE 'ContactStatus|unknown_status' END,
		'ContactSource|unknown_source',
		GETUTCDATE(),
		null
	FROM Attunely_AccountStubs a
		LEFT OUTER JOIN Attunely_ContactAddresses c
			ON a.AccountKey = c.AccountKey
	INNER JOIN Debtors d 
		ON a.AccountKey = d.Number
	WHERE
		c.AccountKey IS NULL
		AND d.Street1 IS NOT NULL
		AND d.Street1 <> ''

	IF @@ROWCOUNT > 0 SET @Updated = 1

	SELECT @Updated
END
GO
