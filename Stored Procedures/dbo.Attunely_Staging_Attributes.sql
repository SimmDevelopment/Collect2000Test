SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_Attributes]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; DECLARE @Updated BIT = 0
	
	UPDATE Attunely_Attributes
	SET [Value] = m.Zipcode, RecordTime = GETUTCDATE()
	FROM Attunely_Attributes d
		INNER JOIN Attunely_AccountStubs a 
			ON d.AccountKey = a.AccountKey 
		INNER JOIN master m 
			ON m.number = a.AccountKey
	WHERE FieldName_Id = 'AttributeFieldName|account.attribute.zipcode'
	AND d.Value NOT LIKE m.Zipcode
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO Attunely_Attributes (Id, AccountKey, FieldName_Id, [Value], RecordTime)
	SELECT NEWID(), m.number, 'AttributeFieldName|account.attribute.zipcode', m.Zipcode, GETUTCDATE()
	FROM Attunely_AccountStubs a
		LEFT OUTER JOIN Attunely_Attributes d
			ON d.AccountKey = a.AccountKey 
		INNER JOIN master m 
			ON m.number = a.AccountKey
	WHERE d.AccountKey IS NULL
	
	IF @@ROWCOUNT > 0 SET @Updated = 1
	
	UPDATE Attunely_Attributes
	SET [Value] = m.State, RecordTime = GETUTCDATE()
	FROM Attunely_Attributes d
		INNER JOIN Attunely_AccountStubs a 
			ON d.AccountKey = a.AccountKey 
		INNER JOIN master m 
			ON m.number = a.AccountKey
	WHERE FieldName_Id = 'AttributeFieldName|account.attribute.state'
	AND d.Value NOT LIKE m.State
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	INSERT INTO Attunely_Attributes (Id, AccountKey, FieldName_Id, [Value], RecordTime)
	SELECT NEWID(), m.number, 'AttributeFieldName|account.attribute.state', m.State, GETUTCDATE()
	FROM Attunely_AccountStubs a
		LEFT OUTER JOIN Attunely_Attributes d
			ON d.AccountKey = a.AccountKey 
		INNER JOIN master m 
			ON m.number = a.AccountKey
	WHERE d.AccountKey IS NULL
	
	IF @@ROWCOUNT > 0 SET @Updated = 1
	SELECT @Updated

END
GO
