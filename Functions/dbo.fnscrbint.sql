SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fnscrbint] (@input varchar(13))
returns int
as
begin
	return 	(
		 case isnull(isnumeric(@input),0)
			when 1 then 
				case when charindex('$',@input)=0 then cast(@input as int)
					else 0
				end
			else 0
		 end
		)	
end

GO
