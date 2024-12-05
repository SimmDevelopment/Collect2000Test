SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Klarna_WebBank_Export_Closed]
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(5000),
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
SELECT account AS [Account_Number],d.firstName AS [FIRST_Name],d.lastName AS [Last_Name], CONVERT(VARCHAR(10), m.received,101) AS [Placement_Date],
s.Description AS [Closure_Reason], m.Closed,m.customer
FROM master m WITH (NOLOCK) INNER JOIN status s WITH (NOLOCK) ON m.status = s.code
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number
WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND closed BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND status NOT IN ('sif', 'pif')
ORDER BY m.received

END
GO
