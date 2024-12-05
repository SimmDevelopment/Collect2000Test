SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_EnterNote] @User VARCHAR(10), @Action VARCHAR(5), @Result VARCHAR(5), @Note VARCHAR(4000), @Private BIT
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[notes] ([number], [ctl], [created], [user0], [action], [result], [comment], [IsPrivate])
SELECT [AccountID], 'WKF', GETDATE(), ISNULL(@User, 'WORKFLOW'), ISNULL(@Action, 'CO'), ISNULL(@Result, 'CO'), @Note, @Private
FROM #WorkFlowAcct;

UPDATE #WorkFlowAcct
SET [Comment] = 'Note entered: ("' + @Action + '", "' + @Result + '"): ' + @Note;

RETURN 0;
GO
