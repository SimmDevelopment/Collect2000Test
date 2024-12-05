SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 05/05/2023
-- Description:	Export Placement File
-- =============================================
CREATE	 PROCEDURE [dbo].[Custom_Doc2Doc_Export_Placement_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account INTO #accounts
FROM master WITH (NOLOCK)
		WHERE (closed IS NULL OR status IN ('pif', 'sif', 'cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd', 'dec', 'bky', 'b07', 'b11', 'b13','ooc'))
		AND customer IN ('0003118')
			   
SELECT  FileDate AS FileDate, ServicerAccountNumber , ServicerSubAccountNumber , Servicer , 
		Entity , SubEntity , GS2AccountNumber , AltLoanID , LoanType , Principal_Balance_Outstanding , Interest_Balance_Outstanding ,
		Fees_Balance_Outstanding , Total_Balance_Outstanding , TotalAmountDue , InterestRate , OriginationDate , LastPaymentDate , 
		LastPaymentAmount , DelinquencyDate , DaysDelinquent , ScheduledPaymentAmount , GraduationDate , DefermentMonthsAvailable , 
		deferementtypesavailable AS DefermentTypesAvailable , ForbearanceMonthsAvailable , LastForbearanceEndDate , CloseReason , ReOpenReason , OriginalSchoolName , 
		LastSchoolName , BorrowerBenefitFlag , RepaymentPlan , Guarantor , Offer1 , Offer2 , Offer3 , InternationalBorrowerFlag , 
		BorrowerSSN , BorrowerDOB , BorrowerFirstName , BorrowerMiddleName , BorrowerLastName , BorrowerSuffix , BorrowerValidAddressFlag , 
		BorrowerAddress1 , BorrowerAddress2 , BorrowerCity , (SELECT code FROM states WITH (NOLOCK) WHERE description = BorrowerState) AS BorrowerState, BorrowerZip , BorrowerHomePhone , BorrowerWorkPhone , BorrowerCellPhone ,
        BorrowerOtherPhone , BorrowerEmail1 , BorrowerEmail2 , BorrowerLexisNexisFlag , CoBorrower1SSN , CoBorrower1DOB , CoBorrower1FirstName ,
        CoBorrower1MiddleName , CoBorrower1LastName , CoBorrower1Suffix , CoBorrower1ValidAddressFlag , CoBorrower1Address1 , CoBorrower1Address2 ,
        CoBorrower1City , CoBorrower1State , CoBorrower1Zip , CoBorrower1HomePhone , CoBorrower1WorkPhone , CoBorrower1CellPhone ,
        CoBorrower1OtherPhone , CoBorrower1Email1 , CoBorrower1Email2 , CoBorrower1LexisNexisFlag , CoBorrower2SSN , CoBorrower2DOB ,
        CoBorrower2FirstName , CoBorrower2MiddleName , CoBorrower2LastName , CoBorrower2Suffix , CoBorrower2ValidAddressFlag ,
        CoBorrower2Address1 , CoBorrower2Address2 , CoBorrower2City , CoBorrower2State , CoBorrower2Zip , CoBorrower2HomePhone , 
        CoBorrower2WorkPhone , CoBorrower2CellPhone , CoBorrower2OtherPhone , CoBorrower2Email1 , CoBorrower2Email2 , CoBorrower2LexisNexisFlag ,
        Reference1FirstName , Reference1MiddleName AS Reserence1MiddleName, Reference1LastName , Reference1Suffix , Reference1Address1 , Reference1Address2 ,
        Reference1City , Reference1State , Reference1Zip , Reference1HomePhone , Reference1WorkPhone , Reference1CellPhone , Reference1OtherPhone ,
        Reference1Email1 , Reference1Email2 , Reference2FirstName , Reference2MiddleName , Reference2LastName , Reference2Suffix ,
        Reference2Address1 , Reference2Address2 , Reference2City , Reference2State , Reference2Zip , Reference2HomePhone , Reference2WorkPhone ,
        Reference2CellPhone , Reference2OtherPhone , Reference2Email1 , Reference2Email2 , LoanGroup , LoanGroupid , StatusCodes , FullyAmortizedPaymentAmount , 
        PreDeterminedbalanceafterTaxCredit , Month15ExpirationDate , EntityofInstaller , InstallerPhoneNumber , Commentslatest , CompletionCertificationDate , 
        ShutOffRequestDate , CancelShutOffRequestDate,Payment_Plan , SpecialPaymentPlan , SPPMonthlyPay, BorrowerLanguagePreference, CoBorrowerLanguagePreference,
		ItemizationDate, TotalBalanceOnItemizationDate, PaymentsSinceItemizationDate, InterestAccruedSinceItemizationDate, FeesSinceItemizationDate, CreditsSinceItemizationDate,
		CurrentTotalBalance

        FROM Custom_Doc2Doc_Import_Active_Accounts cgiaa WITH (NOLOCK)
        WHERE ServicerAccountNumber NOT IN (SELECT account FROM #accounts a)

DROP TABLE #accounts

END
GO
