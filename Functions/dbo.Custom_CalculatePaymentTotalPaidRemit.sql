SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/****** Object:  User Defined Function dbo.Custom_CalculatePaymentTotalPaidRemit    Script Date: 10/7/2005 9:00:41 AM ******/
CREATE                FUNCTION [dbo].[Custom_CalculatePaymentTotalPaidRemit]
	(
		@uid int
	)
returns money
as
	begin
		declare @payment money
		declare @flags varchar(10),@paid1 money,@paid2 money,@paid3 money,@paid4 money,@paid5 money,@paid6 money,@paid7 money,@paid8 money,@paid9 money,@paid10 money
		declare @fee1 money, @fee2 money, @fee3 money, @fee4 money, @fee5 money, @fee6 money, @fee7 money, @fee8 money, @fee9 money, @fee10 money, @overpaidamt money
		declare @customer varchar(7), @tax money
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
			,@overpaidamt = overpaidamt
			,@payment = 0
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
			,@customer = customer
			,@tax = tax
		from payhistory p with (nolock) 
		where uid = @uid
		
		if exists(select customer from customer where customer = @customer and invoicemethod = '1 - Net')
		begin
			if(substring(@flags,1,1) = 1)
				set @payment = @payment + isnull(@paid1,0) - isnull(@fee1,0)
			if(substring(@flags,2,1) = 1)
				set @payment = @payment + isnull(@paid2,0) - isnull(@fee2,0)
			if(substring(@flags,3,1) = 1)
				set @payment = @payment + isnull(@paid3,0) - isnull(@fee3,0)
			if(substring(@flags,4,1) = 1)
				set @payment = @payment + isnull(@paid4,0) - isnull(@fee4,0)
			if(substring(@flags,5,1) = 1)
				set @payment = @payment + isnull(@paid5,0) - isnull(@fee5,0)
			if(substring(@flags,6,1) = 1)
				set @payment = @payment + isnull(@paid6,0) - isnull(@fee6,0)
			if(substring(@flags,7,1) = 1)
				set @payment = @payment + isnull(@paid7,0) - isnull(@fee7,0)
			if(substring(@flags,8,1) = 1)
				set @payment = @payment + isnull(@paid8,0) - isnull(@fee8,0)
			if(substring(@flags,9,1) = 1)
				set @payment = @payment + isnull(@paid9,0) - isnull(@fee9,0)
			if(substring(@flags,10,1) = 1)
				set @payment = @payment + isnull(@paid10,0) - isnull(@fee10,0)
		end
		else
		begin
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
		end
		--set @payment = @payment  - @tax
		set @payment = @payment 
		return isnull(@payment, 0)
			
	end


GO
