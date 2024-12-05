SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create       FUNCTION [dbo].[CustomGetLastName] (
 @name  varchar(150)
)
RETURNS varchar(150)

AS
BEGIN
Declare @lastname as varchar(150)
return rtrim(ltrim(substring(@name,1,case charindex(',',@name,1) when 0 then len(@name) else charindex(',',@name,1)-1 end)))

--return @lastname
END
GO
