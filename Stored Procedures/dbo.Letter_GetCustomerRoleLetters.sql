SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Letter_GetCustomerRoleLetters] @Customer VARCHAR(7), @LetterType CHAR(3) = NULL, @RoleID INTEGER = 0
AS
SET NOCOUNT ON;

SELECT [letter].[code],
	[letter].[description],
	[letter].[allowclosed],
	[letter].[allowcollector],
	[letter].[allowoutside],
	[letter].[allowzero],
	[letter].[fee],
	[letter].[type],
	[letter].[allowfirst30],
	[letter].[allowafter30]
FROM [dbo].[letter] WITH (NOLOCK)
LEFT OUTER JOIN [dbo].[LetterRoles] WITH (NOLOCK)
ON [letter].[LetterID] = [LetterRoles].[LetterID]
INNER JOIN [dbo].[CustLtrAllow] WITH (NOLOCK)
ON [letter].[code] = [CustLtrAllow].[LtrCode]
WHERE ([LetterRoles].[RoleID] = @RoleID
	OR @RoleID = 0)
AND ([letter].[type] = @LetterType
	OR (@LetterType = '' AND [letter].[type] IS NULL)
	OR @LetterType IS NULL)
AND [CustLtrAllow].[CustCode] = @Customer
GROUP BY [letter].[code],
	[letter].[description],
	[letter].[allowclosed],
	[letter].[allowcollector],
	[letter].[allowoutside],
	[letter].[allowzero],
	[letter].[fee],
	[letter].[type],
	[letter].[allowfirst30],
	[letter].[allowafter30]
ORDER BY [letter].[code];

RETURN 0;

GO
