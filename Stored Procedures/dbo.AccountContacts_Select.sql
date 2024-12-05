SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AccountContacts_Select]
	@StartDate DATETIME,
	@EndDate DATETIME,
	@UserID INTEGER = NULL,
	@DeskCode VARCHAR(10) = NULL
WITH RECOMPILE
AS

SELECT [AccountContacts].[Number],
	[AccountContacts].[TheDate],
	[AccountContacts].[Desk],
	[AccountContacts].[TimeOn],
	[AccountContacts].[TimeOff],
	[AccountContacts].[TotalSeconds],
	[AccountContacts].[UserID],
	[AccountContacts].[TimeOnUtc],
	[master].[Name],
	[master].[customer],
	[master].[TotalWorked],
	[master].[TotalViewed],
	[master].[TotalContacted],
	[master].[Current0]
FROM [dbo].[AccountContacts] WITH (NOLOCK)
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [AccountContacts].[Number] = [master].[number]
WHERE (@DeskCode IS NULL
	OR [AccountContacts].[Desk] = @DeskCode)
AND (@UserID IS NULL
	OR [AccountContacts].[UserID] = @UserID)
AND [AccountContacts].[TheDate] >= @StartDate
AND [AccountContacts].[TheDate] < DATEADD(DAY, 1, @EndDate)
ORDER BY [AccountContacts].[TimeOn] ASC;

RETURN 0;

GO
