SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetTeamStats]
   @SupervisorID INT,
   @Date DATETIME,
   @UseGross BIT = 0
AS
BEGIN

   DECLARE @PostingDay INT
   DECLARE @TotalPostingDays INT
   DECLARE @BeginPosting DATETIME
   DECLARE @EndPosting DATETIME
   DECLARE @DateYear INT
   DECLARE @DateMonth INT
    
   DECLARE @Front TABLE (
      Desk VARCHAR(10) NOT NULL,
      Front_Fee MONEY NOT NULL,
      Front_Gross MONEY NOT NULL
   );

   DECLARE @NEW TABLE (
      Desk VARCHAR(10) NOT NULL,
      NEW_Fee MONEY NOT NULL,
      NEW_Gross MONEY NOT NULL
   );

   DECLARE @PDC TABLE (
      Desk VARCHAR(10) NOT NULL,
      PDC_Fee MONEY NOT NULL,
      PDC_Gross MONEY NOT NULL
   );

   DECLARE @DCC TABLE (
      Desk VARCHAR(10) NOT NULL,
      DCC_Fee MONEY NOT NULL,
      DCC_Gross MONEY NOT NULL
   );

    DECLARE @TodayWork TABLE (
        Desk VARCHAR(10) NOT NULL,
        Attempts INT,
        Contacted INT,
        Touched INT,
        Worked INT
    );

    DECLARE @MTDWork TABLE (
        Desk VARCHAR(10) NOT NULL,
        Attempts INT,
        Contacted INT,
        Touched INT,
        Worked INT
    );
    
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
   WHERE [Date] between @BeginPosting and @EndPosting

    --Get Front $$
   INSERT INTO @Front (Desk, Front_Fee, Front_Gross)
   SELECT desk.code,
      ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalFee(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalFee(uid) END),0) AS Front_FEE,
      ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalPaid(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalPaid(uid) END),0) AS Gross
   FROM desk
   JOIN Payhistory WITH(NOLOCK) ON Payhistory.desk = desk.code
   JOIN Teams ON Teams.ID = desk.TeamID
   WHERE SystemYear = YEAR(@Date)
      AND SystemMonth = MONTH(@Date)
      AND SupervisorID = @SupervisorID
   GROUP BY desk.code

   INSERT INTO @NEW (Desk, New_Fee, New_Gross)
   SELECT desk.code,
      ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalFee(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalFee(uid) END),0) AS NEW_FEE,
      ISNULL(SUM(CASE WHEN Batchtype LIKE '%R%' THEN -1*dbo.Custom_CalculatePaymentTotalPaid(uid) ELSE 1*dbo.Custom_CalculatePaymentTotalPaid(uid) END),0) AS Gross
   FROM desk
   JOIN Payhistory WITH(NOLOCK) ON Payhistory.desk = desk.code
   JOIN Teams ON Teams.ID = desk.TeamID
   WHERE Entered = @Date
      AND SupervisorID = @SupervisorID
   GROUP BY desk.code

   INSERT INTO @PDC (Desk, PDC_Fee, PDC_Gross)
   SELECT desk.code,
      ISNULL(SUM(pdc.ProjectedFee), 0) AS [ProjectedFee],
      ISNULL(SUM(pdc.Amount), 0) AS Gross
   FROM desk
   JOIN pdc WITH(NOLOCK) ON pdc.desk = desk.code
   JOIN Teams ON Teams.ID = desk.TeamID
   WHERE YEAR(Deposit) = @DateYear
      AND MONTH(Deposit) = @DateMonth
      AND Active = 1
      AND onhold is null
      AND SupervisorID = @SupervisorID
   GROUP BY desk.code

   INSERT INTO @DCC(Desk, DCC_Fee, DCC_Gross)
   SELECT desk.code,
      ISNULL(SUM(dcc.ProjectedFee), 0) AS [ProjectedFee],
      ISNULL(SUM(dcc.Amount), 0) AS Gross
   FROM desk
   JOIN [master] m WITH(NOLOCK) ON m.desk = desk.code
   JOIN DebtorCreditCards dcc WITH(NOLOCK) ON dcc.number = m.number
   JOIN Teams ON Teams.ID = desk.TeamID
   WHERE YEAR(DepositDate) = @DateYear
      AND MONTH(DepositDate) = @DateMonth
      AND IsActive = 1
      AND DCC.OnHoldDate IS NULL
      AND SupervisorID = @SupervisorID
   GROUP BY desk.code

    --Get Team fees
   IF @UseGross = 0
   BEGIN
      SELECT desk.[Name], teams.[Name] AS Team,
         @PostingDay AS [Posting Day],
         @TotalPostingDays AS [Total Posting Days this Month],
         ISNULL(Front_Fee,0) AS [Front Amount],
         ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee,0) AS [PDC Amount],
         ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee,0) AS [MTD Amount],
         ISNULL(New_Fee, 0) AS New,
         ISNULL((Fee / @TotalPostingDays), 0) AS [Daily Goal],
         ISNULL(Fee, 0) AS [Monthly Goal],
         ISNULL((Fee / @TotalPostingDays) * @PostingDay, 0) As [MTD GOAL],
         (ISNULL(Front_Fee, 0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee, 0)) - ((Fee / @TotalPostingDays) * @PostingDay) AS [MTD Diff],
         CAST(
            CASE WHEN (Fee > 0 AND @TotalPostingDays > 0 AND @PostingDay > 0) THEN
               (ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee,0)) / ((Fee / @TotalPostingDays) * @PostingDay)
            ELSE 0 END
         AS DECIMAL(9,2)) AS [MTD Percent],
         CAST(
            CASE WHEN Fee > 0 THEN (ISNULL(Front_Fee,0) + ISNULL(PDC_Fee,0) + ISNULL(DCC_Fee,0)) / Fee
            ELSE 0 END
         AS DECIMAL(9,2)) AS [Monthly Percent], UserName
      FROM desk 	  
      JOIN users on users.deskcode=desk.code
      JOIN teams on teams.id = desk.teamid
      JOIN goals_desk gd on gd.desk = desk.code
      LEFT JOIN @Front f on f.desk = gd.desk
      LEFT JOIN @New n on n.desk = gd.desk
      LEFT JOIN @PDC p ON p.desk = gd.desk
      LEFT JOIN @DCC d ON d.desk = gd.desk
      WHERE YEAR(gd.[month]) = @DateYear
        AND MONTH(gd.[month]) = @DateMonth
        AND SupervisorID = @SupervisorID
      ORDER BY [Monthly Percent] DESC, [MTD Amount] DESC, [Monthly Goal] DESC
   END
   ELSE
   BEGIN
      SELECT desk.[Name], teams.[Name] as Team,
         @PostingDay AS [Posting Day],
         @TotalPostingDays AS [Total Posting Days this Month],
         ISNULL(Front_Gross,0) AS [Front Amount],
         ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross,0) AS [PDC Amount],
         ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross,0) AS [MTD Amount],
         ISNULL(New_Gross, 0) AS New,
         ISNULL((Gross / @TotalPostingDays), 0) AS [Daily Goal],
         ISNULL(Gross, 0) AS [Monthly Goal],
         ISNULL((Gross / @TotalPostingDays) * @PostingDay, 0) As [MTD GOAL],
         (ISNULL(Front_Gross, 0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross, 0)) - ((Gross / @TotalPostingDays) * @PostingDay) AS [MTD Diff],
         CAST(
            CASE WHEN (Gross > 0 AND @TotalPostingDays > 0 AND @PostingDay > 0) THEN
               (ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross,0)) / ((Gross / @TotalPostingDays) * @PostingDay)
            ELSE 0 END
         AS DECIMAL(9,2)) AS [MTD Percent],
         CAST(
            CASE WHEN Gross > 0 THEN (ISNULL(Front_Gross,0) + ISNULL(PDC_Gross,0) + ISNULL(DCC_Gross,0)) / Gross
            ELSE 0 END
         AS DECIMAL(9,2)) AS [Monthly Percent], UserName
      FROM desk
      JOIN users on users.deskcode=desk.code
      JOIN teams on teams.id = desk.teamid
      JOIN goals_desk gd on gd.desk = desk.code
      LEFT JOIN @Front f on f.desk = gd.desk
      LEFT JOIN @New n on n.desk = gd.desk
      LEFT JOIN @PDC p ON p.desk = gd.desk
      LEFT JOIN @DCC d ON d.desk = gd.desk
      WHERE YEAR(gd.[month]) = @DateYear
        AND MONTH(gd.[month]) = @DateMonth
        AND SupervisorID = @SupervisorID
      ORDER BY [Monthly Percent] DESC, [MTD Amount] DESC, [Monthly Goal] DESC
   END

    --Get Today work stats
