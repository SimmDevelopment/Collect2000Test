SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_RaiseAccountsEventByID] @EventID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM [dbo].[WorkFlow_Events] WHERE [ID] = @EventID) BEGIN
	RAISERROR('Event not found.', 16, 1);
	RETURN 1;
END;

IF OBJECT_ID('tempdb..#EventAccounts') IS NULL BEGIN
	RAISERROR('Temporary table #EventAccounts not defined.', 16, 1);
	RETURN 1;
END;

IF EXISTS (SELECT * FROM [dbo].[WorkFlow_EventConfiguration]) BEGIN
	INSERT INTO [dbo].[WorkFlow_EventQueue] ([EventID], [AccountID], [EventVariable])
	SELECT @EventID, [AccountID], [EventVariable]
	FROM #EventAccounts;
END;

RETURN 0;
GO
