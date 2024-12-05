SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Letters_GetPermittedLetters] @UserID INTEGER, @Customer VARCHAR(7)
AS
SET NOCOUNT ON;

SELECT [letter].[LetterID]
FROM [dbo].[letter]
WHERE (
	EXISTS (SELECT *
		FROM [dbo].[CustLtrAllow]
		WHERE [CustLtrAllow].[CustCode] = @Customer
		AND [CustLtrAllow].[LtrCode] = [letter].[code])
	OR EXISTS (SELECT *
		FROM [dbo].[Fact]
		INNER JOIN [dbo].[CustomCustGroupLetter]
		ON [Fact].[CustomGroupID] = [CustomCustGroupLetter].[CustomCustGroupID]
		WHERE [Fact].[CustomerID] = @Customer
		AND [CustomCustGroupLetter].[LetterID] = [letter].[LetterID]))
AND (
	@UserID = 0
	OR EXISTS (SELECT *
		FROM [dbo].[LetterRoles]
		INNER JOIN [dbo].[Users]
		ON [LetterRoles].[RoleID] = [Users].[RoleID]
		WHERE [Users].[ID] = @UserID
		AND [LetterRoles].[LetterID] = [letter].[LetterID]));

RETURN 0;

GO
