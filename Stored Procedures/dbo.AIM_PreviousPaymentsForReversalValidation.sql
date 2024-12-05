SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[AIM_PreviousPaymentsForReversalValidation] 
@number INT,
@amount MONEY,
@batchtype VARCHAR (50),
@reversalbatchtype VARCHAR(50),
@agencyid INT

AS

SELECT Entered,[UID],AIMBatchID,AIMAgencyID,AIMSendingID,AIMDueAgency,AIMAgencyFee 
FROM dbo.Payhistory WITH (NOLOCK)
WHERE Number = @number 
AND BatchType = @batchtype 
AND AIMSendingID = @agencyID
AND TotalPaid = @amount
ORDER BY datepaid DESC


SELECT Entered,ReverseOfUID,AIMBatchID,AIMAgencyID,AIMSendingID,AIMDueAgency,AIMAgencyFee
FROM dbo.Payhistory WITH (NOLOCK)
WHERE Number = @number 
AND BatchType = @reversalbatchtype 
AND AIMSendingID = @agencyID
AND TotalPaid = @amount
AND ReverseOfUID IS NOT NULL

UNION ALL
-- Added by KAR On 03/18/2009 need to account for paymentbatchitems not
-- processed yet.
/*
Public Enum PaymentTypeEnum
    gsPU = 1
    gsPC = 2
    gsDA = 3
    gsPA = 4
    gsPUR = 5
    gsPCR = 6
    gsDAR = 7
    gsPAR = 8
End Enum
*/
SELECT Entered,ReverseOfUID,AIMBatchID,AIMAgencyID,AIMSendingID,AIMDueAgency,AIMAgencyFee
FROM paymentbatchitems(nolock)
WHERE filenum = @number 
AND pmttype = 
CASE @reversalbatchtype
	WHEN 'PUR' THEN 5
	WHEN 'PCR' THEN 6
	WHEN 'PAR' THEN 8
END and 
paid0 = @amount
AND reverseofuid IS NOT NULL
AND AIMSendingID = @agencyID

GO
