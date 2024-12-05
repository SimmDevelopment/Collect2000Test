SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*LetterSeries_InsertLetterRequests*/
CREATE Procedure [dbo].[LetterSeries_InsertLetterRequests]
	@LetterCount int Output

-- Name			:LetterSeries_InsertLetterRequests
-- Function		:Inserts letter request into letterrequest and recipient tables from the LtrSeriesQueue table
-- Used By      	:End of Day
-- Creation:     	:11/12/2004 jc
-- Change History	10/27/2005 jc changed insert into letterrequest to ensure letterid has not already been requested
--			using 
---                 3/20/2007.  if run prior to 5:00 pm assume current day for @loaddate otherwize user getdate+1 for @loaddate
---					1/29/2008.  added join to debtors to grab the right seq number for the letterrrequestrecipient insert
AS
BEGIN TRANSACTION

	-- declare variables used in error checking.
	DECLARE @error_var INT, @rowcount_var INT
	DECLARE @LoadDate DATETIME

	--assign date to local variable
	SET @LoadDate = case when datepart(hour,GETDATE()) < 17 then getdate() else getdate()+1 end
	--print convert(varchar,@Loaddate)
	SET @LetterCount = 0

	--insert letter requests
	INSERT INTO [dbo].[LetterRequest]
	(
		[AccountID], [CustomerCode], [LetterID], [LetterCode], [DateRequested], [DueDate], [AmountDue], 
		[UserName], [Suspend], [SifPmt1], [SifPmt2], [SifPmt3], [SifPmt4], [SifPmt5], [SifPmt6], 
		[CopyCustomer], [SaveImage], [ProcessingMethod], [DateCreated], [DateUpdated], [FutureID], 
		[SubjDebtorID], [SenderID], [RequesterID], [LtrSeriesQueueID]
	)
	SELECT [LtrSeriesQueue].[accountid], [customer].[customer], [letter].[letterid], [letter].[code], 
	@LoadDate, @LoadDate, [master].[current0], 'Global', 0, 0, 0, 0, 0, 0, 0, [CustLtrAllow].[CopyCustomer], 
	[CustLtrAllow].[SaveImage], 0, @LoadDate, @LoadDate, 0, [LtrSeriesQueue].[primarydebtorid], NULL, 0, 
	[LtrSeriesQueue].[LtrSeriesQueueid]
	FROM [dbo].[LtrSeriesQueue] AS [LtrSeriesQueue] WITH(NOLOCK) 
	INNER JOIN [dbo].[master] AS [master] WITH(NOLOCK) ON [master].[number] = [LtrSeriesQueue].[accountid]
	INNER JOIN [dbo].[debtors] AS [debtors] WITH(NOLOCK) ON [debtors].[debtorid] = [LtrSeriesQueue].[debtorid]
 	INNER JOIN [dbo].[customer] AS [customer] WITH(NOLOCK) ON [customer].[customer] = [master].[customer]
	INNER JOIN [dbo].[LtrSeriesConfig] AS [LtrSeriesConfig] WITH(NOLOCK) ON [LtrSeriesConfig].[ltrseriesconfigid] = [LtrSeriesQueue].[LtrSeriesConfigID]
	INNER JOIN [dbo].[LtrSeries] AS [LtrSeries] WITH(NOLOCK) ON [LtrSeries].[ltrseriesid] = [LtrSeriesConfig].[LtrSeriesid]
	INNER JOIN [dbo].[letter] AS [letter] WITH(NOLOCK) ON [letter].[letterid] = [LtrSeriesConfig].[letterid]
	INNER JOIN [dbo].[CustLtrAllow] AS [CustLtrAllow] WITH(NOLOCK) ON [CustLtrAllow].[CustCode] = [master].[customer] AND [CustLtrAllow].LtrCode = [letter].[code]
	WHERE [LtrSeriesQueue].[datetorequest] <= @LoadDate
	AND [master].[current0] BETWEEN [LtrSeries].[MinBalance] AND [LtrSeries].[MaxBalance]
	AND [letter].[letterid] NOT IN 
	(
		SELECT [LetterRequest].[LetterID] 
		FROM [dbo].[LetterRequest] AS [LetterRequest] 
		WHERE [LetterRequest].[AccountID] = [LtrSeriesQueue].[accountid] 
		AND [LetterRequest].[SubjDebtorID] = [LtrSeriesQueue].[primarydebtorid]
	)

	-- Save the @@ERROR and @@ROWCOUNT values in local 
	-- variables before they are cleared.
	SELECT @error_var = @@error, @rowcount_var = @@rowcount
	if (@error_var != 0) goto ErrHandler
	else if @rowcount_var <= 0 goto cuExit

	SET @LetterCount = ISNULL(@rowcount_var, 0)

	--insert letter request recipients
	INSERT INTO [dbo].[LetterRequestRecipient]
	(
		[LetterRequestID], [AccountID], [Seq], [DebtorID]
	)
	SELECT  [LetterRequest].[letterrequestid], [LtrSeriesQueue].[accountid], [debtors].[seq], [LtrSeriesQueue].[debtorid] 
	FROM [dbo].[LtrSeriesQueue] AS [LtrSeriesQueue]
	INNER JOIN [dbo].[LetterRequest] AS [LetterRequest] ON [LetterRequest].[LtrSeriesQueueID] = [LtrSeriesQueue].[LtrSeriesQueueID]
	INNER JOIN [dbo].[debtors] as [debtors] ON [LtrSeriesQueue].[debtorid] = [debtors].[debtorid]
	WHERE [LetterRequest].[letterrequestid] NOT IN (SELECT [LetterRequestRecipient].[letterrequestid] FROM [dbo].[LetterRequestRecipient] AS [LetterRequestRecipient])

	-- Save the @@ERROR and @@ROWCOUNT values in local 
	-- variables before they are cleared.
	SELECT @error_var = @@error, @rowcount_var = @@rowcount
	if (@error_var != 0) goto ErrHandler
	else if @rowcount_var <= 0 goto cuExit	

	--delete ltr series queue 
	DELETE [ltrseriesqueue] FROM [dbo].[ltrseriesqueue] AS [ltrseriesqueue] WHERE [ltrseriesqueue].[datetorequest] <= @LoadDate

	-- Save the @@ERROR and @@ROWCOUNT values in local 
	-- variables before they are cleared.
	SELECT @error_var = @@error, @rowcount_var = @@rowcount
	if (@error_var != 0) goto ErrHandler
	else if @rowcount_var <= 0 goto cuExit	
	COMMIT TRANSACTION		
	Return(0)	

cuExit:
	ROLLBACK TRANSACTION
	SET @LetterCount = ISNULL(@rowcount_var, 0)
	Return(0)
	
ErrHandler:
	RAISERROR ('20000',16,1,'Error encountered in LetterSeries_InsertLetterRequests.')
	ROLLBACK TRANSACTION
	Return(1)
GO
