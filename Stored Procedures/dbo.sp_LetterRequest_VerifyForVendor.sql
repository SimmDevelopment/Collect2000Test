SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_LetterRequest_VerifyForVendor*/
CREATE PROCEDURE [dbo].[sp_LetterRequest_VerifyForVendor]
(
	@LetterID int,
	@ThroughDate datetime,
	@JobName varchar(256),
	@AddSeedLetter BIT, 
	@LetterRequestIDs dbo.IntList_TableType READONLY,
	@TotalLetterRequests INT OUTPUT,
	@ValidLetterRequests INT OUTPUT
)
AS
-- Name:		sp_LetterRequest_VerifyForVendor
-- Function:		This procedure will update letter requests for processing to a 
-- 			file for an outside letter vendor using input parameters.
--			The errordescription column will be updated for letter requests
--			failing verification
-- Creation:		11/24/2003 jc
--			Used by Letter Console. 
-- Change History:	11/24/2003 jc Added input parm @AddSeedLetter
--		01/23/2004 jc Modified case logic of update statement to account for both conditions
--			of an allow always option. This can either be allowfirst30 = 1 and allowafter30 = 1 
--			or allowfirst30 = 0 and allowafter30 = 0.
--		01/26/2004 jc modified join to debtors table from inner join to left outer join to accomodate customer type letters
--		10/21/2015 bgm add restriction for connecticut letters in resurgent accounts.
--		4/14/2016 bgm removed CT restriction for Resurgent account letters.
--		04/03/2017 BGM Added code to not send letters to MA for Resurgent Customer numbers
--		04/07/2017 BGM Added code to not send letters to ID for Resurgent Customer numbers with Pinnacle as previous creditor
--		05/04/2017 BGM Removed code for ID letters to now be sent again.
--		07/03/2017 BGM Added check for valid Attorney's address when letters to attorney is selected in restrictions tab.
--		08/17/2017 BGM Added letters to only be restricted to MA for LVNV Funding, all other previous creditors will go.
--		12/5/2019  BGM Removed restriction to MA for LVNV Funding
--		04/24/2020 BGM Added no letter send to NV for Covid-19 event
--		09/30/2020 BGM Added no letters for paypal NB customers.
--		10/06/2020 BGM Removed restrictions for PayPal NB.
--		10/13/2020 BGM Removed restrictions for Nevada.
--		10/27/2020 BGM Removed letter restriction for PayPal 2468, 2469 and left letters NYPPC and 22PWC restricted.
--		10/27/2020 BGM Added letter restriction for PayPal 2468, 2469 in NY.
--		10/29/2020 BGM Added letter restriciton on Non-Reg Letters for US Bank customers in LA.
--		12/18/2020 BGM Removed letter restrictions on US Bank in LA
--		01/04/2021 BGM Added code to write an error description for USB accounts that have an older CO date for USB to review.
--		02/24/2021 BGM Added code to send letters to alternate recipients when the MR flag is on for the debtor.
--		02/24/2021 BGM Added code to check when sending to an alternate that their address is valid.
--		Added 07/01/2021 BGM restrict letters sent to all brightree accounts in custom group that are in Nevada
--		01/06/2022 BGM Added code to restrict letters when an account is in DIS status.
--		02/10/2022 BGM Added New York letters to be ommited for RMS accounts from US Bank
--		04/21/2022 BGM Updated suppress letter restriction to allow letter 13U, 13UDB to passthrough.
--		05/06/2022 BGM Updated Attorney address to allow name or firm name instead of both to send a letter.
--		Added 01/03/2023 BGM remove restriction on letters sent to all brightree accounts in custom group that are in Nevada


--declare local variables
declare @LetterCode varchar(5)
declare @LetterRequestID int

--assign letter variable
select @LetterCode = isnull(code,'')
from letter
where letterid = @LetterID

if (@@error != 0) goto ErrHandler

--declare control file variables
declare @SeedAccountID int
declare @SeedDebtorID int

