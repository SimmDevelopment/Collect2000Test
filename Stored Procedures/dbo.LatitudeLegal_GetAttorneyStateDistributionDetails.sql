SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[LatitudeLegal_GetAttorneyStateDistributionDetails]

AS


SELECT 
s.Description as [State] ,
s.Code as [State Code]

FROM States S 


ORDER BY S.Code

SELECT 
ad.ID,
ad.AttorneyId,
ad.StateCode as [State Code],
a.[Name] + ' - ' + a.[Firm] as [Name - Firm],
a.YouGotClaimsID as [YGC ID],
cast(isnull(cast(percentage as decimal(5,2)),cast (0 as decimal(5,2))) as decimal(5,2)) as [Percentage],
isnull(ad.DefaultDesk,'No Change') as [Move to Desk],
CASE WHEN ad.DefaultFeeSchedule is null THEN 'No Change' ELSE ad.DefaultFeeSchedule END as [Pre Suit Fee Schedule],
CASE WHEN ad.DefaultPostSuitFeeSchedule is null THEN 'No Change' ELSE ad.DefaultPostSuitFeeSchedule END as [Post Suit Fee Schedule],
ad.DefaultLawList as [Law List]
FROM LatitudeLegal_AttorneyDistribution ad JOIN Attorney a ON ad.attorneyid = a.attorneyid 
ORDER BY ad.StateCode



GO
