SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Demographic_UpdateAccountsReadyForFile]
AS

BEGIN

DECLARE @lastRunDateTime DATETIME
SELECT @lastRunDateTime = ISNULL(MAX(CompletedDateTime),'1900-01-01 00:00:00.000') FROM AIM_Batch b WITH (NOLOCK)
JOIN AIM_BatchFileHistory bft WITH (NOLOCK) ON b.BatchId = bft.BatchId 
WHERE BatchFileTypeId = 9

INSERT INTO AIM_AccountTransaction
(AccountReferenceId,TransactionTypeId,TransactionStatusTypeID,CreatedDateTime,AgencyId,CommissionPercentage,
Balance,FeeSchedule,ForeignTableUniqueID)

--LAT-10597 After adding two new columns of UpdateWhen and UpdatedBy in Phones_Master Table, we don't need a different Transaction for Phone Edit. Phones ADD and EDIT will be done in same transaction

--SELECT
--AR.AccountReferenceID,36,1,
--GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
--M.Current0,AR.FeeSchedule,PH.ID
--FROM PhoneHistory PH WITH (NOLOCK)
--JOIN AIM_AccountReference AR WITH (NOLOCK) ON PH.AccountID = AR.ReferenceNumber
--JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
--WHERE
--PH.DateChanged > @lastRunDateTime
--AND PH.DateChanged > AR.LastPlacementDate
--AND PH.UserChanged != 'AIM' -- Changed by KAR on 04/25/2011 Don't Echo Back Changes
--AND AR.IsPlaced = 1

--UNION

SELECT
AR.AccountReferenceID,37,1,
GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
M.Current0,AR.FeeSchedule,PM.MasterPhoneID
FROM Phones_Master PM WITH (NOLOCK)
JOIN AIM_AccountReference AR WITH (NOLOCK) ON PM.Number = AR.ReferenceNumber
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
OUTER APPLY (SELECT TOP 1 * FROM Phones_Consent PC WITH (NOLOCK) WHERE PC.MasterPhoneId = PM.MasterPhoneID ORDER BY PhonesConsentId DESC) AS PC
WHERE
(PM.DateAdded > @lastRunDateTime OR PM.LastUpdated > @lastRunDateTime)
AND (PM.DateAdded > AR.LastPlacementDate OR PM.LastUpdated > AR.LastPlacementDate)
AND PM.PhoneTypeID <= 6
AND AR.IsPlaced = 1
AND ltrim(rtrim(PM.phonenumber)) <> ''
AND ( PM.loginname <> 'AIM' OR PM.UpdatedBy <> 'AIM') 
AND (PM.loginname <> 'SYNC' OR PM.UpdatedBy <> 'SYNC')
AND (PM.loginname <> 'CONVERSION' OR PM.UpdatedBy <> 'CONVERSION')

UNION

SELECT
AR.AccountReferenceID,38,1,
GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
M.Current0,AR.FeeSchedule,AH.ID
FROM AddressHistory AH WITH (NOLOCK)
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AH.AccountID = AR.ReferenceNumber
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
WHERE
AH.DateChanged > @lastRunDateTime
AND AH.DateChanged > AR.LastPlacementDate
AND AH.UserChanged != 'AIM'  -- Changed by KAR on 04/25/2011 Don't Echo Back Changes
AND AR.IsPlaced = 1

UNION
--Insert a transaction record for email
SELECT
AR.AccountReferenceID,46,1,
GETUTCDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
M.Current0,AR.FeeSchedule,E.EmailId
FROM 
AIM_AccountReference AR WITH (NOLOCK)
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
JOIN Debtors as D ON D.Number =m.number
JOIN Email E WITH (NOLOCK) ON D.DebtorID=E.DebtorId

WHERE
E.ModifiedWhen > @lastRunDateTime
AND E.ModifiedWhen > AR.LastPlacementDate
AND E.ModifiedBy != 'AIM'
AND AR.IsPlaced = 1

END
GO
