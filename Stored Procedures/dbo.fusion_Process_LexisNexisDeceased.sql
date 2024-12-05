SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Process_LexisNexisDeceased]
	@RequestID int
AS
-- Name:		fusion_Process_LexisNexisDeceased
-- Function:		This procedure will process returned LexisNexis Deceased info
-- Creation:		05/14/2006 jc
-- Modified:		10/11/2006 Jeff Mixon, 03/01/2007 Ibrahim
--			LexisNexis Deceased
-- Change History:	
	DECLARE @number INTEGER, @DebtorID INTEGER, 
	@DebtorSeq INTEGER, @DebtorName VARCHAR(30), @customer VARCHAR(7), 
	@desk VARCHAR(10), @status varchar(5), @qlevel VARCHAR(3), 
	@IsPurchased BIT, @DeceasedReturned INTEGER, @runDate DATETIME

	SELECT @number = [ServiceHistory].[AcctID]
	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestID] = @RequestID

	--determine if bankruptcy was returned 
	IF (SELECT COUNT(*) FROM [dbo].[Services_LexisNexis_Deceased] AS [Services_LexisNexis_Deceased]
		WHERE [Services_LexisNexis_Deceased].[RequestID] = @RequestID) > 0 
		BEGIN
		--deceased match found
		SET @DeceasedReturned = 1;

		if (select customer from master with (Nolock) where number = @number) NOT IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob = 'PROB - PROBATE')
		
			begin

			update master
			set desk = 'DECD', qlevel = '998', status = 'DEC', closed = getdate()
			where number = @number 

			insert into statushistory(accountid, datechanged, username, oldstatus, newstatus)
			values (@number, getdate(), 'SYSTEM', 'NEW', 'DEC')
			
			--added code for AIM to pick up in ASTS files BGM 10/13/2011
			INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
			VALUES (@number, GETDATE(), 'DecdSvc', 'CO', 'DC', 'Found deceased information on Debtor')
			
			end			

	END
	ELSE BEGIN
		--no deceased match found
		SET @DeceasedReturned = 0;

		update master
		set desk = 'NODECD'
		where number = @number

	END

	--assign locals
	SET @runDate = GETDATE();

	SELECT @DebtorID = [debtors].[debtorid], @DebtorSeq = [debtors].[seq], @DebtorName = ISNULL([debtors].[Name],'') FROM [dbo].[debtors] AS [debtors] WITH(NOLOCK) 
	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] WITH(NOLOCK) ON [ServiceHistory].[debtorid] = [debtors].[debtorid]
	WHERE [ServiceHistory].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	SELECT @customer = [master].[customer],  @desk = [master].[desk], @qlevel = [master].[qlevel], @status = [master].[status]
		FROM [dbo].[master] AS [master] WITH(NOLOCK) WHERE [master].[number] = @number
	IF (@@ERROR != 0) GOTO ErrHandler

	SELECT @IsPurchased = IsPrincipleCust FROM [dbo].[Customer] AS [Customer] WITH(NOLOCK) WHERE [Customer].[customer] = @customer
	IF (@@ERROR != 0) GOTO ErrHandler

	--insert service history response
--	INSERT INTO [dbo].[ServiceHistory_RESPONSES] ([RequestID], [FileName], [DateReturned], [XmlInfoReturned])
--	SELECT @RequestID, '', @runDate, [ServiceHistory].[XmlInfoReturned] FROM [dbo].[ServiceHistory] AS [ServiceHistory]
--	WHERE [ServiceHistory].[RequestId] = @RequestID
--	IF (@@ERROR != 0) GOTO ErrHandler

	--update service history 
--	UPDATE [ServiceHistory]
--		SET [ServiceHistory].[Processed] = CASE @DeceasedReturned WHEN 0 THEN 2 ELSE 3 END
--	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
--	WHERE [ServiceHistory].[RequestId] = @RequestID
--	IF (@@ERROR != 0) GOTO ErrHandler

	if @DeceasedReturned = 0 BEGIN
		--no deceased info returned
		
		--insert note	
		INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
		VALUES (@number, @runDate, 'DecdSvc', 'DECD', 'IF', 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') No deceased information found.')
		IF (@@ERROR != 0) GOTO ErrHandler

		--exit here
		GOTO cuExit

