SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_AppliedCard_Report_PB]
@customer varchar(8000)
AS

SELECT account, deposit Date, amount, 'PB' Type
FROM pdc p INNER JOIN master m
	ON p.number = m.number
WHERE p.Customer = @customer AND p.Active = 1
GO
