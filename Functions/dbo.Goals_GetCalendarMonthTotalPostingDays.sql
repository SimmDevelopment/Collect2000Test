SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[Goals_GetCalendarMonthTotalPostingDays] (@Date DATETIME) RETURNS INT
AS
BEGIN

   DECLARE @BeginPosting DATETIME
   DECLARE @EndPosting DATETIME
   DECLARE @TotalPostingDays INT
   
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
   
   SELECT @TotalPostingDays = SUM(CASE PostingDay WHEN 1 THEN 1 ELSE 0 END)
   FROM Calendar  
   WHERE [Date] BETWEEN @BeginPosting AND @EndPosting

   RETURN COALESCE(@TotalPostingDays,0)
END


GO
