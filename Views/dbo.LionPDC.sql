SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionPDC    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionPDC]
AS
SELECT     UID, number, entered, onhold AS [On Hold], amount, checknbr AS [Check Number], deposit AS [Deposit Date], Desk, nitd AS [Nitd Sent], customer, 
                      processed1 AS Processed
FROM         dbo.pdc WITH (nolock)

GO
