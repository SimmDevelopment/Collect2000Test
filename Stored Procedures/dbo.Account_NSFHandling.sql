SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/11/03
-- Description:	Do required data manipulation for a reversed or declined payment.
--		Moved code from Payment_NSFReversalHandling to this new sproc in order to
--		make the functionality not tied to a payment so it can be used for a declined CC/ACH.
--		
-- History: tag removed
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-05-14   Time: 13:46:28-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Case 52863: initialize @rows var 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:53:31-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Added procedures from 9 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2009-11-03   Time: 16:51:15-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Moved functionality from Payment_NSFReverseHandling so that it can be used 
--  for CC/ACH declines that don't yet have a payment. 
-- =============================================

-- 07/13/2022 BGM Added new variable for credit cards to go to DCC status on delicne instead of NPC
-- 10/05/2022 BGM Updated Arrangement reversal status for creditcards to DCC around line 267

CREATE PROCEDURE [dbo].[Account_NSFHandling]
@FileNumber int,
@PostDateID int,
@PostDateType varchar(5),
@ErrorBlock varchar(30) Output
AS
SET NOCOUNT ON;

DECLARE @Err int 
DECLARE @rows int 
DECLARE @UserName varchar(255)
DECLARE @ReversalQDate varchar(8)
DECLARE @ReversalQLevel varchar(3)
DECLARE @FollowerQLevel varchar(3)
DECLARE @DriverQLevel varchar(3)
DECLARE @ReversalStatus varchar(3)
DECLARE @OwnerId int
DECLARE @OwnerDesk varchar(10)
DECLARE @ArrangementAccounts table (number int not null, IsDriver bit not null, InArrangement bit not null, LinkId int null, Status varchar(5) null, NewStatus varchar(5) null, QLevel varchar(3) null, NewQLevel varchar(3) null, QDate varchar(8) null, ShouldQueue bit not null, Desk varchar(10) not null, primary key(number), PaymentVendorTokenId int null)
DECLARE @POSTDATE_PDC varchar(3)
DECLARE @POSTDATE_DEBTORCREDITCARD varchar(3)
DECLARE @INVALID_UID INT
DECLARE @ReversalStatusPCC VARCHAR(3)


SET @POSTDATE_PDC = 'PDC'
SET @POSTDATE_DEBTORCREDITCARD = 'PCC'
SET @INVALID_UID = -1
SET @DriverQLevel = '599'
SET @FollowerQLevel = '875'
SET @ReversalStatus='NSF'
SET @ReversalQLevel='012'
SET @ReversalQDate=REPLACE(STR(DATEPART(yyyy,getdate()),4) + STR(DATEPART(mm,getdate()),2) + STR(DATEPART(dd,getdate()),2),' ','0') 
SET @UserName = 'SYS'
SET @OwnerId = @FileNumber
SET @rows = 0
SET @ReversalStatusPCC = 'DCC'

-- Get any pcc or pdc arrangement information
IF @PostDateType = @POSTDATE_DEBTORCREDITCARD
BEGIN
	-- This is a reversal of a Credit Card...
	INSERT INTO @ArrangementAccounts (number, IsDriver, InArrangement, LinkId, Status, NewStatus, QLevel, NewQLevel, QDate, ShouldQueue, Desk,PaymentVendorTokenId) 
	SELECT DISTINCT m.number, m.LinkDriver, 1, m.Link, m.Status, @ReversalStatusPCC, m.QLevel, @FollowerQLevel, m.QDate, m.ShouldQueue, m.desk ,dcc.PaymentVendorTokenId
	FROM master m INNER JOIN DebtorCreditCardDetails d ON m.number = d.accountid 
	INNER JOIN DebtorCreditCards dcc ON d.DebtorCreditCardID = dcc.Id
	WHERE m.qlevel not in ('998','999') AND d.DebtorCreditCardID IN (
		SELECT DebtorCreditCards.ID FROM DebtorCreditCards WHERE ArrangementID = (
			SELECT DebtorCreditCards.ArrangementID FROM DebtorCreditCards WHERE ID = @PostDateID )
			AND PaymentVendorTokenId = (SELECT PaymentVendorTokenId FROM DebtorCreditCards WHERE ID = @PostDateID))

	SELECT @Err=@@Error, @rows = @@rowcount 
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Insert into temp: ' + @POSTDATE_DEBTORCREDITCARD
		RETURN @Err  
	END  
