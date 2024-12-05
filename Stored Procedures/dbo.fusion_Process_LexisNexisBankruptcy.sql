SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[fusion_Process_LexisNexisBankruptcy]
	@RequestID int
AS
-- Name:		fusion_Process_LexisNexisBankruptcy
-- Function:		This procedure will process returned LexisNexis Bankruptcy info
-- Creation:		05/11/2006 jc
-- Modified:		10/12/2006 Jeff Mixon
-- Modified:		01/19/2010 Kevin Roiz after checking @statusDateNote Not Being NULL proc was jumping to cuExit: label.
--			LexisNexis Bankruptcy
-- Change History:	
	DECLARE @number INTEGER, @DebtorID INTEGER, 
	@DebtorSeq INTEGER, @DebtorName VARCHAR(30), @customer VARCHAR(7), 
	@desk VARCHAR(10), @status varchar(5), @qlevel VARCHAR(3), @ContractDate DATETIME, 
	@CliDlp DATETIME, @ChargeOffDate DATETIME, @IsPurchased BIT,
	@BankruptcyReturned INTEGER, @runDate DATETIME

	SELECT @number = [ServiceHistory].[AcctID]
	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestID] = @RequestID
--	SELECT @RequestID = [Services_Temp].[RequestID] FROM [dbo].[Services_Temp] AS [Services_Temp]
--	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] ON  [ServiceHistory].[RequestID] = [Services_Temp].[RequestID]
--	WHERE [ServiceHistory].[AcctID] = @number
--	IF (@@ERROR != 0) GOTO ErrHandler

	--determine if bankruptcy was returned 
	IF (SELECT COUNT(*) FROM [dbo].[Services_LexisNexis_Bankruptcy] AS [Services_LexisNexis_Bankruptcy]
		WHERE [Services_LexisNexis_Bankruptcy].[RequestID] = @RequestID) > 0 BEGIN
		--bankruptcy found
		SET @BankruptcyReturned = 1;
	END
	ELSE BEGIN
		--no bankruptcy found
		SET @BankruptcyReturned = 0;
	END

	--assign locals
	SET @runDate = GETDATE();

	SELECT @DebtorID = [debtors].[debtorid], @DebtorSeq = [debtors].[seq], @DebtorName = ISNULL([debtors].[Name],'') FROM [dbo].[debtors] AS [debtors] WITH(NOLOCK) 
	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] WITH(NOLOCK) ON [ServiceHistory].[debtorid] = [debtors].[debtorid]
	WHERE [ServiceHistory].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	SELECT @customer = [master].[customer],  @desk = [master].[desk], @qlevel = [master].[qlevel], @status = [master].[status],
		@ContractDate = [master].[ContractDate], @CliDlp = [master].[CliDlp], @ChargeOffDate = [master].[ChargeOffDate] 
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
--		SET [ServiceHistory].[Processed] = CASE @BankruptcyReturned WHEN 0 THEN 2 ELSE 3 END
--	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
--	WHERE [ServiceHistory].[RequestId] = @RequestID
--	IF (@@ERROR != 0) GOTO ErrHandler

	if @BankruptcyReturned = 0 BEGIN
		--no bankruptcy info returned
		
		--insert note	
