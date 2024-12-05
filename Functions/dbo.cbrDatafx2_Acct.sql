SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDatafx2_Acct] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN

/* 
	These functions need to be kept in sync with all applicable changes: 
	cbrDatafx2
	cbrDatafx2_Acct
	cbrDatafx2_All
*/

	WITH cteConfig AS (
		SELECT @AccountId AS AccountId, * 
		FROM [dbo].[cbrDataConfig_Acct](@AccountId)
	)
	SELECT 
		ISNULL(h.fileid,'') AS fileid, 
		cc.*, m.*, o.*, a.*, d.*, b.*,p.* 
    FROM
        cteConfig cc
		cross APPLY [dbo].[cbrDataMaster](cc.AccountId, null) m 
		cross APPLY [dbo].[cbrDataDebtor](m.number) d
		OUTER APPLY [dbo].[cbrDataChargeOff](m.number) o
		OUTER APPLY [dbo].[cbrDataAim](m.number) a
		OUTER APPLY [dbo].[cbrDataBankruptcy](d.debtorid) b
		OUTER APPLY [dbo].[cbrDataPayhistory](m.number) p
		LEFT OUTER JOIN tempcbrAccountHistorykeys h on m.number = h.accountID 
			
GO
