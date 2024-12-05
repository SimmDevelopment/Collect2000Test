SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 01/01/2019
-- Description:	Generates data for daily issues log in exchange.
-- 3/17/2020 BGM Added DIS Disaster Hold to possible issues.
-- 01/21/2021 BGM Updated Column R or Additional notes to send Placement level.
-- 02/01/2023 BGM Added filter for bankruptcy scrub check for dismissed status
-- 03/20/2023 BGM Copied to make changes to new format due 04/01/2023
-- 04/06/2023 BGM Changed date received at agency to date status changed.
--			Need to define Nursing Home, CEE, DEE, Incarcerated, CCCS, Additional Notes
/*

Overall Changes to be made for 4/1/2023
•	No line item should have more than 1 “Y” between columns F-R
•	LIT column has been removed as per previous direction these should not be reported as CEE since we no longer require litigious scrubs. 
•	Removed Call Record and date column. 
•	Cleaned up some column headers to be more precise in the ask. 
•	We added columns for CCCS, Nursing home and CEE, DEE (deceased streams only)
•	PIF column has been UPDATED.  Historically we have asked accounts to be reported as PIF right after account was PIF.  We are now asking this to be programed to only report PIF accounts after 30 days from the last payment causing the PIF.  This will account for my team to validate acct is still pif and recalled as intended. 
•	Reminder -Debt management column, should only be populated once POA is received and evidenced in log
•	Please ensure you utilize the template provided as it has U.S. Bank watermarks we need to ensure stays with the log. 
•	Utilize naming convention provided on template, adjusting “Agency Name and mm-mm-yy with applicable information 

exec Custom_USBank_Export_Daily_Issues_New_Apr_2023 '20230301', '20230310'

*/