END
ELSE
BEGIN
	IF @PostDateType = @POSTDATE_PDC
	BEGIN
		-- This is a reversal of a pdc...
		INSERT INTO @ArrangementAccounts (number, IsDriver, InArrangement, LinkId, Status, NewStatus, QLevel, NewQLevel, QDate, ShouldQueue, Desk,PaymentVendorTokenId) 
		SELECT DISTINCT m.number, m.LinkDriver, 1, m.Link, m.Status, @ReversalStatus, m.QLevel, @FollowerQLevel, m.QDate, m.ShouldQueue, m.desk,pd.PaymentVendorTokenId
		FROM master m INNER JOIN PDCDetails d ON m.number = d.accountid 
		INNER JOIN PDC pd ON [pd].[UID] = d.PdcID 
		WHERE m.qlevel not in ('998','999') AND d.PDCID IN (
			SELECT PDC.UID FROM PDC WHERE ArrangementID = (
				SELECT PDC.ArrangementID FROM PDC WHERE UID = @PostDateID)
				AND PaymentVendorTokenId = (SELECT PaymentVendorTokenId FROM PDC WHERE UID = @PostDateID))
		SELECT @Err=@@Error, @rows = @@rowcount 
		IF @Err <> 0 
		BEGIN  
			SET @ErrorBlock = 'Insert into temp: ' + @POSTDATE_PDC
			RETURN @Err  
		END  
	END
END

-- If we haven't queried any rows yet...
IF @Rows < 1
BEGIN
	-- This is not a reversal of a postdate...or not part of an arrangement...
	INSERT INTO @ArrangementAccounts (number, IsDriver, InArrangement, LinkId, Status, NewStatus, QLevel, NewQLevel, QDate, ShouldQueue, Desk) 
		SELECT DISTINCT m.number, m.LinkDriver, 0, m.Link, m.Status, @ReversalStatus, m.QLevel, @FollowerQLevel, m.QDate, m.ShouldQueue, m.desk 
		FROM master m WHERE number = @OwnerId

	SELECT @Err=@@Error, @rows = @@rowcount 
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Insert into temp: NOT'
		RETURN @Err  
	END  
END

-- Make sure we have a link driver OR that the account is not linked!
IF NOT EXISTS(SELECT * FROM @ArrangementAccounts WHERE IsDriver = 1 OR (LinkId = 0 OR LinkId is NULL))
BEGIN
	INSERT INTO @ArrangementAccounts (number, IsDriver, InArrangement, LinkId, Status, NewStatus, QLevel, NewQLevel, QDate, ShouldQueue, Desk) 
		SELECT DISTINCT m.number, m.LinkDriver, 0, m.Link, m.Status, m.Status, m.QLevel, @FollowerQLevel, m.QDate, m.ShouldQueue, m.desk 
		FROM [dbo].[master] m WHERE m.link = (SELECT link from [dbo].[master] sm where @OwnerId = sm.number) and m.LinkDriver = 1 AND number not in (select number from @ArrangementAccounts)
END

---- Make sure the Owner data is set...
--UPDATE @ArrangementAccounts SET IsOwner = 1 WHERE number = @OwnerId
--SELECT @Err=@@Error, @rows = @@rowcount 
--IF @Err <> 0 
--BEGIN  
--	SET @ErrorBlock = 'Update temp: Owner info'
--	RETURN @Err  
--END 


-- Make sure the Driver data is set...
UPDATE @ArrangementAccounts SET NewQLevel = @ReversalQLevel, QDate = @ReversalQDate WHERE IsDriver = 1
SELECT @Err=@@Error, @rows = @@rowcount 
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'Update temp: Owner info'
	RETURN @Err  
END 

-- Make sure the non-linked account data is set...
UPDATE @ArrangementAccounts SET NewQLevel = @ReversalQLevel, QDate = @ReversalQDate WHERE LinkId = 0 or LinkId is null
SELECT @Err=@@Error, @rows = @@rowcount 
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'Update temp: Owner info'
	RETURN @Err  
END  

