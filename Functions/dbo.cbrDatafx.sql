SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[cbrDatafx] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN
	WITH cteCustomerParam
  AS
  (
    SELECT
			cf.*, CASE WHEN @accountid IS NULL THEN cf.customercode ELSE NULL END as cbrDataMasterParam            
            
        FROM
            [dbo].[cbrDataConfig](@AccountId) cf

			--This refactoring was required because placing the case statement in the cross apply below would cause a full table scan of master.
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
			OUTER APPLY [dbo].[cbrAccountHistory](m.number) h --on h.accountid = @accountid
			
					
			

GO
