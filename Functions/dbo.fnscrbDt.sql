SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fnscrbDt] (@input varchar(23))
returns datetime
as
begin
	return 	(
		 case isnull(isdate(@input),0)
			when 1 then case
					when datediff(d,cast(@input as datetime),'12/30/1899')=0 then null
					else cast(@input as datetime)
				    end
			else null
		 end
		)	
end

GO
