SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_QueryAction_RaiseEvent] @EventID UNIQUEIDENTIFIER, @Accounts IMAGE
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[WorkFlow_EventQueue] ([AccountID], [EventID])
SELECT [accts].[Value], @EventID
FROM [dbo].[fnExtractIDs](@Accounts, 1) AS [accts];

RETURN 0;
GO
