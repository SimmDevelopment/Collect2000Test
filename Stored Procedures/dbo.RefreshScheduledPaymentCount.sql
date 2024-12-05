SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[RefreshScheduledPaymentCount] 
	@AccountID int = NULL
AS

SET NOCOUNT ON

/*
--Null @AccountID - refresh ALL Accounts ELSE refresh single account

1. add accounts that are new
2. update counts for all accounts
3. determine status based off of counts
*/

DECLARE @CurrentDate DATETIME;

SET @CurrentDate = DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)

INSERT INTO dbo.ScheduledPaymentCount
(
    AccountID
)
SELECT number FROM master
EXCEPT
SELECT AccountID FROM dbo.ScheduledPaymentCount

IF @AccountID IS NULL 
BEGIN
	GOTO RefreshALLAccounts
END

--Refresh Single Account

--Determine IF account IS LINKED OR NOT, AND INSERT ALL accounts INTO TABLE variable.
DECLARE @AccountLink INT;
DECLARE @AllAcounts TABLE
( AccountID INT );

SELECT @AccountLink = link FROM MASTER WHERE number = @AccountID;

if @AccountLink <= 0 
BEGIN
	INSERT INTO @AllAcounts
	(
	    AccountID
	)
	VALUES
	(
		@AccountID
	)
END
ELSE
BEGIN
	INSERT INTO @AllAcounts
	(
	    AccountID
	)
	SELECT number FROM master WHERE link = @AccountLink;
END

UPDATE spc 
	SET spc.link = m.link, spc.linkdriver = m.LinkDriver
	FROM dbo.ScheduledPaymentCount spc JOIN master m ON spc.AccountID = m.number
	WHERE accountid IN (select accountid from @AllAcounts)

update dbo.ScheduledPaymentCount set ppa = 
     (select COUNT(acctid) FROM promises WHERE active = 1 AND duedate >= @CurrentDate AND promises.acctID = dbo.ScheduledPaymentCount.accountid)
WHERE AccountID in (select accountid from @AllAcounts)

update dbo.ScheduledPaymentCount set pdc = 
     (select COUNT(number) FROM pdc WHERE active = 1 AND deposit >= @CurrentDate AND pdc.number = ScheduledPaymentCount.accountid)
WHERE AccountID in (select accountid from @AllAcounts)

UPDATE dbo.ScheduledPaymentCount set pcc = 
     (select COUNT(number) FROM dbo.DebtorCreditCards  WHERE ISactive = 1 AND DepositDate >= @CurrentDate AND number = ScheduledPaymentCount.accountid)
WHERE AccountID in (select accountid from @AllAcounts)

--Spread Linked payments accross all accounts
UPDATE spc SET ppa = (SELECT MAX(ppa) FROM dbo.ScheduledPaymentCount WHERE link = spc.link)
FROM dbo.ScheduledPaymentCount spc
WHERE link > 0 AND AccountID in (select accountid from @AllAcounts)

UPDATE spc SET pdc = (SELECT MAX(pdc) FROM dbo.ScheduledPaymentCount WHERE link = spc.link)
FROM dbo.ScheduledPaymentCount spc
WHERE link > 0 AND AccountID in (select accountid from @AllAcounts)

UPDATE spc SET pcc = (SELECT MAX(pcc) FROM dbo.ScheduledPaymentCount WHERE link = spc.link)
FROM dbo.ScheduledPaymentCount spc
WHERE link > 0 and AccountID in (select accountid from @AllAcounts)

--setting STATUS ON all accounts
UPDATE dbo.ScheduledPaymentCount
SET status = CASE WHEN ppa > 0 THEN 'PPA'
				  WHEN pdc > 0 THEN 'PDC'
				  WHEN pcc > 0 THEN 'PCC'
			ELSE NULL
			END
WHERE AccountID in (select accountid from @AllAcounts)