--		INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
--		VALUES (@number, @runDate, 'BankoSvc', 'BNKO', 'IF', 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') No bankruptcy information found.')
--		IF (@@ERROR != 0) GOTO ErrHandler

		--exit here
		GOTO cuExit
	END

	--bankruptcy info returned
	--assign local variables from Services_LexisNexis_Bankruptcy
	DECLARE @chapter CHAR(2), @disposition CHAR(2),
	@fileddate DATETIME, @statusdate DATETIME,
	@MatchName VARCHAR(75), @attorneyExists BIT

	SELECT @chapter = [Services_LexisNexis_Bankruptcy].[Chapter], @disposition = [Services_LexisNexis_Bankruptcy].[DispositionCode], 
		@fileddate = ISNULL(CAST([Services_LexisNexis_Bankruptcy].[FileDate] AS DATETIME), NULL),
		@statusdate = ISNULL(cast([Services_LexisNexis_Bankruptcy].[StatusDate] AS DATETIME), NULL),
		@MatchName = CASE WHEN LEN(ISNULL([Services_LexisNexis_Bankruptcy].[LastName],'')) > 0 THEN ISNULL([Services_LexisNexis_Bankruptcy].[LastName],'') + ', ' + ISNULL([Services_LexisNexis_Bankruptcy].[FirstName],'') + ' ' + ISNULL([Services_LexisNexis_Bankruptcy].[MiddleName],'')
			ELSE ISNULL([Services_LexisNexis_Bankruptcy].[FirstName],'') + ' ' + ISNULL([Services_LexisNexis_Bankruptcy].[MiddleName],'') END,
		@attorneyExists = CASE WHEN LEN([Services_LexisNexis_Bankruptcy].[AttorneyName]) > 0 THEN 1 ELSE 0 END
	FROM [dbo].[Services_LexisNexis_Bankruptcy] AS [Services_LexisNexis_Bankruptcy]
	WHERE [Services_LexisNexis_Bankruptcy].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	--search for an existing bankruptcy record
	DECLARE @BankruptcyFound INTEGER
	SELECT @BankruptcyFound = [Bankruptcy].[debtorid] FROM [dbo].[Bankruptcy] AS [Bankruptcy] WHERE [Bankruptcy].[debtorid] = @DebtorID
	IF (@@ERROR != 0) GOTO ErrHandler

	--search for an existing debtor attorney record
	DECLARE @DebtorAttorneyFound INTEGER
	SELECT @DebtorAttorneyFound = [debtorattorneys].[debtorid] FROM [dbo].[debtorattorneys] AS [debtorattorneys] WHERE [debtorattorneys].[debtorid] = @DebtorID AND [debtorattorneys].[accountid] = @number
	IF (@@ERROR != 0) GOTO ErrHandler

	--validate disposition code
	IF @disposition NOT IN ('02', '20', '15', '30', '99') BEGIN
		RAISERROR('Unrecognized disposition code for Debtor #%d.', 11, 1, @DebtorID)
		GOTO ErrHandler
	END

	--assign disposition type variable from disposition code
	DECLARE @dispositionType VARCHAR(50)
	SET @dispositionType = 
		CASE
			WHEN @disposition = '02' THEN 'Filed'
			WHEN @disposition = '20' THEN 'Discharged'
			WHEN @disposition = '15' THEN 'Dismissed'
			WHEN @disposition = '30' THEN 'Conversion'
			WHEN @disposition = '99' THEN 'Closed'
		END

	--proceed based on disposition code
	IF @disposition = '02' OR @disposition = '20' or @disposition='30' BEGIN

    		IF @BankruptcyFound IS NOT NULL BEGIN
			--bankruptcy found - move to notes and delete
			EXEC spls_BankruptcyToNotes @DebtorID
			IF (@@ERROR != 0) GOTO ErrHandler
    		END
		
		DECLARE @statusDateNote VARCHAR(50)
		IF @statusdate IS NOT NULL BEGIN
			IF @ContractDate IS NOT NULL BEGIN
				IF @statusdate < @ContractDate BEGIN
					SET @statusDateNote = 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') MatchName(' + RTRIM(LTRIM(@MatchName)) + ') Bankruptcy ' + @dispositionType + ': status date ' + CONVERT(VARCHAR(10), @statusdate, 101) + ' before Contract date ' + CONVERT(VARCHAR(10), @ContractDate, 101)+'. '
				END
			END
			ELSE IF @CliDlp IS NOT NULL BEGIN
				IF @statusdate < @CliDlp BEGIN
					SET @statusDateNote = 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') MatchName(' + RTRIM(LTRIM(@MatchName)) + ') Bankruptcy ' + @dispositionType + ': status date ' + CONVERT(VARCHAR(10), @statusdate, 101) + ' before CliDlp date ' + CONVERT(VARCHAR(10), @CliDlp, 101)+'. '
				END
			END
			ELSE IF @ChargeOffDate IS NOT NULL BEGIN
				IF @statusdate < @ChargeOffDate BEGIN
					SET @statusDateNote = 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') MatchName(' + RTRIM(LTRIM(@MatchName)) + ') Bankruptcy ' + @dispositionType + ': status date ' + CONVERT(VARCHAR(10), @statusdate, 101) + ' before ChargedOffDate date ' + CONVERT(VARCHAR(10), @ChargeOffDate, 101)+'. '
				END
			END

			IF @statusDateNote IS NOT NULL BEGIN
				--insert note with bankruptcy info
				INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
				VALUES(@number, @runDate, 'BankoSvc', 'BNKO', 'IF', @statusDateNote)
				IF (@@ERROR != 0) GOTO ErrHandler
	
				--update master account (desk)
				--UPDATE [master] SET [master].[desk] = @NoBankruptcyDesk FROM [dbo].[master] AS [master] WHERE [master].[number] = @number
				IF (@@ERROR != 0) GOTO ErrHandler
				--GOTO cuExit
			END
		END
		ELSE BEGIN
			RAISERROR('Returned bankruptcy status date is invalid for debtor id %d.  fusion_LexisNexisBankruptcy failed.', 11, 1, @DebtorID)
	    		GOTO ErrHandler
		END
		
		if not exists(select * from [Bankruptcy] where DebtorId=@debtorId)
		BEGIN
		--insert bankruptcy record using Services_LexisNexis_Bankruptcy
		INSERT INTO [dbo].[Bankruptcy] ([AccountID], [DebtorID], [Chapter], [DateFiled],
			[CaseNumber], [CourtCity], [CourtDistrict], [CourtDivision], [CourtPhone], [CourtStreet1],
			[CourtStreet2], [CourtState], [CourtZipcode], [Trustee], [TrusteeStreet1], [TrusteeStreet2],
			[TrusteeCity], [TrusteeState], [TrusteeZipcode], [TrusteePhone], [Has341Info], [DateTime341],
			[Location341], [Comments], [Status])
		SELECT top 1 @Number, @DebtorID, CASE [Services_LexisNexis_Bankruptcy].[Chapter] 
						WHEN '06' THEN '13'
						WHEN '52' THEN '7'
						WHEN '53' THEN '11'
						WHEN '54' THEN '12'
					END,
			ISNULL(CAST([Services_LexisNexis_Bankruptcy].[FileDate] AS DATETIME), NULL) FileDate, 
			[Services_LexisNexis_Bankruptcy].[CaseNumber], ISNULL([Services_LexisNexis_Bankruptcy].[CityFiled], ''), ISNULL([Services_LexisNexis_Bankruptcy].[CourtDistrict], ''), '', ISNULL([Services_LexisNexis_Bankruptcy].[CourtPhone], ''), 
			ISNULL([Services_LexisNexis_Bankruptcy].[CourtAddress1], ''), ISNULL([Services_LexisNexis_Bankruptcy].[CourtAddress2], ''), ISNULL([Services_LexisNexis_Bankruptcy].[StateFiled], ''), ISNULL([Services_LexisNexis_Bankruptcy].[CourtZip], ''), 
			[Services_LexisNexis_Bankruptcy].[Trustee], [Services_LexisNexis_Bankruptcy].[TrusteeAddress], '', [Services_LexisNexis_Bankruptcy].[TrusteeCity], [Services_LexisNexis_Bankruptcy].[TrusteeState], [Services_LexisNexis_Bankruptcy].[TrusteeZip], [Services_LexisNexis_Bankruptcy].[TrusteePhone], 
			CASE [Services_LexisNexis_Bankruptcy].[341Location] WHEN '' THEN 0 ELSE 1 END,
			CASE 
				WHEN ISDATE([Services_LexisNexis_Bankruptcy].[341Date]) = 1 THEN 
					CASE 
						WHEN ISDATE([Services_LexisNexis_Bankruptcy].[341Date] + ' ' + [Services_LexisNexis_Bankruptcy].[341time]) = 1 THEN CONVERT(DATETIME, [Services_LexisNexis_Bankruptcy].[341Date] + ' ' + [Services_LexisNexis_Bankruptcy].[341time])
						ELSE CONVERT(DATETIME, [Services_LexisNexis_Bankruptcy].[341Date])
					END
				ELSE NULL
			END DateTime341, [Services_LexisNexis_Bankruptcy].[341Location], '', 
			CASE 
				-- 02 = filed
				-- 15 = dismissed
				-- 20 = discharged
				-- 30 = Conversion
				-- 99 = Closed (unknown if it is dismissed or discharged) 
				-- Latitude Lookups 
				-- Attorney Retained - Not Filed
				-- Filed - Not Discharged
				-- Meeting of Creditors Set
				-- Discharged
				-- Dismissed
				WHEN @disposition IN ('02') THEN 'Filed - Not Discharged'
				WHEN @disposition IN ('20') THEN 'Discharged'
				WHEN @disposition IN ('30') THEN ''
			END
		FROM [dbo].[Services_LexisNexis_Bankruptcy] AS [Services_LexisNexis_Bankruptcy]
		WHERE [Services_LexisNexis_Bankruptcy].[RequestID] = @RequestID
		IF (@@ERROR != 0) GOTO ErrHandler
		END

		-- insert debtor attorney record if present in xml data
		IF @attorneyExists = 1 BEGIN
	    		IF @DebtorAttorneyFound IS NOT NULL BEGIN
				--debtor attorney found - move to notes and delete
				EXEC spls_DebtorAttorneyToNotes @DebtorID
				IF (@@ERROR != 0) GOTO ErrHandler
			END
			IF not exists (select * from DebtorAttorneys where Debtorid=@DebtorId)
			BEGIN
				--insert debtor attorney record using xml input parameter @doc
				-- Execute an INSERT statement using OPENXML rowset provider.
				INSERT INTO [dbo].[DebtorAttorneys] ([AccountID], [DebtorID], [Name], [Firm],
					[Addr1], [Addr2], [City], [State], [Zipcode], [Phone],
					[Fax], [Email], [Comments], [DateCreated], [DateUpdated])
				SELECT TOP 1 @number, @DebtorID, [Services_LexisNexis_Bankruptcy].[AttorneyName], ISNULL([Services_LexisNexis_Bankruptcy].[LawFirm], ''), ISNULL([Services_LexisNexis_Bankruptcy].[AttorneyAddress], ''), '', 
					ISNULL([Services_LexisNexis_Bankruptcy].[AttorneyCity], ''), ISNULL([Services_LexisNexis_Bankruptcy].[AttorneyState],''), ISNULL([Services_LexisNexis_Bankruptcy].[AttorneyZip], ''),
					ISNULL([Services_LexisNexis_Bankruptcy].[AttorneyPhone], ''), '', '', '', @runDate, @runDate
				FROM [dbo].[Services_LexisNexis_Bankruptcy] AS [Services_LexisNexis_Bankruptcy]
				WHERE [Services_LexisNexis_Bankruptcy].[RequestID] = @RequestID
				IF (@@ERROR != 0) GOTO ErrHandler
			END
		END

		--update pending letters as deleted for this debtor
		IF (SELECT COUNT(*) FROM [dbo].[LetterRequest] AS [LetterRequest]
			INNER JOIN [dbo].[LetterRequestRecipient] AS [LetterRequestRecipient] ON [LetterRequestRecipient].[LetterRequestID] = [LetterRequest].[LetterRequestID]
			WHERE [LetterRequestRecipient].[debtorid] = @DebtorID and [LetterRequest].[AccountID] = @number 
			AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000') > 0 BEGIN
				--update letterrequests 
				UPDATE [LetterRequest]
					SET [LetterRequest].[deleted] = 1, 
					[LetterRequest].[errordescription] = 'Bankruptcy info returned ' + CONVERT(VARCHAR(10), @runDate, 101)
				FROM [dbo].[LetterRequest] AS [LetterRequest]
				WHERE [LetterRequest].[accountid] = @number 
				AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000' 
				IF (@@ERROR != 0) GOTO ErrHandler
		END

		--set suppress letters restriction on bankrupt accounts
		IF @DebtorSeq IS NOT NULL BEGIN
			If exists (select * from [restrictions] where DebtorId=@debtorId)
				 BEGIN
					--update restrictions
					UPDATE [restrictions] 
						SET [restrictions].[suppressletters] = 1 
					FROM [dbo].[restrictions] AS [restrictions] 
					WHERE [restrictions].[debtorid] = @DebtorID 
					IF (@@ERROR != 0) GOTO ErrHandler
			END
			ELSE BEGIN
				--insert restrictions
				INSERT INTO [dbo].[restrictions]([number], [debtorid], [suppressletters]) 
				VALUES( @Number, @DebtorID, 1)
				IF (@@ERROR != 0) GOTO ErrHandler
			END									
		END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	IF @disposition = '15' BEGIN 
		-- bankruptcy dismissed
    		IF @BankruptcyFound IS NOT NULL BEGIN
			-- bankruptcy found - move to notes and delete
			EXEC spls_BankruptcyToNotes @DebtorID
			IF (@@ERROR != 0) GOTO ErrHandler
    		END
	END
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--insert note
	INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
	VALUES (@number, @runDate, 'BankoSvc', 'BNKO', 'IF', 'Debtor('+RTRIM(LTRIM(@DebtorName)) + ') MatchName(' + RTRIM(LTRIM(@MatchName)) + ') Bankruptcy ' + @dispositionType +'.')
	IF (@@ERROR != 0) GOTO ErrHandler

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--remove this requestid from Services_Temp
	--DELETE [Services_Temp] FROM [dbo].[Services_Temp] AS [Services_Temp] WHERE [Services_Temp].[RequestID] = @RequestID
	--IF (@@ERROR != 0) GOTO ErrHandler
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN

ErrHandler:
	RAISERROR('Error encountered in fusion_Process_LexisNexisBankruptcy for account id %d.  fusion_Process_LexisNexisBankruptcy failed.', 11, 1, @number)
	RETURN
GO
