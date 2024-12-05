SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_StopLetterSeries] @SeriesID INTEGER
AS
SET NOCOUNT ON;

DECLARE @SeriesName VARCHAR(50);

DECLARE @Accounts TABLE (
	[AccountID] INTEGER NOT NULL
);

IF @SeriesID IS NULL BEGIN
	INSERT INTO @Accounts ([AccountID])
	SELECT DISTINCT [WorkFlowExec].[AccountID]
	FROM [dbo].[LtrSeriesQueue]
	INNER JOIN #WorkFlowExec AS [WorkFlowExec]
	ON [LtrSeriesQueue].[AccountID] = [WorkFlowExec].[AccountID]
	WHERE [LtrSeriesQueue].[DateRequested] = '1753-01-01 12:00:00';

	DELETE [dbo].[LtrSeriesQueue]
	FROM [dbo].[LtrSeriesQueue] WITH (ROWLOCK)
	INNER JOIN @Accounts AS [Accounts]
	ON [Accounts].[AccountID] = [LtrSeriesQueue].[AccountID];
END;
ELSE BEGIN
	SELECT @SeriesName = [Description]
	FROM [dbo].[LtrSeries]
	WHERE [LtrSeriesID] = @SeriesID;

	IF @SeriesName IS NULL BEGIN
		RAISERROR('Letter series %d does not exist.', 16, 1, @SeriesID);
		RETURN 1;
	END;

	INSERT INTO @Accounts ([AccountID])
	SELECT DISTINCT [WorkFlowExec].[AccountID]
	FROM [dbo].[LtrSeriesQueue]
	INNER JOIN #WorkFlowExec AS [WorkFlowExec]
	ON [LtrSeriesQueue].[AccountID] = [WorkFlowExec].[AccountID]
	INNER JOIN [dbo].[LtrSeriesConfig]
	ON [LtrSeriesQueue].[LtrSeriesConfigID] = [LtrSeriesConfig].[LtrSeriesConfigID]
	WHERE [LtrSeriesQueue].[DateRequested] = '1753-01-01 12:00:00'
	AND [LtrSeriesConfig].[LtrSeriesID] = @SeriesID;

	DELETE [dbo].[LtrSeriesQueue]
	FROM [dbo].[LtrSeriesQueue] WITH (ROWLOCK)
	INNER JOIN @Accounts AS [Accounts]
	ON [Accounts].[AccountID] = [LtrSeriesQueue].[AccountID]
	INNER JOIN [dbo].[LtrSeriesConfig]
	ON [LtrSeriesQueue].[LtrSeriesConfigID] = [LtrSeriesConfig].[LtrSeriesConfigID]
	WHERE [LtrSeriesQueue].[DateRequested] = '1753-01-01 12:00:00'
	AND [LtrSeriesConfig].[LtrSeriesID] = @SeriesID;
END;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [Accounts].[AccountID], 'WKF', GETDATE(), 'WORKFLOW', 'LETTR', 'SRIES',
	CASE
		WHEN @SeriesName IS NOT NULL THEN 'Stopped letter series "' + @SeriesName + '".'
		ELSE 'Stopped all letter series.'
	END, 0
FROM @Accounts AS [Accounts];

UPDATE #WorkFlowAcct
SET [Comment] = CASE
		WHEN @SeriesName IS NOT NULL THEN 'Stopped letter series "' + @SeriesName + '".'
		ELSE 'Stopped all letter series.'
	END;

RETURN 0;
GO
