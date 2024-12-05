SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_SetReminder] @ReminderDays SMALLINT, @TimeOfDay DATETIME, @DeskType TINYINT, @Desk VARCHAR(10)
AS
SET NOCOUNT ON;

DECLARE @DueDate DATETIME;
DECLARE @Follow BIT;

SET @DueDate = DATEADD(DAY, @ReminderDays, { fn CURDATE() })
SET @DueDate = DATEADD(HOUR, DATEPART(HOUR, @TimeOfDay), @DueDate);
SET @DueDate = DATEADD(MINUTE, DATEPART(MINUTE, @TimeOfDay), @DueDate);

SET @Follow = 0;

IF @DeskType = 1
	UPDATE #WorkFlowAcct
	SET [ActivityVariable] = [Users].[DeskCode]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master]
	ON [WorkFlowAcct].[AccountID] = [master].[number]
	INNER JOIN [dbo].[desk]
	ON [master].[desk] = [desk].[code]
	INNER JOIN [dbo].[Teams]
	ON [desk].[TeamID] = [Teams].[ID]
	INNER JOIN [dbo].[Users]
	ON [Teams].[SupervisorID] = [Users].[ID];
ELSE IF @DeskType = 2
	UPDATE #WorkFlowAcct
	SET [ActivityVariable] = [Users].[DeskCode]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master]
	ON [WorkFlowAcct].[AccountID] = [master].[number]
	INNER JOIN [dbo].[desk]
	ON [master].[desk] = [desk].[code]
	INNER JOIN [dbo].[Teams]
	ON [desk].[TeamID] = [Teams].[ID]
	INNER JOIN [dbo].[Departments]
	ON [Teams].[DepartmentID] = [Departments].[ID]
	INNER JOIN [dbo].[Users]
	ON [Departments].[ManagerID] = [Users].[ID];
ELSE IF @DeskType = 3
	UPDATE #WorkFlowAcct
	SET [ActivityVariable] = @Desk;
ELSE BEGIN
	UPDATE #WorkFlowAcct
	SET [ActivityVariable] = [master].[desk]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN [dbo].[master]
	ON [WorkFlowAcct].[AccountID] = [master].[number];

	SET @Follow = 1;
END;

UPDATE #WorkFlowAcct
SET [Comment] = 'Reminder set for desk "' + CAST([ActivityVariable] AS VARCHAR(50)) + '" on "' + CONVERT(VARCHAR(50), @DueDate, 101) + '"'
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
INNER JOIN [dbo].[desk]
ON [WorkFlowAcct].[ActivityVariable] = [desk].[code]
LEFT OUTER JOIN [dbo].[Reminders]
ON [Reminders].[AccountID] = [WorkFlowAcct].[AccountID]
AND [Reminders].[Desk] = [desk].[code]
WHERE [Reminders].[AccountID] IS NULL;

INSERT INTO [dbo].[Reminders] ([Desk], [AccountID], [Due], [ReminderDate], [FollowAccountDesk])
SELECT DISTINCT [desk].[code], [WorkFlowAcct].[AccountID], @DueDate, @DueDate, @Follow
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[master]
ON [WorkFlowAcct].[AccountID] = [master].[number]
INNER JOIN [dbo].[desk]
ON [WorkFlowAcct].[ActivityVariable] = [desk].[code]
LEFT OUTER JOIN [dbo].[Reminders]
ON [Reminders].[AccountID] = [WorkFlowAcct].[AccountID]
AND [Reminders].[Desk] = [desk].[code]
WHERE [Reminders].[AccountID] IS NULL;

RETURN 0;
GO
