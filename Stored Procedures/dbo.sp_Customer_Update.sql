SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_Customer_Update*/
CREATE     PROCEDURE [dbo].[sp_Customer_Update]
(
	@CustomerID int, 
	@Code varchar(7),
	@Status varchar(8),
	@CustomerName varchar(100),
	@Street1 varchar(30),
	@Street2 varchar(30),
	@City varchar(20),
	@State varchar(3),
	@ZipCode varchar(10),
	@Contact varchar(30),
	@Phone varchar(20),
	@LetterCode  varchar(75),
	@BadCheck money,
	@BankCode varchar(100),
	@BankId int,
	@SalesmanCode varchar(30),
	@SifInfo text,
	@WorkInfo text,
	@MiscInfo text,
	@InvoiceType varchar(20),
	@InvoiceFreq varchar(20),
	@InvoiceSort varchar(20),
	@InvoiceMethod varchar(20),
	@FaxNumber varchar(30),
	@AmtDueClient smallint,
	@COB varchar(50),
	@RemitMethod varchar(5),
	@CustGroup varchar(7),
	@CheckHoldDays smallint,
	@InvShowRcvd bit,
	@InvShowBal bit,
	@CCostPct float,
	@CCostBucket tinyint,
	@FeeSchedule varchar(5),
	@LegalFeeSchedule varchar(5),
	@IsPodCust bit,
	@Email varchar(100),
	@ShowReverseOfDate bit,
	@AlphaCode varchar(50),
	@Sweep bit,
	@SweepDays int,
	@SweepDaysPaid int,
	@SweepMinBalance money,
	@SweepDesk varchar(10),
	@DefaultDesk varchar(10),
	@CustomDate1 datetime,
	@CustomDate2 datetime,
	@CustomDate3 datetime,
	@CustomDate4 datetime,
	@CustomDate5 datetime,
	@CustomDate6 datetime,
	@CustomDate7 datetime,
	@CustomDate8 datetime,
	@CustomDate9 datetime,
	@CustomOption1 bit,
	@CustomOption2 bit,
	@CustomOption3 bit,
	@CustomOption4 bit,
	@CustomOption5 bit,
	@CustomOption6 bit,
	@CustomOption7 bit,
	@CustomOption8 bit,
	@CustomOption9 bit,
	@CustomValue1 int,
	@CustomValue2 int,
	@CustomValue3 int,
	@CustomValue4 int,
	@CustomValue5 int,
	@CustomValue6 int,
	@CustomValue7 int,
	@CustomValue8 int,
	@CustomValue9 int,
	@CustomText1 varchar(500),
	@CustomText2 varchar(500),
	@CustomText3 varchar(500),
	@CustomText4 varchar(500),
	@CustomText5 varchar(500),
	@BlanketSif float,
	@LetterDeliveryMethod int,
	@IsPrincipleCust bit,
	@InvShowOther bit,
	@AcknowledgeNewBiz bit,
	@DefaultInterest float,
	@CollectorFeeSchedule varchar(5),
	@CbrAccountType char(2),
	@CbrCreditorClass char(2),
	@CbrOriginalCreditor varchar(30),
	@FreeDemandDays tinyint,
	@FreeDemandBatchTypes tinyint,
	@FeeCapAmount money,
	@FeeCapPercent real,
	@InvoiceReport varchar(120),
	@Priority tinyint = 5,
	@LatitudeUser varchar(256),
	@PermitSurcharge bit
)
AS

