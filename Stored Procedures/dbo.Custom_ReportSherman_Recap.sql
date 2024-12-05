SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 02/01/2007  SG
-- Description:	
-- =============================================
/*
Exec Custom_ReportSherman_Recap @startDate='20050101',@endDate='20060130',@customer='Arrow'
*/
CREATE  PROCEDURE [dbo].[Custom_ReportSherman_Recap]
	-- Add the parameters for the stored procedure here
	@startDate as DateTime,
	@endDate as DateTime,
	@customer as varchar(8000)
AS
BEGIN
	SET NOCOUNT ON;

	/*==================================================================================
		Fields that need to be filled out correctly
	====================================================================================*/
	Declare @agencyName as varchar(100)
	Declare @agencyAddress1 as varchar(300)
	Declare @agencyAddress2 as varchar(300)
	Declare @today as DateTime
	Declare @vendorInvoiceNum varchar(100)	--*** Update

	set @agencyName='SIMM Associates Inc'
	set @agencyAddress1='800 Pencader Drive'
	set @agencyAddress2='Newark, DE 19702'
	set @today = GETDATE()
	set @vendorInvoiceNum='Sherm'


	/*==================================================================================
		Fields that do NOT need to be changed!
	====================================================================================*/
	Declare @activityDateString as varchar(300)
	Declare @formattedStartDate as varchar(100)
	Declare @formattedEndDate as varchar(100)
	
	Set @formattedStartDate = Convert(varchar(300),@startDate,1)
	Set @formattedEndDate = Convert(varchar(300),@endDate,1)

	Select '' as [Recap Report Illustration],'' as[ ]	--to make the heading
	union all
	Select 'Agency Name',			@agencyName
	union all
	Select 'Agency Address',		@agencyAddress1
	union all	
	Select '',						@agencyAddress2
	union all
	Select '',''
	union all
	Select 'Activity Date for',		@formattedStartDate + '  to  ' + @formattedEndDate
	union all
	Select 'Vendor Invoice number',	@vendorInvoiceNum	
	union all
	Select '',''
	union all
	Select 'Prepared for',''
	union all
	Select 'Resurgent Capital Services L.P.',''
	union all
	Select '15 S. Main St, Suite 500',''
	union all
	Select 'Greenville, SC 29601',''
	union all
	Select '',''
	
			
	/*==================================================================================
		Second section of the report
	====================================================================================*/
	--Create the temp table to contain the summary info
	DECLARE @PaymentSummary TABLE (
	[ID] INTEGER IDENTITY (1, 1) NOT NULL,
	[PaymentType]	varchar(100) NOT NULL,
	[NumPayments]	Integer NOT NULL,
	[PaymentSum]	money NOT NULL,
	[CommissionSum]	money NOT NULL
	);
	Declare @paymentAgencyStr varchar(100)
	Declare @misappliedPaymentStr varchar(100)
	Set @paymentAgencyStr = 'Payment to Agency'
	Set @misappliedPaymentStr = 'Misapplied Payment'

	Insert into @PaymentSummary([PaymentType],[NumPayments],[PaymentSum],[CommissionSum])
	Select	
			@paymentAgencyStr,
			Count(*),						--num payments
			Sum(isnull(dbo.Custom_CalculatePaymentTotalPaid(ph.uid),0)),		
			Sum(isnull(dbo.Custom_CalculatePaymentTotalFee(ph.uid),0))			
		From PayHistory ph
		where ph.customer in (select string from dbo.CustomStringToSet(@customer,'|')) and ph.entered between @startDate and @endDate
		and ph.batchtype in ('PA','PU')
		Group by ph.batchtype

		Declare @numTranzPA int
		Declare @numTranzMisapplied int
		Declare @grossPA money
		Declare @grossMisapplied money
		Declare @commissionPA as money
		Declare @commissionMisapplied as money		

		Select	@numTranzPa = [NumPayments], 
				@grossPA = [PaymentSum],
				@commissionPa = [CommissionSum]
		From @PaymentSummary where PaymentType=@paymentAgencyStr

		Select	@numTranzMisapplied = isnull([NumPayments],0), 
				@grossMisapplied = isnull([PaymentSum],0),
				@commissionMisapplied = isnull([CommissionSum],0)
		From @PaymentSummary Where PaymentType=@misappliedPaymentStr


		--Now lets select this data in the correct format
		Select	@paymentAgencyStr	as [Payment],
				@numTranzPa			as [# of Transactions],
				@grossPA			as [Gross],
				@commissionPA		as [Expected commission]
		union all
		Select	@misappliedPaymentStr,
				isnull(@numTranzMisapplied,0),
				isnull(@grossMisapplied,0),
				isnull(@commissionMisapplied,0)
		union all
		Select	'Net payments',
				(@numTranzPa + isnull(@numTranzMisapplied,0)),
				@grossPa - isnull(@grossMisapplied,0),
				@commissionPA - isnull(@commissionMisapplied,0)
		
		/*==========================================
			NSF Section
			With Latitude there is no notion of a 'mis-applied' payment so we leave those values 0
		============================================*/
		DECLARE @NSFSummary TABLE (
			[ID] INTEGER IDENTITY (1, 1) NOT NULL,
			[PaymentType]	varchar(100) NOT NULL,
			[NumPayments]	Integer NOT NULL,
			[PaymentSum]	money NOT NULL,
			[CommissionSum]	money NOT NULL
		);
		Declare @nsfPaymentAgencyStr varchar(100)
		Set @nsfPaymentAgencyStr = 'Returned checks to the agency'		

		Declare @nsfNumTranzPA int
		Declare @nsfGrossPA money
		Declare @nsfCommissionPA as money
		
		Insert into @NSFSummary([PaymentType],[NumPayments],[PaymentSum],[CommissionSum])
		Select
			@nsfPaymentAgencyStr,
			isnull(Count(*),0),						--num payments
			isnull(Sum(isnull(dbo.Custom_CalculatePaymentTotalPaid(ph.uid),0)),0),		
			isnull(Sum(isnull(dbo.Custom_CalculatePaymentTotalFee(ph.uid),0)),0)		
		From PayHistory ph
		where ph.customer in (select string from dbo.CustomStringToSet(@customer,'|')) and ph.entered between @startDate and @endDate
		and ph.batchtype in ('PUR','PAR')
		--Group by ph.batchtype


		Select	@nsfNumTranzPA = isnull([NumPayments],0), 
				@nsfGrossPA = isnull([PaymentSum],0),
				@nsfCommissionPA = isnull([CommissionSum],0)
		From @NSFSummary where PaymentType=@nsfPaymentAgencyStr

		--Now lets select this data in the correct format
		Select	@nsfPaymentAgencyStr	as [Payment],
				@nsfNumTranzPA			as [# of Transactions],
				@nsfGrossPA				as [Gross],
				@nsfCommissionPA		as [Expected commission]
		From @NSFSummary Where PaymentType=@nsfPaymentAgencyStr
		union all
		Select	'Misapplied NSF',
				0,
				0.0,
				0.0
		union all
		Select	'True NSF returned checks',
				@nsfNumTranzPA,
				@nsfGrossPA,
				@nsfCommissionPA

	

	/*====================================================================
		Summary section
	======================================================================*/
	Declare @totalNumTranz int
	Declare @totalPayments money
	Declare @totalCommission money

	Set @totalNumTranz = isnull(@numTranzPA,0) + isnull(@numTranzMisapplied,0) + isnull(@nsfNumTranzPA,0)
	Set @totalPayments = (isnull(@grossPA,0) + isnull(@grossMisapplied,0)) - isnull(@nsfGrossPA,0);
	Set @totalCommission = (isnull(@commissionPA,0) - isnull(@commissionMisapplied,0)) - isnull(@nsfCommissionPA,0)

	Select	'Total # of Transactions'	as [ ],
			@totalNumTranz				as [  ],
			null							as [   ]
	union all
	Select	'Total Wire from Agency',
			null,
			@totalPayments
	union all
	Select	'Total Expected Commission from Resurgent',
			null,
			@totalCommission
END






GO
