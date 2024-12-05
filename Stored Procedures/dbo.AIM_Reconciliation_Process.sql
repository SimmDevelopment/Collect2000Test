SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Reconciliation_Process]
@batchFileHistoryID INT

--This stored procedure updates the AIM_Reconciliation table after processing a AREC file
--from an agency

AS

UPDATE AIM_Reconciliation

SET
LatitudeNumber = master.Number,
LatitudeBalance = master.Current0,
LatitudeAccount = master.Account,
LatitudeAgencyID = AIM_AccountReference.CurrentlyPlacedAgencyID
FROM AIM_Reconciliation AIM_Reconciliation WITH (NOLOCK)
JOIN AIM_AccountReference AIM_AccountReference WITH (NOLOCK) 
ON AIM_Reconciliation.Number = AIM_AccountReference.ReferenceNumber
JOIN [master] [master] WITH (NOLOCK)
ON master.Number = AIM_Reconciliation.Number
WHERE AIM_Reconciliation.BatchFileHistoryID = @batchFileHistoryID

GO