-- Name:		sp_Customer_Update
-- Function:		This procedure will update a customer in Customer table
-- 			using input parameters.
-- Creation:		6/17/2002 jc
--			Used by class CCustomerFactory. 
-- Change History:
--			6/18/2002 jc added field alphacode to database revised sp
--			10/22/2002 jc added field DefaultDesk to database revised sp
--			1/6/2003 jc resized @LetterCode from varchar(30) to varchar(75)
--			2/24/2003 jc added field CbrAcctRtnSendDel
--			2/24/2003 jc added custom fields CustomDate1-9, CustomOption1-9, CustomValue1-9
--			5/15/2003 jc added field LegalFeeSchedule
--			9/5/2003 jc added field BlanketSif
--			9/19/2003 jc added field LetterDeliveryMethod
--			11/17/2003 jc increased parm @Email from varchar(30) to varchar(100)
--			12/4/2003 jc added field IsPrincipleCust
--			01/16/2004 jc increased parm @@BankCode from varchar(30) to varchar(100)
--			01/23/2004 jc added custom fields CustomText1-5
--			7/3/2003 jc changed updated to use input parm @CustomerID instead of @Code
--			5/28/2004 jc added field bankid
--			7/1/2004 jc added fields InvShowOther, AcknowledgeNewBiz, DefaultInterest
--			10/29/2004 jc added field CollectorFeeSchedule
--			7/8/2005 jc removed parms @CbrRptType varchar(50), @CbrClass varchar(40), @CbrMinBal money, @CbrWaitDays int, 
--			@CbrAcctRtnSendDel bit, @UseEquifax bit, @UseTransUnion bit, @UseExperian bit, @UseInnovis bit
--			added new parms @CbrAccountType char(2), @CbrCreditorClass char(2), @CbrOriginalCreditor varchar(30)
--			4/20/06 MDD - Added @FreeDemandDays, @FeeCapAmount money, @FeeCapPercent, @InvoiceReport, @LatitudeUser
--			7/23/2010 tjl Removed cbrAccountType, cbrCreditorClass and CbrOriginalCreditor from Update
    BEGIN TRAN
	IF ISNULL(@LatitudeUser, suser_sname()) = '' 
		Select @LatitudeUser = suser_sname()
	ELSE
		Select @LatitudeUser = @LatitudeUser
	
	UPDATE Customer 
		SET status = @Status,
		Name = @CustomerName,
		Street1 = @Street1,
		Street2 = @Street2,
		City = @City,
		State = @State,
		Zipcode = @ZipCode,
		Contact = @Contact,
		phone = @Phone,
		lettercode = @LetterCode,
		badcheck = @BadCheck,
		bankcode = @BankCode,
		bankid = @BankId,
		salesmancode = @SalesmanCode,
		sifinfo = @SifInfo,
		workinfo = @WorkInfo,
		miscinfo = @MiscInfo,
		invoicetype = @InvoiceType,
		invoicefreq = @InvoiceFreq,
		invoicesort = @InvoiceSort,
		invoicemethod = @InvoiceMethod,
		FaxNumber = @FaxNumber,
		AmtDueClient = @AmtDueClient,
		cob = @COB,
		RemitMethod = @RemitMethod,
		CustGroup = @CustGroup,
		CheckHoldDays = @CheckHoldDays,
		InvShowRcvd = @InvShowRcvd,
		InvShowBal = @InvShowBal,
		CCostPct = Round(@CCostPct,4),
		CCostBucket = @CCostBucket,
		FeeSchedule = @FeeSchedule,
		LegalFeeSchedule = @LegalFeeSchedule,
		IsPODCust = @IsPodCust,
		eMail = @Email,
		ShowReverseofDate = @ShowReverseOfDate,
		AlphaCode = @AlphaCode,
		Sweep = @Sweep,
		SweepDays = @SweepDays,
		SweepDaysPaid = @SweepDaysPaid,
		SweepMinBalance = @SweepMinBalance,
		SweepDesk = @SweepDesk,
		DefaultDesk = @DefaultDesk,
		CustomDate1 = @CustomDate1,
		CustomDate2 = @CustomDate2,
		CustomDate3 = @CustomDate3,
		CustomDate4 = @CustomDate4,
		CustomDate5 = @CustomDate5,
		CustomDate6 = @CustomDate6,
		CustomDate7 = @CustomDate7,
		CustomDate8 = @CustomDate8,
		CustomDate9 = @CustomDate9,
		CustomOption1 = @CustomOption1,
		CustomOption2 = @CustomOption2,
		CustomOption3 = @CustomOption3,
		CustomOption4 = @CustomOption4,
		CustomOption5 = @CustomOption5,
		CustomOption6 = @CustomOption6,
		CustomOption7 = @CustomOption7,
		CustomOption8 = @CustomOption8,
		CustomOption9 = @CustomOption9,
		CustomValue1 = @CustomValue1,
		CustomValue2 = @CustomValue2,
		CustomValue3 = @CustomValue3,
		CustomValue4 = @CustomValue4,
		CustomValue5 = @CustomValue5,
		CustomValue6 = @CustomValue6,
		CustomValue7 = @CustomValue7,
		CustomValue8 = @CustomValue8,
		CustomValue9 = @CustomValue9,
		CustomText1 = @CustomText1,
		CustomText2 = @CustomText2,
		CustomText3 = @CustomText3,
		CustomText4 = @CustomText4,
		CustomText5 = @CustomText5,
		BlanketSif = @BlanketSif,
		LetterDeliveryMethod = @LetterDeliveryMethod,
		IsPrincipleCust = @IsPrincipleCust,
		InvShowOther = @InvShowOther,
		AcknowledgeNewBiz = @AcknowledgeNewBiz,
		DefaultInterest = Round(@DefaultInterest,4),
		CollectorFeeSchedule = @CollectorFeeSchedule,
		FreeDemandDays = @FreeDemandDays,
		FreeDemandBatchTypes = @FreeDemandBatchTypes,
		FeeCapAmount = @FeeCapAmount,
		FeeCapPercent = @FeeCapPercent,
		InvoiceReport = @InvoiceReport,
		PermitSurcharges = @PermitSurcharge,
		Priority = @Priority,
		UpdatedBy = @LatitudeUser
	WHERE CCustomerID = @CustomerID

    IF (@@error!=0)
    BEGIN
        RAISERROR  ('20001',16,1,'sp_Customer_Update: Cannot update Customer table ')
        ROLLBACK TRAN
        RETURN(1)
    END
    COMMIT TRAN
GO
