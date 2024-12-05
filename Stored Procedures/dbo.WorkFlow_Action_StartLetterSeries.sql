SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_StartLetterSeries] @SeriesID INTEGER, @FromToday BIT, @EnforceRules BIT
AS
SET NOCOUNT ON;

DECLARE @SeriesName VARCHAR(50);

SELECT @SeriesName = [Description]
FROM [dbo].[LtrSeries]
WHERE [LtrSeries].[LtrSeriesID] = @SeriesID;

IF @@ROWCOUNT = 0 BEGIN
	RAISERROR('Letter series "%d" does not exist or is not active.', 16, 1, @SeriesID);
	RETURN;
END;

DECLARE @Requests TABLE (
	[LtrSeriesConfigID] INTEGER NOT NULL,
	[DateToRequest] DATETIME NOT NULL,
	[AccountID] INTEGER NOT NULL,
	[DebtorID] INTEGER NOT NULL,
	[PrimaryDebtorID] INTEGER NOT NULL
);

DECLARE @Accounts TABLE (
	[AccountID] INTEGER NOT NULL
);

INSERT INTO @Requests ([LtrSeriesConfigID], [DateToRequest], [AccountID], [DebtorID], [PrimaryDebtorID])
SELECT DISTINCT [LtrSeriesConfig].[LtrSeriesConfigID],
	DATEADD(DAY, [LtrSeriesConfig].[DaysToWait], CASE @FromToday
		WHEN 1 THEN { fn CURDATE() }
		ELSE [master].[received]
	END) AS [DateToRequest],
	[WorkFlowExec].[AccountID],
	[Debtors].[DebtorID],
	[PrimaryDebtors].[DebtorID] AS [PrimaryDebtorID]
FROM #WorkFlowExec AS [WorkFlowExec]
INNER JOIN [dbo].[master]
ON [WorkFlowExec].[AccountID] = [master].[number]
INNER JOIN [dbo].[customer]
ON [master].[customer] = [customer].[customer]
INNER JOIN [dbo].[LtrSeries]
ON [LtrSeries].[LtrSeriesID] = @SeriesID
INNER JOIN [dbo].[LtrSeriesConfig]
ON [LtrSeriesConfig].[LtrSeriesID] = [LtrSeries].[LtrSeriesID]
INNER JOIN [dbo].[LtrSeriesFact]
ON [LtrSeriesFact].[LtrSeriesID] = [LtrSeries].[LtrSeriesID]
AND [LtrSeriesFact].[CustomerID] = [customer].[CCustomerID]
AND (@EnforceRules = 0
	OR ([master].[current0] >= [LtrSeriesFact].[MinBalance]
		AND [master].[current1] <= [LtrSeriesFact].[MaxBalance]))
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
AND (([LtrSeriesConfig].[ToPrimaryDebtor] = 1
		AND [master].[PSeq] = [Debtors].[Seq])
	OR ([LtrSeriesConfig].[ToCoDebtors] = 1
		AND [master].[PSeq] != [Debtors].[Seq]))
INNER JOIN [dbo].[Debtors] AS [PrimaryDebtors]
ON [master].[number] = [PrimaryDebtors].[number]
AND [master].[PSeq] = [PrimaryDebtors].[Seq]
WHERE [Debtors].[Responsible] = 1
AND DATEADD(DAY, [LtrSeriesConfig].[DaysToWait], CASE @FromToday
		WHEN 1 THEN { fn CURDATE() }
		ELSE [master].[received]
	END) >= { fn CURDATE() };

INSERT INTO @Accounts ([AccountID])
SELECT DISTINCT [AccountID]
FROM @Requests;

INSERT INTO [dbo].[LtrSeriesQueue] ([LtrSeriesConfigID], [DateToRequest], [AccountID], [DebtorID], [PrimaryDebtorID])
SELECT [LtrSeriesConfigID], [DateToRequest], [AccountID], [DebtorID], [PrimaryDebtorID]
FROM @Requests;

INSERT INTO [dbo].[notes] WITH (ROWLOCK) ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [AccountID], 'WKF', GETDATE(), 'WORKFLOW', 'LETTR', 'SRIES', 'Started letter series "' + @SeriesName + '".', 0
FROM @Accounts;

UPDATE #WorkFlowAcct
SET [Comment] = 'Started letter series "' + @SeriesName + '".';

RETURN 0;
GO
