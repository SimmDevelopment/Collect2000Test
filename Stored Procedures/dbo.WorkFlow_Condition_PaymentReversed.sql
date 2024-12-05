SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_PaymentReversed]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE #WorkFlowAcct
SET [True] = 1,
	[Comment] = 'Payment for ' + CONVERT(VARCHAR(50), [reversed].[totalpaid], 1) + ' for ' + CONVERT(VARCHAR(50), [reversed].[datepaid], 101) + ' reversed on ' + CONVERT(VARCHAR(50), [payhistory].[datepaid], 101)
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
INNER JOIN [dbo].[payhistory]
ON [WorkFlowAcct].[AccountID] = [payhistory].[number]
INNER JOIN [dbo].[payhistory] AS [reversed]
ON [payhistory].[ReverseOfUID] = [reversed].[UID]
WHERE ([payhistory].[datepaid] > [WorkFlowExec].[EnteredDate]
	OR ([payhistory].[datepaid] = CONVERT(VARCHAR(10), [WorkFlowExec].[EnteredDate], 112)
		AND [payhistory].[Created] > [WorkFlowExec].[EnteredDate]
	)
)
AND [payhistory].[batchtype] LIKE 'P_R'
AND [payhistory].[IsCorrection] = 0;

RETURN 0;
GO