DECLARE @PaymentVendorTokenID int
DECLARE @NumberOfPDCs int
DECLARE @NumberOfPCCs int

set @PaymentVendorTokenID = (SELECT TOP 1 PaymentVendorTokenId FROM @ArrangementAccounts WHERE PaymentVendorTokenId IS NOT NULL);

--  Place PDCs on Hold 
SET @NumberOfPDCs =  CASE WHEN @PaymentVendorTokenID is NULL THEN 
  (SELECT COUNT(number) from PDC WHERE number = @OwnerId and Active = 1)
ELSE 
(SELECT COUNT(number) from PDC WHERE PaymentVendorTokenId = @PaymentVendorTokenID AND Active = 1)
END
SELECT @Err=@@Error, @rows = @@rowcount 
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'SELECT PDCs on NSF'  
	RETURN @Err  
END  

SET @NumberOfPCCs =  CASE WHEN @PaymentVendorTokenID is NULL THEN 
  (SELECT COUNT(number) from DebtorCreditCards WHERE number = @OwnerId and IsActive = 1)
ELSE 
(SELECT COUNT(number) from DebtorCreditCards WHERE PaymentVendorTokenId = @PaymentVendorTokenID AND IsActive = 1)
END
SELECT @Err=@@Error, @rows = @@rowcount 
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'SELECT PCCs on NSF'  
	RETURN @Err  
END  

IF (@NumberOfPDCs > 0 ) 
BEGIN   
	IF (@PaymentVendorTokenID is NULL)
	BEGIN
		UPDATE PDC SET OnHold = GetDate() WHERE number = @OwnerId and Active = 1
		SELECT @Err=@@Error  
		IF @Err <> 0 
		BEGIN  
			SET @ErrorBlock = 'Update PDCs OnHold'  
			RETURN @Err  
		END  
	END
	ELSE 
		BEGIN
			UPDATE PDC SET OnHold = GetDate() WHERE PaymentVendorTokenId = @PaymentVendorTokenID and Active = 1
			SELECT @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
				SET @ErrorBlock = 'Update PDCs OnHold'  
				RETURN @Err  
	END  
		END

	--	Change our status and qlevel values from default 
	SELECT @ReversalStatus='NPC', @ReversalQLevel='019'

	UPDATE @ArrangementAccounts SET NewQLevel = @ReversalQLevel, ShouldQueue = 1, QDate = @ReversalQDate WHERE IsDriver = 1 OR (LinkId = 0 OR LinkId is NULL)
	SELECT @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Update temp owner qlevel'  
		RETURN @Err  
	END  

	UPDATE @ArrangementAccounts SET NewStatus = @ReversalStatus WHERE InArrangement = 1
	SELECT @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Update temp NewXXXXX'  
		RETURN @Err  
	END  
END  

IF (@NumberOfPCCs > 0) 
BEGIN   
	IF (@PaymentVendorTokenID is NULL)
	BEGIN
		UPDATE DebtorCreditCards SET OnHoldDate = GetDate() WHERE number = @OwnerId and IsActive = 1
		SELECT @Err=@@Error  
		IF @Err <> 0 
		BEGIN  
			SET @ErrorBlock = 'Update PDCs OnHold'  
			RETURN @Err  
		END  
	END
	ELSE 
		BEGIN
			UPDATE DebtorCreditCards SET OnHoldDate = GetDate() WHERE PaymentVendorTokenId = @PaymentVendorTokenID and IsActive = 1
			SELECT @Err=@@Error  
			IF @Err <> 0 
			BEGIN  
				SET @ErrorBlock = 'Update PDCs OnHold'  
				RETURN @Err  
	END  
		END

	--	Change our status and qlevel values from default 
	SELECT @ReversalStatus='DCC', @ReversalQLevel='019'

	UPDATE @ArrangementAccounts SET NewQLevel = @ReversalQLevel, ShouldQueue = 1, QDate = @ReversalQDate WHERE IsDriver = 1 OR (LinkId = 0 OR LinkId is NULL)
	SELECT @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Update temp owner qlevel'  
		RETURN @Err  
	END  

	UPDATE @ArrangementAccounts SET NewStatus = @ReversalStatus WHERE InArrangement = 1
	SELECT @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Update temp NewXXXXX'  
		RETURN @Err  
	END  
END  


