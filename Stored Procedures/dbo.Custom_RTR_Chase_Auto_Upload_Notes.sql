SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan, Simm Associates, Inc.
-- Create date: 4/20/2013
-- Description:	Prepares Notes information to send to client
-- Update: 9/20/2014 BGM, Cleaned up commented out code and formatted keywords to standard.
-- =============================================

--Remove all of below
--set @startDate='20130416'
--set @endDate='20130418'
--set @customer='255001|255002|255003|255004|256001|256002'
--exec Custom_RTR_Chase_Auto_Upload_Notes '255001|255002|255003|255004|256001|256002', '20130416','20130418'

CREATE PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Upload_Notes]
--Remove @startDate and @endDate
    @customer VARCHAR(8000),
    @startDate DATETIME,
    @endDate DATETIME
AS 
    BEGIN
--Comment back out
---- Added by Adip to allow time to be specified
--        DECLARE @startDate DATETIME
--        DECLARE @endDate DATETIME

--        UPDATE  export.NotesDates
--        SET     LastStartDate = StartDate ,
--                StartDate = EndDate ,
--                EndDate = GETDATE() ;
		
--        SELECT  @startDate = StartDate ,
--                @endDate = EndDate
--        FROM    export.NotesDates
		

---- End Adip's edit 05/29/2013

        DECLARE @id2 VARCHAR(50)
        DECLARE cur CURSOR
        FOR
            --load the cursor with the alpha codes from the customer table
	SELECT DISTINCT
                AlphaCode
      FROM      customer WITH ( NOLOCK )
      WHERE     customer IN ( SELECT    string
                              FROM      dbo.CustomStringToSet(@customer, '|') )
	
        OPEN cur

--get the information from the cursor and into the variables
        FETCH FROM cur INTO @id2
        WHILE @@fetch_status = 0 
            BEGIN

                IF EXISTS ( SELECT  *
                            FROM    tempdb.sys.tables
                            WHERE   name LIKE '#tmpcms_count%' ) 
                    DROP TABLE #tmpcms_count
                IF EXISTS ( SELECT  *
                            FROM    tempdb.sys.tables
                            WHERE   name LIKE '#tmpcms_close%' ) 
                    DROP TABLE #tmpcms_close
                IF EXISTS ( SELECT  *
                            FROM    tempdb.sys.tables
                            WHERE   name LIKE '#tmpcms%' ) 
                    DROP TABLE #tmpcms

			--Temp table for Address and phone changes
                CREATE TABLE #tmpcms_count
                    (
                      [ID] [int] IDENTITY(1, 1)
                                 NOT NULL ,
                      [number] [int] NOT NULL
                    )
			
			--Temp table for closed accounts
                CREATE TABLE #tmpcms_close
                    (
                      [ID] [int] IDENTITY(1, 1)
                                 NOT NULL ,
                      [number] [int] NOT NULL ,
                      [amount] [money] NULL
                    )

			--Insert closed accounts into closed table for all accounts except SIF PIF
                INSERT  INTO #tmpcms_close
                        ( number ,
                          amount
                        )
                        SELECT DISTINCT
                                m.number ,
                                0
                        FROM    master m WITH ( NOLOCK )
                                INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                        WHERE   ( m.status IN ( 'ATY', 'CND', 'CCR', 'CAD',
                                                'DEC', 'LDA', 'NPA', 'OFF',
                                                'OOS', 'AEX', 'BKY', 'B07',
                                                'B11', 'B13' )
                                  OR m.qlevel IN ( '018', '830', '840', '998' )
                                )
                                AND m.customer IN (
                                SELECT  string
                                FROM    dbo.CustomStringToSet(@customer, '|') )
                                AND m.returned IS NULL
                                AND m.closed BETWEEN @startdate AND @enddate
                                AND c.AlphaCode = @id2
                        GROUP BY m.number

			--Insert closed accounts into closed table for SIF PIF accounts for full balance streams 4QFRTR and 4CFRTR
                INSERT  INTO #tmpcms_close
                        ( number ,
                          amount
                        )
                        SELECT DISTINCT
                                m.number ,
                                0
                        FROM    master m WITH ( NOLOCK )
                                INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                        WHERE   m.status IN ( 'SIF', 'PIF', 'BSA' )
                                AND m.closed BETWEEN ( @startdate - 10 ) AND ( @endDate
                                                              - 10 )--10 day hold for 4QF and 4CF customers change as needed for hold period
                                AND m.customer IN (
                                SELECT  string
                                FROM    dbo.CustomStringToSet(@customer, '|') )
                                AND m.returned IS NULL
                                AND c.AlphaCode IN ( '4QFRTR', '4CFRTR',
                                                     'WQFRTR', 'WCFRTR' )
                        GROUP BY m.number

			--Insert closed accounts into closed table for SIF PIF accounts in all other streams
                INSERT  INTO #tmpcms_close
                        ( number ,
                          amount
                        )
                        SELECT DISTINCT
                                m.number ,
                                0
                        FROM    master m WITH ( NOLOCK )
                                INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                        WHERE   m.status IN ( 'SIF', 'PIF', 'BSA' )
                                AND m.closed BETWEEN ( @startdate - 30 ) AND ( @endDate
                                                              - 30 )--10 day hold for 4QF and 4CF customers change as needed for hold period
                                AND m.customer IN (
                                SELECT  string
                                FROM    dbo.CustomStringToSet(@customer, '|') )
                                AND m.returned IS NULL
                                AND c.AlphaCode NOT IN ( '4QFRTR', '4CFRTR',
                                                         'WQFRTR', 'WCFRTR' )
                        GROUP BY m.number
			
                CREATE TABLE #tmpcms
                    (
                      [ID] [int] IDENTITY(1, 1)
                                 NOT NULL ,
                      [number] [int] NOT NULL
                    )

                INSERT  INTO #tmpcms
                        ( number
                        )
                        SELECT DISTINCT
                                AccountID
                        FROM    AddressHistory a
                                JOIN master m WITH ( NOLOCK ) ON m.Number = a.AccountId
                                INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                        WHERE   a.DateChanged BETWEEN @startDate AND @endDate
                                AND m.customer IN (
                                SELECT  string
                                FROM    dbo.CustomStringToSet(@customer, '|') )
                                AND c.AlphaCode = @id2

                INSERT  INTO #tmpcms
                        ( number
                        )
                        SELECT DISTINCT
                                AccountID
                        FROM    PhoneHistory p
                                JOIN master m WITH ( NOLOCK ) ON m.Number = p.AccountId
                                INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                        WHERE   p.DateChanged BETWEEN @startDate AND @endDate
                                AND m.customer IN (
                                SELECT  string
                                FROM    dbo.CustomStringToSet(@customer, '|') )
                                AND c.AlphaCode = @id2