--assign control file variables
select @SeedAccountID = isnull(m.number,0),
@SeedDebtorID = isnull(d.debtorid,0)
from controlFile cf
left outer join master m on m.number = cf.SeedLetterNo
left outer join debtors d on d.number = m.number and d.seq = 0

if (@@error != 0) goto ErrHandler

-- only check up if we don't have the list of requests
IF NOT EXISTS (SELECT * FROM @LetterRequestIDs)
BEGIN
	----------------------------------------------------------------------------------
	-- First lets make sure we have all our letterRequest_Account records in place.
	-- Keep in mind that if all the requests are inserted properly, this data correction 
	-- would not be necessary. This is here for requests that for some reason don't 
	-- have lr_account records, which would include historical data and rogue requests.
	----------------------------------------------------------------------------------
	-- Non-link letters should have an lr_account record for just the one account...
	-- Linkedletter = 0, no link
    INSERT  INTO dbo.LetterRequest_Account
            (
                LetterRequestId,
                AccountId,
                Printed,
                PrintedDate,
                Comment,
                CreatedBy,
                CreatedWhen
            )             -- transpose accounts from LetterRequest table to new LetterRequest_Account table
    SELECT DISTINCT
        lr.LetterRequestID,
        lr.AccountID,
        NULL,
        lr.DateProcessed,
        NULL,
        lr.UserName,
        lr.DateCreated
    FROM
        dbo.LetterRequest lr
        INNER JOIN dbo.letter l
            ON l.LetterID = lr.LetterID
    WHERE
        l.linkedLetter = 0 AND
        lr.LetterRequestID NOT IN (SELECT DISTINCT
                                    lr2.LetterRequestID
                                    FROM
                                    dbo.LetterRequest lr2
                                    INNER JOIN dbo.LetterRequest_Account lra2
                                        ON lr2.LetterRequestID = lra2.LetterRequestId
                                    WHERE
                                    lr2.DateProcessed < '1800-1-1') AND
        lr.DateProcessed < '1800-1-1' AND
        lr.LetterID = @LetterID;

	-- Linked letter where the account isn't linked should have an lr_account record for just the one account
	--LinkedLetter = 1  master.link = 0 and not in LetterRequest_Account
    INSERT  INTO dbo.LetterRequest_Account
            (
                LetterRequestId,
                AccountId,
                Printed,
                PrintedDate,
                Comment,
                CreatedBy,
                CreatedWhen
            )             -- transpose accounts from LetterRequest table to new LetterRequest_Account table
    SELECT DISTINCT
        lr.LetterRequestID,
        lr.AccountID,
        NULL,
        lr.DateProcessed,
        NULL,
        lr.UserName,
        lr.DateCreated
    FROM
        dbo.LetterRequest lr
        INNER JOIN dbo.letter l
            ON l.LetterID = lr.LetterID
        INNER JOIN dbo.master m
            ON m.number = lr.AccountID
    WHERE
        l.linkedLetter = 1 AND
        lr.LetterRequestID NOT IN (SELECT DISTINCT
                                    lr2.LetterRequestID
                                    FROM
                                    dbo.LetterRequest lr2
                                    INNER JOIN dbo.LetterRequest_Account lra2
                                        ON lr2.LetterRequestID = lra2.LetterRequestId
                                    WHERE
                                    lr2.DateProcessed < '1800-1-1') AND
        (m.link = 0	OR m.link IS NULL)																	-- no links
        AND
        lr.DateProcessed < '1800-1-1' AND
        lr.LetterID = @LetterID;

	-- Linked letter, for a linked account, lets make sure all the linked accounts have a letterRequest_Account record...
	-- LinkedLetter = 1  master.link = 1 and not in LetterRequest_Account
    INSERT  INTO dbo.LetterRequest_Account
            (
                LetterRequestId,
                AccountId,
                Printed,
                PrintedDate,
                Comment,
                CreatedBy,
                CreatedWhen
            )             -- transpose accounts from LetterRequest table to new LetterRequest_Account table
    SELECT DISTINCT
        lr.LetterRequestID,
        m2.number,
        NULL,
        lr.DateProcessed,
        NULL,
        lr.UserName,
        lr.DateCreated
    FROM
        dbo.LetterRequest lr
        INNER JOIN dbo.letter l
            ON l.LetterID = lr.LetterID
        INNER JOIN dbo.master m
            ON m.number = lr.AccountID
        INNER JOIN dbo.master m2
            ON m2.link = m.link
    WHERE
        l.linkedLetter = 1 AND
        lr.LetterRequestID NOT IN (SELECT DISTINCT
                                    lr2.LetterRequestID
                                    FROM
                                    dbo.LetterRequest lr2
                                    INNER JOIN dbo.LetterRequest_Account lra2
                                        ON lr2.LetterRequestID = lra2.LetterRequestId
                                    WHERE
                                    lr2.DateProcessed < '1800-1-1') AND
        ISNULL(m.link, 0) != 0	                                                   --  links
        AND
		--M.qlevel NOT LIKE '99[89]' AND
        lr.DateProcessed < '1800-1-1' AND
        lr.LetterID = @LetterID;