--Set qlevel on single accounts            
UPDATE dbo.ScheduledPaymentCount
SET qlevel = CASE WHEN status = 'PPA' THEN '820'
				  WHEN status = 'PDC' THEN '830'
				  WHEN status = 'PCC' THEN '840'
			ELSE NULL
			END
WHERE link <= 0 AND AccountID in (select accountid from @AllAcounts)

--set qlevel on linked accounts - driver
UPDATE dbo.ScheduledPaymentCount
SET qlevel = CASE WHEN status = 'PPA' THEN '820'
				  WHEN status = 'PDC' THEN '830'
				  WHEN status = 'PCC' THEN '840'
			ELSE NULL
			END
WHERE link > 0 AND linkdriver = 1 AND AccountID in (select accountid from @AllAcounts)

--set qlevel on linked accounts - follower
UPDATE dbo.ScheduledPaymentCount
SET qlevel = '875'
WHERE link > 0 AND linkdriver = 0 AND status IN ('PPA','PDC','PCC') AND AccountID in (select accountid from @AllAcounts);

--Exit without updating more accounts
GOTO EXIT_RefreshScheduledPaymentCount


--Refresh All Accounts
RefreshALLAccounts:
UPDATE spc 
	SET spc.link = m.link, spc.linkdriver = m.LinkDriver
	FROM dbo.ScheduledPaymentCount spc JOIN master m ON spc.AccountID = m.number
	
UPDATE dbo.ScheduledPaymentCount set ppa = 
     (select COUNT(acctid) FROM promises WHERE active = 1 AND duedate >= @CurrentDate AND promises.acctID = dbo.ScheduledPaymentCount.accountid)

update dbo.ScheduledPaymentCount set pdc = 
     (select COUNT(number) FROM pdc WHERE active = 1 AND deposit >= @CurrentDate AND pdc.number = ScheduledPaymentCount.accountid)

update dbo.ScheduledPaymentCount set pcc = 
     (select COUNT(number) FROM dbo.DebtorCreditCards  WHERE ISactive = 1 AND DepositDate >= @CurrentDate AND number = ScheduledPaymentCount.accountid)


--Spread linked payments accross all accounts
UPDATE spc SET ppa = (SELECT MAX(ppa) FROM dbo.ScheduledPaymentCount WHERE link = spc.link)
FROM dbo.ScheduledPaymentCount spc
WHERE link > 0

UPDATE spc SET pdc = (SELECT MAX(pdc) FROM dbo.ScheduledPaymentCount WHERE link = spc.link)
FROM dbo.ScheduledPaymentCount spc
WHERE link > 0

UPDATE spc SET pcc = (SELECT MAX(pcc) FROM dbo.ScheduledPaymentCount WHERE link = spc.link)
FROM dbo.ScheduledPaymentCount spc
WHERE link > 0


--setting STATUS ON all accounts
UPDATE dbo.ScheduledPaymentCount
SET status = CASE WHEN ppa > 0 THEN 'PPA'
				  WHEN pdc > 0 THEN 'PDC'
				  WHEN pcc > 0 THEN 'PCC'
			ELSE NULL
			END

--Set qlevel on single accounts            
UPDATE dbo.ScheduledPaymentCount
SET qlevel = CASE WHEN status = 'PPA' THEN '820'
				  WHEN status = 'PDC' THEN '830'
				  WHEN status = 'PCC' THEN '840'
			ELSE NULL
			END
WHERE link <= 0

--set qlevel on linked accounts - driver
UPDATE dbo.ScheduledPaymentCount
SET qlevel = CASE WHEN status = 'PPA' THEN '820'
				  WHEN status = 'PDC' THEN '830'
				  WHEN status = 'PCC' THEN '840'
			ELSE NULL
			END
WHERE link > 0 AND linkdriver = 1

--set qlevel on linked accounts - follower
UPDATE dbo.ScheduledPaymentCount
SET qlevel = '875'
WHERE link > 0 AND linkdriver = 0 AND status IN ('PPA','PDC','PCC')

			
EXIT_RefreshScheduledPaymentCount:
GO
