SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.fusion_Process_TransUnionCPE*/
CREATE  proc [dbo].[fusion_Process_TransUnionCPE]
	@number int
AS
-- Name:		fusion_Process_TransUnionCPE
-- Function:		This procedure will process returned TransUnion CPE info
-- Creation:		05/14/2006 jc
--			TransUnion CPE
--			
--			THIS IS CURRENTLY NOT USED, Services_Temp table required
--
-- Change History:	
	DECLARE @RequestID INTEGER, @DebtorID INTEGER, 
	@DebtorSeq INTEGER, @DebtorName VARCHAR(30), @customer VARCHAR(7), 
	@desk VARCHAR(10), @status varchar(5), @qlevel VARCHAR(3), 
	@IsPurchased BIT, @runDate DATETIME

	--assign @RequestID from Services_Temp
	SELECT @RequestID = [Services_Temp].[RequestID] FROM [dbo].[Services_Temp] AS [Services_Temp]
	INNER JOIN [dbo].[ServiceHistory] AS [ServiceHistory] ON  [ServiceHistory].[RequestID] = [Services_Temp].[RequestID]
	WHERE [ServiceHistory].[AcctID] = @number
	IF (@@ERROR != 0) GOTO ErrHandler

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
	DELETE [Services_Temp] FROM [dbo].[Services_Temp] AS [Services_Temp] WHERE [Services_Temp].[RequestID] = @RequestID
	IF (@@ERROR != 0) GOTO ErrHandler
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

cuExit:
	IF (@@ERROR != 0) GOTO ErrHandler
	RETURN

ErrHandler:
	RAISERROR('Error encountered in fusion_Process_TransUnionCPE for account id %d.  fusion_Process_TransUnionCPE failed.', 11, 1, @number)
	RETURN
GO
