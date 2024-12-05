SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_RaiseAccountEventByID] @AccountID INTEGER, @EventID UNIQUEIDENTIFIER, @EventVariable SQL_VARIANT = NULL
AS
SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM [dbo].[WorkFlow_Events] WHERE [ID] = @EventID) BEGIN
	RAISERROR('Event not found.', 16, 1);
	RETURN 1;
END;

IF EXISTS (SELECT * FROM [dbo].[WorkFlow_EventConfiguration]) BEGIN
	INSERT INTO [dbo].[WorkFlow_EventQueue] ([AccountID], [EventID], [EventVariable])
	VALUES (@AccountID, @EventID, @EventVariable);
END;

RETURN 0;
GO
