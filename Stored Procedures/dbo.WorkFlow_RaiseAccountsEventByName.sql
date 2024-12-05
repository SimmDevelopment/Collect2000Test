SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName NVARCHAR(100), @CreateNew BIT = 0
AS
SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#EventAccounts') IS NULL BEGIN
	RAISERROR('Temporary table #EventAccounts not defined.', 16, 1);
	RETURN 1;
END;

DECLARE @EventID UNIQUEIDENTIFIER;

SELECT @EventID = [ID]
FROM [dbo].[WorkFlow_Events]
WHERE [Name] = @EventName;

IF @@ROWCOUNT = 0 BEGIN
	IF @CreateNew = 0 BEGIN
		RETURN 0;
	END;

	SET @EventID = NEWID();

	INSERT INTO [dbo].[WorkFlow_Events] ([ID], [Name], [SystemEvent], [MinimumDays], [MaximumDays])
	VALUES (@EventID, @EventName, 1, 0, 0);
END;

IF EXISTS (SELECT * FROM [dbo].[WorkFlow_EventConfiguration]) BEGIN
	INSERT INTO [dbo].[WorkFlow_EventQueue] ([EventID], [AccountID], [EventVariable])
	SELECT @EventID, [AccountID], [EventVariable]
	FROM #EventAccounts;
END;

RETURN 0;
GO
