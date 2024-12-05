SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 02/28/2023
-- Description: Will Retrieve Email Stats, Text Message stats and payments entered by payment portal only.
-- Changes:
--				04/03/2023 BGM Updated sub queries for getting number of account and amount of total paid 
--11/30/2023 BGM Added Webportal entries within 5 days and Web portal dollars received within 5 days of email
--12/01/2023 BGM Added code for Num Emails sent and number paid within 5 days of email(commented out)
--12/01/2023 BGM Added new columns Accounts with email addresses and Accounts with email addresses and U.S. Bank provided consent
--12/01/2023 BGM Added code for the new email and email consent columns above.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_Proactive_Email_Text_Old]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @CustGroupID INT
--SET @CustGroupID = @CustGroupID --Production
SET @CustGroupID = 113 --Test	



    -- Insert statements for procedure here
SELECT 'SIMM' AS [Vendor]
, FORMAT(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())), 'M/dd/yy') AS [EOM Date]
--, (SELECT COUNT(*)
--FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
----INNER JOIN DebtorCreditCards dcc WITH (NOLOCK) ON m.number = dcc.Number AND dcc.ApprovedBy = 'payweb' AND CAST(dcc.DateEntered AS DATE) BETWEEN CAST(n.created AS DATE) AND CAST(DATEADD(dd, 5, n.created) AS DATE)
--WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
--AND CAST(n.created AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
--AND user0 = 'iconnect24' AND action = 'eml' AND result = 'eml-ok') AS [Number of emails sent]
, '0' AS [Number of emails sent]
, '0' AS [Number of emails opened]
, '0' AS [Number of email opt outs received]
, '0' AS [Number of bounce backs - Bad address]
--, (SELECT SUM(p.totalpaid)
--FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
--INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number AND batchtype = 'pu'
--WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
--AND CAST(n.created AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
--AND user0 = 'iconnect24' AND action = 'eml' AND result = 'eml-ok' --AND p1.number IS NOT NULL
--AND CAST(p.datepaid AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
--) AS [Number of payments within 5 days of email]
, '0' AS [Number of payments within 5 days of email]
, (SELECT COUNT(DISTINCT m.number)
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number 
INNER JOIN email e WITH (NOLOCK) ON d.DebtorID = e.DebtorId AND e.[Primary] = 1 AND active = 1
WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)) AS [Accounts with email addresses]
, (SELECT COUNT(DISTINCT m.number)
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number 
INNER JOIN email e WITH (NOLOCK) ON d.DebtorID = e.DebtorId AND e.[Primary] = 1 AND active = 1 AND e.ConsentGiven = 1 AND e.ConsentSource LIKE '%US Bank%'
WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)) AS [Accounts with email addresses and U.S. Bank provided consent]
, '0' AS [Number of text messages sent]
, '0' AS [Number of text messages opened]
, '0' AS [Number of text message opt outs received]
, (SELECT count(*) FROM PropensioSiteAccountEvent psae WHERE psae.EventID IN (2,3) AND psae.AccountID IN (SELECT number FROM master m WITH (NOLOCK) WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID))
		AND psae.Occurred BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)) AS [Web portal entries]
, (SELECT (SELECT COUNT(DISTINCT m.number)
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN pdc p WITH (NOLOCK) ON n.number = p.number AND P.ApprovedBy = 'payweb' AND CAST(p.entered AS DATE) BETWEEN CAST(n.created AS DATE) AND CAST(DATEADD(dd, 5, n.created) as DATE)
WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND CAST(n.created AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
AND user0 = 'iconnect24' AND action = 'eml' AND result = 'eml-ok')
+
(SELECT COUNT(DISTINCT m.number)
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN DebtorCreditCards dcc WITH (NOLOCK) ON m.number = dcc.Number AND dcc.ApprovedBy = 'payweb' AND CAST(dcc.DateEntered AS DATE) BETWEEN CAST(n.created AS DATE) AND CAST(DATEADD(dd, 5, n.created) AS DATE)
WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND CAST(n.created AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
AND user0 = 'iconnect24' AND action = 'eml' AND result = 'eml-ok')
) AS [Web portal entries within 5 days of email]
, COUNT(pw.number) AS [Web portal payments]
, (SELECT SUM(p.totalpaid)
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number AND batchtype = 'pu'
WHERE m.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND CAST(n.created AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
AND user0 = 'iconnect24' AND action = 'eml' AND result = 'eml-ok' --AND p1.number IS NOT NULL
AND CAST(p.datepaid AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
AND (p.PostDateUID IN (SELECT pdc.UID FROM pdc pdc WITH (NOLOCK) WHERE pdc.number = m.number AND pdc.ApprovedBy = 'payweb')
OR p.PostDateUID IN (SELECT dcc.ID FROM DebtorCreditCards dcc WITH (NOLOCK) WHERE dcc.Number = m.number AND dcc.ApprovedBy = 'payweb'))) AS [Web Portal dollars received from entries within 5 days of email]
, SUM(pw.totalpaid) AS [Dollars of payment through web portal]
, ISNULL( (SELECT SUM(@@rowcount) FROM (SELECT count(*) AS numaccts FROM pdc p WITH (NOLOCK) WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID) AND ApprovedBy = 'payweb' 
		AND CAST(p.entered AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
		AND (active = 1 OR (active = 0 AND printed = 1)) GROUP BY p.number HAVING COUNT(*) > 1) r), 0) 
		+
		ISNULL( (SELECT SUM(@@rowcount) FROM (SELECT COUNT(*) AS numaccts FROM DebtorCreditCards  p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number 
		WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID) AND ApprovedBy = 'payweb' 
		AND p.DateEntered BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
		AND (p.IsActive = 1 OR (p.IsActive = 0 AND printed = 'Y')) GROUP BY p.number HAVING COUNT(*) > 1) r1), 0) 
		AS [Number of reoccurring payments taken through web portal]
, ISNULL( (SELECT SUM(s.amtaccts) FROM (SELECT SUM(p.amount) AS amtaccts FROM pdc p WITH (NOLOCK) WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID) AND ApprovedBy = 'payweb' 
		AND CAST(p.entered AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
		AND (active = 1 OR (active = 0 AND printed = 1)) GROUP BY p.number HAVING COUNT(*) > 1) s), 0) 
		+
		ISNULL( (SELECT SUM(s1.amtaccts) FROM (SELECT SUM(amount) AS amtaccts FROM DebtorCreditCards  p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number 
		WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID) AND ApprovedBy = 'payweb' 
		AND p.DateEntered BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)
		AND (p.IsActive = 1 OR (p.IsActive = 0 AND printed = 'Y')) HAVING COUNT(*) > 1) s1), 0) AS [Dollars of reoccurring payments taken through web portal]
FROM (SELECT P.number, P.totalpaid
FROM payhistory p WITH (NOLOCK) LEFT OUTER JOIN pdc pdc WITH (NOLOCK) ON p.PostDateUID = pdc.UID AND p.number = pdc.number
LEFT OUTER JOIN DebtorCreditCards dcc WITH (NOLOCK) ON p.PostDateUID = dcc.ID AND p.number = dcc.Number
WHERE (dcc.ApprovedBy = 'payweb' OR pdc.ApprovedBy = 'payweb' OR p.BatchPmtCreatedBy = 'payweb')
AND p.customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND CAST(p.datepaid AS DATE) BETWEEN CAST(dbo.F_START_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE) AND CAST(dbo.F_END_OF_MONTH(DATEADD(MM, -1, GETDATE())) AS DATE)) AS pw


END
GO
