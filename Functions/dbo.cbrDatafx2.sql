SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDatafx2] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN

/* 
	These functions need to be kept in sync with all applicable changes: 
	cbrDatafx2
	cbrDatafx2_Acct
	cbrDatafx2_All
*/

	WITH cteCustomerParam AS (
		SELECT cf.*, CASE WHEN @accountid IS NULL THEN cf.customercode ELSE NULL END as cbrDataMasterParam            
        FROM [dbo].[cbrDataConfig](@AccountId) cf
	)
	SELECT 
		ISNULL(h.fileid,'') AS fileid, 
		cc.*, m.*, o.*, a.*, d.*, b.*,p.* 

	FROM
		cteCustomerParam cc
		cross APPLY [dbo].[cbrDataMaster](@AccountId, cc.cbrDataMasterParam) m 
		cross APPLY [dbo].[cbrDataDebtor](m.number) d
		OUTER APPLY [dbo].[cbrDataChargeOff](m.number) o
		OUTER APPLY [dbo].[cbrDataAim](m.number) a
		OUTER APPLY [dbo].[cbrDataBankruptcy](d.debtorid) b
		OUTER APPLY [dbo].[cbrDataPayhistory](m.number) p
		LEFT OUTER JOIN tempcbrAccountHistorykeys h on m.number = h.accountID 		


GO