--	AND p.NewNumber <> ''			removed this to allow Bad Phone Number notifications
	

                SELECT DISTINCT --Header Record
	--RecordCode coded in exchange
	--Filler coded in exchange
                        CAST(GETDATE() AS SMALLDATETIME) AS [Date] ,
	--Type=1 coded in exchange
	--SourceCode=1 coded in exchange
                        m.customer , --reference only, not needed in file
                        c.alphacode AS [AgencyCode] , --Entered in the latitude customer properties Alpha Code field
                        'Real Time Resolutions' AS [AgencyName] ,
	--Rec1 not used
	--Rec2 not used
	--Rec3 not used
	--Rec4 Note codes Get number of record 4 records
                        ( SELECT    ISNULL(COUNT(m.number), 0)
                          FROM      master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                          WHERE     m.closed BETWEEN @startDate AND @endDate
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND m.status IN ( 'ATY', 'CND', 'CAD',
                                                      'DEC', 'LDA', 'NPA',
                                                      'OFF', 'OOS', 'AEX',
                                                      'BKY', 'B07', 'B11',
                                                      'B13' )
                                    AND m.returned IS NULL
                                    AND m.qlevel = '998'
                                    AND c.alphacode = @id2
                        )
                        + (	--Placement Acknowledgements
                            SELECT  ISNULL(COUNT(m.number), 0)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                    LEFT JOIN dbo.R_RTR_ChaseAccountsReactivatedToday r
                                    WITH ( NOLOCK ) ON m.number = r.number
                            WHERE   ( m.received BETWEEN @startDate AND @endDate
                                      OR r.Account IS NOT NULL
                                    )
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND c.AlphaCode = @id2
                          )
	-- The below code snip is comment out because we need to disable TPN till Tom decides when to send this code.
	--+
	--(	--Bad Phone Notifications
	--	SELECT ISNULL(COUNT(DISTINCT CAST (m.Number AS VARCHAR) + REPLACE(REPLACE(REPLACE(substring(n.comment, 6, 14), '(', ''), ')', ''), ' ', '-')), 0)
	--	FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	--	INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
	--	WHERE n.action = '+++++' AND n.result = '+++++' AND created BETWEEN @startDate AND @endDate
	--	AND (n.comment LIKE 'Work%Bad' OR n.comment LIKE 'Home%Bad' OR n.comment LIKE 'Fax%Bad' OR n.comment LIKE 'Cell%Bad') --add in other phone types as needed or when added to system
	--	AND c.AlphaCode = @id2 
	--)
                        + (	--Autodialer no consent notifications
                            SELECT  ISNULL(COUNT(m.number), 0)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                    INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                            WHERE   n.action = 'AC'
                                    AND n.result = 'NC'
                                    AND created BETWEEN @startDate AND @endDate
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND c.AlphaCode = @id2
                          )
                        + (	--Autodialer yes consent notifications
                            SELECT  ISNULL(COUNT(m.number), 0)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                    INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                            WHERE   n.action = 'AC'
                                    AND n.result = 'YC'
                                    AND created BETWEEN @startDate AND @endDate
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND c.AlphaCode = @id2
                          )
                        + ( --SIF/PIF/BSA Notifications for Full Balance customers
                            SELECT  ISNULL(COUNT(m.number), 0)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            WHERE   m.status IN ( 'SIF', 'PIF', 'BSA' )
                                    AND m.closed BETWEEN ( @startdate - 10 ) AND ( @endDate
                                                              - 10 )--10 day hold for 4QF and 4CF customers change as needed for hold period
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND m.returned IS NULL
                                    AND c.AlphaCode IN ( '4QFRTR', '4CFRTR' )
                                    AND c.AlphaCode = @id2
                          )
                        + ( --SIF/PIF/BSA Notifications for Other customers
                            SELECT  ISNULL(COUNT(m.number), 0)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            WHERE   m.status IN ( 'SIF', 'PIF', 'BSA' )
                                    AND m.closed BETWEEN ( @startdate - 30 ) AND ( @endDate
                                                              - 30 )--30 day hold for 4QF and 4CF customers change as needed for hold period
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND m.returned IS NULL
                                    AND c.AlphaCode NOT IN ( '4QFRTR',
                                                             '4CFRTR' )
                                    AND c.AlphaCode = @id2
                          )
                        + (	--Military Status
                            SELECT  ISNULL(COUNT(m.number), 0)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                    INNER JOIN dbo.vActiveMilitaryStatus ams ON m.number = ams.Number
                            WHERE   m.qlevel < 998
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND c.AlphaCode = @id2
                          )
                        + (	-- Wrong number codes (CWN, SWN)
                            SELECT  COUNT(DISTINCT m.account)
                            FROM    PhoneHistory ph
                                    INNER JOIN Phones_Master pm WITH ( NOLOCK ) ON ph.AccountID = pm.Number
                                                              AND ph.OldNumber = pm.PhoneNumber
                                    INNER JOIN master m WITH ( NOLOCK ) ON ph.AccountID = m.number
                                    INNER JOIN Customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                    INNER JOIN #tmpcms t ON m.number = t.number
                                    LEFT JOIN notes n WITH ( NOLOCK ) ON ph.AccountID = n.number
                                                              AND CONVERT(VARCHAR, n.comment) LIKE '%'
                                                              + ph.OldNumber
                                                              + ' added'
                            WHERE   DateChanged BETWEEN @startDate AND @endDate
                          )
                        + (	-- Attorney retained by debtor (ATY)
                            SELECT  COUNT(DISTINCT m.account)
                            FROM    master m
                                    INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                                                              AND n.created BETWEEN @startDate AND @endDate
                                                              AND CONVERT (VARCHAR, n.comment) LIKE 'Status Changed%ATY'
                            WHERE   m.qlevel < 998
                                    AND m.customer IN (
                                    SELECT  string
                                    FROM    dbo.CustomStringToSet(@customer,
                                                              '|') )
                                    AND c.AlphaCode = @id2
                                    AND m.status = 'ATY'
                          )
                        + (
		-- Do not call phone numbers
                            SELECT  COUNT(m.account)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                                              AND c.AlphaCode = @id2
                                    INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                                                              AND n.created BETWEEN @startDate AND @endDate
                                                              AND CAST(n.comment AS VARCHAR(8000)) LIKE '%status changed%to Do Not Call'
                                    INNER JOIN Phones_Master pm WITH ( NOLOCK ) ON m.number = pm.Number
                                                              AND pm.PhoneStatusID = 3 -- Do not call
                                                              AND pm.PhoneTypeID != 7 -- We will handle TPNs separately
                                    INNER JOIN Phones_Types pt WITH ( NOLOCK ) ON pm.PhoneTypeID = pt.PhoneTypeID
                          )
                        + (
		-- Third party numbers
                            SELECT  COUNT(m.account)
                            FROM    master m WITH ( NOLOCK )
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                                              AND c.AlphaCode = @id2
                                    INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                                                              AND n.created BETWEEN @startDate AND @endDate
                                                              AND CAST(n.comment AS VARCHAR(8000)) LIKE '%changed to Third Party Number'
                                    INNER JOIN Phones_Master pm WITH ( NOLOCK ) ON m.number = pm.Number
                                                              AND pm.PhoneTypeID = 7 -- Third party numbers
                                                              AND ( pm.PhoneStatusID != 2
                                                              OR pm.PhoneStatusID IS NULL
                                                              ) -- anything other than good
                                    INNER JOIN Phones_Types pt WITH ( NOLOCK ) ON pm.PhoneTypeID = pt.PhoneTypeID
                          ) AS [NumRec4] ,
	--Rec5 demographic changes (Modified by Adip to send the NOTE Codes (and eliminate the demographic info)
                        ( SELECT    ISNULL(COUNT(DISTINCT m2.number), 0)
                          FROM      #tmpcms t
                                    JOIN master m2 WITH ( NOLOCK ) ON m2.Number = t.Number
                                    LEFT JOIN CourtCases co WITH ( NOLOCK ) ON m2.Number = co.AccountID
                                    LEFT JOIN Courts ct WITH ( NOLOCK ) ON co.CourtID = ct.CourtID
                                    INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                          WHERE     m2.customer = m.customer
                                    AND c.AlphaCode = @id2
                        ) AS [NumRec5] ,
	--Filler coded in exchange
                        '03300' AS [BankID] --Change bank ID when testing is over to production bank ID
	--Fills coded in exchange
                FROM    master m WITH ( NOLOCK ) --left outer JOIN #tmpcms_count t ON m.number=t.number
                        LEFT OUTER JOIN #tmpcms t2 ON t2.number = m.number
                        LEFT OUTER JOIN #tmpcms_close t3 ON t3.number = m.number
                        INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                WHERE   m.customer IN (
                        SELECT  string
                        FROM    dbo.CustomStringToSet(@customer, '|') )
                        AND m.customer IS NOT NULL
                        AND c.AlphaCode = @id2


                (--Gather Post date and Promise accounts to send
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(ISNULL(ISNULL(p.deposit, s.datechanged),
                                        GETDATE()) AS SMALLDATETIME) AS [Date] ,--return either the deposit date of the post date or the date the status changed or current date
                            CASE WHEN m.STATUS IN ( 'PDC', 'PCC' ) THEN 'PPA'
                                 WHEN m.STATUS = 'PPA' THEN 'PTP'
                                 ELSE 'PTP'
                            END AS [NoteCode] ,--outgoing note code
                            CASE WHEN m.STATUS IN ( 'PDC', 'PCC' )
                                 THEN 'Payment Arrangement'
                                 WHEN m.STATUS = 'PPA' THEN 'Promise to Pay'
                                 ELSE 'PROMISE TO PAY'
                            END AS [Narrative1] , --Must use these narratives
                            '' AS [Narrative2] ,  --not used for Promises/post-dates
                            c.AlphaCode AS [FirstDataAcct] , --Entered in the latitude customer properties Alpha Code field
                            m.account AS [AccountID]
                  FROM      #tmpcms_close t
                            LEFT OUTER JOIN master m WITH ( NOLOCK ) ON t.number = m.number
                            LEFT OUTER JOIN statushistory s WITH ( NOLOCK ) ON s.accountid = m.number
                            LEFT OUTER JOIN pdc p ON p.number = m.number
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                  WHERE     m.qlevel IN ( '018', '820', '830', '840' )
                            AND p.deposit BETWEEN @startDate AND @endDate
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                (--Gather closed accounts
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(ISNULL(m.closed, NULL) AS SMALLDATETIME) AS [Date] ,
                            CASE WHEN m.STATUS = 'ATY' THEN 'ATY'
                                 WHEN m.STATUS IN ( 'CND', 'CAD' ) THEN 'CD'
                                 WHEN m.STATUS = 'CCR' THEN 'CCR'
                                 WHEN m.STATUS = 'LDA' THEN 'LDA'
                                 WHEN m.STATUS = 'NPA' THEN 'NPA'
                                 WHEN m.STATUS = 'OFF' THEN 'OFF'
                                 WHEN m.STATUS = 'OOS' THEN 'OOS'
                                 WHEN m.STATUS = 'AEX' THEN 'UNC'
                                 ELSE ''
                            END AS [NoteCode] ,--outgoing note code
                            CASE WHEN m.status = 'ATY'
                                 THEN 'DBTR REPRESENTED BY ATTY'
                                 WHEN m.status = 'BSA'
                                 THEN 'Below Settlement Authority'
                                 WHEN M.STATUS IN ( 'CND', 'CAD' )
                                 THEN 'Cease & Desist'
                                 WHEN M.STATUS = 'CCR'
                                 THEN 'Client Close & Return'
                                 WHEN m.status = 'LDA'
                                 THEN 'Litigious Debtor Account'
                                 WHEN m.STATUS = 'NPA'
                                 THEN 'Non-pursuable account'
                                 WHEN m.STATUS = 'OFF' THEN 'Possible Offset'
                                 WHEN m.STATUS = 'OOS' THEN 'OUT OF STATUTE'
                                 WHEN m.STATUS = 'AEX'
                                 THEN 'Return Uncollectable'
                                 ELSE ''
                            END AS [Narrative1] ,
                            '' AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      #tmpcms_close t
                            LEFT OUTER JOIN master m WITH ( NOLOCK ) ON t.number = m.number
                            LEFT OUTER JOIN statushistory s WITH ( NOLOCK ) ON s.accountid = m.number
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                  WHERE     m.status IN ( 'ATY', 'CND', 'CCR', 'CAD', 'LDA',
                                          'NPA', 'OFF', 'OOS', 'AEX' )
                            AND m.returned IS NULL
                            AND m.qlevel = '998'
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                (--Gather SIF PIF Accounts
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(ISNULL(m.closed, NULL) AS SMALLDATETIME) AS [Date] ,
                            CASE WHEN m.STATUS = 'BSA' THEN 'BSA'
                                 WHEN m.STATUS = 'PIF' THEN 'PIF'
                                 WHEN m.STATUS = 'SIF' THEN 'SIF'
                                 ELSE ''
                            END AS [NoteCode] ,--outgoing note code
                            CASE WHEN m.STATUS = 'BSA'
                                 THEN 'Below Settlement Authority'
                                 WHEN m.status = 'PIF'
                                 THEN 'Return Paid in Full'
                                 WHEN m.status = 'SIF'
                                 THEN 'Return Settled in Full'
                                 ELSE ''
                            END AS [Narrative1] ,
                            CASE WHEN m.Score BETWEEN 1 AND 560
                                      AND c.AlphaCode LIKE 'W%'
                                 THEN 'Account scored LOW. Score '
                                      + CAST(m.Score AS VARCHAR)
                                 WHEN m.Score BETWEEN 561 AND 620
                                      AND c.AlphaCode LIKE 'W%'
                                 THEN 'Account scored MEDIUM. Score '
                                      + CAST(m.Score AS VARCHAR)
                                 WHEN m.Score >= 621
                                      AND c.AlphaCode LIKE 'W%'
                                 THEN 'Account scored HIGH. Score '
                                      + CAST(m.Score AS VARCHAR)
                                 WHEN c.AlphaCode LIKE 'W%'
                                 THEN 'There is no score for this account'
                                 ELSE ''
                            END AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      #tmpcms_close t
                            LEFT OUTER JOIN master m WITH ( NOLOCK ) ON t.number = m.number
                            LEFT OUTER JOIN statushistory s WITH ( NOLOCK ) ON s.accountid = m.number
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                  WHERE     m.status IN ( 'BSA', 'PIF', 'SIF' )
                            AND ( ( m.closed BETWEEN ( @startdate - 30 ) AND ( @endDate
                                                              - 30 )
                                    AND @id2 NOT IN ( '4QFRTR', '4CFRTR',
                                                      'WQFRTR', 'WCFRTR' )
                                  )
                                  OR ( m.closed BETWEEN ( @startdate - 10 ) AND ( @endDate
                                                              - 10 )
                                       AND @id2 IN ( '4QFRTR', '4CFRTR',
                                                     'WQFRTR', 'WCFRTR' )
                                     )
                                )--Hold days
                            AND m.returned IS NULL
                            AND m.qlevel = '998'
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                (-- Gather Bankruptcy information (This query has been edited by Adip. Please get with him before changing anything)
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(GETDATE() AS SMALLDATETIME) AS [Date] ,
                            CASE WHEN m.status IN ( 'BKY', 'B07', 'B11', 'B13' )
                                 THEN 'BAC'
                                 ELSE ''
                            END AS [NoteCode] ,--outgoing note code
                            CASE WHEN m.status IN ( 'BKY', 'B07', 'B11', 'B13' )
                                 THEN 'Return Bankruptcy Confirmed'
                                 ELSE ''
                            END AS [Narrative1] ,
                            'case # ' + b.CaseNumber + ' Filed '
                            + CONVERT(VARCHAR(10), b.DateFiled, 101)
                            + ' Chapter ' + CONVERT(VARCHAR(2), b.chapter)
                            + 'Attorney ' + da.Name + ' ' + da.City + ' '
                            + da.State + ' ' + da.Phone AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      #tmpcms_close t
                            LEFT OUTER JOIN master m WITH ( NOLOCK ) ON t.number = m.number
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            INNER JOIN debtors d WITH ( NOLOCK ) ON m.number = d.number-- AND d.seq = 0
                            INNER JOIN dbo.Bankruptcy b WITH ( NOLOCK ) ON d.DebtorID = b.DebtorID
                            INNER JOIN dbo.DebtorAttorneys da WITH ( NOLOCK ) ON d.DebtorID = da.DebtorID
                  WHERE     m.status IN ( 'BKY', 'B07', 'B11', 'B13' )
                            AND c.AlphaCode = @id2
                            AND m.returned IS NULL
                            AND m.qlevel = '998'
                )
                UNION ALL
                (-- Gather Deceased information
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(GETDATE() AS SMALLDATETIME) AS [Date] ,
                            CASE WHEN m.status IN ( 'DEC' ) THEN 'DEC'
                                 ELSE ''
                            END AS [NoteCode] ,--outgoing note code
                            CASE WHEN m.status IN ( 'DEC' )
                                 THEN 'Return Deceased'
                                 ELSE ''
                            END AS [Narrative1] ,
                            'DOD ' + CONVERT(VARCHAR(10), de.DOD, 101)
                            + ' Court ' + de.CourtDivision + ' '
                            + de.courtstreet1 + ' ' + de.CourtCity + ' '
                            + de.CourtState + ' ' + de.CourtZipcode + ' '
                            + de.CourtPhone AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      #tmpcms_close t
                            LEFT OUTER JOIN master m WITH ( NOLOCK ) ON t.number = m.number
                            LEFT OUTER JOIN statushistory s WITH ( NOLOCK ) ON s.accountid = m.number
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            INNER JOIN debtors d WITH ( NOLOCK ) ON m.number = d.number
                                                              AND d.seq = 0
                            INNER JOIN deceased de WITH ( NOLOCK ) ON d.DebtorID = de.DebtorID
                  WHERE     m.status IN ( 'DEC' )
                            AND m.customer IN (
                            SELECT  string
                            FROM    dbo.CustomStringToSet(@customer, '|') )
                            AND c.AlphaCode = @id2
                            AND m.returned IS NULL
                            AND m.qlevel = '998'
                )


                UNION ALL
                ( --Get all newly placed accounts
-- Changing the note date to now reflect date generated + 1 day per BKenney. Tom has approved this change in CW 38909
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(DATEADD(dd, 1, GETDATE()) AS SMALLDATETIME) AS [Date] ,
                            'ACK' AS [NoteCode] ,
                            'PLACEMENT ACKNOWLEDGEMENT FROM ' + c.AlphaCode
                            + '.' AS [Narrative1] ,
                            '' AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      master m WITH ( NOLOCK )
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            LEFT JOIN dbo.R_RTR_ChaseAccountsReactivatedToday r
                            WITH ( NOLOCK ) ON m.number = r.number
                  WHERE     ( m.received BETWEEN @startDate AND @endDate
                              OR r.Account IS NOT NULL
                            )
                            AND m.customer IN (
                            SELECT  string
                            FROM    dbo.CustomStringToSet(@customer, '|') )
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                ( --Get all military accounts
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST (GETDATE() AS SMALLDATETIME) AS [Date] ,
                            'MIL' AS [NoteCode] ,
                            'MILITARY STATUS' AS [Narrative1] ,
                            '' AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      master m WITH ( NOLOCK )
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            INNER JOIN dbo.vActiveMilitaryStatus ams ON m.number = ams.Number
                  WHERE     m.qlevel < 998
                            AND m.customer IN (
                            SELECT  string
                            FROM    dbo.CustomStringToSet(@customer, '|') )
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                (-- Get all accounts that have a wrong phone number (CWN, SWN)
                  SELECT	DISTINCT
                            '4' AS [RecordCode] ,
                            CAST (ph.DateChanged AS SMALLDATETIME) AS [Date] ,
                            CASE WHEN n.number IS NULL THEN 'CWN'
                                 ELSE 'SWN'
                            END 'NoteCode' ,
                            CASE WHEN n.number IS NULL
                                 THEN 'Chase wrong number '
                                      + LEFT(pm.PhoneNumber, 3) + '-'
                                      + SUBSTRING(pm.PhoneNumber, 4, 3) + '-'
                                      + RIGHT(pm.PhoneNumber, 4)
                                 ELSE 'Skip wrong number '
                                      + LEFT(pm.PhoneNumber, 3) + '-'
                                      + SUBSTRING(pm.PhoneNumber, 4, 3) + '-'
                                      + RIGHT(pm.PhoneNumber, 4)
                            END 'Narrative1' ,
                            '' 'Narrative2' ,
                            c.AlphaCode ,
                            m.account
                  FROM      PhoneHistory ph
                            INNER JOIN Phones_Master pm WITH ( NOLOCK ) ON ph.AccountID = pm.Number
                                                              AND ph.OldNumber = pm.PhoneNumber
                            INNER JOIN master m WITH ( NOLOCK ) ON ph.AccountID = m.number
                            INNER JOIN Customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            INNER JOIN #tmpcms t ON m.number = t.number
                            LEFT JOIN notes n WITH ( NOLOCK ) ON ph.AccountID = n.number
                                                              AND CONVERT(VARCHAR, n.comment) LIKE '%'
                                                              + ph.OldNumber
                                                              + ' added'
                  WHERE     DateChanged BETWEEN @startDate AND @endDate
                            AND m.customer IN (
                            SELECT  string
                            FROM    dbo.CustomStringToSet(@customer, '|') )
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                (-- Get all accounts that have an attorney retained by debtor
                  SELECT	DISTINCT
                            '4' AS [RecordCode] ,
                            GETDATE() AS [Date] ,
                            'ATY' AS 'NoteCode' ,
                            'Customer Represented by Attorney' AS 'Narrative1' ,
                            LEFT(da.Name + ' ' + da.Firm + ' ' + da.Addr1
                                 + ' ' + da.City + ' ' + da.State + ' '
                                 + da.Zipcode + ' ' + da.phone, 140) AS 'Narrative2' ,
                            c.AlphaCode ,
                            m.account
                  FROM      master m WITH ( NOLOCK )
                            INNER JOIN Customer c WITH ( NOLOCK ) ON m.customer = c.customer
                            INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                                                              AND n.created BETWEEN @startDate AND @endDate
                                                              AND CONVERT (VARCHAR, n.comment) LIKE 'Status Changed%ATY'
                            LEFT JOIN DebtorAttorneys da WITH ( NOLOCK ) ON m.number = da.AccountID
                  WHERE     m.qlevel < 998
                            AND m.status = 'ATY'
                            AND m.customer IN (
                            SELECT  string
                            FROM    dbo.CustomStringToSet(@customer, '|') )
                            AND c.AlphaCode = @id2
                )
                UNION ALL
                (--Gather do not call phones
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(GETDATE() AS SMALLDATETIME) AS [Date] ,
                            CASE pt.PhoneTypeMapping
                              WHEN 2 THEN 'CCE'
                              WHEN 0 THEN 'CHO'
                              WHEN 4 THEN 'CHO'
                              WHEN 1 THEN 'CEM'
                              WHEN 5 THEN 'CEM'
                              WHEN 3 THEN 'CHO'	-- We treat fax numbers as home phones while reporting DNCs
                              ELSE 'ERR'
                            END 'NoteCode' ,
                            'Cease and Desist ' + CASE pt.PhoneTypeMapping
                                                    WHEN 2 THEN 'Cell Phone'
                                                    WHEN 0 THEN 'Home'
                                                    WHEN 4 THEN 'Home'
                                                    WHEN 1 THEN 'POE'
                                                    WHEN 5 THEN 'POE'
                                                    WHEN 3 THEN 'Home'	-- We treat fax numbers as home phones while reporting DNCs
                                                    ELSE 'Erroneous phone type mapping'
                                                  END + ' - Do Not Call '
                            + LEFT(pm.PhoneNumber, 3) + '-'
                            + SUBSTRING(pm.PhoneNumber, 4, 3) + '-'
                            + RIGHT(pm.PhoneNumber, 4) AS [Narrative1] ,
                            '' AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      master m WITH ( NOLOCK )
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                                              AND c.AlphaCode = @id2
                            INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                                                              AND n.created BETWEEN @startDate AND @endDate
                                                              AND CAST(n.comment AS VARCHAR(8000)) LIKE '%status changed%to Do Not Call'
                            INNER JOIN Phones_Master pm WITH ( NOLOCK ) ON m.number = pm.Number
                                                              AND pm.PhoneStatusID = 3 -- Do not call
                                                              AND pm.PhoneTypeID != 7 -- We will handle TPNs separately
                            INNER JOIN Phones_Types pt WITH ( NOLOCK ) ON pm.PhoneTypeID = pt.PhoneTypeID
                )
                UNION ALL
                (--Gather third party numbers
                  SELECT DISTINCT
                            '4' AS [RecordCode] ,
                            CAST(GETDATE() AS SMALLDATETIME) AS [Date] ,
                            'TPN' AS 'NoteCode' ,
                            'Third Party Number - Do Not Call '
                            + LEFT(pm.PhoneNumber, 3) + '-'
                            + SUBSTRING(pm.PhoneNumber, 4, 3) + '-'
                            + RIGHT(pm.PhoneNumber, 4) AS [Narrative1] ,
                            '' AS [Narrative2] ,
                            c.AlphaCode AS [FirstDataAcct] ,
                            m.account AS [AccountID]
                  FROM      master m WITH ( NOLOCK )
                            INNER JOIN customer c WITH ( NOLOCK ) ON m.customer = c.customer
                                                              AND c.AlphaCode = @id2
                            INNER JOIN notes n WITH ( NOLOCK ) ON m.number = n.number
                                                              AND n.created BETWEEN @startDate AND @endDate
                                                              AND CAST(n.comment AS VARCHAR(8000)) LIKE '%changed to Third Party Number'
                            INNER JOIN Phones_Master pm WITH ( NOLOCK ) ON m.number = pm.Number
                                                              AND pm.PhoneTypeID = 7 -- Third party numbers
                                                              AND ( pm.PhoneStatusID != 2
                                                              OR pm.PhoneStatusID IS NULL
                                                              ) -- anything other than good
                            INNER JOIN Phones_Types pt WITH ( NOLOCK ) ON pm.PhoneTypeID = pt.PhoneTypeID
                )


--------Account Master
                SELECT DISTINCT
                        m.customer AS [Customer] ,
                        '5' AS [RecordCode] ,
                        CAST(GETDATE() AS SMALLDATETIME) AS [Date] ,
                        '1' AS [Type] ,
                        '1' AS [SourceCode] ,
                        'M' AS [NameType] ,
                        'U' AS [Function] ,
                        m.Name ,
                        m.Street1 ,
                        m.Street2 ,
                        m.City ,
                        m.State ,
                        REPLACE(m.Zipcode, '-', '') AS Zipcode ,
--m.HomePhone,
-- added by Adip 11/29/2013 to tag wrong number fields
-- added by Adip 06/19/2014 to tag DNC numbers as well
                        CASE WHEN pm.PhoneStatusID IN ( 1, 3 )
                             THEN LEFT(pm.PhoneNumber, 6) + 'XXXX'
                             ELSE m.HomePhone
                        END 'PhoneNumber' ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN CAST(c.JudgementAmt AS VARCHAR(10))
                             ELSE '000000000000'
                        END AS [JudgeAmount] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN c.JudgementDate
                             ELSE NULL
                        END AS [JudgeDate] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN c.Remarks
                             ELSE ''
                        END AS [JudgeReference] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN c.JudgementIntRate
                             ELSE 0
                        END AS [IntRate] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN c.intFromDate
                             ELSE NULL
                        END AS [IntStartDate] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN ct.County
                             ELSE ''
                        END AS [JudgeCounty] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN ct.CourtName
                             ELSE ''
                        END AS [JudgeCourt] ,
                        '' AS [JudgeSheriff] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN CAST(c.JudgementAmt AS VARCHAR(10))
                             ELSE '000000000000'
                        END AS [JudgePrin] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN CAST(c.JudgementOtherAward AS VARCHAR(10))
                             ELSE '000000000000'
                        END AS [JudgeOtherInc] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN CAST(c.JudgementIntAward AS VARCHAR(10))
                             ELSE '000000000000'
                        END AS [JudgeInt] ,
                        CASE WHEN c.DateUpdated BETWEEN @startDate AND @endDate
                             THEN CAST(c.JudgementCostAward AS VARCHAR(10))
                             ELSE '000000000000'
                        END AS [JudgeCost] ,
                        '' AS [Collector] ,
                        '' AS [DocketNumber] ,
                        '' AS [id1] ,
                        m.account
                FROM    #tmpcms t
                        JOIN master m WITH ( NOLOCK ) ON m.Number = t.Number --AND m.id2 = @id2
                        INNER JOIN Customer cu WITH ( NOLOCK ) ON m.customer = cu.customer
                                                              AND cu.AlphaCode = @id2
                        LEFT JOIN CourtCases c WITH ( NOLOCK ) ON m.Number = c.AccountID
                        LEFT JOIN Courts ct WITH ( NOLOCK ) ON c.CourtID = ct.CourtID
-- Added by Adip 11/29/2013 to pickup wrong number
                        LEFT JOIN Phones_Master pm WITH ( NOLOCK ) ON m.number = pm.Number
                                                              AND pm.PhoneStatusID IN (
                                                              1, 3 )	-- bad phone, DNC phones
                        INNER JOIN PhoneHistory ph WITH ( NOLOCK ) ON m.number = ph.AccountID
                                                              AND pm.PhoneNumber = ph.OldNumber
                                                              AND pm.PhoneTypeID = ph.Phonetype
                                                              AND ph.DateChanged BETWEEN @startDate AND @endDate


                FETCH FROM cur INTO @id2
	
            END
        DROP TABLE #tmpcms_count
        DROP TABLE #tmpcms_close
        DROP TABLE #tmpcms
--close and free up all the resources.
        CLOSE cur
        DEALLOCATE cur
    END
GO
