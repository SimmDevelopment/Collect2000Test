SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.ins_TransUnionHardCopy*/
CREATE PROCEDURE [dbo].[ins_TransUnionHardCopy]
@Number INT,
@HardCopyData TEXT, 
@FutureID INT,
@DebtorID INT,
@ReportName VARCHAR(255),
@UserName VARCHAR(50),
@ErrorXml TEXT = NULL
AS
-- Name:		ins_TransUnionHardCopy
-- Function:		This procedure processes returned TransUnion Net Access responses.
-- Creation:		12/19/2005 jc
--			Used by TunaWizard version 1.2
-- Change History:	
--			02/20/2006 jc modified to support exception handling with log file.
--			03/16/2005 jc modified to always delete future record instead of success only 

BEGIN TRANSACTION
	SET NOCOUNT ON
	-- declare variables used
	DECLARE @currentDateTime DATETIME
	DECLARE @currentDate DATETIME
	DECLARE @SysMonth INT
	DECLARE @SysYear INT
	DECLARE @ptrval BINARY(16) 
	DECLARE @len INT 
	DECLARE @debtorName VARCHAR(50)
	DECLARE @branch VARCHAR(5)

	DECLARE @idoc INT
	DECLARE @errorCode VARCHAR(10)
	DECLARE @errorText VARCHAR(80)

	--assign date to local variable
	SET @currentDateTime = GETDATE();
	SET @currentDate = CAST(CONVERT(CHAR(20), GETDATE(), 111) AS DATETIME);

	--assign control file variables
	SELECT @SysMonth = [ControlFile].[CurrentMonth], @SysYear = [ControlFile].[CurrentYear] 
	FROM [dbo].[ControlFile] AS [ControlFile] WITH(NOLOCK)
	if (@@error != 0) goto ErrHandler

	--assign account variables
	SELECT @branch = [master].[branch] FROM [dbo].[master] AS [master] WITH(NOLOCK)
	WHERE [master].[number] = @Number
	if (@@error != 0) goto ErrHandler

	--assign debtor variables
	SELECT @debtorName = [debtors].[name] FROM [dbo].[debtors] AS [debtors] WITH(NOLOCK)
	WHERE [debtors].[debtorID] = @DebtorID
	if (@@error != 0) goto ErrHandler

	--update qlevel
	UPDATE [master] 
	SET [master].[qlevel] = '200' 
	FROM [dbo].[master] AS [master]
	WHERE [master].[number] = @Number
	if (@@error != 0) goto ErrHandler

	IF @ErrorXml IS NOT NULL BEGIN

		-- Create an internal representation of the XML document.
		exec sp_xml_preparedocument @idoc output, @ErrorXml
		if (@@error != 0) goto ErrHandler

		--extract error code and description from error xml
		select @errorCode = ISNULL(ErrorCodeNumber, 'Unknown'), @errorText = ISNULL(ErrorDescription, '')
		from openxml (@idoc, '/error/ERRT', 3)
		with (ErrorCodeNumber varchar(10), ErrorDescription varchar(80))
		if (@@error != 0) goto ErrHandler

		IF @errorCode IS NULL OR LEN(@errorCode) = 0 BEGIN
			SET @errorCode = 'Unknown'
			SET @errorText = ''
		END

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@Number, @currentDateTime, @UserName,'+++++','+++++', @ReportName + ' Debtor(' + @debtorName + ') [ERROR CODE ' + @errorCode + ': ' + @errorText + ']' )
		if (@@error != 0) goto ErrHandler

		-- Remove the document from memory
		exec sp_xml_removedocument @idoc
		if (@@error != 0) goto ErrHandler
	END
	ELSE BEGIN
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@Number, @currentDateTime, @UserName,'+++++','+++++', @ReportName + ' Received: Debtor(' + @debtorName + ')')
		if (@@error != 0) goto ErrHandler

		--update hardcopy stats
		IF LEN(@branch) > 0 BEGIN
			--determine whether a HardCopyStats record exists for this account. 
			--insert a new HardCopyStats record if one does not exist otherwise update the
			--existing HardCopyStats record
			IF (SELECT COUNT(*) FROM [dbo].[HardCopyStats] AS [HardCopyStats] WITH(NOLOCK) 
				WHERE [HardCopyStats].[SystemYear] = @SysYear
				AND [HardCopyStats].[SystemMonth] = @SysMonth
				AND [HardCopyStats].[Branch] = @branch
				AND [HardCopyStats].[ProcessedDate] = @currentDate ) = 0 BEGIN 
				if (@@error != 0) goto ErrHandler	
			
				INSERT INTO [dbo].[HardCopyStats] (Branch, SystemMonth, SystemYear, ProcessedCount, ProcessedDate)
				VALUES(@branch, @SysMonth, @SysYear, 1, @currentDate )
				if (@@error != 0) goto ErrHandler
			END
			ELSE BEGIN
				UPDATE [HardCopyStats]
		               	SET [HardCopyStats].[ProcessedCount] = [HardCopyStats].[ProcessedCount] + 1
				FROM [dbo].[HardCopyStats] AS [HardCopyStats]
				WHERE [HardCopyStats].[SystemYear] = @SysYear
				AND [HardCopyStats].[SystemMonth] = @SysMonth
				AND [HardCopyStats].[Branch] = @branch
				AND [HardCopyStats].[ProcessedDate] = @currentDate
				if (@@error != 0) goto ErrHandler
			END
		END
	END	
	
	--determine whether a current hardcopy record exists for this account. 
	--insert a new hardcopy record if one does not exist otherwise append to the
	--existing hardcopy record
	IF (SELECT COUNT(*) FROM [dbo].[HardCopy] AS [HardCopy] WITH(NOLOCK) 
		WHERE [HardCopy].[number] = @Number) = 0 BEGIN 
		if (@@error != 0) goto ErrHandler	
	
		INSERT INTO [dbo].[HardCopy] (Number, CTL, HardCopyType, HardCopyData)
		VALUES(@Number, 'CTL', '1', @HardCopyData)
		if (@@error != 0) goto ErrHandler
	END
	ELSE BEGIN
		IF (SELECT DATALENGTH([HardCopy].[HardCopyData]) FROM [dbo].[HardCopy] AS [HardCopy] WITH(NOLOCK) 
			WHERE number = @Number) = 0 BEGIN 
			if (@@error != 0) goto ErrHandler
	
			UPDATE [HardCopy]
	               	SET [HardCopy].[HardCopyData] = @HardCopyData 
			FROM [dbo].[HardCopy] AS [HardCopy]
			WHERE [HardCopy].[number] = @Number
			if (@@error != 0) goto ErrHandler
		END
		ELSE BEGIN
			SELECT @len = DATALENGTH([HardCopy].[HardCopyData]) 
		   	FROM [dbo].[HardCopy] AS [HardCopy] WITH(NOLOCK) 
	      		WHERE [HardCopy].[number] = @Number 
			if (@@error != 0) goto ErrHandler
	
			SELECT @ptrval = TEXTPTR([HardCopy].[HardCopyData]) 
	   		FROM [dbo].[HardCopy] AS [HardCopy] WITH(NOLOCK) 
		      	WHERE [HardCopy].[number] = @Number
			if (@@error != 0) goto ErrHandler	

			--UPDATETEXT [HardCopy].[HardCopyData] @ptrval @len 0 @HardCopyData 
			--this will prepend new data as opposed to appending new data to the end
			UPDATETEXT [HardCopy].[HardCopyData] @ptrval 0 0 @HardCopyData 
			if (@@error != 0) goto ErrHandler
		END	
	END
	
	--delete future table record
	DELETE [Future] FROM [dbo].[Future] AS [Future] WHERE [Future].[uid] = @FutureID
	if (@@error != 0) goto ErrHandler

	SET NOCOUNT OFF

	COMMIT TRANSACTION		
	RETURN(0)	

ErrHandler:
	RAISERROR ('20000',16,1,'Error encountered in ins_TransUnionHardCopy.')
	SET NOCOUNT OFF
	ROLLBACK TRANSACTION
	RETURN(1)
GO
