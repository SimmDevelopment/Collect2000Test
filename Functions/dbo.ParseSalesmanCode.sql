SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ParseSalesmanCode](@salesmanCode varchar(30))
RETURNS varchar(30)
AS

BEGIN

	RETURN CASE 
		WHEN @salesmanCode LIKE '%-%' THEN
			LEFT(@salesmanCode, CHARINDEX(' - ', @salesmanCode))
		ELSE
			@salesmanCode
		END

END
GO
