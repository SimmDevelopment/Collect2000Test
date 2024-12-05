SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetDeskStats]
   @UserId INT,
   @Date DATETIME,
   @UseGross BIT = 0
AS
BEGIN
    DECLARE @PostingDay INT
    DECLARE @TotalPostingDays INT
    DECLARE @BeginPosting DATETIME
    DECLARE @EndPosting DATETIME
    DECLARE @SystemMonth INT
    DECLARE @SystemYear INT
    DECLARE @FrontCollections MONEY
    DECLARE @FrontFees MONEY
    DECLARE @NewCollections MONEY
    DECLARE @NewFees MONEY
    DECLARE @GrossPDC MONEY
    DECLARE @FeePDC MONEY
    DECLARE @GrossDCC MONEY
    DECLARE @FeeDCC MONEY
    DECLARE @DeskCode VARCHAR(10)
    DECLARE @UserName VARCHAR(50)
    DECLARE @DateYear INT
    DECLARE @DateMonth INT

    --Get the user's desk
    SELECT @DeskCode = DeskCode, @UserName=UserName
    FROM [dbo].[users] 
    WHERE [dbo].[users].[id] = @UserID

    --Get Current System Year and Month
    SELECT @SystemYear = CurrentYear, @SystemMonth = CurrentMonth 
    FROM ControlFile

    --Get Current Date
    IF(@Date IS NULL)
    BEGIN
        SET @Date = {fn curdate()}
    END
    
    SET @DateYear = YEAR(@Date)
    SET @DateMonth = MONTH(@Date)
    
    --Get Posting Day Variables
   SELECT @BeginPosting = [Date]
   FROM Calendar 
   WHERE IsFirstDay = 1
     AND Month([Date]) = MONTH(@Date)
     AND YEAR([Date]) = YEAR(@Date)
   ORDER BY [Date] DESC

   -- jjh: Default to first calendar day if no first day is configured
   IF @BeginPosting IS NULL
      SELECT TOP 1 @BeginPosting = [Date]
      FROM Calendar 
      WHERE Month([Date]) = MONTH(@Date)
        AND YEAR([Date]) = YEAR(@Date)
      ORDER BY [Date] ASC

   SET @EndPosting = (
   SELECT TOP 1 [Date]
   FROM Calendar
   WHERE IsLastDay = 1
     -- jjh: Fixed bug where IsLastday could be picked up for a future month and not current month
     AND [Date] >= @BeginPosting AND MONTH([Date])=MONTH(@Date) AND YEAR([Date]) = YEAR(@Date)
   ORDER BY [Date])

   -- jjh: Default to last calendar day if no last day is configured
   IF @EndPosting IS NULL
      SELECT TOP 1 @EndPosting = [Date]
      FROM Calendar 
      WHERE Month([Date]) = MONTH(@Date)
        AND YEAR([Date]) = YEAR(@Date)
      ORDER BY [Date] DESC
   PRINT @EndPosting

   SELECT
      @PostingDay = SUM(CASE WHEN PostingDay = 1 AND Date <= @Date THEN 1 ELSE 0 END), 
      @TotalPostingDays = SUM(CASE PostingDay WHEN 1 THEN 1 ELSE 0 END)
   FROM Calendar  
   WHERE [Date] BETWEEN @BeginPosting AND @EndPosting

    --Get Front $$
    SELECT 
    @FrontCollections = ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalPaid(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalPaid(uid) END),0),
    @FrontFees = ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalFee(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalFee(uid) END),0)
    FROM Payhistory WITH (NOLOCK)
    WHERE Desk = @DeskCode AND SystemYear = @SystemYear AND SystemMonth = @SystemMonth

    --Get New $$
    SELECT 
    @NewCollections = ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalPaid(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalPaid(uid) END),0),
    @NewFees = ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalFee(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalFee(uid) END),0) 
    FROM payhistory WITH (NOLOCK)
    WHERE Desk = @DeskCode 
      AND Entered = @Date

    --Get Post Dates from PDC
    SELECT
    @GrossPDC = ISNULL(SUM(amount),0),
    @FeePDC = ISNULL(SUM(projectedfee),0)
    FROM PDC WITH (NOLOCK) 
    WHERE MONTH(Deposit) = @DateMonth
      AND YEAR(Deposit) = @DateYear
      AND Desk = @DeskCode
      AND Active = 1
      AND onhold is null

    --Get Post Dates from DCC
    SELECT
    @GrossDCC = ISNULL(SUM(amount),0),
    @FeeDCC = ISNULL(SUM(projectedfee),0)
    FROM DebtorCreditCards DCC WITH (NOLOCK) 
    JOIN [master] m WITH (NOLOCK) ON DCC.Number = m.Number
    WHERE MONTH(DepositDate) = @DateMonth
      AND YEAR(DepositDate) = @DateYear
      AND Desk = @DeskCode
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL

   IF @UseGross = 0
   BEGIN
      SELECT
      d.Name,
      @PostingDay AS [Posting Day],
      @TotalPostingDays AS [Total Posting Days this Month],
      @FrontFees AS [Front Amount],
      @FeePDC+ @FeeDCC AS [PDC Amount],
      @FrontFees+@FeePDC+@FeeDCC AS [MTD Amount],
      @NewFees AS [NEW],
      Fee/@TotalPostingDays AS [Daily Goal],
      Fee AS [Monthly Goal],
      (Fee/@TotalPostingDays)*@PostingDay AS [MTD Goal],
      (@FrontFees+@FeePDC+@FeeDCC)-((Fee/@TotalPostingDays)*@PostingDay) AS [MTD Diff],
      CAST(
         CASE WHEN (Fee > 0 AND @TotalPostingDays > 0 AND @PostingDay > 0) THEN
            (@FrontFees+@FeePDC+@FeeDCC)/((Fee/@TotalPostingDays)*@PostingDay)
         ELSE 0 END
      AS DECIMAL(9,2)) AS [MTD Percent],
      CAST(
         CASE WHEN FEE > 0 THEN (@FrontFees+@FeePDC+@FeeDCC)/(Fee)
         ELSE 0 END
      AS DECIMAL(9,2)) AS [Monthly Percent],
      @UserName as UserName
      FROM Goals_Desk gd 
      JOIN Desk d WITH (NOLOCK) ON gd.Desk = d.Code
      WHERE Month([Month]) = @DateMonth
        AND Year([Month]) = @DateYear
        AND Desk = @DeskCode
   END
   ELSE
   BEGIN
      SELECT
      d.Name,
      @PostingDay AS [Posting Day],
      @TotalPostingDays AS [Total Posting Days this Month],
      @FrontCollections AS [Front Amount],
      @GrossPDC+ @GrossDCC AS [PDC Amount],
      @FrontCollections+@GrossPDC+@GrossDCC AS [MTD Amount],
      @NewCollections AS [NEW],
      Gross/@TotalPostingDays AS [Daily Goal],
      Gross AS [Monthly Goal],
      (Gross/@TotalPostingDays)*@PostingDay AS [MTD Goal],
      (@FrontCollections+@GrossPDC+@GrossDCC)-((Gross/@TotalPostingDays)*@PostingDay) AS [MTD Diff],
      CAST(
         CASE WHEN (Gross > 0 AND @TotalPostingDays > 0 AND @PostingDay > 0) THEN
            (@FrontCollections+@GrossPDC+@GrossDCC)/((Gross/@TotalPostingDays)*@PostingDay)
         ELSE 0 END
      AS DECIMAL(9,2)) AS [MTD Percent],
      CAST(
         CASE WHEN Gross > 0 THEN (@FrontCollections+@GrossPDC+@GrossDCC)/(Gross)
         ELSE 0 END
      AS DECIMAL(9,2)) AS [Monthly Percent],
      @UserName as UserName
      FROM Goals_Desk gd 
      JOIN Desk d WITH (NOLOCK) ON gd.Desk = d.Code
      WHERE Month([Month]) = @DateMonth
        AND Year([Month]) = @DateYear
        AND Desk = @DeskCode  
   END

    --Get Today Work Statistics
    SELECT
    ISNULL(ds.Attempts, 0) AS Attempts,
    ISNULL(ds.Contacted, 0) AS Contacted,
    ISNULL(ds.Touched, 0) AS Touched,
    ISNULL(ds.Worked, 0) AS Worked
    FROM DeskStats ds WITH(NOLOCK) 
    JOIN Users ON Users.LoginName = ds.Desk
    WHERE DeskCode = @DeskCode 
      AND ds.TheDate = @Date

    --Get MTD Work Statistics
    SELECT
    ISNULL(SUM(ds.Attempts), 0) AS Attempts,
    ISNULL(SUM(ds.Contacted), 0) AS Contacted,
    ISNULL(SUM(ds.Touched), 0) AS Touched,
    ISNULL(SUM(ds.Worked), 0) AS Worked
    FROM DeskStats ds WITH(NOLOCK) 
    JOIN Users ON Users.LoginName = ds.Desk
    WHERE DeskCode = @DeskCode 
      AND SystemMonth = @SystemMonth 
      AND SystemYear = @SystemYear

END

GO