/*
		--update master account desk only if not yet set
		IF (SELECT COUNT(*) FROM [dbo].[master] AS [master] 
			WHERE [master].[number] = @number 
			AND [master].[desk] <> @DeceasedDesk
			AND [master].[desk] <> @NoDeceasedDesk) > 0 BEGIN

			--update master account (desk)
			UPDATE [master]
				SET [master].[desk] = @NoDeceasedDesk 
			FROM [dbo].[master] AS [master]
			WHERE [master].[number] = @number
			IF (@@ERROR != 0) GOTO ErrHandler
			GOTO cuExit
		END
*/
	END

	--deceased info returned
	--assign local variables from Services_LexisNexis_Deceased
	DECLARE @MatchName varchar(75)

	SELECT @MatchName = CASE WHEN LEN(ISNULL([Services_LexisNexis_Deceased].[LastName], '')) > 0 THEN ISNULL([Services_LexisNexis_Deceased].[LastName], '') + ', ' + ISNULL([Services_LexisNexis_Deceased].[FirstName], '')
		ELSE ISNULL([Services_LexisNexis_Deceased].[FirstName], '')
		END
	FROM [dbo].[Services_LexisNexis_Deceased] AS [Services_LexisNexis_Deceased] 
	WHERE [Services_LexisNexis_Deceased].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	--search for an existing deceased record
	DECLARE @DeceasedFound INTEGER
	SELECT @DeceasedFound = [Deceased].[debtorid] FROM [dbo].[Deceased] AS [Deceased] WHERE [Deceased].[debtorid] = @DebtorID
	IF (@@ERROR != 0) GOTO ErrHandler

	IF @DeceasedFound IS NOT NULL BEGIN
		-- deceased found - move to notes and delete
		EXEC spls_DeceasedToNotes @DebtorID
		IF (@@ERROR != 0) GOTO ErrHandler
	END

	if not exists(select * from [Deceased] where DebtorId=@debtorid)
	Begin
		--insert deceased record using Services_LexisNexis_Deceased
		INSERT INTO [dbo].[Deceased] ([AccountID], [DebtorID], [SSN], [FirstName],
			[LastName], [State], [PostalCode], [DOB], [DOD], [MatchCode],
			[TransmittedDate])
		SELECT TOP 1 @number, @DebtorID, [Services_LexisNexis_Deceased].[SSN], [Services_LexisNexis_Deceased].[FirstName], [Services_LexisNexis_Deceased].[LastName],
			[Services_LexisNexis_Deceased].[State], [Services_LexisNexis_Deceased].[Zip], 
			
			[Services_LexisNexis_Deceased].[DateofBirth],
			[Services_LexisNexis_Deceased].[DateofDeath],
			--CASE	
				--WHEN (ISDATE(SUBSTRING([Services_LexisNexis_Deceased].[DateofBirth],1,2)+'/'+ SUBSTRING([Services_LexisNexis_Deceased].[DateofBirth],3,2)+'/'+SUBSTRING([Services_LexisNexis_Deceased].[DateofBirth],5,4)) = 0) THEN NULL
				--ELSE CAST(SUBSTRING([Services_LexisNexis_Deceased].[DateofBirth],1,2)+'/'+SUBSTRING([Services_LexisNexis_Deceased].[DateofBirth],3,2)+'/'+SUBSTRING([Services_LexisNexis_Deceased].[DateofBirth],5,4) AS DATETIME)
			--END AS DateofBirth,
			--CASE
			--	WHEN (ISDATE(SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],1,2)+'/'+CASE WHEN SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],3,2) = '00' THEN '01' ELSE SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],3,2) END +'/'+SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],5,4)) = 0) THEN NULL
			--	ELSE CAST(SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],1,2)+'/'+CASE WHEN SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],3,2) = '00' THEN '01' ELSE SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],3,2) END +'/'+SUBSTRING([Services_LexisNexis_Deceased].[DateofDeath],5,4) AS DATETIME)
			--END AS DateofDeath,
			[Services_LexisNexis_Deceased].[MatchCode], @runDate
		FROM [dbo].[Services_LexisNexis_Deceased] AS [Services_LexisNexis_Deceased]
		WHERE [Services_LexisNexis_Deceased].[RequestID] = @RequestID
		IF (@@ERROR != 0) GOTO ErrHandler
	END
	--update pending letters as deleted for this debtor
	IF @DebtorSeq IS NOT NULL AND @customer NOT IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob = 'PROB - PROBATE') BEGIN
		IF (SELECT COUNT(*) FROM [dbo].[LetterRequest] AS [LetterRequest]
		INNER JOIN [dbo].[LetterRequestRecipient] AS [LetterRequestRecipient] ON [LetterRequestRecipient].[LetterRequestID] = [LetterRequest].[LetterRequestID]
		WHERE [LetterRequestRecipient].[debtorid] = @DebtorID and [LetterRequest].[AccountID] = @number 
		AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000') > 0 BEGIN
			--update letterrequests 
			UPDATE [LetterRequest]
				SET [LetterRequest].[deleted] = 1, 
				[LetterRequest].[errordescription] = 'Deceased info returned ' + CONVERT(VARCHAR(10), @runDate, 101)
			FROM [dbo].[LetterRequest] AS [LetterRequest]
			WHERE [LetterRequest].[accountid] = @number 
			AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000' 
			IF (@@ERROR != 0) GOTO ErrHandler
		END
	END

	--set suppress letters restriction on bankrupt accounts
	IF @DebtorSeq IS NOT NULL AND @customer NOT IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob = 'PROB - PROBATE') BEGIN
		IF (SELECT COUNT(*) FROM [dbo].[restrictions] AS [restrictions] 
			WHERE [restrictions].[debtorid] = @DebtorID 
			AND [restrictions].[number] = @number) > 0 BEGIN
				--update restrictions
				UPDATE [restrictions] 
					SET [restrictions].[suppressletters] = 1 
				FROM [dbo].[restrictions] AS [restrictions] 
				WHERE [restrictions].[debtorid] = @DebtorID 
				AND [restrictions].[number] = @number
				IF (@@ERROR != 0) GOTO ErrHandler
		END
		ELSE BEGIN
			--insert restrictions
			INSERT INTO [dbo].[restrictions]([number], [debtorid], [suppressletters]) 
			VALUES( @number, @DebtorID, 1)
			IF (@@ERROR != 0) GOTO ErrHandler
		END									
	END

	--insert note
	INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
	VALUES (@number, @runDate, 'DecdSvc', 'DECD', 'IF', 'Debtor('+RTRIM(LTRIM(@DebtorName))+') MatchName('+RTRIM(LTRIM(@MatchName))+') Deceased information found.')
	IF (@@ERROR != 0) GOTO ErrHandler

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
	if @IsPurchased = 1 begin
		--purchased account
		if @desk <> 'AIM' begin 
			if @qlevel < '998' begin
				--update open master account (desk,status,qlevel)
				update master 
					set desk = @DeceasedDesk,
					status = @DeceasedStatus,
					qlevel = @DeceasedQlevel,
					closed = getdate()
				where number = @number
				if (@@error != 0) goto ErrHandler
			end
			else begin
				--update closed master account (desk,status)
				update master 
					set desk = @DeceasedDesk,
					status = @DeceasedStatus 
				where number = @number
				if (@@error != 0) goto ErrHandler			
			end
		end
		else begin
			if @qlevel < '998' begin
				--update open master account (status,qlevel)
				--AIM desk so DO NOT update desk
				update master 
					set status = @DeceasedStatus,
					qlevel = @DeceasedQlevel,
					closed = getdate()
				where number = @number
				if (@@error != 0) goto ErrHandler			
			end
			else begin
				--update closed master account (status)
				--AIM desk so DO NOT update desk
				update master 
					set status = @DeceasedStatus
				where number = @number
				if (@@error != 0) goto ErrHandler	
			end
		end
	end
	else begin
		--contingency account
		-- close account
		update master 
			set desk = @DeceasedDesk, 
			status = @DeceasedStatus, 
			qlevel = @DeceasedQlevel, 
			closed = getdate() 
		where number=@number
		if (@@error != 0) goto ErrHandler
	end
*/
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--remove this requestid from Services_Temp
	--DELETE [Services_Temp] FROM [dbo].[Services_Temp] AS [Services_Temp] WHERE [Services_Temp].[RequestID] = @RequestID
	--IF (@@ERROR != 0) GOTO ErrHandler
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN

ErrHandler:
	RAISERROR('Error encountered in fusion_Process_LexisNexisDeceased for account id %d.  fusion_Process_LexisNexisDeceased failed.', 11, 1, @number)
	RETURN
GO
