SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Attunely_Staging_Letters]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	DECLARE @Updated BIT = 0

	INSERT INTO [dbo].[Attunely_Letters]
           ([AccountKey]
           ,[LetterKey]
           ,[VariationCode]
           ,[SentTime]
           ,[RecordTime])
	SELECT
		AccountId,
		LetterRequestID,
		LetterCode,
		DateProcessed,
		GETUTCDATE()
	FROM Attunely_AccountStubs a
		INNER JOIN LetterRequest l
			ON a.AccountKey = l.AccountID
		LEFT OUTER JOIN Attunely_Letters al
			ON l.LetterID = al.LetterKey
	WHERE al.LetterKey IS NULL
		AND (DateProcessed <> '1753-01-01 12:00:00.000')
		
	IF @@ROWCOUNT > 0 SET @Updated = 1

	SELECT @Updated
END
GO
