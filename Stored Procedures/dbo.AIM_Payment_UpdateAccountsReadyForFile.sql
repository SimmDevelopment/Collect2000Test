SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Payment_UpdateAccountsReadyForFile]
AS

BEGIN

DECLARE @lastRunDateTime DATETIME
SELECT @lastRunDateTime = ISNULL(MAX(CompletedDateTime),'1900-01-01 00:00:00.000') FROM AIM_Batch b WITH (NOLOCK)
JOIN AIM_BatchFileHistory bft WITH (NOLOCK) ON b.BatchId = bft.BatchId 
WHERE BatchFileTypeId = 8

--Get temp table of payments, reversals and adjustments that have AIMAgencyID set that have come in after the last time we ran
--payment files
CREATE TABLE #AIMTempPaymentExportTransactions (UID INT PRIMARY KEY)
INSERT INTO #AIMTempPaymentExportTransactions
SELECT [UID] FROM Payhistory WITH (NOLOCK)
WHERE BatchType NOT IN ('LJ','LJR') AND DateTimeEntered > @lastRunDateTime
--Queue up Payments and Reversals for accounts where the agency getting credit still has it
--This will get upstream PC, directs PU and PA from other agencies
INSERT INTO AIM_AccountTransaction
(AccountReferenceId,TransactionTypeId,TransactionStatusTypeID,CreatedDateTime,AgencyId,CommissionPercentage,
Balance,FeeSchedule,ForeignTableUniqueID,TransactionContext,PaymentBatchNumber)
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
PH.AIMAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
CASE WHEN PH.BatchType IN ('PU','PC','PA') THEN 'PC' WHEN PH.BatchType IN ('PUR','PCR','PAR') THEN 'PCR' END + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber	
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number 
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber 
WHERE BatchType IN ('PU','PC','PUR','PCR','PA','PAR') AND AIMAgencyID IS NOT NULL AND ISNULL(AIMAgencyID,-1) <> ISNULL(AIMSendingID,-1)
--Queue up Payments and Reversals that need to go as adjustments as another agency received commission
UNION
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
CASE WHEN PH.BatchType IN ('PU','PC','PA') THEN 'DA' WHEN PH.BatchType IN ('PUR','PCR','PAR') THEN 'DAR' END + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number AND AR.IsPlaced = 1
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber AND PH.AIMAgencyID <> AR.CurrentlyPlacedAgencyID
WHERE BatchType IN ('PU','PC','PUR','PCR','PA','PAR') AND AIMAgencyID IS NOT NULL AND AIMAgencyID = AIMSendingID AND PH.DateTimeEntered > AR.LastPlacementDate

-- Added by KAR on 03/29/2011 
-- Queue In House or Client Reversals for accounts that are now with different that need to be notified with a DAR to increase the balance.
UNION
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
'DAR' + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number AND AR.IsPlaced = 1
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber AND PH.AIMAgencyID <> AR.CurrentlyPlacedAgencyID
WHERE PH.BatchType IN ('PUR','PCR') AND PH.AIMAgencyID IS NOT NULL AND PH.AIMSendingID IS NULL AND PH.DateTimeEntered > AR.LastPlacementDate

--Queue up Payments and Reversals that need to go as adjustments as no agency received commission (AIMAgencyID IS NULL)
UNION
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
CASE WHEN PH.BatchType IN ('PU','PC','PA') THEN 'DA' WHEN PH.BatchType IN ('PUR','PCR','PAR') THEN 'DAR' END + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number AND AR.IsPlaced = 1
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
WHERE (AIMAgencyID IS NULL OR AIMAgencyID <= 0) AND BatchType IN ('PU','PC','PUR','PCR','PA','PAR') AND PH.DateTimeEntered > AR.LastPlacementDate

--Queue up adjustments that originated internally in Latitude
UNION
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
+ PH.BatchType + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number 
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
WHERE BatchType IN ('DA','DAR')  AND ISNULL(AIMSendingID,-1) <= 0 AND PH.DateTimeEntered > AR.LastPlacementDate

-- Added by KAR on 04/21/2011 
-- Queue Adjustments that were entered for an account that is no longer placed with the SENDING agency
UNION
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
PH.BatchType + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number AND AR.IsPlaced = 1
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber AND PH.AIMAgencyID = AR.CurrentlyPlacedAgencyID
WHERE PH.BatchType IN ('DA','DAR') AND PH.AIMAgencyID IS NOT NULL AND PH.AIMSendingID IS NOT NULL AND PH.DateTimeEntered > AR.LastPlacementDate
AND PH.AIMAgencyID != PH.AIMSendingID

-- Added by KAR on 04/25/2011 
-- Queue Adjustments that were entered for an account that is no longer placed with the SENDING agency
-- and at the time the adjustment was created was not with an agency but is now placed.
UNION
SELECT
AR.AccountReferenceID,10,1,GETDATE(),
AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,M.Current0,AR.FeeSchedule,temp.UID,
'<PaymentRecord><file_number>'+cast(PH.number as varchar)+'</file_number><account>'+cast(M.account as varchar)+'</account><payment_amount>'+cast((PH.paid1+PH.paid2+PH.paid3+PH.paid4+PH.paid5+PH.paid6+PH.paid7+PH.paid8+PH.paid9) as varchar)+'</payment_amount><payment_date>'+cast(PH.datepaid as varchar)+'</payment_date><payment_type>'+
+ PH.BatchType + '</payment_type><payment_identifier>'+cast(PH.uid as varchar)+'</payment_identifier><comment>'+pH.comment+'</comment></PaymentRecord>',
PaymentBatchNumber = PH.batchnumber
FROM #AIMTempPaymentExportTransactions temp
JOIN Payhistory PH WITH (NOLOCK) ON PH.UID = temp.UID
JOIN AIM_AccountReference AR WITH (NOLOCK) ON AR.ReferenceNumber = PH.Number AND AR.IsPlaced = 1
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
WHERE PH.BatchType IN ('DA','DAR') AND PH.AIMAgencyID IS NULL 
AND ISNULL(PH.AIMSendingID,-1) >-1 AND PH.DateTimeEntered > AR.LastPlacementDate


DROP TABLE #AIMTempPaymentExportTransactions
END

GO
