SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Crescent_Recall_File] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account, d.lastName, d.firstName, d.middleName, d.Street1, d.Street2, d.City, d.State, d.Zipcode, d.HomePhone, d.WorkPhone,
d.SSN, m.current1 AS prinbal, m.lastpaidamt, ISNULL(CONVERT(VARCHAR(10), m.lastpaid, 101), '') AS lastpaid, ISNULL(CONVERT(VARCHAR(10), m.ContractDate, 101), '') AS contractdate, 
ISNULL(CONVERT(VARCHAR(10), m.Delinquencydate, 101), '') AS delingdate, ISNULL(CONVERT(VARCHAR(10), m.ChargeOffDate, 101), '') AS ChargeOffDate, '' AS chargeoffamt,
ISNULL(d2.lastName, '') AS colastname, ISNULL(d2.firstName, '') AS cofirstname, ISNULL(d2.HomePhone, '') AS cohomephone, 
ISNULL(d2.WorkPhone, '') AS coworkphone, ISNULL(CONVERT(VARCHAR(10), d.DOB, 101), '') AS dob, ISNULL(CONVERT(VARCHAR(10), m.closed, 101), '') AS closed, '' AS specdata
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d.seq = 1
WHERE customer = '0001055' AND status IN ('rcl', 'ccr') AND dbo.date(closed) between dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
