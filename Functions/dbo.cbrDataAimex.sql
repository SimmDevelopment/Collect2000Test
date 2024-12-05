SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataAimex] ( @soldportfolio int)
RETURNS TABLE
AS 
    RETURN		
	SELECT ap.portfolioid,
		COALESCE(ag.[name], ag2.[name], '') AS [SoldToPurchasedFrom],
		al.DateEntered as PortfolioSoldDate
    FROM (SELECT [PortfolioId], [buyergroupid], [sellergroupid] 
			FROM [dbo].[AIM_Portfolio] 
			WHERE portfolioid = @soldportfolio) ap
		LEFT OUTER JOIN [dbo].[AIM_Group] ag 
			ON ap.[buyergroupid] = ag.groupid
		LEFT OUTER JOIN [dbo].[AIM_Group] [ag2] 
			ON [ap].[sellergroupid] = [ag2].[groupid]
		LEFT OUTER JOIN [dbo].[AIM_LedgerType] alt 
			ON alt.Name = 'sales'  
		LEFT OUTER JOIN [dbo].[AIM_Ledger] al 
			ON al.soldPortfolioId = ap.PortfolioId AND al.LedgerTypeId = alt.ledgertypeid
				
				
GO