END  -- @LetterRequestIDs is null

BEGIN TRANSACTION

	--insert seed letter request if required
	if @AddSeedLetter = 1
	BEGIN
		if @SeedAccountID > 0
		BEGIN		
			--add a LetterRequest for the dummy account
			insert into letterrequest(accountid, lettercode, letterid, daterequested, jobname, duedate, username)
			values(@SeedAccountID, @LetterCode, @LetterID, GETUTCDATE(), '[Seed]' + @JobName, GETUTCDATE(), 'Global')

			select @LetterRequestID = SCOPE_IDENTITY()
			if (@@error != 0) goto ErrHandler
			
			--add the recipient
			insert into letterrequestrecipient(letterrequestid, accountid, debtorid, seq)
			values(@LetterRequestID, @SeedAccountID, @SeedDebtorID, 0)
			if (@@error != 0) goto ErrHandler
		END
	END

	if (@@error != 0) goto ErrHandler

	-- create a table definition to hold all the letterrequestId's that meet the given parms.
	--DECLARE @letterRequestIds AS TABLE (LetterRequestId INT NOT NULL);
	DECLARE @lrids AS IntList_TableType;

	IF EXISTS (SELECT * FROM @LetterRequestIDs)
	BEGIN
			INSERT INTO @lrids
			SELECT lr.LetterRequestID 
			FROM @LetterRequestIDs lrids INNER JOIN dbo.LetterRequest lr
				ON lrids.Id = lr.LetterRequestID
			WHERE  lr.Deleted = 0 AND lr.AddEditMode = 0 AND lr.Suspend = 0 AND lr.Edited = 0;
    
			SET @TotalLetterRequests = @@ROWCOUNT
	END
	ELSE
	BEGIN
		-- populate our table with all the letterrequests we care about. This is used below.
		BEGIN TRY
			INSERT INTO @lrids
			SELECT lr.LetterRequestId 
			FROM dbo.LetterRequest lr
			WHERE  lr.DateRequested <= @ThroughDate AND (lr.DateProcessed IS NULL OR lr.DateProcessed = '1/1/1753 12:00:00')
			AND lr.Deleted = 0 AND lr.AddEditMode = 0 AND lr.Suspend = 0 AND lr.Edited = 0 AND lr.LetterID = @LetterID;
    
			SET @TotalLetterRequests = @@ROWCOUNT
		END TRY
		BEGIN CATCH
			GOTO ErrHandler
		END CATCH
	END

	-- reset printed and comment columns in letter request account
	UPDATE lra
	SET printed = NULL, Comment = ''
	FROM LetterRequest_Account lra
		INNER JOIN @lrids lrids
			ON lra.LetterRequestId = lrids.Id
		INNER JOIN LetterRequest lr
			ON lr.LetterRequestID = lrids.Id

	if (@@error != 0) goto ErrHandler;

	update lra
		set lra.Comment = 
		--CASE
		--	WHEN (r.suppressletters = 1) THEN 'Letter Suppressed'
		--	WHEN (l.allowclosed = 0) and (m.qlevel = '998' or m.qlevel = '999') THEN 'Account closed'  
		--	WHEN (l.allowzero = 0) and (m.current0 = 0) THEN 'Account at zero balance'
		--	WHEN (l.allowfirst30 = 1) and (l.allowafter30 = 0) and (GETUTCDATE() > dateadd(d, 30, m.received)) THEN 'Cannot send letter after the first 30 days'
		--	WHEN (l.allowafter30 = 1) and (l.allowfirst30 = 0) and (GETUTCDATE() < dateadd(d, 30, m.received)) THEN 'Cannot send letter during the first 30 days'
		--	WHEN ((sr.restricted = 1) and (l.type <> 'ATT' or l.type <> 'CUS')) THEN 'Letters restricted in ' + sr.statename
		--	WHEN (l.type <> 'ATT' or l.type <> 'CUS') and (d.mr = 'Y') THEN 'Bad Address'
		--	ELSE ''
		--END

		CASE
			WHEN (r.suppressletters = 1 AND @LetterCode NOT IN ('13U', '13UDB')) THEN 'Letter Suppressed'
			WHEN (l.allowclosed = 0) and (m.qlevel = '998' or m.qlevel = '999') THEN 'Account closed'
			WHEN (l.allowzero = 0) and (m.current0 = 0) THEN 'Account at zero balance'
			WHEN (l.allowfirst30 = 1) and (l.allowafter30 = 0) and (getdate() > dateadd(d, 30, m.received)) THEN 'Cannot send letter after the first 30 days'
			WHEN (l.allowafter30 = 1) and (l.allowfirst30 = 0) and (getdate() < dateadd(d, 30, m.received)) THEN 'Cannot send letter during the first 30 days'
			WHEN ((sr.restricted = 1) and (l.type <> 'ATT' or l.type <> 'CUS')) THEN 'Letters restricted in ' + sr.statename
			--WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 289) AND sd.STATE IN ('LA') AND l.TYPE = '' THEN 'Letters restricted in ' + sd.STATE + ' for current events'
			--Removed 4/14/2016 add restriction for connecticut letters in resurgent accounts.
			WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 289) AND m.status IN ('DIS') AND l.TYPE = '' THEN 'Letters restricted in ' + sd.STATE + ' for current events'
			--Added 01/04/2021 BGM Added code to write an error description for USB accounts that have an older CO date for USB to review.
			WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 289) AND m.status IN ('HLD') AND m.ChargeOffDate <= '20191101' AND lr.LetterCode IN ('usbp1', 'usb01', 'USNY1', 'USNYP') AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL)
			THEN 'Letter Suppressed per Client' 
			--Added 04/03/2017 BGM Added code to not send letters to MA for Resurgent Customer numbers
			--Updated 08/17/2017 BGM Added letters to only be restricted to MA for LVNV Funding, all other previous creditors will go.
			--Updated 12/5/2019 BGM Removed restriction to MA for LVNV Funding
			--WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 24) AND d.STATE = 'MA' AND m.previouscreditor = 'LVNV Funding LLC' THEN 'Letters restricted in MA for LVNV Funding Accts'
			--removed 5/4/2017
			--WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 24) AND d.STATE = 'ID' 
			--	AND m.previouscreditor = 'Pinnacle Credit Services, LLC' THEN 'Letters restricted in ID for Pinnacle'
			--Added 4/11/2018 BGM to restrict letters sent to CT for JH Capital.
			--WHEN m.customer IN ('0002337', '0002338', '0002366') THEN 'Letters restricted for customer at this time'
			--Added 1/6/2022 restrict letters that are in DIS status
			WHEN m.status IN ('DIS') AND l.TYPE = '' THEN 'Letters restricted in ' + sd.STATE + ' for current events'
			--Added 10/19/2020 BGM restrict letters sent to customer 2468 and 2469 per PayPal
			WHEN m.customer IN ('0002468', '0002469') AND lr.letterid IN (613, 447) THEN 'Letters restricted for customer at this time'
			WHEN m.customer IN ('0002468', '0002469') AND m.STATE = 'NY' THEN 'Letters restricted for customer and state at this time'
			--Added 07/01/2021 BGM restrict letters sent to all brightree accounts in custom group that are in Nevada
			--WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 269) AND d.STATE = 'NV' THEN 'Letters restricted for customer and state at this time'
			WHEN m.customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE customgroupid = 186) AND d.STATE = 'CT' THEN 'Letters restricted in CT for JH Capital Accts'
			--WHEN (l.type <> 'ATT' or l.type <> 'CUS') and (d.mr = 'Y') THEN 'Bad Address'
			WHEN (l.type NOT IN ('ATT', 'CUS', 'PDC') AND lrr.AltRecipient <> 1) and (d.mr = 'Y' ) THEN 'Bad Address'
			WHEN (r.letterstoatty = 1 AND ((da.NAME = '' AND da.firm = '') OR da.Addr1 = '' OR da.City = '' OR da.State = '' OR da.Zipcode = '')) THEN 'Invalid address for Attorney while letters to attorney selected'
			WHEN (l.type IN ('ATT', 'CUS', 'PDC') AND lrr.AltRecipient = 1 and (d.mr = 'Y' ) AND (lrr.AltName = '' OR lrr.AltStreet1 = '' OR lrr.AltCity = '' OR lrr.AltState = '' OR lrr.altZipcode = '')) THEN 'Invalid Alternate Address'
			ELSE ''
		END
	from letterrequest_account lra
		inner join letterrequest lr on lr.letterrequestid = lra.letterrequestid
		INNER JOIN @lrids lrids ON lr.LetterRequestId = lrids.Id
		inner join letterrequestrecipient lrr on lr.letterrequestid = lrr.letterrequestid
		inner join letter l on l.letterid = lr.letterid
		inner join master m on m.number = lra.accountid
		left outer join debtors d on d.debtorid = lrr.debtorid
		left outer join restrictions r on r.debtorid = lrr.debtorid
		left outer join StateRestrictions sr on sr.abbreviation = d.State
		left outer join DebtorAttorneys da on da.debtorid = lr.subjdebtorid
		left outer join debtors sd on sd.debtorid = lr.subjdebtorid

	
	if (@@error != 0) goto ErrHandler;

	-- update error description with concatenated error descriptions of all linked accounts of a letter request
	;WITH cte_lra (LetterRequestId, ErrorDescriptions) AS (
		SELECT DISTINCT lra.LetterRequestId, 
				(
					SELECT ',' + CAST(lr.AccountId AS varchar(100)) + ': ' + lr.Comment 
					FROM LetterRequest_Account lr
						INNER JOIN @lrids lrids
							ON lra.LetterRequestId = lrids.Id
					WHERE lr.LetterRequestId = lra.LetterRequestId
						AND lr.Comment IS NOT NULL AND lr.Comment != ''
					ORDER BY lr.LetterRequestId
					FOR XML PATH ('')
				) [ErrorDescriptions]
		FROM LetterRequest_Account lra
			INNER JOIN @lrids lrids
				ON lra.LetterRequestId = lrids.Id)

	UPDATE lr
	SET JobName = @JobName,
		lr.ProcessingMethod = 4, -- default all processMethod to error, it will be updated again when processdate is updated.
		lr.ErrorDescription = CASE WHEN cte.ErrorDescriptions = '' THEN '' ELSE CAST(cte.ErrorDescriptions AS VARCHAR(MAX)) END
	FROM cte_lra cte 
		INNER JOIN letterrequest lr
			ON cte.LetterRequestId = lr.LetterRequestID

	if (@@error != 0) goto ErrHandler

	SELECT @ValidLetterRequests = COUNT(*) 
	FROM letterrequest lr
		INNER JOIN @lrids lrids
			ON lr.LetterRequestId = lrids.Id
	WHERE ISNULL(lr.ErrorDescription, '') = ''

	if (@@error != 0) goto ErrHandler

	COMMIT TRANSACTION		
	Return(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_LetterRequest_VerifyForVendor.')
	ROLLBACK TRANSACTION
	Return(1)
GO
