SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LatitudeLegal_AssignViaDistributionLogic]

AS


--Bulk update from distribution logic
UPDATE MASTER SET
AttorneyStatus = 'Placing',
Desk = isnull(AD.DefaultDesk,M.Desk),
FeeCode = isnull(AD.DefaultFeeSchedule,M.FeeCode),
AttorneyID = AD.AttorneyID,
AssignedAttorney = getdate(),
AttorneyLawList = AD.DefaultLawList

FROM Master M WITH (NOLOCK) JOIN Distribution D WITH (NOLOCK) 
ON M.number = D.AccountID
JOIN LatitudeLegal_AttorneyDistribution AD WITH (NOLOCK)
ON D.Proposed = AD.AttorneyID AND M.State = AD.StateCode


--Insert post suit fee schedule reference if not null
INSERT INTO LatitudeLegal_FeeScheduleReference 
(Number,PostSuitFeeSchedule) 
SELECT M.Number,AD.DefaultPostSuitFeeSchedule
FROM Master M WITH (NOLOCK) JOIN Distribution D WITH (NOLOCK) 
ON M.number = D.AccountID
JOIN LatitudeLegal_AttorneyDistribution AD WITH (NOLOCK)
ON D.Proposed = AD.AttorneyID AND M.State = AD.StateCode
WHERE AD.DefaultPostSuitFeeSchedule IS NOT NULL



GO
