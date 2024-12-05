SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_RequestService] @ActivityID UNIQUEIDENTIFIER, @AllowOnPrevReqAccounts BIT, @IncludeCodebtors BIT, @PackageID INTEGER, @WaitForResponse BIT, @MaximumHoldTime INTEGER
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @ServiceID INT;
DECLARE @PackageName VARCHAR(200);
DECLARE @Now DATETIME;

IF @PackageID IS NULL BEGIN
	RAISERROR('@PackageID cannot be NULL.', 16, 1);
	RETURN 0;
END;

SELECT @PackageName = [Name], @ServiceID = [ServiceID]
FROM [dbo].[Fusion_Packages]
WHERE [ID] = @PackageID;

IF @PackageName IS NULL BEGIN
	RAISERROR('@PackageID %d is not a valid package.', 16, 1, @PackageID);
	RETURN 0;
END;

SET @Now = GETDATE();

DECLARE @Requests TABLE (
	[ExecID] UNIQUEIDENTIFIER NOT NULL,
	[AccountID] INTEGER NOT NULL,
	[RequestID] INTEGER NULL,
	[AlreadyRequested] BIT NOT NULL DEFAULT(0),
	[Processed] BIT NOT NULL DEFAULT(0),
	[Expired] BIT NOT NULL DEFAULT(0),
	[Wait] BIT NOT NULL DEFAULT(1),
	[Comment] VARCHAR(250) NULL
);

INSERT INTO @Requests ([ExecID], [AccountID], [RequestID])
SELECT [ExecID],
	[AccountID],
	CASE
		WHEN [WorkFlowAcct].[ActivityVariable] IS NOT NULL AND SQL_VARIANT_PROPERTY([WorkFlowAcct].[ActivityVariable], 'BaseType') = 'int'
		THEN CAST([WorkFlowAcct].[ActivityVariable] AS INTEGER)
		ELSE NULL
	END AS [RequestID]
FROM #WorkFlowAcct AS [WorkFlowAcct];

UPDATE [Requests]
SET [Processed] = 1,
	[Wait] = 0,
	[Comment] = 'Response recieved for service request for package ' + @PackageName + '.'
FROM @Requests AS [Requests]
INNER JOIN [dbo].[ServiceHistory]
ON [Requests].[RequestID] = [ServiceHistory].[RequestID]
WHERE [Requests].[RequestID] IS NOT NULL
AND [ServiceHistory].[Processed] >= 4;

UPDATE [Requests]
SET [Expired] = 1,
	[Wait] = 0,
	[Comment] = 'Request has exceeded maximum wait time for package ' + @PackageName + '.'
FROM @Requests AS [Requests]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [Requests].[ExecID] = [WorkFlowExec].[ExecID]
INNER JOIN [dbo].[ServiceHistory]
ON [Requests].[RequestID] = [ServiceHistory].[RequestID]
WHERE [Requests].[RequestID] IS NOT NULL
AND [Requests].[Comment] IS NULL
AND [ServiceHistory].[CreationDate] <= DATEADD(MINUTE, -COALESCE(@MaximumHoldTime, 0), GETDATE());

UPDATE [Requests]
SET [Expired] = 1,
	[Wait] = 0,
	[Comment] = 'Request has been manually deleted for package ' + @PackageName + '.'
FROM @Requests AS [Requests]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [Requests].[ExecID] = [WorkFlowExec].[ExecID]
LEFT OUTER JOIN [dbo].[ServiceHistory]
ON [Requests].[RequestID] = [ServiceHistory].[RequestID]
WHERE [Requests].[RequestID] IS NOT NULL
AND [Requests].[Comment] IS NULL
AND [ServiceHistory].[RequestID] IS NULL;

IF @AllowOnPrevReqAccounts = 1 BEGIN
	IF @IncludeCoDebtors = 1 BEGIN
		INSERT INTO [dbo].[ServiceHistory] ([AcctID], [DebtorID], [Processed], [CreationDate], [PackageID], [ServiceID], [RequestedBy], [RequestedProgram])
		SELECT [Debtors].[Number], [Debtors].[DebtorID], 0, @Now, @PackageID, @ServiceID, 'WorkFlow', 'WorkFlow'
		FROM @Requests AS [Requests]
		INNER JOIN [dbo].[Debtors]
		ON [Requests].[AccountID] = [Debtors].[Number]
		WHERE [Requests].[RequestID] IS NULL
		AND [Debtors].[Responsible] = 1;
	END;
	ELSE BEGIN
		INSERT INTO [dbo].[ServiceHistory] ([AcctID], [DebtorID], [Processed], [CreationDate], [PackageID], [ServiceID],  [RequestedBy], [RequestedProgram])
		SELECT [Debtors].[Number], [Debtors].[DebtorID], 0, @Now, @PackageID, @ServiceID, 'WorkFlow', 'WorkFlow'
		FROM @Requests AS [Requests]
		INNER JOIN [dbo].[master]
		ON [Requests].[AccountID] = [master].[number]
		INNER JOIN [dbo].[Debtors]
		ON [Requests].[AccountID] = [Debtors].[Number]
		WHERE [Requests].[RequestID] IS NULL
		AND [Debtors].[Responsible] = 1
		AND [Debtors].[Seq] = [master].[PSeq];
	END;
