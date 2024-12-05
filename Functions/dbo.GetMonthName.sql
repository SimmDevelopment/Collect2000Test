SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Returns the month name of the integer
--Do NOT use in a where clause -- SQLServer will not use indexes correctly if you do
CREATE FUNCTION [dbo].[GetMonthName](@inDate int)
RETURNS VARCHAR(20)
AS

BEGIN

RETURN CASE @indate
			WHEN 1 THEN 'January'
			WHEN 2 THEN 'February'
			WHEN 3 THEN 'March'
			WHEN 4 THEN 'April'
			WHEN 5 THEN 'May'
			WHEN 6 THEN 'June'
			WHEN 7 THEN 'July'
			WHEN 8 THEN 'August'
			WHEN 9 THEN 'September'
			WHEN 10 THEN 'October'
			WHEN 11 THEN 'November'
			WHEN 12 THEN 'December'
			end

END
GO
