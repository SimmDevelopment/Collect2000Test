SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetTeamPerformance]
   @SupervisorID INT,
   @Date DATETIME = NULL,
   @UseGross BIT = 0
AS
BEGIN
    
    DECLARE @beginPosting DATETIME
    DECLARE @lastMonth DATETIME
    DECLARE @lastlastMonth DATETIME
    DECLARE @cmDate DATETIME
    DECLARE @lmDate DATETIME
    DECLARE @llmDate DATETIME
    DECLARE @PDay INT
    DECLARE @cmCount INT
    DECLARE @lmCount INT
    DECLARE @llmCount INT
    DECLARE @WorkStats TABLE (
            [Day] INT NOT NULL,
            [Current Month] DECIMAL(9, 2) NOT NULL DEFAULT 0,
            [Last Month] DECIMAL(9, 2) NOT NULL DEFAULT 0,
			[Last Last Month] DECIMAL(9, 2) NOT NULL DEFAULT 0
    );

    IF(@Date IS NULL)
    BEGIN
        SET @Date = { fn CurDate() }
    END

    -- Current Month
    -- Get beginning of current month
    SELECT @beginPosting = [Date]
    FROM Calendar 
    WHERE IsFirstDay = 1
      AND MONTH([Date]) = MONTH(@Date)
      AND YEAR([Date]) = YEAR(@Date)
    ORDER BY [Date] DESC

    IF @beginPosting IS NULL
    SET @beginPosting = (SELECT TOP 1 [Date]
    FROM Calendar 
    WHERE MONTH([Date]) = MONTH(@Date)
      AND YEAR([Date]) = YEAR(@Date)
    ORDER BY [Date])

    -- Get posting day upto @Date
    SELECT IDENTITY(INT, 1,1) AS 'Day', [Date]+0.999 as [Date]
    INTO #tmpCMDates
    FROM calendar
    WHERE [Date] BETWEEN @beginPosting AND @Date
      AND PostingDay = 1
    ORDER BY [Date]
    
    SET @cmCount = @@ROWCOUNT

    -- Last Month
    SET @lastMonth = DATEADD(MONTH, -1, @Date)
    SET @lastlastMonth = DATEADD(MONTH, -2, @Date)
    
    -- Get beginning of last month
    SET @beginPosting = (SELECT TOP 1 [Date]
    FROM Calendar 
    WHERE IsFirstDay = 1
      AND MONTH([Date]) = MONTH(@lastMonth)
      AND YEAR([Date]) = YEAR(@lastMonth)
    ORDER BY [Date] DESC)

    IF @beginPosting IS NULL
		SET @beginPosting = (SELECT TOP 1 [Date]
		FROM Calendar 
		WHERE 
		  MONTH([Date]) = MONTH(@lastMonth)
		  AND YEAR([Date]) = YEAR(@lastMonth)
		ORDER BY [Date])

    SELECT IDENTITY(INT, 1,1) AS 'Day', [Date]+0.999 as [Date]
    INTO #tmpLMDates
    FROM calendar
    WHERE [Date] BETWEEN @beginPosting AND @lastMonth
      AND PostingDay = 1
    ORDER BY [Date]
    
    SET @lmCount = @@ROWCOUNT

    SET @PDay = @lmCount
    IF @cmCount > @lmCount
    BEGIN
        SET @PDay = @cmCount
    END 

    -- Get beginning of last last month
    SET @beginPosting = (SELECT TOP 1 [Date]
    FROM Calendar 
    WHERE IsFirstDay = 1
      AND MONTH([Date]) = MONTH(@lastlastMonth)
      AND YEAR([Date]) = YEAR(@lastlastMonth)
    ORDER BY [Date] DESC)  

    IF @beginPosting IS NULL
     SET @beginPosting = (SELECT TOP 1 [Date]
    FROM Calendar 
    WHERE MONTH([Date]) = MONTH(@lastlastMonth)
      AND YEAR([Date]) = YEAR(@lastlastMonth)
    ORDER BY [Date])  


    SELECT IDENTITY(INT, 1,1) AS 'Day', [Date]+0.999 as [Date]
    INTO #tmpLLMDates
    FROM calendar
    WHERE [Date] BETWEEN @beginPosting AND @lastlastMonth
      AND PostingDay = 1
    ORDER BY [Date]

    SET @llmCount = @@ROWCOUNT

    IF @llmCount > @PDay
    BEGIN
        SET @PDay = @llmCount
    END 

    DECLARE @CM_dccFee MONEY
    DECLARE @CM_pdcFee MONEY
    DECLARE @LM_dccFee MONEY
    DECLARE @LM_pdcFee MONEY
    DECLARE @LLM_dccFee MONEY
    DECLARE @LLM_pdcFee MONEY
    DECLARE @CM_dccPaid MONEY
    DECLARE @CM_pdcPaid MONEY
    DECLARE @LM_dccPaid MONEY
    DECLARE @LM_pdcPaid MONEY
	DECLARE @LLM_dccPaid MONEY
    DECLARE @LLM_pdcPaid MONEY

    SELECT @CM_dccFee = ISNULL(SUM(dcc.ProjectedFee), 0)
    FROM desk
    JOIN [master] M WITH(NOLOCK) ON M.desk = desk.code
    JOIN DebtorCreditCards DCC WITH(NOLOCK) ON DCC.number = M.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = YEAR(@Date)
      AND MONTH(DepositDate) = MONTH(@Date)
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID

    SELECT @CM_pdcFee = ISNULL(SUM(pdc.ProjectedFee), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = YEAR(@Date)
      AND MONTH(Deposit) = MONTH(@Date)
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID

    SELECT @LM_dccFee = ISNULL(SUM(dcc.ProjectedFee), 0)
    FROM desk
    JOIN [master] M WITH(NOLOCK) ON M.desk = desk.code
    JOIN DebtorCreditCards DCC WITH(NOLOCK) ON DCC.number = M.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = YEAR(@lastMonth)
      AND MONTH(DepositDate) = MONTH(@lastMonth)
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID

    SELECT @LM_pdcFee = ISNULL(SUM(pdc.ProjectedFee), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = YEAR(@lastMonth)
      AND MONTH(Deposit) = MONTH(@lastMonth)
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID

    SELECT @LLM_dccFee = ISNULL(SUM(dcc.ProjectedFee), 0)
    FROM desk
    JOIN [master] M WITH(NOLOCK) ON M.desk = desk.code
    JOIN DebtorCreditCards DCC WITH(NOLOCK) ON DCC.number = M.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = YEAR(@lastlastMonth)
      AND MONTH(DepositDate) = MONTH(@lastlastMonth)
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID

    SELECT @LLM_pdcFee = ISNULL(SUM(pdc.ProjectedFee), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = YEAR(@lastlastMonth)
      AND MONTH(Deposit) = MONTH(@lastlastMonth)
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID

    SELECT @CM_dccPaid = ISNULL(SUM(dcc.Amount), 0)
    FROM desk
    JOIN [master] m WITH(NOLOCK) ON m.desk = desk.code
    JOIN DebtorCreditCards dcc WITH(NOLOCK) ON dcc.number = m.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = YEAR(@Date)
      AND MONTH(DepositDate) = MONTH(@Date)
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID

    SELECT @CM_pdcPaid = ISNULL(SUM(pdc.Amount), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = YEAR(@Date)
      AND MONTH(Deposit) = MONTH(@Date)
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID

    SELECT @LM_dccPaid = ISNULL(SUM(dcc.Amount), 0)
    FROM desk
    JOIN [master] m WITH(NOLOCK) ON m.desk = desk.code
    JOIN DebtorCreditCards dcc WITH(NOLOCK) ON dcc.number = m.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = YEAR(@lastMonth)
      AND MONTH(DepositDate) = MONTH(@lastMonth)
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID

    SELECT @LM_pdcPaid = ISNULL(SUM(pdc.Amount), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = YEAR(@lastMonth)
      AND MONTH(Deposit) = MONTH(@lastMonth)
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID

    SELECT @LLM_dccPaid = ISNULL(SUM(dcc.Amount), 0)
    FROM desk
    JOIN [master] m WITH(NOLOCK) ON m.desk = desk.code
    JOIN DebtorCreditCards dcc WITH(NOLOCK) ON dcc.number = m.number
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(DepositDate) = YEAR(@lastlastMonth)
      AND MONTH(DepositDate) = MONTH(@lastlastMonth)
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID

    SELECT @LLM_pdcPaid = ISNULL(SUM(pdc.Amount), 0)
    FROM desk
    JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
    JOIN Teams ON Teams.ID = desk.TeamID
    WHERE YEAR(Deposit) = YEAR(@lastlastMonth)
      AND MONTH(Deposit) = MONTH(@lastlastMonth)
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID

    SELECT 
        ISNULL(ISNULL(l.day, c.day),ll.day) AS [day]
        , ISNULL(l.date, DATEADD(m, -1, c.date)) AS LM_Date 
        , ISNULL(ll.date, DATEADD(m, -2, c.date)) AS LLM_Date, 
        ISNULL(c.date, DATEADD(m, 1, l.date)) CM_Date 
    INTO #tmpDates
    FROM #tmpLMDates l FULL JOIN #tmpCMDates c ON c.[day] = l.[day] FULL JOIN #tmpLLMDates ll ON ll.[day]=l.[day]


    IF @UseGross = 0
    BEGIN
        INSERT INTO @workstats([Day], [Current Month], [Last Month], [Last Last Month]) 
        SELECT
            l.Day
            , COALESCE(v1.fees, 0.00)+@CM_dccFee+@CM_pdcFee currmonth 
            , COALESCE(v.fees, 0.00)+@LM_pdcFee+@LM_dccFee lastmonth
            , COALESCE(v2.fees, 0.00)+@LLM_pdcFee+@LLM_dccFee lastlastmonth
            
        FROM #tmpDates l 		
        LEFT JOIN 
        (
            SELECT  COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee1 ELSE fee1 END) ELSE 0 END), 0) +
                 COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee2 ELSE fee2 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee3 ELSE fee3 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee4 ELSE fee4 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee5 ELSE fee5 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee6 ELSE fee6 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee7 ELSE fee7 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee8 ELSE fee8 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee9 ELSE fee9 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee10 ELSE fee10 END) ELSE 0 END), 0) AS fees
                ,
             t.[Day]
            FROM #tmpDates t
            LEFT JOIN   payhistory WITH(NOLOCK) ON payhistory.entered <= t.LM_Date 
            LEFT JOIN desk ON desk.code = payhistory.desk
            LEFT JOIN teams ON teams.ID = desk.TeamID 
            WHERE  Supervisorid = @SupervisorID AND YEAR(entered) = YEAR(@lastMonth)
            AND MONTH(entered) = MONTH(@lastMonth)
            GROUP BY  t.[Day]
        ) v ON v.[Day] = l.[Day]
        LEFT JOIN 
        (
            SELECT  COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee1 ELSE fee1 END) ELSE 0 END), 0) +
                 COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee2 ELSE fee2 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee3 ELSE fee3 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee4 ELSE fee4 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee5 ELSE fee5 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee6 ELSE fee6 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee7 ELSE fee7 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee8 ELSE fee8 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee9 ELSE fee9 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee10 ELSE fee10 END) ELSE 0 END), 0) AS fees
                ,
             t.[Day]
            FROM #tmpDates t
            LEFT JOIN   payhistory WITH(NOLOCK) ON payhistory.entered <= t.LLM_Date 
            LEFT JOIN desk ON desk.code = payhistory.desk
            LEFT JOIN teams ON teams.ID = desk.TeamID 
            WHERE  Supervisorid = @SupervisorID AND YEAR(entered) = YEAR(@lastlastMonth)
            AND MONTH(entered) = MONTH(@lastlastMonth)
            GROUP BY t.Day
        ) v2 ON v2.[Day] = l.[Day]
        LEFT JOIN 
        (
            SELECT  COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee1 ELSE fee1 END) ELSE 0 END), 0) +
                COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee2 ELSE fee2 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee3 ELSE fee3 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee4 ELSE fee4 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee5 ELSE fee5 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee6 ELSE fee6 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee7 ELSE fee7 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee8 ELSE fee8 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee9 ELSE fee9 END) ELSE 0 END), 0)
                + COALESCE(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                            (CASE WHEN batchtype LIKE '%R%' THEN -1 * fee10 ELSE fee10 END) ELSE 0 END), 0) AS fees
            ,t.[Day]
            FROM #tmpDates t
            LEFT JOIN   payhistory WITH(NOLOCK) ON payhistory.entered <= t.CM_Date 
            LEFT JOIN desk ON desk.code = payhistory.desk
            LEFT JOIN teams ON teams.ID = desk.TeamID 
            WHERE  Supervisorid = @SupervisorID AND YEAR(entered) = YEAR(@Date)
            AND MONTH(entered) = MONTH(@Date)
      
            GROUP BY t.Day
         ) v1 ON v1.Day = l.Day
    END
    ELSE
    BEGIN
        INSERT INTO @workstats([Day], [Current Month], [Last Month], [Last Last Month]) 
        SELECT
            l.Day
            , COALESCE(v1.Amt, 0.00)+@CM_dccPaid+@CM_pdcPaid currmonth 
            , COALESCE(v.Amt, 0.00)+@LM_pdcPaid+@LM_dccPaid lastmonth
            , COALESCE(v.Amt, 0.00)+@LLM_pdcPaid+@LLM_dccPaid lastlastmonth
            
        FROM #tmpDates l 
        LEFT JOIN 
        (
            SELECT 
                ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid1 ELSE paid1 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid2 ELSE paid2 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid3 ELSE paid3 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid4 ELSE paid4 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid5 ELSE paid5 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid6 ELSE paid6 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid7 ELSE paid7 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid8 ELSE paid8 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid9 ELSE paid9 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid10 ELSE paid10 END) ELSE 0 END), 0) AS Amt
                ,t.[Day]
            FROM #tmpDates t
            LEFT JOIN   payhistory WITH(NOLOCK) ON payhistory.entered <= t.LM_Date 
            LEFT JOIN desk ON desk.code = payhistory.desk
            LEFT JOIN teams ON teams.ID = desk.TeamID 
            WHERE  Supervisorid = @SupervisorID AND YEAR(entered) = YEAR(@lastMonth)
            AND MONTH(entered) = MONTH(@lastMonth)
            GROUP BY  t.[Day]
        ) v ON v.[Day] = l.[Day]
        LEFT JOIN 
        (
            SELECT 
                ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid1 ELSE paid1 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid2 ELSE paid2 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid3 ELSE paid3 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid4 ELSE paid4 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid5 ELSE paid5 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid6 ELSE paid6 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid7 ELSE paid7 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid8 ELSE paid8 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid9 ELSE paid9 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid10 ELSE paid10 END) ELSE 0 END), 0) AS Amt
                ,t.[Day]
            FROM #tmpDates t
            LEFT JOIN   payhistory WITH(NOLOCK) ON payhistory.entered <= t.LLM_Date 
            LEFT JOIN desk ON desk.code = payhistory.desk
            LEFT JOIN teams ON teams.ID = desk.TeamID 
            WHERE  Supervisorid = @SupervisorID AND YEAR(entered) = YEAR(@lastlastMonth)
            AND MONTH(entered) = MONTH(@lastlastMonth)
            GROUP BY t.[Day]
        ) v2 ON v2.[Day] = l.[Day]
        LEFT JOIN 
        (
            SELECT
                ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 1, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid1 ELSE paid1 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 2, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid2 ELSE paid2 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 3, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid3 ELSE paid3 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 4, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid4 ELSE paid4 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 5, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid5 ELSE paid5 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 6, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid6 ELSE paid6 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 7, 1) = 1 THEN
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid7 ELSE paid7 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 8, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid8 ELSE paid8 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 9, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid9 ELSE paid9 END) ELSE 0 END), 0)
                +ISNULL(SUM(CASE WHEN SUBSTRING(invoiceflags, 10, 1) = 1 THEN 
                    (CASE WHEN batchtype LIKE '%R%' THEN -1 * paid10 ELSE paid10 END) ELSE 0 END), 0) AS Amt
                ,t.[Day]
            FROM #tmpDates t
            LEFT JOIN   payhistory WITH(NOLOCK) ON payhistory.entered <= t.CM_Date 
            LEFT JOIN desk ON desk.code = payhistory.desk
            LEFT JOIN teams ON teams.ID = desk.TeamID 
            WHERE  Supervisorid = @SupervisorID AND YEAR(entered) = YEAR(@Date)
            AND MONTH(entered) = MONTH(@Date)
      
            GROUP BY  t.Day
         ) v1 ON v1.Day = l.Day

    END

    DROP TABLE #tmpCMDates
    DROP TABLE #tmpLMDates
    DROP TABLE #tmpLLMDates
    DROP TABLE #tmpDates

    SELECT * 
    FROM @workstats
    ORDER BY [Day]
END

GO