END;
ELSE BEGIN
	UPDATE [Requests]
	SET [AlreadyRequested] = 1,
		[Wait] = 0,
		[Comment] = 'Request for package ' + @PackageName + ' has already been made on this account.'
	FROM @Requests AS [Requests]
	WHERE [Requests].[RequestID] IS NULL
	AND EXISTS (
		SELECT *
		FROM [dbo].[ServiceHistory]
		WHERE [ServiceHistory].[AcctID] = [Requests].[AccountID]
		AND [ServiceHistory].[PackageID] = @PackageID
	);

	IF @IncludeCoDebtors = 1 BEGIN
		INSERT INTO [dbo].[ServiceHistory] ([AcctID], [DebtorID], [Processed], [CreationDate], [PackageID], [ServiceID], [RequestedBy], [RequestedProgram])
		SELECT [Debtors].[Number], [Debtors].[DebtorID], 0, @Now, @PackageID, @ServiceID, 'WorkFlow', 'WorkFlow' 
		FROM @Requests AS [Requests]
		INNER JOIN [dbo].[Debtors]
		ON [Requests].[AccountID] = [Debtors].[Number]
		WHERE [Requests].[RequestID] IS NULL
		AND [Debtors].[Responsible] = 1
		AND [Requests].[AlreadyRequested] = 0;
	END;
	ELSE BEGIN
		INSERT INTO [dbo].[ServiceHistory] ([AcctID], [DebtorID], [Processed], [CreationDate], [PackageID], [ServiceID], [RequestedBy], [RequestedProgram])
		SELECT [Debtors].[Number], [Debtors].[DebtorID], 0, @Now, @PackageID, @ServiceID, 'WorkFlow', 'WorkFlow'
		FROM @Requests AS [Requests]
		INNER JOIN [dbo].[master]
		ON [Requests].[AccountID] = [master].[number]
		INNER JOIN [dbo].[Debtors]
		ON [Requests].[AccountID] = [Debtors].[Number]
		WHERE [Requests].[RequestID] IS NULL
		AND [Debtors].[Responsible] = 1
		AND [Debtors].[Seq] = [master].[PSeq]
		AND [Requests].[AlreadyRequested] = 0;
	END;
END;

UPDATE [Requests]
SET [RequestID] = [ServiceHistory].[RequestID],
	[Comment] = 'Request for service entered on package ' + @PackageName + '.'
FROM @Requests AS [Requests]
INNER JOIN [dbo].[ServiceHistory]
ON [Requests].[AccountID] = [ServiceHistory].[AcctID]
WHERE [Requests].[RequestID] IS NULL
AND [ServiceHistory].[PackageID] = @PackageID
AND [ServiceHistory].[CreationDate] = @Now
AND [ServiceHistory].[RequestedBy] = 'WorkFlow';

UPDATE @Requests
SET [Wait] = 0,
	[Comment] = 'Request for service for package ' + @PackageName + ' not made on this account.'
WHERE [RequestID] IS NULL
AND [Comment] IS NULL;

IF @WaitForResponse = 1 AND @MaximumHoldTime > 0 BEGIN
	UPDATE [WorkFlowExec]
	SET [NextActivityID] = @ActivityID,
		[NextEvaluateDate] = DATEADD(MINUTE, 15, GETDATE())
	FROM #WorkFlowExec AS [WorkFlowExec]
	INNER JOIN @Requests AS [Requests]
	ON [Requests].[ExecID] = [WorkFlowExec].[ExecID]
	WHERE [Requests].[RequestID] IS NOT NULL
	AND [Requests].[Wait] = 1;

	UPDATE [WorkFlowAcct]
	SET [ActivityVariable] = [Requests].[RequestID]
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN @Requests AS [Requests]
	ON [WorkFlowAcct].[AccountID] = [Requests].[AccountID]
	WHERE [Requests].[RequestID] IS NOT NULL;
END;

UPDATE [WorkFlowAcct]
SET [Comment] = [Requests].[Comment]
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN @Requests AS [Requests]
ON [WorkFlowAcct].[ExecID] = [Requests].[ExecID]
AND [WorkFlowAcct].[AccountID] = [Requests].[AccountID]
AND [Requests].[Comment] IS NOT NULL;

RETURN 0;
GO
