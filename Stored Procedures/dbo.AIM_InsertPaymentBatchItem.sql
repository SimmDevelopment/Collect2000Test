SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    procedure [dbo].[AIM_InsertPaymentBatchItem]
(
	 @agency int
	,@batchnumber int
	,@datepaid datetime
	,@amountpaid money
	,@paymenttype varchar(3)
	,@filenumber int
	,@payment_identifier varchar(30)
)
as
begin
	declare @paymethod varchar(30)
	select @paymethod = 'AIM'

	declare @paymenttypenumber int
	select @paymenttypenumber = dbo.AIM_PaymentTypeNumber(@paymenttype)
	
	insert into dbo.PaymentBatchItems
	(
		 batchnumber
		,datepaid
		,pmttype
		,paid0
		,paymethod
		,filenum
		,aimagencyid
		,entered
		,paidentifier
	)
	values
	(
		 @batchnumber
		,@datepaid
		,@paymenttypenumber
		,@amountpaid
		,@paymethod
		,@filenumber
		,@agency
		,getdate()
		,@payment_identifier
	)
	
	declare @purchasedPortfolioId int
	declare @commissionPercentage float
	select
		@purchasedPortfolioId = purchasedportfolio
		,@commissionpercentage = calculationamount
	from
		master m
		join aim_portfolio p on p.portfolioid = m.purchasedportfolio
		join aim_ledgerdefinition ld on ld.portfolioid = p.portfolioid and ld.ledgertypeid = 14
	where
		number = @filenumber
	if(@purchasedportfolioid is not null and @commissionpercentage > 0)
	begin
		insert into
			aim_ledger
			(
				ledgertypeid
				,credit
				,dateentered
				,portfolioid
				,number
			)
			values
			(
				14
				,@amountpaid * (@commissionpercentage / 100)
				,getdate()
				,@purchasedportfolioid
				,@filenumber
			)
	end
end


GO