-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_Daily_Issues_New_Apr_2023]
	-- Add the parameters for the stored procedure here
    @startDate DATETIME ,
    @endDate DATETIME
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here

        SET @startDate = dbo.F_START_OF_DAY(@startDate)
        SET @endDate = DATEADD(ss, -3, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

    SELECT  GETDATE() AS [Date Agency Reported on Log]
	, 'SIMM' AS [Agency Name]
	, ( SELECT TOP 1 CONVERT(VARCHAR(10), datechanged, 101)
              FROM      StatusHistory WITH ( NOLOCK )
              WHERE     AccountID = m.number
                        AND (NewStatus IN ('AEX', 'ALV', 'ATY', 'BKY', 'BKO', 'B07', 'B11', 'B13', 'CCS', 'COV', 'DEC', 'DIN', 'DIS', 'MIL', 'OOS', 'POA', 'POO')
										   OR (status = 'PIF' AND CAST(DATEADD(dd, 30, m.lastpaid) AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)))
              ORDER BY  DateChanged DESC ) AS [Date received at Agency]
	--, m.received AS [Date received at Agency]
	, m.account AS [Account #]
	, m.name AS [Customer Name]
	, CASE WHEN status = 'ATY' THEN 'Y' ELSE '' END AS [ATTY]
	, CASE WHEN status IN ('BKY', 'BKO', 'B07', 'B11', 'B13') THEN 'Y' ELSE '' END AS [BK]
	, CASE WHEN status = 'DEC' THEN 'Y' ELSE '' END AS [DEC]
	, CASE WHEN status = 'MIL' THEN 'Y' ELSE '' END AS [SCRA]
	--Need to define
	, '' AS [Nursing Home]
	, CASE WHEN status = 'DMC' THEN 'Y' ELSE '' END AS [Debt Management (POA Received)]
	, CASE status WHEN 'POA' THEN 'Y' WHEN 'POO' THEN 'Y' ELSE '' END AS [POA/3rd party authorization]
	, CASE WHEN status IN ('AEX', 'DIN', 'OOS') AND customer <> '0001749' THEN 'Y' ELSE '' END AS [CEE]
	, CASE WHEN status IN ('AEX', 'DIN', 'OOS') AND customer = '0001749' THEN 'Y' ELSE '' END AS [DEE (DECEASED ONLY)]
	, CASE WHEN m.status = 'DIP' THEN 'Y' ELSE '' END AS [Incarcerated]
	, CASE WHEN status = 'CCS' THEN 'Y' ELSE '' END AS [CCCS]
	, CASE WHEN status = 'PIF' AND CAST(DATEADD(dd, 30, m.lastpaid) AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) THEN 'Y' ELSE '' END AS [PIF]
	, CASE WHEN status IN ('COV', 'DIS') THEN 'Y' ELSE '' END AS [OTHER]
	, CASE WHEN status = 'ATY' THEN 'Attorney Representation'
			WHEN status IN ('COV', 'DIS') THEN 'Disaster Hold'
			WHEN status IN ('BKY', 'BKO', 'B07', 'B11', 'B13') THEN 
                 --account closed by scrub
                 CASE WHEN m.number IN (SELECT TOP 1 AccountID FROM Bankruptcy WITH (NOLOCK) WHERE AccountID = m.number 
					AND status NOT IN ('Dismissed') AND transmitteddate is NOT null) THEN 'Bankruptcy Scrub'
                 --account closed by Collector
                 WHEN number IN (SELECT TOP 1 AccountID FROM StatusHistory WITH (NOLOCK) WHERE AccountID = number 
					AND NewStatus = 'BKY' AND UserName NOT IN ('system', 'exg', 'exchange', 'workflow') 
					AND UserName IN (SELECT loginname FROM users WITH (NOLOCK) WHERE RoleID = 4)) THEN 'Bankruptcy Notification'
                 --Account closed by client services
                 ELSE 'Verbal Bankruptcy' END
                 WHEN status = 'DEC' THEN 
                 --account closed by scrub
                 CASE WHEN m.number IN (SELECT TOP 1 AccountID FROM Deceased WITH (NOLOCK) WHERE AccountID = m.number 
					AND transmitteddate is NOT null) THEN 'Deceased Scrub'
                 --account closed by Collector
                 WHEN number IN (SELECT TOP 1 AccountID FROM StatusHistory WITH (NOLOCK) WHERE AccountID = number 
					AND NewStatus = 'DEC' AND UserName NOT IN ('system', 'exg', 'exchange', 'workflow') 
					AND UserName IN (SELECT loginname FROM users WITH (NOLOCK) WHERE RoleID = 4)) THEN 'Deceased Notification'
				 --Account closed by client services
				 ELSE 'Verbal Deceased' END
			WHEN status = 'MIL' THEN 'SCRA Scrub'
			WHEN status = 'PIF' THEN 'Paid in Full'
			WHEN status = 'CCS' THEN 'Debt Management Representation'
			WHEN status = 'ALV' THEN 'Debtor Alive'
			WHEN status = 'DIN' THEN 'Deceased Insolvent'
            WHEN status = 'AEX' THEN 'All Efforts Exhausted'
			WHEN status IN ('POA', 'POO') THEN 'POA 3rd Party Authorization'
			ELSE status END AS [Account Issue]
	--, m.status AS [Account Status]
	, CASE WHEN status IN ('DMC', 'CCS', 'POA', 'POO') THEN (SELECT TOP 1 c.companyname FROM cccs c WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON c.debtorid = D.debtorid AND d.number = m.number ORDER BY c.datemodified DESC)
	ELSE CASE  
	(SELECT TOP 1 RIGHT(thedata, 4) FROM dbo.MiscExtra WITH (NOLOCK)  WHERE number = m.number AND title = 'pla.0.placementlevel')
	WHEN 'ASED' THEN 'DECEASED'
	WHEN 'ECEA' THEN 'DECEASED'
	ELSE (SELECT TOP 1 RIGHT(thedata, 4) FROM dbo.MiscExtra WITH (NOLOCK)  WHERE number = m.number AND title = 'pla.0.placementlevel')
	END END AS [Additional Notes (Name of Debt Management/POA if applicable)]
	, '' AS [Attachments]
	, '' AS [USB Response]
    FROM master m WITH (NOLOCK)
    WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 113)
            AND ((status IN ('AEX', 'ALV', 'ATY', 'BKY', 'BKO', 'B07', 'B11', 'B13', 'CCS', 'COV', 'DEC', 'DIN', 'DIS', 'MIL', 'OOS', 'POA', 'POO')
            AND (SELECT TOP 1 datechanged FROM StatusHistory WITH (NOLOCK)
                  WHERE AccountID = m.number AND NewStatus IN 
						  ('AEX', 'ALV', 'ATY', 'BKY', 'BKO', 'B07', 'B11', 'B13', 'CCS', 'COV', 'DEC', 'DIN', 'DIS', 'MIL', 'OOS', 'POA', 'POO') 
						  ORDER BY DateChanged DESC) BETWEEN @startDate AND @endDate)
			OR (status = 'PIF' AND CAST(DATEADD(dd, 30, m.lastpaid) AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)))


END
GO
