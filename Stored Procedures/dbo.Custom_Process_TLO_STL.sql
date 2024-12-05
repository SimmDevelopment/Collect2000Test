SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Custom_Process_TLO_STL]
	@RequestID INT
AS
-- Name:			Custom_Process_TLO
-- Function:		This procedure will process returned TLO Bankruptcy info for Student Loan Class of Business
-- Creation:		07/24/2017 Brian Meehan
-- Modified:		
--					Student Loan TLO Bankruptcy
--
-- Change History:	
-- Changed note result code to be more specific as to the chapter of bankruptcy.  6/26/2014 (for ACB ASTS file.)
-- Added that all chapter 13 valid bankruptcies for either pri or co will be closed.

	--Declare Global Variables
	DECLARE @number INTEGER, @DebtorID INTEGER, 
	@DebtorSeq INTEGER, @DebtorName VARCHAR(30), @customer VARCHAR(7), 
	@desk VARCHAR(10), @status VARCHAR(5), @qlevel VARCHAR(3), @ContractDate DATETIME, 
	@CliDlp DATETIME, @ChargeOffDate DATETIME, @IsPurchased BIT,
	@BankruptcyReturned INTEGER, @runDate DATETIME, @noteResultCode AS VARCHAR(5)
	
	--Get file number from history table
	SELECT @number = [ServiceHistory].[AcctID]
	FROM [dbo].[ServiceHistory] AS [ServiceHistory] WITH (NOLOCK)
	WHERE [ServiceHistory].[RequestID] = @RequestID

	DECLARE @attstreet1 VARCHAR(50), @attcity VARCHAR(50), @attstate VARCHAR(50), @attzip VARCHAR(50),
			@crtstreet1 VARCHAR(50), @crtcity VARCHAR(50), @crtstate VARCHAR(50), @crtzip VARCHAR(50),
			@trststreet1 VARCHAR(50), @trstcity VARCHAR(50), @trststate VARCHAR(50), @trstzip VARCHAR(50)
			
	SELECT @attstreet1 = PARSENAME(REPLACE(AttorneyStreet1, ', ', '.'), 3),
			@attcity = PARSENAME(REPLACE(AttorneyStreet1, ', ', '.'), 2),
			@attstate = LEFT(PARSENAME(REPLACE(AttorneyStreet1, ', ', '.'), 1), 2),
			@attzip = SUBSTRING(PARSENAME(REPLACE(AttorneyStreet1, ', ', '.'), 1), 4, LEN(PARSENAME(REPLACE(AttorneyStreet1, ', ', '.'), 1))),
			@crtstreet1 = PARSENAME(REPLACE(CourtStreet1, ', ', '.'), 3),
			@crtcity = PARSENAME(REPLACE(CourtStreet1, ', ', '.'), 2),
			@crtstate = LEFT(PARSENAME(REPLACE(CourtStreet1, ', ', '.'), 1), 2),
			@crtzip = SUBSTRING(PARSENAME(REPLACE(CourtStreet1, ', ', '.'), 1), 4, LEN(PARSENAME(REPLACE(CourtStreet1, ', ', '.'), 1))),
			@trststreet1 = PARSENAME(REPLACE(TrusteeStreet1, ', ', '.'), 3),
			@trstcity = PARSENAME(REPLACE(TrusteeStreet1, ', ', '.'), 2),
			@trststate = LEFT(PARSENAME(REPLACE(TrusteeStreet1, ', ', '.'), 1), 2),
			@trstzip = SUBSTRING(PARSENAME(REPLACE(TrusteeStreet1, ', ', '.'), 1), 4, LEN(PARSENAME(REPLACE(TrusteeStreet1, ', ', '.'), 1)))
	FROM dbo.Services_TLO_Bankruptcy WITH (NOLOCK)
	WHERE requestid = @RequestID
	
	--Insert XML info returned into service history table
	DECLARE @xmlinfo VARCHAR(2500)
	SELECT @xmlinfo = '<?xml version="1.0"?><DataRows><DataRow><VIRTUALHEADER>VIRTUALHEADER</VIRTUALHEADER><RequestID>' + CONVERT(VARCHAR(25), stb.RequestID) + '</RequestID>
	<CaseNumber>' + CaseNumber + '</CaseNumber><Chapter>' + Chapter + '</Chapter><FileDate>' + ISNULL(CONVERT(VARCHAR(10), FileDate, 101), '') + '</FileDate>
	<DischargeDate>' + ISNULL(CONVERT(VARCHAR(10), DischargeDate, 101), '') + '</DischargeDate><ClosedDate>' + ISNULL(CONVERT(VARCHAR(10), ClosedDate, 101), '') + '</ClosedDate>
	<NoticeType>' + REPLACE(NoticeType, '&', '') + '</NoticeType><AttorneyName>' + AttorneyName + '</AttorneyName><AttorneyStreet1>' + @attstreet1 + '</AttorneyStreet1>
	<AttorneyStreet2>' + AttorneyStreet2 + '</AttorneyStreet2><AttorneyCity>' + @attcity + '</AttorneyCity><AttorneyState>' + @attstate + '</AttorneyState>
	<AttorneyZip>' + @attzip + '</AttorneyZip><AttorneyPhone>' + AttorneyPhone + '</AttorneyPhone><CourtDistrict>' + CourtDistrict + '</CourtDistrict>
	<CourtDivision>' + CourtDivision + '</CourtDivision><CourtStreet1>' + @crtstreet1 + '</CourtStreet1><CourtStreet2>' + CourtStreet2 + '</CourtStreet2>
	<CourtCity>' + @crtcity + '</CourtCity><CourtState>' + @crtstate + '</CourtState><CourtZip>' + @crtzip + '</CourtZip><CourtPhone>' + CourtPhone + '</CourtPhone>
	<TrusteeName>' + TrusteeName + '</TrusteeName><TrusteeStreet1>' + @trststreet1 + '</TrusteeStreet1><TrusteeStreet2>' + TrusteeStreet2 + '</TrusteeStreet2>
	<TrusteeCity>' + @trstcity + '</TrusteeCity><TrusteeState>' + @trststate + '</TrusteeState><TrusteeZip>' + @trstzip + '</TrusteeZip>
	<TrusteePhone>' + TrusteePhone + '</TrusteePhone><TLOFirstName>' + TLOFirstName + '</TLOFirstName><TLOMiddleName>' + TLOMiddleName + '</TLOMiddleName>
	<TLOLastName>' + TLOLastName + '</TLOLastName><TLOSuffix>' + TLOSuffix + '</TLOSuffix><TLOSSN>' + TLOSSN + '</TLOSSN>
	<TLOStreet1>' + TLOStreet1 + '</TLOStreet1><TLOStreet2>' + TLOStreet2 + '</TLOStreet2><TLOCity>' + TLOCity + '</TLOCity>
	<TLOState>' + TLOState + '</TLOState><TLOZip>' + TLOZip + '</TLOZip></DataRow></DataRows>'
	FROM services_tlo_bankruptcy stb WITH (NOLOCK)
	WHERE stb.requestid = @Requestid
	
	UPDATE dbo.ServiceHistory
	SET XMLInfoReturned = @xmlinfo
	WHERE requestid = @Requestid
	
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



	--determine if bankruptcy was returned 
	IF (SELECT COUNT(*) FROM dbo.Services_TLO_Bankruptcy WITH (NOLOCK)
		WHERE RequestID = @RequestID) > 0 
		BEGIN
			--bankruptcy found
			SET @BankruptcyReturned = 1;
		END

	ELSE 
		BEGIN
			--no bankruptcy found
			SET @BankruptcyReturned = 0;
			
			IF (@debtorseq = 0)
			BEGIN
				UPDATE master
				SET desk = 'NOBKCY'
				WHERE number = @number AND desk = '0000000'
			END
			
		END

	
	
	
		
	--update service history returned date
	UPDATE [ServiceHistory]
	SET [ServiceHistory].ReturnedDate = GETDATE()
	FROM [dbo].[ServiceHistory] AS [ServiceHistory] WITH (NOLOCK)
	WHERE [ServiceHistory].[RequestId] = @RequestID
	
	IF (@@ERROR != 0) GOTO ErrHandler
	
	--no bankruptcy info returned
	IF @BankruptcyReturned = 0 
		BEGIN
	
		
		--insert note	
			INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
			VALUES (@number, @runDate, 'TLO', 'BNKO', 'IF', 'Debtor(' + RTRIM(LTRIM(@DebtorName)) + ') No bankruptcy information found.')
			IF (@@ERROR != 0) GOTO ErrHandler
						
			--exit here
			GOTO cuExit
		END


	--BANKRUPTCY INFORMATION RETURNED PROCESSING BEGIN
	
	--assign local variables from Services_TLO_Bankruptcy
	DECLARE @chapter CHAR(2), @disposition BIT,
	@fileddate DATETIME, @statusdate DATETIME,
	@MatchName VARCHAR(75), @attorneyExists BIT

	SELECT @chapter = [Services_TLO_Bankruptcy].[Chapter],  
		@fileddate = ISNULL(CAST([Services_TLO_Bankruptcy].[FileDate] AS DATETIME), NULL),
		@MatchName = CASE WHEN LEN(ISNULL([Services_TLO_Bankruptcy].[TLOLastName],'')) > 0 THEN ISNULL([Services_TLO_Bankruptcy].[TLOLastName],'') + ', ' + ISNULL([Services_TLO_Bankruptcy].[TLOFirstName],'') + ' ' + ISNULL([Services_TLO_Bankruptcy].[TLOMiddleName],'')
			ELSE ISNULL([Services_TLO_Bankruptcy].[TLOFirstName],'') + ' ' + ISNULL([Services_TLO_Bankruptcy].[TLOMiddleName],'') END,
		@disposition = CASE WHEN [services_tlo_bankruptcy].NoticeType NOT LIKE '%dismiss%' AND @customer IN ('0001256', '0001257') THEN 1
			WHEN [Services_TLO_Bankruptcy].dischargedate IS NULL THEN 0 
			WHEN [Services_TLO_Bankruptcy].dischargedate = '' THEN 0 
			 
			ELSE 1 END, 	
		@attorneyExists = CASE when @disposition = 0 then 0 WHEN LEN([Services_TLO_Bankruptcy].[AttorneyName]) > 0 THEN 1 ELSE 0 END
		
	--For 1256, 1257 Filing is considered closing reason for bankruptcy
		
	FROM [dbo].[Services_TLO_Bankruptcy] AS [Services_TLO_Bankruptcy] WITH (NOLOCK)
	WHERE [Services_TLO_Bankruptcy].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	--search for an existing bankruptcy record
	DECLARE @BankruptcyFound INTEGER
	SELECT @BankruptcyFound = [Bankruptcy].[debtorid] FROM [dbo].[Bankruptcy] AS [Bankruptcy] WITH (NOLOCK) WHERE [Bankruptcy].[debtorid] = @DebtorID
	IF (@@ERROR != 0) GOTO ErrHandler

	--search for an existing debtor attorney record
	DECLARE @DebtorAttorneyFound INTEGER
	SELECT @DebtorAttorneyFound = [debtorattorneys].[debtorid] FROM [dbo].[debtorattorneys] AS [debtorattorneys] WITH (NOLOCK) WHERE [debtorattorneys].[debtorid] = @DebtorID AND [debtorattorneys].[accountid] = @number
	IF (@@ERROR != 0) GOTO ErrHandler



		
		IF EXISTS(SELECT * FROM [Bankruptcy] WITH (NOLOCK) WHERE DebtorId=@debtorId)
		BEGIN
		
				IF (@debtorseq = 0 AND @disposition = 1 AND @customer not in ('0001483', '0001404', '0001476', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)) 
					and @customer NOT IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob LIKE 'STL%' AND customer <> '0001489' and customer NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (196) AND customerid not in ('0001404', '0001283'))))
					OR (@disposition = 1 AND @chapter = '13' and @customer not in ('0001483', '0001283', '0001489', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)))
					BEGIN
					
						IF ((SELECT COUNT(*) FROM debtors WITH (NOLOCK) WHERE number = @number) = (SELECT COUNT(*) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = @number))
							BEGIN
							
								SET @noteResultCode = CASE @chapter WHEN '7' THEN 'B7' WHEN '11' THEN 'B11' WHEN '13' THEN 'B13' ELSE 'BK' END
							
								UPDATE master
								SET desk = 'BKCY', qlevel = '998', status = 'BKY', closed = GETDATE()
								WHERE number = @number
							
							
								INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
								VALUES (@number, @runDate, 'BankoSvc', 'CO', @noteResultCode, 'Found bankruptcy information on Debtor see Panel')

							
								INSERT INTO statushistory(accountid, datechanged, username, oldstatus, newstatus)
								VALUES (@number, GETDATE(), 'SYSTEM', 'NEW', 'BKY')
							END
						ELSE
							BEGIN
					
								UPDATE master
								SET desk = 'NOBKCY'
								WHERE number = @number
							
								INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
								VALUES (@number, @runDate, 'BankoSvc', 'CO', 'CO', 'Found bankruptcy information on Debtor see Panel')
								
							END
					END
				
				IF (@debtorseq = 0 AND @disposition = 0)
					BEGIN
					
						UPDATE master
						SET desk = 'NOBKCY'
						WHERE number = @number
					
						INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
						VALUES (@number, @runDate, 'BankoSvc', 'CO', 'CO', 'Found bankruptcy information on Debtor see Panel')
						
					END
			END	
			--insert bankruptcy record using Services_LexisNexis_Bankruptcy
		IF NOT EXISTS(SELECT * FROM [Bankruptcy] WITH (NOLOCK) WHERE DebtorId=@debtorId)
			BEGIN
			INSERT INTO [dbo].[Bankruptcy] ([AccountID], [DebtorID], [Chapter], [DateFiled],
				[CaseNumber], [CourtCity], [CourtDistrict], [CourtDivision], [CourtPhone], [CourtStreet1],
				[CourtStreet2], [CourtState], [CourtZipcode], [Trustee], [TrusteeStreet1], [TrusteeStreet2],
				[TrusteeCity], [TrusteeState], [TrusteeZipcode], [TrusteePhone], [TransmittedDate], [Location341], [Comments], [Status])
			SELECT TOP 1 @Number, @DebtorID, [Services_TLO_Bankruptcy].[Chapter],
				ISNULL(CAST([Services_TLO_Bankruptcy].[FileDate] AS DATETIME), NULL) FileDate, 
				[Services_TLO_Bankruptcy].[CaseNumber], ISNULL(@crtcity, ''), ISNULL([Services_TLO_Bankruptcy].[CourtDistrict], ''), ISNULL([Services_TLO_Bankruptcy].courtdivision, ''), ISNULL([Services_TLO_Bankruptcy].[CourtPhone], ''), 
				ISNULL(@crtstreet1, ''), ISNULL([Services_TLO_Bankruptcy].[Courtstreet2], ''), ISNULL(@crtstate, ''), ISNULL(@crtzip, ''), 
				[Services_TLO_Bankruptcy].[Trusteename], ISNULL(@trststreet1, ''), '', ISNULL(@trstcity, ''), ISNULL(SUBSTRING(@trststate, 1, 3), ''), ISNULL(SUBSTRING(@trstzip, 1,10), ''), ISNULL([Services_TLO_Bankruptcy].[TrusteePhone], ''), 
				@rundate, '', '', [services_tlo_bankruptcy].NoticeType
			FROM [dbo].[Services_TLO_Bankruptcy] AS [Services_TLO_Bankruptcy] WITH (NOLOCK)
			WHERE [Services_TLO_Bankruptcy].[RequestID] = @RequestID

			IF (@@ERROR != 0) GOTO ErrHandler
		END
		

		-- insert debtor attorney record if present in xml data
		IF @attorneyExists = 1 
			BEGIN
	    		
				IF NOT EXISTS (SELECT * FROM DebtorAttorneys WITH (NOLOCK) WHERE Debtorid=@DebtorId)
					BEGIN
						--insert debtor attorney record using xml input parameter @doc
						-- Execute an INSERT statement using OPENXML rowset provider.
						INSERT INTO [dbo].[DebtorAttorneys] ([AccountID], [DebtorID], [Name], 
							[Addr1], [Addr2], [City], [State], [Zipcode], [Phone],
							[Fax], [Email], [Comments], [DateCreated], [DateUpdated], [firm] )
						SELECT TOP 1 @number, @DebtorID, [Services_TLO_Bankruptcy].[AttorneyName], ISNULL(@attstreet1, ''), ISNULL([Services_TLO_Bankruptcy].Attorneystreet2, ''), 
							ISNULL(@attcity, ''), ISNULL(SUBSTRING(@attstate, 1, 3), ''), ISNULL(SUBSTRING(@attzip, 1, 20), ''),
							ISNULL([Services_TLO_Bankruptcy].[AttorneyPhone], ''), '', '', '', @runDate, @runDate, ''
						FROM [dbo].[Services_TLO_Bankruptcy] AS [Services_TLO_Bankruptcy] WITH (NOLOCK)
						WHERE [Services_TLO_Bankruptcy].[RequestID] = @RequestID
						IF (@@ERROR != 0) GOTO ErrHandler
					END
			END

		--update pending letters as deleted for this debtor
		IF (SELECT COUNT(*) FROM [dbo].[LetterRequest] AS [LetterRequest] WITH (NOLOCK)
			INNER JOIN [dbo].[LetterRequestRecipient] AS [LetterRequestRecipient] WITH (NOLOCK) ON [LetterRequestRecipient].[LetterRequestID] = [LetterRequest].[LetterRequestID]
			WHERE [LetterRequestRecipient].[debtorid] = @DebtorID AND [LetterRequest].[AccountID] = @number 
			AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000') > 0 
			BEGIN
				--update letterrequests 
					UPDATE [LetterRequest]
						SET [LetterRequest].[deleted] = 1, 
						[LetterRequest].[errordescription] = 'Bankruptcy info returned ' + CONVERT(VARCHAR(10), @runDate, 101)
					FROM [dbo].[LetterRequest] AS [LetterRequest] WITH (NOLOCK)
					WHERE [LetterRequest].[accountid] = @number 
					AND [LetterRequest].[dateprocessed] = '1753-01-01 12:00:00.000' 
					IF (@@ERROR != 0) GOTO ErrHandler
			END

		--set suppress letters restriction on bankrupt accounts
		
		IF @DebtorSeq IS NOT NULL 
			BEGIN
				IF (@customer not in ('0001483', '0001404', '0001476', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)) 
					AND @customer NOT IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob LIKE 'STL%' AND customer <> '0001489' AND customer NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID IN (196) AND customerid not in ('0001404', '0001283'))))
					OR (@disposition = 1 AND @chapter = 13 AND @customer not in ('0001483', '0001283', '0001489', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)))
					BEGIN
				
						IF EXISTS (SELECT * FROM [restrictions] WHERE DebtorId=@debtorId)
							 BEGIN
								--update restrictions
								UPDATE [restrictions] 
									SET [restrictions].[suppressletters] = 1 
								FROM [dbo].[restrictions] AS [restrictions] WITH (NOLOCK)
								WHERE [restrictions].[debtorid] = @DebtorID 
								IF (@@ERROR != 0) GOTO ErrHandler
							END
						ELSE 
							BEGIN
							--insert restrictions
							INSERT INTO [dbo].[restrictions]([number], [debtorid], [suppressletters]) 
							VALUES( @number, @DebtorID, 1)
							IF (@@ERROR != 0) GOTO ErrHandler
							END	
					END	
					--GOTO cuExit
			END
		
		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	--insert note
	
	IF @BankruptcyReturned = 1 AND @disposition = 1
		BEGIN
			INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
			VALUES (@number, @runDate, 'TLO', 'BNKO', 'IF', 'Debtor('+RTRIM(LTRIM(@DebtorName)) + ') MatchName(' + RTRIM(LTRIM(@MatchName)) + ') See Bankruptcy Panel for Info.')
		END
	IF @BankruptcyReturned = 1 AND @disposition = 0
		BEGIN
			INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
			VALUES (@number, @runDate, 'TLO', 'BNKO', 'IF', 'Debtor('+RTRIM(LTRIM(@DebtorName)) + ') MatchName(' + RTRIM(LTRIM(@MatchName)) + ') See Bankruptcy Panel for Info.')
		END		
			IF (@@ERROR != 0) GOTO ErrHandler

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--prepare account for next service
		IF (@debtorseq = 0 AND @BankruptcyReturned = 1 AND @disposition = 1)
			OR (@disposition = 1 AND @chapter = 13 and @customer not in ('0001283', '0001489', '0001483', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)))
			BEGIN
			
				IF ((SELECT COUNT(*) FROM debtors WITH (NOLOCK) WHERE number = @number) = (SELECT COUNT(*) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = @number)
				AND @customer not in ('0001483', '0001404', '0001476', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)) AND @customer NOT IN (SELECT customer FROM customer WITH (NOLOCK) WHERE cob LIKE 'STL%' AND customer <> '0001489' AND customer NOT IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID IN (196) AND customerid not in ('0001404', '0001283'))))
				OR (@disposition = 1 AND @chapter = 13 and @customer not in ('0001283', '0001489', '0001483', '0001527', '0001531', '0001552', '0001553', '0001554', '0001555', '0001556', '0001557', '0001571') and @customer not in (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (261)))
							BEGIN
							
							SET @noteResultCode = CASE @chapter WHEN '7' THEN 'B7' WHEN '11' THEN 'B11' WHEN '13' THEN 'B13' ELSE 'BK' END
							
								UPDATE master
								SET desk = 'BKCY', qlevel = '998', status = 'BKY', closed = GETDATE()
								WHERE number = @number

								INSERT INTO statushistory(accountid, datechanged, username, oldstatus, newstatus)
								VALUES (@number, GETDATE(), 'SYSTEM', 'NEW', 'BKY')
								
								INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
								VALUES (@number, @runDate, 'BankoSvc', 'CO', @noteResultCode, 'Found bankruptcy information on Debtor See Panel')
							END
							
							ELSE
								BEGIN
									UPDATE master
									SET desk = 'NOBKCY'
									WHERE number = @number
									
									INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
									VALUES (@number, @runDate, 'BankoSvc', 'CO', 'CO', 'Found bankruptcy information on Debtor See Panel')

									
								END
				
			END
			
		IF (@debtorseq = 0 AND @BankruptcyReturned = 1 AND @disposition = 0)
			BEGIN
				UPDATE master
				SET desk = 'NOBKCY'
				WHERE number = @number
				
				INSERT INTO [dbo].[notes] ([number], [created], [user0], [action], [result], [comment])
				VALUES (@number, @runDate, 'BankoSvc', 'CO', 'CO', 'Found bankruptcy information on Debtor See Panel')

				
			END
	IF (@@ERROR != 0) GOTO ErrHandler
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN

ErrHandler:
	RAISERROR('Error encountered in Custom_Process_TLO for account id %d.  Custom_Process_TLO failed.', 11, 1, @number)
	RETURN
GO