--Place Promises on Hold - LAT-10650 Fix
SELECT AcctID from Promises WHERE AcctID = @OwnerId and Active = 1
SELECT @Err=@@Error, @rows = @@rowcount 
IF @Err <> 0 
BEGIN  
	SET @ErrorBlock = 'SELECT Promisess on NSF'  
	RETURN @Err  
END
IF (@rows > 0 ) 
BEGIN   
	UPDATE Promises SET Suspended = 1 WHERE AcctID = @OwnerId and Active = 1
	SELECT @Err=@@Error  
	IF @Err <> 0 
	BEGIN  
		SET @ErrorBlock = 'Update Promisess On NSF'  
		RETURN @Err  
	END  
END  

-------------- Do our account updates --------------------

-- Just to print the results so far...
/*
SELECT * FROM @ArrangementAccounts WHERE IsOwner = 0 AND IsDriver = 0
SET @rows = @@ROWCOUNT
PRINT 'Set ' + CAST(@rows AS varchar(10)) + ' Follower Accounts to ' + @ReversalStatus + '/' + @FollowerQLevel

SELECT * FROM @ArrangementAccounts WHERE IsOwner = 0 AND IsDriver <> 0
SET @rows = @@ROWCOUNT
PRINT 'Set ' + CAST(@rows AS varchar(10)) + ' Driver Account to ' + @ReversalStatus + '/' + @DriverQLevel

SELECT * FROM @ArrangementAccounts WHERE IsOwner <> 0
SET @rows = @@ROWCOUNT
PRINT 'Set ' + CAST(@rows AS varchar(10)) + ' Owner Account to ' + @ReversalStatus + '/' + @ReversalQLevel
	*/
-- Update the master record...
UPDATE m SET m.qlevel = t.NewQLevel,
	m.Status = t.NewStatus,
	m.ShouldQueue = t.ShouldQueue,
	m.qdate = t.QDate,
	closed = CASE
		WHEN t.NewQLevel IN ('998', '999') THEN COALESCE(closed, GETDATE())
		ELSE NULL
	END,
	returned = CASE
		WHEN t.NewQLevel = '999' THEN COALESCE(returned, GETDATE())
		ELSE NULL
	END
FROM master m INNER JOIN @ArrangementAccounts t ON m.number = t.number

SELECT @Err=@@Error, @Rows=@@ROWCOUNT
PRINT 'Updated ' + CAST(@Rows AS varchar(10)) + ' accounts.'  
IF @Err <> 0 
BEGIN  
		SET @ErrorBlock = 'Update Master ' + @ReversalStatus
		RETURN @Err  
END  

-- insert a StatusHistory record
INSERT INTO StatusHistory( AccountID, DateChanged, UserName, OldStatus, NewStatus )
SELECT number, GetDate(), @UserName, Status, NewStatus FROM @ArrangementAccounts WHERE Status <> NewStatus
SELECT @Err=@@Error, @Rows=@@ROWCOUNT
PRINT 'Inserted ' + CAST(@Rows AS varchar(10)) + ' StatusHistory.'  
IF @Err <> 0 
BEGIN  
		SET @ErrorBlock = 'StatusHistory_Insert ' + @ReversalStatus
		RETURN @Err  
END  
		
-- insert a status changed note 
INSERT INTO Notes (Number, Created, User0, action, result, comment) SELECT Number, GetDate(), @UserName, '+++++', '+++++',  'Status Changed from '  + Status + ' to ' + NewStatus FROM @ArrangementAccounts WHERE Status <> NewStatus
SELECT @Err=@@Error, @Rows=@@ROWCOUNT
PRINT 'Inserted ' + CAST(@Rows AS varchar(10)) + ' notes.'  
IF @Err <> 0 
BEGIN  
		SET @ErrorBlock = 'Insert Notes ' + @ReversalStatus
		RETURN @Err  
END  

-- Set a reminder...NOT, the sproc sets the qdate, qlevel, etc. WE DON'T WANT THAT...
--SELECT @OwnerDesk = Desk FROM @ArrangementAccounts WHERE number = @OwnerId
--EXEC @Err = Account_SetReminder @OwnerId, @OwnerDesk, DATEADD(minute, 5, GETDATE())

RETURN @Err

GO
