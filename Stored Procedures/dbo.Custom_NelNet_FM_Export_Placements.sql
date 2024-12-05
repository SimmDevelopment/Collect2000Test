SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 09/20/2024
-- Description:	Create Placement file of accounts not yet loaded and accounts to be reopened.  Reopened accounts have phone numbers deduped.
-- Changes:		
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NelNet_FM_Export_Placements] 

AS
BEGIN

	SET NOCOUNT ON;


SELECT  cnnfmf.SystemNumber
	  , cnnfmf.AccountNumber
	  , cnnfmf.CurrentCreditor
	  , cnnfmf.PrimaryFirstName
	  , cnnfmf.PrimaryMiddleName
	  , cnnfmf.PrimaryLastName
	  , cnnfmf.CoborrowerFirstName
	  , cnnfmf.CoborrowerMiddleName
	  , cnnfmf.CoborrowerLastName
	  , CASE WHEN cnnfmf.PrimaryWorkPhone IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryWorkPhone END AS PrimaryWorkPhone
	  , CASE WHEN cnnfmf.PrimaryPhone IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone END AS PrimaryPhone
	  , CASE WHEN cnnfmf.PrimaryPhone IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhoneType END AS PrimaryPhoneType
	  , CASE WHEN cnnfmf.PrimaryPhone2 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone2 END AS PrimaryPhone2
	  , CASE WHEN cnnfmf.PrimaryPhone2 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone2Type END AS PrimaryPhone2Type
	  , CASE WHEN cnnfmf.PrimaryPhone3 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone3 END AS PrimaryPhone3
	  , CASE WHEN cnnfmf.PrimaryPhone3 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone3Type END AS PrimaryPhone3Type
	  , CASE WHEN cnnfmf.PrimaryPhone4 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone4 END AS PrimaryPhone4
	  , CASE WHEN cnnfmf.PrimaryPhone4 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone4Type END AS PrimaryPhone4Type
	  , CASE WHEN cnnfmf.PrimaryPhone5 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone5 END AS PrimaryPhone5
	  , CASE WHEN cnnfmf.PrimaryPhone5 IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.PrimaryPhone5Type END AS PrimaryPhone5Type
	  , cnnfmf.PrimaryEmail
	  , CASE WHEN cnnfmf.CoborrowerWorkPhone IN (SELECT phonenumber FROM Phones_Master pm WHERE pm.Number = M.number) THEN '' ELSE cnnfmf.CoborrowerWorkPhone END AS CoborrowerWorkPhone
	  , cnnfmf.CoborrowerEmail
	  , cnnfmf.CurrentBalance
	  , cnnfmf.LastStatementDate
	  , cnnfmf.InterestAccruedsinceLastStatementdate
	  , cnnfmf.FeesAccruedsinceLastStatementdate
	  , cnnfmf.PaymentsCreditssincelaststatementdate
	  , cnnfmf.CreditLine
	  , cnnfmf.Int_Rate
	  , cnnfmf.CurrentPaymentDue
	  , cnnfmf.CurrentPaymentDueDate
	  , cnnfmf.TotalAmountDelinquent
	  , cnnfmf.DaysDelinquent
	  , cnnfmf.DateLastPayment
	  , cnnfmf.AmountLastPayment
	  , cnnfmf.PrimaryAddress1
	  , cnnfmf.PrimaryAddress2
	  , cnnfmf.PrimaryCity
	  , cnnfmf.PrimaryState
	  , cnnfmf.PrimaryZipCode
	  , cnnfmf.CoBAddress1
	  , cnnfmf.CoBAddress2
	  , cnnfmf.CoBCity
	  , cnnfmf.CoBState
	  , cnnfmf.CoBZipCode
	  , cnnfmf.PriSSN
	  , cnnfmf.CoBSSN
	  , cnnfmf.OpenDate
	  , cnnfmf.Del1CycleAmt
	  , cnnfmf.Del2CycleAmt
	  , cnnfmf.Del3CycleAmt
	  , cnnfmf.Del4CycleAmt
	  , cnnfmf.Del5CycleAmt
	  , cnnfmf.Del6CycleAmt
	  , cnnfmf.Del7CycleAmt
FROM Custom_NelNet_FM_Main_File cnnfmf WITH (NOLOCK) LEFT OUTER	JOIN MASTER M WITH (NOLOCK) ON cnnfmf.AccountNumber = M.account and customer = '0003114'
where cnnfmf.AccountNumber NOT IN (select account from master m WITH (NOLOCK) WHERE customer = '0003114' and closed IS null)

END
GO
