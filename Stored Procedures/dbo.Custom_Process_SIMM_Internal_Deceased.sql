SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROC [dbo].[Custom_Process_SIMM_Internal_Deceased]
	@RequestID INT
AS
-- Name:		Custom_Process_SIMM_Internal_Deceased
-- Function:		This procedure will process returned TLO Deceased info
-- Creation:		03/18/2018 Brian Meehan
-- Modified:			
--		BGM 03/18/2018 Created new procedure by cloning Custom_Process_TLO_Deceased
-- Change History:	

	--Declare Variables
	DECLARE @number INTEGER, @DebtorID INTEGER, 
	@DebtorSeq INTEGER, @DebtorName VARCHAR(30), @customer VARCHAR(7), 
	@desk VARCHAR(10), @status VARCHAR(5), @qlevel VARCHAR(3), 
	@DeceasedReturned INTEGER, @runDate DATETIME, @firstMarbleHead BIT = 0,
	@Probate BIT = 0
	
	--Get file number from service history request ID
	SELECT @number = [ServiceHistory].[AcctID]
	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestID] = @RequestID	
	
	--Check if customer is First MarbleHead
	IF (SELECT customer FROM master WITH (NOLOCK) WHERE number = @number) IN (SELECT Customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 134)
		BEGIN
			SET @firstMarbleHead = 1
		END
	--Check if customer is in Probate class of business
	IF (SELECT customer FROM master WITH (NOLOCK) WHERE number = @number) IN (SELECT Customer FROM customer WITH (NOLOCK) WHERE cob = 'prob - Probate')
		OR (SELECT customer FROM master WITH (NOLOCK) WHERE number = @number) IN ('0001483')
		BEGIN
			SET @Probate = 1
		END
		


	--Populate Debtor Variables
	SELECT @DebtorID = [debtors].[debtorid], @DebtorSeq = [debtors].[seq], @DebtorName = ISNULL([debtors].[Name],'') FROM [dbo].[debtors] AS [debtors] WITH(NOLOCK) 
	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] WITH(NOLOCK) ON [ServiceHistory].[debtorid] = [debtors].[debtorid]
	WHERE [ServiceHistory].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	--determine if deceased information was returned 
	IF (SELECT COUNT(*) FROM [dbo].[Services_SIMM_Internal_Deceased] AS [Services_SIMM_Internal_Deceased]
		WHERE [Services_SIMM_Internal_Deceased].[RequestID] = @RequestID) > 0 
		BEGIN
		
		--Set variable true if deceased information found
		SET @DeceasedReturned = 1;
	
		--Only process accounts not in Probate stream to close
		IF (@Probate <> 1)
		
			BEGIN
				--Only close account if primary debtor, remain open for co-debtors
				IF (@debtorseq = 0)
				BEGIN
					--If an FMH account put into FDC status to be reported to FMH for them to determine to close account.
					IF (@firstMarbleHead <> 1)
						BEGIN
							--Set account closed in Master Table
							UPDATE master
							SET desk = 'DECD', qlevel = '998', status = 'DEC', closed = GETDATE()
							WHERE number = @number 
							
							--Insert status change into history
							INSERT INTO statushistory(accountid, datechanged, username, oldstatus, newstatus)
							VALUES (@number, GETDATE(), 'SYSTEM', 'NEW', 'DEC')
						END	
					ELSE	
						--Keep account open and place into FDC status for FMH accounts.
						BEGIN
							--Set account as FDC status in Master Table and remain open.
							UPDATE master
							SET desk = 'DECD', status = 'FDC'
							WHERE number = @number 
							
							--Insert status change into history
							INSERT INTO statushistory(accountid, datechanged, username, oldstatus, newstatus)
							VALUES (@number, GETDATE(), 'SYSTEM', 'NEW', 'FDC')
						END	
						
						--code for AIM to pick up in ASTS files for certain AIM Clients 
						INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
						VALUES (@number, GETDATE(), 'DecdSvc', 'CO', 'DC', 'Found deceased information on Debtor')
					END
					
				END			
			END
			
	ELSE 
	
		BEGIN
		
		IF (@Probate <> 1)
			BEGIN
			--no deceased match found
			SET @DeceasedReturned = 0;
			END
			
		--Leave account open in Master Table and set up for next process
		UPDATE master
		SET desk = '0000001'
		WHERE number = @number

	END

	--Update service history returned date to show process was completed
	UPDATE [ServiceHistory]
	SET [ServiceHistory].ReturnedDate = GETDATE()
	FROM [dbo].[ServiceHistory] AS [ServiceHistory] WITH (NOLOCK)
	WHERE [ServiceHistory].[RequestId] = @RequestID

	--Assign local time
	SET @runDate = GETDATE();

	--Populate Account Details
	SELECT @customer = [master].[customer],  @desk = [master].[desk], @qlevel = [master].[qlevel], @status = [master].[status]
		FROM [dbo].[master] AS [master] WITH(NOLOCK) WHERE [master].[number] = @number
	IF (@@ERROR != 0) GOTO ErrHandler
	
	--When no Deceased information returned
	IF @DeceasedReturned = 0 
		BEGIN
			--Check if Probate class of business
			IF (@Probate <> 1)
				BEGIN
					--insert note stating no deceased information found	
					INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
					VALUES (@number, @runDate, 'DecdSvc', 'DECD', 'IF', 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') No deceased information found.')
					
					--exit here
					GOTO cuExit
				END
			ELSE
		
				BEGIN
					--code for AIM to pick up in ASTS files for certain AIM Clients
					INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
					VALUES (@number, GETDATE(), 'DecdSvc', 'CO', 'CO', 'Check deceased panel for information on Debtor')
				END	
			
		IF (@@ERROR != 0) GOTO ErrHandler
	END

	
	----Assign local variables from Services_LexisNexis_Deceased
	--DECLARE @MatchName VARCHAR(75)
	
	----Get name that was matched from TLO
	--SELECT @MatchName = CASE WHEN LEN(ISNULL([Services_TLO_Deceased].[TLOLastName], '')) > 0 THEN ISNULL([Services_TLO_Deceased].[TLOLastName], '') + ', ' + ISNULL([Services_TLO_Deceased].[TLOFirstName], '')
	--	ELSE ISNULL([Services_TLO_Deceased].[TLOFirstName], '')
	--	END
	--FROM [dbo].[Services_TLO_Deceased] AS [Services_TLO_Deceased] 
	--WHERE [Services_TLO_Deceased].[RequestID] = @RequestID
	--IF (@@ERROR != 0) GOTO ErrHandler

	----Search for an existing deceased record
	--DECLARE @DeceasedFound INTEGER
	--SELECT @DeceasedFound = [Deceased].[debtorid] FROM [dbo].[Deceased] AS [Deceased] WHERE [Deceased].[debtorid] = @DebtorID
	--IF (@@ERROR != 0) GOTO ErrHandler

	--IF @DeceasedFound IS NOT NULL BEGIN
	--	-- existing deceased record found - move to notes and delete the current deceased record
	--	EXEC spls_DeceasedToNotes @DebtorID
	--	IF (@@ERROR != 0) GOTO ErrHandler
	--END
	
	--Check if deceased record currently exists in deceased table
	IF NOT EXISTS(SELECT * FROM [Deceased] WHERE DebtorId=@debtorid)
	BEGIN
	
		--insert deceased record using information from Services_TLO_Deceased
		INSERT INTO [dbo].[Deceased] ([AccountID], [DebtorID], [SSN], [FirstName],
			[LastName], [State], [PostalCode], [DOB], [DOD])
		SELECT TOP 1 @number, @DebtorID, [Services_SIMM_Internal_Deceased].[SSN], [Services_SIMM_Internal_Deceased].[FirstName], 
			[Services_SIMM_Internal_Deceased].[LastName], [Services_SIMM_Internal_Deceased].[State], 
			[Services_SIMM_Internal_Deceased].[Zipcode], 
			[Services_SIMM_Internal_Deceased].[dob],
			[Services_SIMM_Internal_Deceased].[DOD]
		FROM [dbo].[Services_SIMM_Internal_Deceased] AS [Services_SIMM_Internal_Deceased]
		WHERE [Services_SIMM_Internal_Deceased].[RequestID] = @RequestID
		IF (@@ERROR != 0) GOTO ErrHandler
	END
	
	--Check if there are pending letters for this debtor
	IF (SELECT COUNT(*) FROM [dbo].[LetterRequest] AS [LetterRequest]
		INNER JOIN [dbo].[LetterRequestRecipient] AS [LetterRequestRecipient] ON [LetterRequestRecipient].[LetterRequestID] = [LetterRequest].[LetterRequestID]
		WHERE [LetterRequestRecipient].[debtorid] = @DebtorID AND [LetterRequest].[AccountID] = @number 
		AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000') > 0 
		
		BEGIN
			
			--Check if account is in Probate class of business
			IF (@Probate <> 1)
			
			BEGIN
			
				--update letterrequests as deleted and add error description
				UPDATE [LetterRequest]
					SET [LetterRequest].[deleted] = 1, 
					[LetterRequest].[errordescription] = 'Deceased info returned ' + CONVERT(VARCHAR(10), @runDate, 101)
				FROM [dbo].[LetterRequest] AS [LetterRequest]
				WHERE [LetterRequest].[accountid] = @number 
				AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000' 
				IF (@@ERROR != 0) GOTO ErrHandler
			END
		END

	--set suppress letters restriction on deceased accounts
	IF @DebtorSeq IS NOT NULL BEGIN
		--Check if record already exists in restrictions table
		IF (SELECT COUNT(*) FROM [dbo].[restrictions] AS [restrictions] 
			WHERE [restrictions].[debtorid] = @DebtorID 
			AND [restrictions].[number] = @number) > 0 
			--Do below if record already exists in restrictions table
			BEGIN
				
				--Check if customer is in Probate class of business	
				IF (@Probate <> 1)
					BEGIN
						--Update restrictions to suppress letters
						UPDATE [restrictions] 
							SET [restrictions].[suppressletters] = 1 
						FROM [dbo].[restrictions] AS [restrictions] 
						WHERE [restrictions].[debtorid] = @DebtorID 
						AND [restrictions].[number] = @number
						IF (@@ERROR != 0) GOTO ErrHandler
					END
			END
		ELSE 
		--Create new record in restrictions table
		BEGIN
			--Check if account in Probate class of business
			IF (@Probate <> 1)
				BEGIN
					--insert restrictions
					INSERT INTO [dbo].[restrictions]([number], [debtorid], [suppressletters]) 
					VALUES( @number, @DebtorID, 1)
					IF (@@ERROR != 0) GOTO ErrHandler
				END
		END									
	END

	--insert note stating deceased information was found
	INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
	VALUES (@number, @runDate, 'DecdSvc', 'DECD', 'IF', 'Debtor('+RTRIM(LTRIM(@DebtorName))+ ' Deceased information was found in internal database.')
	IF (@@ERROR != 0) GOTO ErrHandler


cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN

ErrHandler:
	RAISERROR('Error encountered in Custom_Process_SIMM_Internal_Deceased for account id %d.  Custom_Process_SIMM_Internal_Deceased failed.', 11, 1, @number)
	RETURN
GO
