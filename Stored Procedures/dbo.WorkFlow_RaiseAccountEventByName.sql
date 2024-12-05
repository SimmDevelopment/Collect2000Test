SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_RaiseAccountEventByName] @AccountID INTEGER, @EventName NVARCHAR(100), @CreateNew BIT = 0, @EventVariable SQL_VARIANT = NULL
AS
SET NOCOUNT ON;

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
	INSERT INTO [dbo].[WorkFlow_EventQueue] ([AccountID], [EventID], [EventVariable])
	VALUES (@AccountID, @EventID, @EventVariable);
END;

RETURN 0;
GO
