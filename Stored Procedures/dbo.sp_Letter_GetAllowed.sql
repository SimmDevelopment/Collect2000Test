SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*dbo.sp_Letter_GetAllowed*/
CREATE  PROCEDURE [dbo].[sp_Letter_GetAllowed] 
	@accountID INT, @roleID INT
-- Name:	sp_Letter_GetAllowed
-- Function:    This procedure will retrieve allowed letters for an account using input parameters
--		accountID and roleID
-- Creation: 	03/07/2006 jc
-- Change History:
AS
	SELECT DISTINCT [letter].[LetterID], [letter].[code], [letter].[description], [letter].[type], [letter].[VendorLetter], [letter].[LinkedLetter]
	FROM [dbo].[letter] AS [letter] WITH(NOLOCK)
	INNER JOIN [dbo].[CustLtrAllow] AS [CustLtrAllow] WITH(NOLOCK) ON [CustLtrAllow].[LtrCode] = [letter].[code]
	INNER JOIN [dbo].[master] AS [master] WITH(NOLOCK) ON [master].[customer] = [CustLtrAllow].[CustCode]
	WHERE [master].[number] = @accountID 
	AND	(
			--input parm @roleID with value of -1 represents either global or admin user 
			(@roleID = -1)
			OR
			--input parm @roleID with any other value must exist in LetterRoles table
			(EXISTS (SELECT * FROM [dbo].[LetterRoles] AS [LetterRoles]
				WHERE [LetterRoles].[RoleID] = @roleID AND [LetterRoles].[LetterID] = [letter].[LetterID]))
		)
	AND	(
			--allow this letter on both closed and open accounts
			([letter].[Allowclosed] = 1)
			OR
			--allow this letter only on open accounts
			([letter].[Allowclosed] = 0 AND [master].[qlevel] < '998')
		)
	AND 	(
			--allow this letter on all accounts including those with a current0 balance of zero
			([letter].[Allowzero] = 1)
			OR
			--allow this letter only on accounts with a current0 balance greater than zero
			([letter].[Allowzero] = 0 AND [master].[current0] > 0)
		)
	AND 	(
			--allow this letter on all accounts 
			([letter].[AllowFirst30] = 0 AND [letter].[AllowAfter30] = 0) 
			OR
			--allow this letter on all accounts 
			([letter].[AllowFirst30] = 1 AND [letter].[AllowAfter30] = 1) 
			OR
			--allow this letter only on accounts where the current date is within 30 days of the received date
			([letter].[AllowFirst30] = 1 AND GETDATE() < DATEADD(day, 30, [master].[received]))
			OR
			--allow this letter only on accounts where the current date is past 30 days of the received date
			([letter].[AllowAfter30] = 1 AND GETDATE() > DATEADD(day, 30, [master].[received]))
	)


GO
