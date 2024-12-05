SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE      procedure [dbo].[AIM_Payment_ProcessPayment]
(
	 @file_number int
	,@account varchar(30)
	,@agency int
	,@payment_amount money
	,@payment_date datetime
	,@payment_type varchar(3)
	,@paymentbatchnumber int
	,@payment_identifier varchar(30) = null
)
as
begin

	declare @masterNumber int
	declare @current0 money,@currentAgencyId int
	select 	@masterNumber = m.number 
		,@currentAgencyId = r.currentlyplacedagencyid
	from 	master m with (nolock)
		left outer join aim_accountreference r on m.number = r.referencenumber
	where 	m.number = @file_number

	if(@currentAgencyId <> @agency)
	begin
		raiserror ('15004', 16, 1)
		return
	end
		
	-- Validate masterid
	if(@masterNumber is null)
	begin
		declare @accountcount int
		select 	@accountcount = count(*),@masterNumber = max(m.number)
		from	dbo.Master m with (nolock)
		where	m.account = @account
		
		if(@accountcount = 0)
		begin
			raiserror ('15001', 16, 1)
			return
		end
		else if(@accountcount > 1)
		begin
			raiserror ('15001', 16, 1)
			return
		end
	end

	-- For PAR, make sure we've recorded a payment
	declare @paidentifierexists varchar(30)
	if(dbo.AIM_PaymentTypeNumber(@payment_type) = 8)
		begin
			select	@paidentifierexists = paidentifier 
			from 	dbo.PayHistory ph with (nolock)
			where	ph.paidentifier = @payment_identifier
				and ph.aimagencyid = @agency
				
			if(@paidentifierexists is null)
			begin
				raiserror ('15006', 16, 1)
				return
			end
		end
	
	-- Should we extend the recall date?
	declare @paymentExtension int
	select
		@paymentExtension = paymentextensiondays
	from
		AIM_Agency
	where
		agencyid = @agency
		
	if(@paymentExtension > 0)
	begin
		-- Extend the recall date
		update
			AIM_AccountReference
		set
			expectedpendingrecalldate = expectedpendingrecalldate + @paymentExtension
			,expectedfinalrecalldate = expectedfinalrecalldate + @paymentExtension
		from
			AIM_AccountReference ar
		where
			ar.referencenumber = @masterNumber
	end
	
	-- Insert the payment into the payment batch table
	exec AIM_InsertPaymentBatchItem @agency, @paymentbatchnumber, @payment_date, @payment_amount, @payment_type, @file_number, @payment_identifier
		
	-- Add a note
	declare @notelogmessageid int, @notefilenumber int, @notepaymentamount money, @agencyname varchar(50), @notepaymentdate datetime
	select
		@notelogmessageid = 1004
		,@notefilenumber = @file_number
		,@agencyname = a.name
		,@notepaymentamount = @payment_amount
		,@notepaymentdate = @payment_date
	from
		AIM_AccountReference ar
		inner join AIM_Agency a on ar.currentlyplacedagencyid = a.agencyid
	where
		ar.referencenumber = @file_number
	
	exec AIM_AddAimNote @notelogmessageid, @file_number, @notepaymentamount, @agencyname, @agency, @notepaymentdate
	return 
end



GO
