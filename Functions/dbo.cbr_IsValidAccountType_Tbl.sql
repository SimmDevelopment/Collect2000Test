SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2010-10-14
-- Description:	Determine if the combination of Industry, portfolio type, and account type are valid.
-- =============================================
CREATE FUNCTION [dbo].[cbr_IsValidAccountType_Tbl] 
(
	@Industry char(10), 
	@portfolioType char(1),
	@accountType char(2)
)
RETURNS TABLE
AS
RETURN
	SELECT Result = COUNT(*)
	FROM cbr_Industry_AccountType i INNER JOIN cbr_PortfolioType_AccountType p 
		ON i.industryCode = @Industry 
		AND p.portfolioType = @portfolioType
		AND i.accountType = @accountType
		AND i.accountType = p.accountType

GO
