SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE    PROCEDURE [dbo].[SelectReminders] @UserID INTEGER, @DeskCode VARCHAR(10) = NULL, @DueDate DATETIME = NULL
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @UserDeskCode VARCHAR(10);

IF @DeskCode = '' SET @DeskCode = NULL;
IF @DueDate IS NULL SET @DueDate = GETUTCDATE();

SELECT @UserDeskCode = [Users].[DeskCode]
FROM [dbo].[Users]
INNER JOIN [dbo].[desk]
ON [Users].[DeskCode] = [desk].[code]
WHERE [Users].[ID] = @UserID
AND [Users].[Active] = 1
AND [desk].[code] <> '';

IF @DeskCode IS NULL AND @UserDeskCode IS NULL BEGIN
	-- Return an empty recordset
	SELECT TOP 0 CAST(NULL AS INTEGER) AS [number], CAST(NULL AS VARCHAR(50)) AS [name], CAST(NULL AS VARCHAR(50)) AS [CustomerName], CAST(NULL AS MONEY) AS [current0], CAST(NULL AS DATETIME) AS [Due], CAST(NULL AS VARCHAR(10)) AS [Desk] 
	FROM [dbo].[master];

	RETURN 1;
END;

SET @DeskCode = ISNULL(@DeskCode, @UserDeskCode);
SET @UserDeskCode = ISNULL(@UserDeskCode, @DeskCode);

SELECT [Reminders].[number], [Reminders].[name], [Reminders].[CustomerName], [Reminders].[current0], MIN([Reminders].[Due]) AS [Due], MIN([Reminders].[Desk]) AS [Desk] 
FROM (
	-- Select accounts with reminders set to the specific desk
	SELECT [master].[number], [master].[name], [customer].[name] AS [CustomerName], [master].[current0], [Reminders].[Due], [Reminders].[Desk]
	FROM [dbo].[master]
	INNER JOIN [dbo].[Reminders]
	ON [master].[number] = [Reminders].[AccountID]
	INNER JOIN [dbo].[customer]
	ON [master].[customer] = [customer].[customer]
	WHERE [master].[qlevel] NOT IN ('998', '999')
	AND [Reminders].[Desk] IN (@DeskCode, @UserDeskCode)
	AND [Reminders].[ReminderDate] <= @DueDate
	AND [Reminders].[FollowAccountDesk] = 0
	UNION
	-- Select accounts with reminders set to follow the accounts' desks
	SELECT [master].[number], [master].[name], [customer].[name] AS [CustomerName], [master].[current0], [Reminders].[Due], [Reminders].[Desk]
	FROM [dbo].[master]
	INNER JOIN [dbo].[Reminders]
	ON [master].[number] = [Reminders].[AccountID]
	INNER JOIN [dbo].[customer]
	ON [master].[customer] = [customer].[customer]
	WHERE [master].[qlevel] NOT IN ('998', '999')
	AND [Reminders].[FollowAccountDesk] = 1
	AND [master].[desk] IN (@DeskCode, @UserDeskCode)
	AND [Reminders].[ReminderDate] <= @DueDate
) AS [Reminders]	
GROUP BY [number], [name], [CustomerName], [current0]
ORDER BY [Due] ASC;

RETURN 0;











GO
