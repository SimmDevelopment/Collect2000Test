SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetCompanyStats] 
    @Date DATETIME
AS
BEGIN
    DECLARE @PostingDay INT
    DECLARE @TotalPostingDays INT
    DECLARE @BeginPosting DATETIME
    DECLARE @EndPosting DATETIME
    DECLARE @BranchGross TABLE (
      [GoalsCompanyID] UNIQUEIDENTIFIER,
      [Name] VARCHAR(75),
      [Branch] VARCHAR(5),
      [Collection] MONEY,
      [Monthly Goal] MONEY,
      [Daily Goal] MONEY,
      [MTD Goal] MONEY,
      [MTD Diff] MONEY,
      [MTD Percent] FLOAT,
      [Monthly Percent] FLOAT
    )
    
    --Get Posting Day Variables
    SELECT @BeginPosting = [Date]
    FROM Calendar 
    WHERE IsFirstDay = 1
      AND Month([Date]) = MONTH(@Date)
      AND YEAR([Date]) = YEAR(@Date)
    ORDER BY [Date] DESC
       
    SET @EndPosting = (
    SELECT TOP 1 [Date]
    FROM Calendar
    WHERE IsLastDay = 1
      AND [Date] >= @BeginPosting
    ORDER BY [Date])

    SELECT
    @PostingDay = SUM(CASE WHEN PostingDay = 1 AND Date <= @Date THEN 1 ELSE 0 END), 
    @TotalPostingDays = SUM(CASE PostingDay WHEN 1 THEN 1 ELSE 0 END)
    FROM Calendar  
    WHERE [Date] BETWEEN @BeginPosting AND @EndPosting
    
    INSERT INTO @BranchGross
    SELECT gc.goalscompanyid,
    c.Name,
    gcm.BranchCode,
    ISNULL(SUM(p.totalpaid), 0),
    ISNULL(MIN(gross), 0), 
    ISNULL((MIN(gross) / @TotalPostingDays), 0),
    ISNULL((MIN(gross) / @TotalPostingDays) * @PostingDay, 0),
    (ISNULL(SUM(p.TotalPaid), 0) - ISNULL((MIN(gross) / @TotalPostingDays) * @PostingDay, 0)),
    ISNULL(CAST(
        CASE WHEN (MIN(gross) > 0 AND @TotalPostingDays > 0 AND @PostingDay > 0) THEN
            SUM(p.TotalPaid) / ((MIN(gross) / @TotalPostingDays) * @PostingDay)
        ELSE 0 END
    AS DECIMAL(9,2)),0),
    ISNULL(CAST(
        CASE WHEN MIN(gross) > 0 THEN SUM(p.TotalPaid) / MIN(gross)
        ELSE 0 END
    AS DECIMAL(9,2)),0)
    FROM Customer c 
    JOIN goals_companycustomer gcc ON gcc.customer = c.customer
    JOIN goals_company gc ON gc.goalscompanyid = gcc.goalscompanyid
    JOIN goals_companymonth gcm ON gcm.goalscompanyid = gcc.goalscompanyid
    LEFT JOIN (SELECT ph.customer, ph.totalpaid, d.branch
          FROM payhistory ph WITH (NOLOCK)
          JOIN desk d ON d.code = ph.desk
          WHERE ph.entered BETWEEN @BeginPosting AND @Date) AS p ON p.customer = c.customer AND p.branch = gcm.branchcode          
    WHERE YEAR(gcm.[month]) = YEAR(@Date) AND MONTH(gcm.[month]) = MONTH(@Date)
      AND c.status = 'active'
    GROUP BY gc.goalscompanyid, c.name, gcm.branchcode
        
    --groups summary
    SELECT gc.GoalsCompanyID, gc.[name], 
      @postingday AS [Posting Day], 
      @totalpostingdays AS [Total Posting Days],
      SUM([Collection]) AS [Collection], 
      SUM([Monthly Goal]) AS [Monthly Goal], 
      SUM([Daily Goal]) AS [Daily Goal], 
      SUM([MTD Goal])AS [MTD Goal],
      SUM([MTD DIFF]) AS [MTD Diff], 
      AVG([MTD Percent]) AS [MTD Percent], 
      AVG([Monthly Percent]) AS [Monthly Percent]
    FROM @BranchGross bg
    JOIN Goals_Company gc ON gc.GoalsCompanyID = bg.GoalsCompanyID
    GROUP BY gc.GoalsCompanyID, gc.Name
    ORDER BY gc.Name
    
    --all customers
    SELECT * 
    FROM @BranchGross bg
    ORDER BY bg.Name

END

GO
