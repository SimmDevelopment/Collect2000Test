SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCO_NCT_Tert_Recon] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT '38' AS recordcode, m.id1 AS fileno, m.account AS forw_file, '' AS masco_file, 'FAKE INC' AS firm_id, CASE WHEN m.customer = '0001031' THEN 'ANCPM' END AS forw_id,
	CONVERT(VARCHAR(8), m.received, 112) AS dplaced, d.lastname + '/' + d.firstName AS debt_name, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = '01.0.creditor_name') AS cred_name,
	m.current1 AS d1_bal, '' AS idate, '' AS iamt, m.current2 AS idue, ABS(m.paid1 + m.paid2) AS paid, '' AS cost_bal, d.city + ', ' + d.State AS debt_cs,
	d.Zipcode AS debt_zip, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = '01.0.creditor_name2') AS cred_name2,
	fsd.fee1 AS comm, '' AS sfee, d.SSN AS ssn, (SELECT TOP 1 thedata FROM dbo.MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = '06.0.debtor_no') AS debtor_no
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0
	INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	INNER JOIN dbo.FeeSchedules fs WITH (NOLOCK) ON c.FeeSchedule = fs.Code
	INNER JOIN dbo.FeeScheduleDetails fsd WITH (NOLOCK) ON fs.Code = fsd.Code
WHERE m.customer = '0001031' AND m.returned IS NULL

END
GO
