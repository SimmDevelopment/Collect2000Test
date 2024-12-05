SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataAim] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN
    SELECT
            ap.portfolioid, ag.[name] AS AimGroupSeller, ag2.[name] AS AimGroupBuyer,
            al.DateEntered AS PortfolioSoldDate
        FROM
            master m
        LEFT OUTER JOIN [dbo].[AIM_Portfolio] ap ON  m.soldportfolio = ap.portfolioid
        LEFT OUTER JOIN [dbo].[AIM_Group] ag ON  ap.[buyergroupid] = ag.groupid
        LEFT OUTER JOIN [dbo].[AIM_Group] [ag2] ON  [ap].[sellergroupid] = [ag2].[groupid]
		--LEFT OUTER JOIN [dbo].[AIM_Portfolio] ap2 ON m.purchasedportfolio = ap2.portfolioid
        LEFT OUTER JOIN [dbo].[AIM_LedgerType] alt ON  alt.Name = 'sales'
        LEFT OUTER JOIN [dbo].[AIM_Ledger] al ON  al.LedgerTypeId = alt.ledgertypeid AND ap.PortfolioId = al.soldPortfolioId
        WHERE
            m.number = @Accountid
            AND m.soldportfolio IS NOT NULL
            AND ap.PortfolioId IS NOT NULL ; 
GO
