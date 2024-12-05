SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_BrighTree_Export_Placement] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  DISTINCT 'A' AS RecType, CollectionType , CreditBureau , DebtorIdent , CreditorIdent , CreditorName , CreditorAddress1 , CreditorAddress2 , CreditorCity , CreditorState , 
		CreditorPostalCode , CreditorPhone , CreditorContactFirstName , CreditorContactLastName , CreditorContactPhone , CreditorContactExtension , 
		CreditorContactFax , CreditorContactEmail , PatientAccountNo , PatientFirstName , PatientLastName , PatientBirthDate , RSPBusinessName , RSPFirstName , 
		RSPLastName , RSPAddr1 , RSPAddr2 , RSPCity , RSPState , RSPPostalCode , RSPSSN , RSPPhone , EmployerName , EmployerPhone , SpouseFirstName , SpouseLastName , 
		SpouseSSN , SpouseEmployer , SpouseEmployerPhone , RelativeName , RelativePhone , EmergencyContact , EmergencyContactPhone, OriginalAmount , LateFee , 
		TotalDue
FROM Custom_BrighTree_Import_NewBiz_File cbtinbf WITH (NOLOCK)



SELECT  'I' AS RecType, CollectionType , DebtorIdent , Note1 , Note2 , InsuranceName1 , InsuranceName2 , InsuranceName3 , ServiceDate , InvoiceDate , 
		ServiceAmount , ServiceDesc , InvoiceNo , BalanceDue , LastPayDate
FROM Custom_BrighTree_Import_NewBiz_File cbtinbf WITH (NOLOCK)
ORDER BY InvoiceDate

END
GO
