SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Acknowledgment_Process]
@batchFileHistoryID INT
AS

--Update All Acknowledgment records loaded for this batch with current Latitude values
UPDATE AIM_Acknowledgment
SET
LatitudeNumber = master.Number,
LatitudeBalance = master.Current0,
LatitudeAccount = master.Account,
LatitudeAgencyID = AIM_AccountReference.CurrentlyPlacedAgencyID
FROM AIM_Acknowledgment AIM_Acknowledgment WITH (NOLOCK)
JOIN AIM_AccountReference AIM_AccountReference WITH (NOLOCK) 
ON AIM_Acknowledgment.Number = AIM_AccountReference.ReferenceNumber
JOIN [master] [master] WITH (NOLOCK)
ON master.Number = AIM_Acknowledgment.Number AND AIM_AccountReference.CurrentlyPlacedAgencyID = AIM_Acknowledgment.AgencyID
WHERE AIM_Acknowledgment.BatchFileHistoryID = @batchFileHistoryID

--Update AIM Account Reference records for records loaded in this batch
UPDATE AIM_AccountReference
SET
AgencyAcknowledgement = 1,
AcknowledgementError =  CASE WHEN LatitudeAccount <> Account THEN 1 
						WHEN ABS(cast(AA.[Current] as decimal(15,4)) - cast(AA.LatitudeBalance as decimal(15,4))) > .01 THEN 1
						ELSE 0 END
FROM AIM_AccountReference AR WITH (NOLOCK) 
JOIN AIM_Acknowledgment AA WITH (NOLOCK) ON AR.ReferenceNumber = AA.Number
WHERE 
AA.BatchFileHistoryID = @batchFileHistoryID

GO
