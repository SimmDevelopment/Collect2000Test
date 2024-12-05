SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Dashboard_GetCustomerPerformance](@customer VARCHAR(10), @Date DATETIME, @MonthsBack INT)
AS
BEGIN

   DECLARE @months TABLE (
      [Month] INT,
      [Name] VARCHAR(3)
   )

   DECLARE @placement TABLE (
      [Month] INT,
      [Year] INT,
      [Placements] INT,
      [PlacementAmts] money
   )

   DECLARE @performance TABLE (
      [Month] INT,
      [Year] INT,
      [Collections] MONEY,
      [Fees] MONEY
   )

   DECLARE @EndDate    DATETIME
   DECLARE @EndYear    INT
   DECLARE @StartDate  DATETIME
   DECLARE @StartYear  INT

   IF @MonthsBack > 24
   BEGIN
      SET @MonthsBack = 24
   END   
   
   SET @EndDate   = @Date
   SET @EndYear   = YEAR(@EndDate)
   SET @StartDate = DATEADD(MONTH, (-1 * @MonthsBack), @Date)
   IF @monthsback = 0
   BEGIN
      SET @StartDate = DATEADD(DAY, (-1 * (DAY(@Date) - 1)), @Date)
   END
   SET @StartYear = YEAR(@StartDate)

   INSERT INTO @months VALUES (1, 'Jan')
   INSERT INTO @months VALUES (2, 'Feb')
   INSERT INTO @months VALUES (3, 'Mar')
   INSERT INTO @months VALUES (4, 'Apr')
   INSERT INTO @months VALUES (5, 'May')
   INSERT INTO @months VALUES (6, 'Jun')
   INSERT INTO @months VALUES (7, 'Jul')
   INSERT INTO @months VALUES (8, 'Aug')
   INSERT INTO @months VALUES (9, 'Sep')
   INSERT INTO @months VALUES (10, 'Oct')
   INSERT INTO @months VALUES (11, 'Nov')
   INSERT INTO @months VALUES (12, 'Dec')

   INSERT INTO @placement
   SELECT MONTH(M.received), 
      YEAR(M.received),
      COUNT(M.Number),
      SUM(M.Original)
   FROM [master] M WITH (NOLOCK)
   JOIN CUSTOMER C ON M.Customer = C.Customer
   WHERE M.Customer = @Customer
      AND C.[status] = 'active'
      AND M.received BETWEEN @StartDate AND @EndDate
   GROUP BY YEAR(M.received), MONTH(M.received)

   INSERT INTO @performance
   SELECT MONTH(P.entered),
      YEAR(P.entered),
      SUM(P.TotalPaid),
      SUM(P.FEE1+P.FEE2+P.FEE3+P.FEE4+P.FEE5+P.FEE6+P.FEE7+P.FEE8+P.FEE9+P.FEE10)
   FROM Payhistory P WITH (NOLOCK)
   JOIN CUSTOMER C WITH (NOLOCK) ON P.Customer = C.Customer
   WHERE P.Customer = @Customer
     AND C.[status] = 'active'
     AND P.entered BETWEEN @StartDate AND @EndDate
   GROUP BY YEAR(P.entered), MONTH(P.entered)

   IF (@EndYear - @StartYear) = 0
   BEGIN
      --Pivot Placements
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Placements END), 0) AS [Year]
      FROM @months m
      LEFT JOIN @placement p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Placement Amounts
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN PlacementAmts END), 0) AS [Year]
      FROM @months m
      LEFT JOIN @placement p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Collections
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Collections END), 0) AS [Year]
      FROM @months m
      LEFT JOIN @performance p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Fees
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Fees END), 0) AS [Year]
      FROM @months m
      LEFT JOIN @performance p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]
   END
   
   IF (@EndYear - @StartYear) = 1
   BEGIN
      --Pivot Placements
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Placements END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN Placements END), 0) AS Year1
      FROM @months m
      LEFT JOIN @placement p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Placement Amounts
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN PlacementAmts END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN PlacementAmts END), 0) AS Year1
      FROM @months m
      LEFT JOIN @placement p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Collections
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Collections END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN Collections END), 0) AS Year1
      FROM @months m
      LEFT JOIN @performance p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Fees
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Fees END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN Fees END), 0) AS Year1
      FROM @months m
      LEFT JOIN @performance p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]   
   END
   
   IF (@EndYear - @StartYear) = 2
   BEGIN
      --Pivot Placements
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Placements END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN Placements END), 0) AS Year1,
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 2 THEN Placements END), 0) AS Year2
      FROM @months m
      LEFT JOIN @placement p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Placement Amounts
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN PlacementAmts END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN PlacementAmts END), 0) AS Year1,
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 2 THEN PlacementAmts END), 0) AS Year2
      FROM @months m
      LEFT JOIN @placement p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Collections
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Collections END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN Collections END), 0) AS Year1,
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 2 THEN Collections END), 0) AS Year2
      FROM @months m
      LEFT JOIN @performance p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]

      --Pivot Fees
      SELECT m.[Name], ISNULL(MIN(CASE WHEN [Year] = @StartYear THEN Fees END), 0) AS [Year],
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 1 THEN Fees END), 0) AS Year1,
         ISNULL(MIN(CASE WHEN [Year] = @StartYear + 2 THEN Fees END), 0) AS Year2
      FROM @months m
      LEFT JOIN @performance p on p.[Month] = m.[Month]
      GROUP BY m.[Month], m.[Name]
      ORDER BY m.[Month]   
   END
END

GO
