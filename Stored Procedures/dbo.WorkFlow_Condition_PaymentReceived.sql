SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_PaymentReceived]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

UPDATE #WorkFlowAcct
SET [True] = 1,
	[Comment] = 'Payment for ' + CONVERT(VARCHAR(50), [payhistory].[totalpaid], 1) + ' for ' + CONVERT(VARCHAR(50), [payhistory].[datepaid], 101) + ' entered on ' + CONVERT(VARCHAR(50), [payhistory].[entered], 101)
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
INNER JOIN [dbo].[payhistory]
ON [WorkFlowAcct].[AccountID] = [payhistory].[number]
WHERE ([payhistory].[datepaid] > [WorkFlowExec].[EnteredDate]
	OR ([payhistory].[datepaid] = CONVERT(VARCHAR(10), [WorkFlowExec].[EnteredDate], 112)
		AND [payhistory].[Created] > [WorkFlowExec].[EnteredDate]
	)
)
AND [payhistory].[batchtype] LIKE 'P_';

RETURN 0;
GO
