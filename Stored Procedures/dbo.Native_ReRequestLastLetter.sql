SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Native_ReRequestLastLetter]
	@number INT
AS
BEGIN

	DECLARE @lrid INT = (SELECT MAX(LetterRequestId) FROM LetterRequest WHERE AccountID = @number)

	IF @lrid IS NOT NULL
	BEGIN

		INSERT INTO [dbo].[LetterRequest]
			   ([AccountID]
			   ,[CustomerCode]
			   ,[LetterID]
			   ,[LetterCode]
			   ,[DateRequested]
			   ,[DateProcessed]
			   ,[JobName]
			   ,[DueDate]
			   ,[AmountDue]
			   ,[UserName]
			   ,[Suspend]
			   ,[SifPmt1]
			   ,[SifPmt2]
			   ,[SifPmt3]
			   ,[SifPmt4]
			   ,[SifPmt5]
			   ,[SifPmt6]
			   ,[Manual]
			   ,[AddEditMode]
			   ,[Edited]
			   ,[DocumentData]
			   ,[Deleted]
			   ,[CopyCustomer]
			   ,[SaveImage]
			   ,[ProcessingMethod]
			   ,[ErrorDescription]
			   ,[DateCreated]
			   ,[DateUpdated]
			   ,[SubjDebtorID]
			   ,[SenderID]
			   ,[RequesterID]
			   ,[FutureID]
			   ,[RecipientDebtorID]
			   ,[RecipientDebtorSeq]
			   ,[LtrSeriesQueueID]
			   ,[SifPmt7]
			   ,[SifPmt8]
			   ,[SifPmt9]
			   ,[SifPmt10]
			   ,[SifPmt11]
			   ,[SifPmt12]
			   ,[SifPmt13]
			   ,[SifPmt14]
			   ,[SifPmt15]
			   ,[SifPmt16]
			   ,[SifPmt17]
			   ,[SifPmt18]
			   ,[SifPmt19]
			   ,[SifPmt20]
			   ,[SifPmt21]
			   ,[SifPmt22]
			   ,[SifPmt23]
			   ,[SifPmt24])
		SELECT [AccountID]
			  ,[CustomerCode]
			  ,[LetterID]
			  ,[LetterCode]
			  ,GETDATE()
			  ,'1753-01-01 12:00:00.000'
			  ,''
			  ,'1753-01-01 12:00:00.000'
			  ,[AmountDue]
			  ,[UserName]
			  ,[Suspend]
			  ,[SifPmt1]
			  ,[SifPmt2]
			  ,[SifPmt3]
			  ,[SifPmt4]
			  ,[SifPmt5]
			  ,[SifPmt6]
			  ,[Manual]
			  ,[AddEditMode]
			  ,[Edited]
			  ,[DocumentData]
			  ,[Deleted]
			  ,[CopyCustomer]
			  ,[SaveImage]
			  ,[ProcessingMethod]
			  ,''
			  ,GETDATE()
			  ,GETDATE()
			  ,[SubjDebtorID]
			  ,[SenderID]
			  ,[RequesterID]
			  ,[FutureID]
			  ,[RecipientDebtorID]
			  ,[RecipientDebtorSeq]
			  ,[LtrSeriesQueueID]
			  ,[SifPmt7]
			  ,[SifPmt8]
			  ,[SifPmt9]
			  ,[SifPmt10]
			  ,[SifPmt11]
			  ,[SifPmt12]
			  ,[SifPmt13]
			  ,[SifPmt14]
			  ,[SifPmt15]
			  ,[SifPmt16]
			  ,[SifPmt17]
			  ,[SifPmt18]
			  ,[SifPmt19]
			  ,[SifPmt20]
			  ,[SifPmt21]
			  ,[SifPmt22]
			  ,[SifPmt23]
			  ,[SifPmt24]
		  FROM [dbo].[LetterRequest]
		  WHERE LetterRequestID = @lrid
		  
		DECLARE @newlrid INT = (SELECT SCOPE_IDENTITY())

		INSERT INTO [dbo].[LetterRequestRecipient]
			   ([LetterRequestID]
			   ,[AccountID]
			   ,[Seq]
			   ,[DebtorID]
			   ,[CustomerCode]
			   ,[DebtorAttorney]
			   ,[DateCreated]
			   ,[DateUpdated]
			   ,[AttorneyID]
			   ,[AltRecipient]
			   ,[AltName]
			   ,[AltBusinessName]
			   ,[AltStreet1]
			   ,[AltStreet2]
			   ,[AltCity]
			   ,[AltState]
			   ,[AltZipcode]
			   ,[AltEmail]
			   ,[AltFax]
			   ,[SecureRecipientID])
		SELECT @newlrid
			  ,[AccountID]
			  ,[Seq]
			  ,[DebtorID]
			  ,[CustomerCode]
			  ,[DebtorAttorney]
			  ,[DateCreated]
			  ,[DateUpdated]
			  ,[AttorneyID]
			  ,[AltRecipient]
			  ,[AltName]
			  ,[AltBusinessName]
			  ,[AltStreet1]
			  ,[AltStreet2]
			  ,[AltCity]
			  ,[AltState]
			  ,[AltZipcode]
			  ,[AltEmail]
			  ,[AltFax]
			  ,[SecureRecipientID]
		  FROM [dbo].[LetterRequestRecipient]
		  WHERE LetterRequestID = @lrid
		  
		  
		  INSERT INTO [dbo].[notes]
			   ([number]
			   ,[ctl]
			   ,[created]
			   ,[user0]
			   ,[action]
			   ,[result]
			   ,[comment]
			   ,[Seq]
			   ,[IsPrivate]
			   ,[UtcCreated])
		  SELECT AccountID
				,NULL
				,GETDATE()
				,'EXG'
				,'LETTR'
				,'REQST'
				,'Letter ' + LetterCode + ' re-requested: ' + l.[Description]
				,NULL
				,NULL
				,GETUTCDATE()
		  FROM [dbo].[LetterRequest]
		  INNER JOIN dbo.letter l
		  ON l.code = LetterRequest.LetterCode
		  WHERE LetterRequestID = @lrid
	END

END
GO