-- jjh: Fixed: order of Touched,Worked,Contacted,Attempts incorrect, changed to Attempts,Contacted,Touched,Worked
    INSERT INTO @TodayWork (Desk, Attempts, Contacted, Touched, Worked)
    SELECT desk.code,
        ISNULL(SUM(ds.Attempts), 0) AS Attempts,
        ISNULL(SUM(ds.Contacted), 0) AS Contacted,
        ISNULL(SUM(ds.Touched), 0) AS Touched,
        ISNULL(SUM(ds.Worked), 0) AS Worked
    FROM desk
    JOIN Teams ON Teams.ID = desk.TeamID
    JOIN Users ON Users.DeskCode = desk.code
    JOIN DeskStats ds WITH(NOLOCK) ON ds.desk = Users.LoginName
    WHERE TheDate = @Date
      AND SupervisorID = @SupervisorID
    GROUP BY desk.code

    --Get MTD work stats
-- jjh: Fixed: order of Touched,Worked,Contacted,Attempts incorrect, changed to Attempts,Contacted,Touched,Worked
    INSERT INTO @MTDWork (Desk, Attempts, Contacted, Touched, Worked)
    SELECT desk.code,      
        ISNULL(SUM(ds.Attempts), 0) AS Attempts,
        ISNULL(SUM(ds.Contacted), 0) AS Contacted,
        ISNULL(SUM(ds.Touched), 0) AS Touched,
        ISNULL(SUM(ds.Worked), 0) AS Worked
    FROM desk
    JOIN Teams ON Teams.ID = desk.TeamID
    JOIN Users ON Users.DeskCode = desk.code
    LEFT JOIN DeskStats ds WITH(NOLOCK) ON ds.desk = Users.LoginName
    WHERE SystemYear = @DateYear
      AND SystemMonth = @DateMonth
      AND SupervisorID = @SupervisorID
    GROUP BY desk.code

    --Get Today work stats
    SELECT desk.[Name], teams.[Name] AS Team, ISNULL(Touched, 0) AS Touched,
        ISNULL(Worked, 0) AS Worked, ISNULL(Contacted, 0) AS Contacted, 
        ISNULL(tw.Attempts, 0) AS Attempts, Username
    FROM desk
    JOIN users on users.deskcode=desk.code
    JOIN teams ON teams.ID = desk.TeamID
    LEFT JOIN @TodayWork tw ON tw.Desk = desk.code
    WHERE SupervisorID = @SupervisorID   
    ORDER BY ISNULL(Contacted, 0) DESC,desk.[Name]

    --Get MTD work stats
    SELECT desk.[Name], teams.[Name] AS Team, ISNULL(Touched, 0) AS Touched,
        ISNULL(Worked, 0) AS Worked, ISNULL(Contacted, 0) AS Contacted, 
        ISNULL(mw.Attempts, 0) AS Attempts, Username
    FROM desk
    JOIN users on users.deskcode=desk.code
    JOIN teams ON teams.ID = desk.TeamID
    LEFT JOIN @MTDWork mw ON mw.Desk = desk.code
    WHERE SupervisorID = @SupervisorID   
    ORDER BY ISNULL(Contacted, 0) DESC,desk.[Name]

    SELECT UserName,Teams.Name as Team FROM Users 
    INNER JOIN Teams ON Teams.SupervisorID=Users.ID
    WHERE Users.ID=@SupervisorID
END

GO
