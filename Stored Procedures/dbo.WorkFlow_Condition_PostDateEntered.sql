SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_PostDateEntered] @PCC BIT = 0, @PDC BIT = 0
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF @PCC = 1 BEGIN
	UPDATE #WorkFlowAcct
	SET [True] = 1,
		[Comment] = 'Credit card payment for ' + CONVERT(VARCHAR(50), [DebtorCreditCards].[Amount], 1) + ' due ' + CONVERT(VARCHAR(50), [DebtorCreditCards].[DepositDate], 101) + ' entered/created on ' + CONVERT(VARCHAR(50), [DebtorCreditCards].[DateCreated], 100)
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN #WorkFlowExec AS [WorkFlowExec]
	ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
	INNER JOIN [dbo].[DebtorCreditCards]
	ON [WorkFlowAcct].[AccountID] = [DebtorCreditCards].[Number]
	WHERE [DebtorCreditCards].[DateCreated] > [WorkFlowExec].[EnteredDate]
	AND [WorkFlowAcct].[True] = 0;
END;

IF @PDC = 1 BEGIN
	UPDATE #WorkFlowAcct
	SET [True] = 1,
		[Comment] = 'PDC for ' + CONVERT(VARCHAR(50), [pdc].[amount], 1) + ' due ' + CONVERT(VARCHAR(50), [pdc].[deposit], 101) + ' entered/created on ' + CONVERT(VARCHAR(50), [pdc].[DateCreated], 100)
	FROM #WorkFlowAcct AS [WorkFlowAcct]
	INNER JOIN #WorkFlowExec AS [WorkFlowExec]
	ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
	INNER JOIN [dbo].[pdc]
	ON [WorkFlowAcct].[AccountID] = [pdc].[number]
	WHERE [pdc].[DateCreated] > [WorkFlowExec].[EnteredDate];
END;

RETURN 0;

GO
