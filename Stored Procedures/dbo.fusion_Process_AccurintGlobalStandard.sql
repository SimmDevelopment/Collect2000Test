SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Name:		fusion_Process_AccurintGlobalStandard
-- Function:		This procedure will process returned Accurint Global Standard info
-- Creation:		05/14/2006 jc
--			Accurint Global Standard
--			
--			THIS IS CURRENTLY NOT USED, Services_Temp table required
--
-- Change History:	
/*
exec [fusion_Process_AccurintGlobalStandard] @requestid=1
*/
CREATE  proc [dbo].[fusion_Process_AccurintGlobalStandard]
	@RequestID int
AS
	DECLARE @DebtorID INTEGER, 
	@number int,
	@DebtorSeq INTEGER, @DebtorName VARCHAR(30), @customer VARCHAR(7), 
	@desk VARCHAR(10), @status varchar(5), @qlevel VARCHAR(3), 
	@IsPurchased BIT, @runDate DATETIME,@errorMessage varchar(8000)	

	set @errorMessage='Unknown error'

	IF(@requestid=null)
	BEGIN
		set @errorMessage='request id is null'
		GOTO ErrHandler
		return
	END

	select @number=AcctId from ServiceHistory where requestid=@requestid

	IF( @number=null )
	BEGIN
		set @errorMessage='Account id not found for request id [' + cast(@requestid as varchar(15)) + ']'
		GOTO ErrHandler
	END

	--assign @RequestID from Services_Temp
--	SELECT @RequestID = [Services_Temp].[RequestID] FROM [dbo].[Services_Temp] AS [Services_Temp]
--	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] ON  [ServiceHistory].[RequestID] = [Services_Temp].[RequestID]
--	WHERE [ServiceHistory].[AcctID] = @number
--	IF (@@ERROR != 0) GOTO ErrHandler

	--assign locals
	SET @runDate = GETDATE();

	SELECT 
		@DebtorID = [debtors].[debtorid], 
		@DebtorSeq = [debtors].[seq], 
		@DebtorName = ISNULL([debtors].[Name],'') 
	FROM [dbo].[debtors] AS [debtors] WITH(NOLOCK) 
	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] WITH(NOLOCK) ON [ServiceHistory].[debtorid] = [debtors].[debtorid]
	WHERE [ServiceHistory].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	SELECT 
		@customer = [master].[customer],  
		@desk = [master].[desk], 
		@qlevel = [master].[qlevel], 
		@status = [master].[status]
	FROM [dbo].[master] AS [master] WITH(NOLOCK) 
	WHERE [master].[number] = @number
	IF (@@ERROR != 0) GOTO ErrHandler

	SELECT 
		@IsPurchased = IsPrincipleCust 
	FROM [dbo].[Customer] AS [Customer] WITH(NOLOCK) 
	WHERE [Customer].[customer] = @customer
	IF (@@ERROR != 0) GOTO ErrHandler

	--insert service history response
	INSERT INTO [dbo].[ServiceHistory_RESPONSES] ([RequestID], [FileName], [DateReturned], [XmlInfoReturned])
	SELECT @RequestID, '', @runDate, [ServiceHistory].[XmlInfoReturned] FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestId] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

	--update service history 
	UPDATE [ServiceHistory]
		SET [ServiceHistory].[Processed] = 3
	FROM [dbo].[ServiceHistory] AS [ServiceHistory]
	WHERE [ServiceHistory].[RequestId] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--remove this requestid from Services_Temp
--	DELETE [Services_Temp] FROM [dbo].[Services_Temp] AS [Services_Temp] WHERE [Services_Temp].[RequestID] = @RequestID
--	IF (@@ERROR != 0) GOTO ErrHandler
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN

ErrHandler:
	RAISERROR('Error encountered in fusion_Process_AccurintGlobalStandard for account id %d. Message: ''%s''  fusion_Process_AccurintGlobalStandard failed.', 11, 1, @number,@errorMessage)
	RETURN
GO
