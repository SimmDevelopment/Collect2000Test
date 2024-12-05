SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE         FUNCTION [dbo].[Custom_CalculatePaymentTotalFee] 
	(
		@uid int
	)
returns money
as
	begin
-- declare @uid int
-- set @uid = 262589
		declare @payment money
		declare @flags varchar(10),@fee1 money,@fee2 money,@fee3 money,@fee4 money,@fee5 money,@fee6 money,@fee7 money,@fee8 money,@fee9 money,@fee10 money
		select @flags = invoiceflags 
			,@fee1 = fee1
			,@fee2 = fee2
			,@fee3 = fee3
			,@fee4 = fee4
			,@fee5 = fee5
			,@fee6 = fee6
			,@fee7 = fee7
			,@fee8 = fee8
			,@fee9 = fee9
			,@fee10 = fee10
			,@payment = 0
		from payhistory where uid = @uid
		if(substring(@flags,1,1) = 1)
			set @payment = @payment + isnull(@fee1,0)
		if(substring(@flags,2,1) = 1)
			set @payment = @payment + isnull(@fee2,0)
		if(substring(@flags,3,1) = 1)
			set @payment = @payment + isnull(@fee3,0)
		if(substring(@flags,4,1) = 1)
			set @payment = @payment + isnull(@fee4,0)
		if(substring(@flags,5,1) = 1)
			set @payment = @payment + isnull(@fee5,0)
		if(substring(@flags,6,1) = 1)
			set @payment = @payment + isnull(@fee6,0)
		if(substring(@flags,7,1) = 1)
			set @payment = @payment + isnull(@fee7,0)
		if(substring(@flags,8,1) = 1)
			set @payment = @payment + isnull(@fee8,0)
		if(substring(@flags,9,1) = 1)
			set @payment = @payment + isnull(@fee9,0)
		if(substring(@flags,10,1) = 1)
			set @payment = @payment + isnull(@fee10,0)
		return @payment
	end

GO
