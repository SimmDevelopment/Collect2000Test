SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View dbo.vAcknowledgementDetailReport    Script Date: 4/11/2002 5:04:15 PM ******/

CREATE  VIEW [dbo].[vAcknowledgementDetailReport]
AS
SELECT     received, lower(Name) AS Name, lower(other) AS [Other Name], Account, CONVERT(varchar(19), original, 1) AS [Balance Placed],original,customer
FROM         dbo.master


GO
