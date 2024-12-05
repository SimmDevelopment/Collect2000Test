SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WorkFlow_Update_SIF_Payments_For_SIF_Letters]
	-- Add the parameters for the stored procedure here
	--@acctID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @acctID INT
	DECLARE cur CURSOR FOR
	
		SELECT [AccountID] 
		FROM #WorkFlowAcct
	
	OPEN cur
fetch from cur into @acctID
while @@fetch_status = 0 BEGIN

	IF EXISTS (SELECT * FROM promises WITH (NOLOCK) WHERE AcctID = @acctID AND CONVERT(varchar(8), entered, 101) = CONVERT(varchar(8), DATEADD(dd, 0, GETDATE()), 101))
		BEGIN
			UPDATE LetterRequest
			SET AmountDue = (SELECT SUM(amount) FROM promises WITH (NOLOCK) WHERE AcctID = lr.accountid	AND Active = 1),
			SifPmt1 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid order by DueDate), ''),
			SifPmt2 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 1 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt3 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 2 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt4 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 3 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt5 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 4 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt6 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 5 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			Sifpmt7 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 6 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt8 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 7 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt9 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 8 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt10 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 9 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt11 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 10 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt12 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 11 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt13 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 12 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt14 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 13 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt15 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 14 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt16 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 15 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt17 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 16 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt18 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 17 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt19 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 18 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt20 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 19 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt21 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 20 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt22 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 21 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt23 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 22 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), ''),
			SifPmt24 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DueDate, 101) from promises with (nolock) where AcctID = lr.accountid AND DueDate NOT IN (select top 23 DueDate from promises with (nolock) where AcctID = lr.accountid order by DueDate)), '')	
			from LetterRequest lr WITH (NOLOCK)
			where lr.AccountID = @acctID AND lettercode LIKE '%ca%' AND DateProcessed = '1753-01-01 12:00:00.000'
			AND CONVERT(varchar(8), DateRequested, 101) = CONVERT(varchar(8), GETDATE(), 101) AND Deleted = 0
			AND LetterRequestID = lr.LetterRequestID

		END
	ELSE
		BEGIN
			IF EXISTS (SELECT * FROM pdc p WITH (NOLOCK) WHERE number = @acctID AND Active = 1 AND CONVERT(varchar(8), DateCreated, 101) = CONVERT(varchar(8), DATEADD(dd, 0, GETDATE()), 101))

			UPDATE LetterRequest
			SET AmountDue = (SELECT SUM(amount) FROM pdc WITH (NOLOCK) WHERE number = lr.accountid	AND Active = 1),
			SifPmt1 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 order by DueDate), ''),
			SifPmt2 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 1 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt3 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 2 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt4 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 3 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt5 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 4 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt6 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 5 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt7 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 6 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt8 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 7 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt9 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 8 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt10 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 9 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt11 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 10 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt12 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 11 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt13 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 12 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt14 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 13 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt15 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 14 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt16 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 15 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt17 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 16 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt18 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 17 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt19 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 18 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt20 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 19 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt21 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 20 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt22 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 21 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt23 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 22 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), ''),
			SifPmt24 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), deposit, 101) from pdc with (nolock) where number = lr.accountid AND Active = 1 AND deposit NOT IN (select top 23 deposit from pdc with (nolock) where number = lr.accountid AND Active = 1 order by deposit)), '')
			from LetterRequest lr WITH (NOLOCK)
			where lr.AccountID = @acctID AND lettercode LIKE '%ca%' AND DateProcessed = '1753-01-01 12:00:00.000'
			AND CONVERT(varchar(8), DateRequested, 101) = CONVERT(varchar(8), GETDATE(), 101) AND Deleted = 0
			AND LetterRequestID = lr.LetterRequestID
			
		ELSE
		
			UPDATE LetterRequest
			SET AmountDue = (SELECT SUM(Amount) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = lr.accountid AND IsActive = 1),
			SifPmt1 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate), ''),
			SifPmt2 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 1 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt3 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 2 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt4 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 3 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt5 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 4 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt6 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 5 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt7 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 6 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt8 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 7 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt9 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 8 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt10 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 9 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt11 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 10 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt12 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 11 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt13 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 12 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt14 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 13 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt15 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 14 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt16 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 15 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt17 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 16 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt18 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 17 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt19 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 18 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt20 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 19 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt21 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 20 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt22 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 21 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt23 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 22 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), ''),
			SifPmt24 = isnull((select top 1 '$' + CAST(Amount AS VARCHAR(12)) + ' due by ' + CONVERT(varchar(10), DepositDate, 101) from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 AND DepositDate NOT IN (select top 23 DepositDate from DebtorCreditCards with (nolock) where number = lr.accountid AND IsActive = 1 order by DepositDate)), '')		
			from LetterRequest lr WITH (NOLOCK)
			where lr.AccountID = @acctID AND lettercode LIKE '%ca%' AND DateProcessed = '1753-01-01 12:00:00.000'
			AND CONVERT(varchar(8), DateRequested, 101) = CONVERT(varchar(8), GETDATE(), 101) AND Deleted = 0
			AND LetterRequestID = lr.LetterRequestID
			
	END
END

fetch from cur into @acctID

END

--close and free up all the resources.
close cur
deallocate cur
GO
