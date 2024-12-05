SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[LatitudeLegal_GetPanelDetails]
@number int

AS



SELECT *
FROM
LatitudeLegal_AssetInfo WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_CaptionLegalNames  WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_ClaimBalanceInterestInfo  WITH (NOLOCK)
WHERE AccountID = @number


SELECT *
FROM
LatitudeLegal_HistoryRecordDetail  WITH (NOLOCK)
WHERE Number = @number




SELECT *
FROM
LatitudeLegal_MiscInfo  WITH (NOLOCK)
WHERE AccountID = @number




SELECT *
FROM
LatitudeLegal_PaymentPlanInfo  WITH (NOLOCK)
WHERE AccountID = @number




SELECT *
FROM
LatitudeLegal_SuitJudgmentInfo  WITH (NOLOCK)
WHERE AccountID = @number






SELECT *
FROM
LatitudeLegal_Payments  WITH (NOLOCK)
WHERE AccountID = @number






SELECT *
FROM
LatitudeLegal_Messages  WITH (NOLOCK)
WHERE AccountID = @number






SELECT *
FROM
LatitudeLegal_Reconciliation  WITH (NOLOCK)
WHERE AccountID = @number





SELECT *
FROM
LatitudeLegal_Bankruptcy  WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_Probate  WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_PhysicalAssets  WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_DebtorInformation  WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_2ND3RDDebtorInformation  WITH (NOLOCK)
WHERE AccountID = @number



SELECT *
FROM
LatitudeLegal_EmploymentInformation WITH (NOLOCK)
WHERE AccountID = @number


GO
