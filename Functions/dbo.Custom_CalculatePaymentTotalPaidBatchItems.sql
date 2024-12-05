SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create         FUNCTION [dbo].[Custom_CalculatePaymentTotalPaidBatchItems]
	(
		@uid int
	)
returns money
as
	begin
		declare @payment money
		declare @flags varchar(10),@paid1 money,@paid2 money,@paid3 money,@paid4 money,@paid5 money,@paid6 money,@paid7 money,@paid8 money,@paid9 money,@paid10 money
		select @flags = invoiceflags 
			,@paid1 = paid1
			,@paid2 = paid2
			,@paid3 = paid3
			,@paid4 = paid4
			,@paid5 = paid5
			,@paid6 = paid6
			,@paid7 = paid7
			,@paid8 = paid8
			,@paid9 = paid9
			,@paid10 = paid10
			,@payment = 0
		from paymentbatchitems where uid = @uid
		if(substring(@flags,1,1) = 1)
			set @payment = @payment + isnull(@paid1,0)
		if(substring(@flags,2,1) = 1)
			set @payment = @payment + isnull(@paid2,0)
		if(substring(@flags,3,1) = 1)
			set @payment = @payment + isnull(@paid3,0)
		if(substring(@flags,4,1) = 1)
			set @payment = @payment + isnull(@paid4,0)
		if(substring(@flags,5,1) = 1)
			set @payment = @payment + isnull(@paid5,0)
		if(substring(@flags,6,1) = 1)
			set @payment = @payment + isnull(@paid6,0)
		if(substring(@flags,7,1) = 1)
			set @payment = @payment + isnull(@paid7,0)
		if(substring(@flags,8,1) = 1)
			set @payment = @payment + isnull(@paid8,0)
		if(substring(@flags,9,1) = 1)
			set @payment = @payment + isnull(@paid9,0)
		if(substring(@flags,10,1) = 1)
			set @payment = @payment + isnull(@paid10,0)
		return @payment
			

	end








GO
