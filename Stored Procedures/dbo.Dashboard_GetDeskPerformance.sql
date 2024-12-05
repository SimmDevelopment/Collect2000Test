SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDeskPerformance]
    @UserID INT,
    @Date DATETIME = NULL,
    @UseGross BIT = 0
AS
BEGIN
    DECLARE @DeskCode VARCHAR(10)
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

    SELECT @DeskCode = DeskCode FROM Users WHERE ID = @UserID

    IF(@Date IS NULL)
    BEGIN
        SET @Date = { fn CurDate() }
    END

    -- Current Month
    SELECT IDENTITY(INT, 1,1) AS 'Day', [Date]
    INTO #tmpCMDates
    FROM calendar
    WHERE MONTH([Date]) = MONTH(@Date) 
      AND YEAR([Date]) = YEAR(@Date)
      AND [Date] <= @Date
      AND PostingDay = 1
    ORDER BY [Date]
    
    SET @cmCount = @@ROWCOUNT

    -- Last Month
    SET @lastMonth = DATEADD(MONTH, -1, @Date)
    SET @lastlastMonth = DATEADD(MONTH, -2, @Date)

    SELECT IDENTITY(INT, 1,1) AS 'Day', [Date]
    INTO #tmpLMDates
    FROM calendar
    WHERE MONTH([Date]) = MONTH(@lastMonth) 
      AND YEAR([Date]) = YEAR(@lastMonth)	  
      AND PostingDay = 1
    ORDER BY [Date]
    
    SET @lmCount = @@ROWCOUNT

    SET @PDay = @lmCount
    IF @cmCount > @lmCount
    BEGIN
        SET @PDay = @cmCount
    END

    SELECT IDENTITY(INT, 1,1) AS 'Day', [Date]
    INTO #tmpLLMDates
    FROM calendar
    WHERE MONTH([Date]) = MONTH(@lastlastMonth) 
      AND YEAR([Date]) = YEAR(@lastlastMonth)	  
      AND PostingDay = 1
    ORDER BY [Date]


    SET @llmCount = @@ROWCOUNT

    IF @llmCount > @PDay
    BEGIN
        SET @PDay = @cmCount
    END 

    WHILE @pDay > 0
    BEGIN
        SELECT @cmDate = [Date] 
        FROM #tmpCMDates
        WHERE [Day] = @pDay
           OR ([Day] = @cmCount AND @pDay > @cmCount)

        SELECT @lmDate = [Date]
        FROM #tmpLMDates
        WHERE [Day] = @pDay
           OR ([Day] = @lmCount AND @pDay > @lmCount)

	    SELECT @llmDate = [Date]
        FROM #tmpLLMDates
        WHERE [Day] = @pDay
           OR ([Day] = @llmCount AND @pDay > @llmCount)

      IF @UseGross = 0
      BEGIN
         INSERT INTO @workstats([Day], [Current Month], [Last Month], [Last Last Month]) 
         VALUES (@pDay, [dbo].Goals_GetDeskFeesOnDate(@DeskCode, @cmDate), [dbo].Goals_GetDeskFeesOnDate(@DeskCode, @lmDate), [dbo].Goals_GetDeskFeesOnDate(@DeskCode, @llmDate))
      END
      ELSE
      BEGIN
         INSERT INTO @workstats([Day], [Current Month], [Last Month], [Last Last Month]) 
         VALUES (@pDay, [dbo].Goals_GetDeskGrossOnDate(@DeskCode, @cmDate), [dbo].Goals_GetDeskGrossOnDate(@DeskCode, @lmDate), [dbo].Goals_GetDeskGrossOnDate(@DeskCode, @llmDate))
        END

        SET @pDay = @pDay - 1
    END

    DROP TABLE #tmpCMDates
    DROP TABLE #tmpLMDates
    DROP TABLE #tmpLLMDates

    SELECT * FROM @workstats ORDER BY [Day] 
END

GO
