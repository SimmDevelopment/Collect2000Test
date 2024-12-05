SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Attunely_Staging_ContactEmails]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; DECLARE @Updated BIT = 0

	UPDATE Attunely_ContactEmails SET
		Email = d.Email,
		Party_Id = CASE d.Seq WHEN 0 THEN 'ContactParty|debtor' ELSE 'ContactParty|cosigner' END,
		EndpointType_Id = 'EmailEndpointType|personal',
		Status_Id = 'ContactStatus|unknown_status',
		Source_Id = 'ContactSource|unknown_source',
		RecordTime = GETUTCDATE()	
	FROM Attunely_ContactEmails a
	INNER JOIN Debtors d 
		ON a.EmailKey = d.DebtorID
	WHERE
		a.Email NOT LIKE d.Email OR
		Party_Id NOT LIKE CASE d.Seq WHEN 0 THEN 'ContactParty|debtor' ELSE 'ContactParty|cosigner' END
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO [dbo].Attunely_ContactEmails
           ([AccountKey]
		   ,[EmailKey]
		   ,[Email]
           ,[Party_Id]
           ,[OtherPartyDescription]
		   ,[EndpointType_Id]
           ,[Status_Id]
           ,[Source_Id]
           ,[RecordTime]
           ,[Deleted])
	SELECT DISTINCT
		d.Number,
		d.DebtorID,
		d.Email,
		CASE d.Seq WHEN 0 THEN 'ContactParty|debtor' ELSE 'ContactParty|cosigner' END,
		null,
		'EmailEndpointType|personal',
		'ContactStatus|unknown_status',
		'ContactSource|unknown_source',
		GETUTCDATE(),
		null
	FROM Attunely_AccountStubs a
		LEFT OUTER JOIN Attunely_ContactEmails c
			ON a.AccountKey = c.AccountKey
	INNER JOIN Debtors d 
		ON a.AccountKey = d.Number
	WHERE
		c.AccountKey IS NULL
		AND d.Email IS NOT NULL
		AND d.Email <> ''

	IF @@ROWCOUNT > 0 SET @Updated = 1
	SELECT @Updated
END
GO
