SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Object:  User Defined Function dbo.AIM_PaymentTypeNumber    */
CREATE FUNCTION [dbo].[AIM_PaymentTypeNumber]
	(
		@paymentType varchar(3)
	)
returns int
as
	begin
		declare @paymentTypeNumber int
		select @paymentTypeNumber = 
			case @paymentType
				when 'PU' then 1
				when 'PC' then 2
				when 'DA' then 3
				when 'PA' then 4
				when 'PUR' then 5
				when 'PCR' then 6
				when 'DAR' then 7
				when 'PAR' then 8 
			end
			
		return @paymentTypeNumber
	end


GO
