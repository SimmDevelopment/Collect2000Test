SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_AppliedCard_Report_PR]
@customer varchar(8000)

AS

SELECT account, DueDate Date, Amount, 'PR' Type
FROM Promises p INNER JOIN master m
	ON p.AcctID = m.number
WHERE p.Customer = @customer AND p.Active = 1
GO
