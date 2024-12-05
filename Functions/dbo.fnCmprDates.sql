SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[fnCmprDates] (@input1 varchar(23), @input2 varchar(23))
returns datetime
as
begin
	declare @date1 datetime, @date2 datetime
	select @date1 = dbo.fnscrbdt(@input1)
	select @date2 = dbo.fnscrbdt(@input2)
	return (
		case when isnull(@date1,'1/1/1900')>isnull(@date2,'1/1/1900') then @date1
			 when isnull(@date2,'1/1/1900')>isnull(@date1,'1/1/1900') then @date2
			 when isnull(@date1,'1/1/1900')=isnull(@date2,'1/1/1900') and @date1 is not null then @date1	
			 else null 
		end
		)

end

GO
