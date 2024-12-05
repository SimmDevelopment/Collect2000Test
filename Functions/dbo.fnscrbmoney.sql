SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fnscrbmoney] (@input varchar(13))
returns money
as
begin
	return 	(
		 case isnull(isnumeric(@input),0)
			when 1 then cast(@input as money)
			else 0
		 end
		)	
end

GO
