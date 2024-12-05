SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 10/24/2024
-- Description:	Exports file to be used to import into new business for Lake Cumberland
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Lake_Cumber_Export_Placement_File]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Patient Record
SELECT p.RecType, p.PatientMRN, p.PatientFirstName, p.PatientLastName, p.PatientMiddleName, p.PatiendDOB, p.PatientSex, p.PatientAddr1, p.PatientAddr2, p.PatientAddrCity, p.PatientAddrState
	 , p.PatientAddrZip, p.PatientPriPhone, p.TotalChargeforCase, c.CaseIDNum, p.SEQ
	 , (SELECT format(min(CAST(ChargeTransDate as date)), 'M/dd/yyyy') FROM Custom_Lake_Cumber_Import_Charges_Data clcicd WITH (NOLOCK) WHERE p.seq = clcicd.SEQ) AS ContractDate
	 , (SELECT top 1 case WHEN clciad.TransactionCode like '%SIMM%' THEN format(cast(clciad.TransactionDate as date), 'M/dd/yyyy') 
	 WHEN clciad.TransactionType IN ('WO', '') THEN format(max(cast(clciad.TransactionDate as date)), 'M/dd/yyyy') ELSE format(max(cast(clciad.TransactionDate as date)), 'M/dd/yyyy') END 	
FROM Custom_Lake_Cumber_Import_Adjust_Data clciad WHERE clciad.TransactionType IN ('WO', '') AND p.seq = clciad.SEQ GROUP BY clciad.SEQ, clciad.TransactionCode, clciad.TransactionDate, clciad.TransactionType ORDER BY cast(clciad.TransactionDate as date) DESC) AS chargeoffdate 
FROM Custom_Lake_Cumber_Import_Patient_Data p WITH (NOLOCK) 
INNER JOIN (SELECT c.CaseIDNum, c.SEQ, sum(cast(c.CurrentBalDueforCharge as MONEY)) AS CBalDue FROM Custom_Lake_Cumber_Import_Charges_Data c WITH (NOLOCK)
GROUP BY c.caseidnum, c.SEQ) c ON p.SEQ = c.SEQ
ORDER BY cast(c.seq AS int)

--Guarantors
SELECT clcigd.RecType, clcigd.PatientMRN, clcigd.CaseIDNumber, clcigd.GuarantorOrderInd, clcigd.GuarantorFirstName, clcigd.GuarantorLastName, clcigd.GuarantorMiddle
	 , clcigd.GuarantorSuffix, clcigd.GuarantorDOB, clcigd.GuarantorSex, clcigd.GuarantorSSN, clcigd.GuarantorAddr1, clcigd.GuarantorAddr2, clcigd.GuarantorCity, clcigd.GuarantorState
	 , clcigd.GuarantorZip, clcigd.GuarantorExtendZip, clcigd.GuarantorPriPhoneNum, clcigd.GuarantorEmpName, clcigd.GuarantorEmpAddr1, clcigd.GuarantorEmpAddr2, clcigd.GuarantorEmpCity
	 , clcigd.GuarantorEmpState, clcigd.GuarantorEmpZip, clcigd.GuarantorEmpZipExt, clcigd.SEQ 
FROM Custom_Lake_Cumber_Import_Guarantor_Data clcigd
WHERE clcigd.GuarantorLastName <> ''

--Insurance
SELECT clciid.RecType, clciid.PatientMRN, clciid.CaseIDNumber, clciid.InsOrderIndicator, clciid.InsCarrierName, clciid.InsClaimOfficeAddr1, clciid.InsClaimOfficeAddr2
	 , clciid.InsClaimOfficeCity, clciid.InsClaimOfficeState, clciid.InsClaimOfficeZip, clciid.InsClaimOfficePhoneNum, clciid.InsGroupName, clciid.InsGroupNum, clciid.SuscriberID
	 , clciid.SubscriberRelationship, clciid.SubscriberFirstName, clciid.SubscriberLastName, clciid.SubscriberMiddle, clciid.SubscriberSuffix, clciid.SubscriberDOB, clciid.SubscriberSex
	 , clciid.SubscriberSSN, clciid.SEQ 
FROM Custom_Lake_Cumber_Import_INS_Data clciid
WHERE clciid.InsCarrierName <> ''

--Charges
SELECT clcicd.RecType, clcicd.PatientMRN, clcicd.ParrentLineItemNum, clcicd.CaseIDNum, clcicd.ChargeTransDate, clcicd.ChargeCPTHPSCode, clcicd.ChargeProcDescript
	 , clcicd.OriginalChargeAmt, clcicd.CurrentBalDueforCharge, clcicd.CurrentRespPartyCode, clcicd.ChargeUnits, clcicd.ChargeRevenueCode, clcicd.ChargeMod1, clcicd.ChargeMod2
	 , clcicd.ChargeMod3, clcicd.ChargeMod4, clcicd.ChargeDiagCode1, clcicd.ChargeDiagCode2, clcicd.ChargeDiagCode3
	 , clcicd.ChargeDiagCode4, clcicd.EntFacilityName, clcicd.ChargePhysicianFirstName, clcicd.ChargePhysicianLastName, clcicd.ChargePhsicianMiddle, clcicd.ChargePhysicianSuffix, clcicd.SEQ 
FROM Custom_Lake_Cumber_Import_Charges_Data clcicd 

-- Adjustments
SELECT clciad.RecType, clciad.PatientMRN, clciad.LineItemOrder, clciad.ParentTransLineItemOrdNumber, clciad.CaseIDNumber, clciad.TransactionType, clciad.TransactionDate
	 , clciad.TransactionAmount, clciad.TransactionCode, clciad.TransactionRecvdFromPartyName, clciad.TransactionRecvdFromPartyOrd, clciad.SEQ
FROM Custom_Lake_Cumber_Import_Adjust_Data clciad 
END

GO
