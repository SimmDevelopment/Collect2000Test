SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       FUNCTION [dbo].[AIM_FormatDateYYYYMMDD]
	(
		@date datetime
	)
returns char(8)
as
	begin
		declare @value char(8)
		set @value = '19000101'
		
		if(@date is not null)
		begin
			declare @year char(4)
			declare @month char(2)
			declare @day char(2)
			set @year = cast(year(@date) as char(4))
			
			if(month(@date) < 10)
				begin 
				set @month = '0' + cast(month(@date) as char(1))
				end
			else
				begin
				set @month = cast(month(@date) as char(2))
				end

			if(day(@date) < 10)
				begin 
				set @day = '0' + cast(day(@date) as char(1))
				end
			else
				begin
				set @day = cast(day(@date) as char(2))
				end

			set @value = @year + @month + @day
		end

		return @value
			

	end






GO
