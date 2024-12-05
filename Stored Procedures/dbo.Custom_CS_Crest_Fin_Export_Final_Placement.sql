SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CS_Crest_Fin_Export_Final_Placement] 
	
AS
BEGIN

Select  LoanIdent , DisplayIdent , Portfolio , LoanNumber , LoanGroup , LoanType , LoanClass1 , LoanClass1Description , RetailerName , Name1 , 
		Name2 , Address1 , Address2 , City , State , Zip , DateOfBirth , TIN1 , TIN2 , Email1 , Email2 , PhoneLabel1 , PhoneNumber1 ,
        PhoneLabel2 , PhoneNumber2 , CoApplicantFirstName , CoApplicantLastName , CoApplicantEmail , CoApplicantPhone , '1' AS RecordType
FROM Custom_CS_Crest_Fin_Section1 WITH (NOLOCK)

Select  LoanIdent , DisplayIdent , Portfolio , LoanNumber , LoanGroup , LoanStatus , SetupDate , MaturityDate , LastActivity , InterestAccruedThrough ,
        InterestPaidThrough , PrincipalPaidThrough , LoanType , InterestType , CurrentRate , TermType , Term , PaymentsMade , PaymentsRemaining ,
        OriginalLoanAmount , PrincipalBalance , InterestBalance , FeesBalance , TotalFees , LateChargesBalance , SuspenseBalance , PerDiem ,
        RegularPayment , LastPaymentAmount , NextPrincipalDueDateToBePaid , NextInterestDueDateToBePaid , LastPaymentDate , BalloonDate , '2' AS RecordType
FROM Custom_CS_Crest_Fin_Section2 WITH (NOLOCK)

Select  LoanIdent , DisplayIdent , PrincipalPaid , InterestPaid , FeesPaid , TotalPaid , '3' AS RecordType
FROM Custom_CS_Crest_Fin_Section3 WITH (NOLOCK)

Select  LoanIdent , DisplayIdent , Name , PhoneNumber , Relationship , PhoneType , '4' AS RecordType
FROM Custom_CS_Crest_Fin_Section4 WITH (NOLOCK)

Select LoanIdent , DisplayIdent , EmployerName , JobTitle , HireDate , PhoneNumber , '5' AS RecordType
FROM Custom_CS_Crest_Fin_Section5 WITH (NOLOCK)

END
GO
