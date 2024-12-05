SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE       FUNCTION [dbo].[CustomGetFirstName] (
 @name  varchar(150)
)
RETURNS varchar(150)

AS 
BEGIN
	return ltrim(rtrim(substring(@name,case charindex(',',@name,1) when 0 then 1 else charindex(',',@name,1)+1 end, case charindex(',',@name,1) when 0 then len(@name) else len(@name) - charindex(',',@name,1) end)))

--return @lastname
END
GO
