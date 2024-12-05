SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Denise Atkinson
-- Create date: 05/04/2022
-- Description:	Creates an exception report to be emailed out daily.  
--              The report will look through the notes entered on all US Bank customers 
--              for the keywords: Fraud, Frd, Dispute, Dsp, or disp. 
-- Usage:       EXEC [dbo].[Custom_USBank_Daily_Fraud_and_Dispute_Report] '2019-05-23'
--              
-- Changes: 5/4/2022 DMA Completed changes to proc to make it run with Latitude.		
--			5/5/2022 DMA Tested against live data and added further selection criteria,	
--				         added order by account number and notation date. 
--				
--				
--				
--				
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Daily_Fraud_and_Dispute_Report]
	@reportDate VARCHAR(10)
AS

SET NOCOUNT ON;

-- Exec Custom_USBank_Daily_Fraud_and_Dispute_Report '2019-03-08'
-- Exec Custom_USBank_Daily_Fraud_and_Dispute_Report '2021-08-25' --use this on the test database to see a record.  Use 22 as the customgroupid instead of 289.

drop table if exists tmpFraudDispute
declare @tmpFraudDispute table  (
									number int, --Per Brian, we use customer number and customer group, not name - DMA 5/4/2022
									[status] varchar(256), 
									notation varchar(256),
									created varchar(10)
								)
								
select *	
into tmpFraudDispute
from
(													
	select distinct n.number, c.status, cast(n.comment as varchar(256)) as [notation], n.created, user0, action, result
	FROM master m WITH (NOLOCK) 
	INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	INNER JOIN notes n WITH (NOLOCK) ON m.number=n.number
	WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE customgroupid = 22/*289*/) --289 is the value for production.  22 is the value for test - DMA 5/4/2022 
	and closed is null	
) x
where
cast(created as date) = cast(@reportDate as date) --The CAST is better to use than the CONVERT per Brian - DMA 5/4/2022


  and
	  (		 x.notation like '%fraud%'
		or	 x.notation like '% frd%' -- '%frd' includes 'refrd'.  We only want 'fraud'.  So add a leading space. - DMA 5/4/2022
		or	 x.notation like '%dispute%'
		or	(x.notation like '%disp%'   and x.notation not like '%dispense%'  and x.notation not like '%display%' and x.notation not like '%dispo%')
		or	(x.notation like '%dsp%'    and x.notation not like '%dspn%'      and x.notation not like '%dspo%')
	  )
	  and x.notation not like 'Status%'
	  and (concat(action,result) <>'++++++++++' or user0='EXG')

order by number, created
;
select * from tmpFraudDispute
;

GO
