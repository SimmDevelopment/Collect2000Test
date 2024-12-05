SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Credigy_Auto_Export_Placement_File]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  FILEDATE ,
        CUSTOMER_NUMBER ,
        PS_ACCT_NO ,
        LAST_NAME ,
        FIRST_NAME ,
        CONTRACT_DATE ,
        ORIGINAL_NOTE_AMOUNT ,
        DOWN_PMT_AMT ,
        AMOUNT_FINANCED ,
        PAYMENT_AMOUNT ,
        APR ,
        TERM ,
        TERM_PAID ,
        EXTENSIONS_GRANTED ,
        TERM_REMAINING ,
        FIRST_DUE_DATE ,
        LAST_PAY_DATE ,
        NEXT_DUE_DATE ,
        MATURITY_DATE ,
        COLLATERAL_YEAR ,
        COLLATERAL_MAKE ,
        COLLATERAL_MODEL ,
        COLLATERAL_VIN ,
        PROVIDED_MILEAGE ,
        CURRENT_BALANCE ,
        CUSTOMER_SSN ,
        CUSTOMER_FICO ,
        CUSTOMER_DOB ,
        CUSTOMER_ADDRESS ,
        CUSTOMER_CITY ,
        CUSTOMER_STATE ,
        CUSTOMER_ZIP ,
        CUSTOMER_HOME_PHONE ,
        CUSTOMER_WORK_PHONE ,
        CUSTOMER_OTHER_PHONE ,
        COBUYER_FIRST_NAME ,
        COBUYER_MIDDLE_NAME ,
        COBUYER_LAST_NAME ,
        COBUYER_SSN ,
        COBUYER_DOB ,
        COBUYER_ADDRESS ,
        COBUYER_CITY ,
        COBUYER_STATE ,
        COBUYER_ZIP ,
        COBUYER_HOME_PHONE ,
        COBUYER_WORK_PHONE ,
        COBUYER_OTHER_PHONE ,
        LOAN_GROUP ,
        DEALER_NAME ,
        RECOURSE_PMTS ,
        RECOURSE_PERIOD ,
        LOAN_STATUS ,
        ACCOUNT_STATUS ,
        ACCOUNT_STATUS_DESCR ,
        DPD ,
        DELQ_BUCKET ,
        GPS_DEVICE_ID ,
        INTERNAL_SCORE ,
        CREDIT_SCORE ,
        PRINCIPAL_PTD ,
        INTEREST_PTD ,
        PAYMENT_FREQ ,
        INTEREST_METHOD ,
        BULK_OR_POS ,
        TITLE_STATUS ,
        MONTHLY_INCOME ,
        LTV ,
        DTI ,
        PTI ,
        DATE_CHARGED_OFF ,
        PRINCIPAL_CHARGED_OFF ,
        INTEREST_CHARGED_OFF ,
        FEES_CHARGED_OFF ,
        REASON_NO_STMT ,
        MTD_INT_ACCRUED ,
        MTD_PAID_AHEAD ,
        MTD_PAID_IN_FULL ,
        REPO_DATE ,
        REPO_TYPE ,
        SOLD_DATE ,
        TOTAL_CURRENT_DUE_BALANCE ,
        OFR_DATE ,
        OFR_DATE_REMOVED ,
        NEXT_PRIN_PMT_DATE ,
        INT_ACCRUED_THRU_DATE ,
        MISC_FEE ,
        RECON_FEE ,
        SALE_FEE ,
        REPO_FEE ,
        CURRENT_INTEREST_BALANCE ,
        CURRENT_FEES_BALANCE ,
        CURRENT_LATE_CHARGE_BALANCE ,
        CURRENT_PAYOFF_BALANCE
FROM Custom_Credigy_Auto_Maint_Import ccami WITH (NOLOCK)
WHERE CUSTOMER_NUMBER NOT IN (SELECT account FROM master m WITH (NOLOCK)
WHERE customer = '0001041' AND (closed IS NULL OR status IN ('pif', 'sif', 'cnd', 'cad', 'lcp', 'rsk', 'aty', 'lit', 'fcd', 'dec', 'bky', 'b07', 'b11', 'b13')))

END
GO
