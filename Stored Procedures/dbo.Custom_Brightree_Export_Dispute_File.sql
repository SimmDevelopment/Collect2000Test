SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/30/2018
-- Description:	Create BrighTree Export Dispute File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Brightree_Export_Dispute_File] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))


--Required Fields
SELECT m.id1 AS AgencyPlacementID, sh.id AS AgencyDisputeID, 
(SELECT thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.creditorid') AS CreditorID,
m.OriginalCreditor AS CreditorName,
m.account AS PatientAccountNo, 
(SELECT thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.patientfirstname') AS PatientFirstName,
(SELECT thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'acc.0.patientlastname') AS PatientLastName,
CONVERT(VARCHAR(10), m.ContractDate, 101) AS ServiceDate,
m.current0 AS BalanceDue,
CASE m.status WHEN 'STL' THEN 'SET' WHEN 'VAL' THEN 'PMT' WHEN 'DSP' THEN 'BAL' END AS DisputeType,
CONVERT(VARCHAR(10), sh.DateChanged, 101) AS DisputeDate,
--Not Required Fields
'' AS DisputeTypeAmount,
'' AS InsuranceType,
'' AS InsuranceName,
'' AS RelationtoPatient,
'' AS SubscriberID,
'' AS SubscriberDOB,
'' AS GroupID,
'' AS SSN,
'' AS InsuranceAddress,
'' AS EmployerName,
'' AS EffectiveDate,
'' AS InsurancePhone,
'' AS FamilySingleCoverage,
'' AS Misc,
'' AS EquipPickupAddress,
'' AS Notes,
'' AS HasAttachment

FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID

WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 102)
AND NewStatus IN ('STL', 'VAL', 'DSP') AND DateChanged BETWEEN @startDate AND @endDate

END

GO
